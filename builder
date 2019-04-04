#!/bin/bash
. .env

# Clean builds folders
echo "----------- BUILD START"
echo "Clean old data"
rm -r "$ROOT" "$BUILD_OUTPUT" 2> /dev/null

# Create new folders
echo "Build arch"
mkdir -p "$ROOT" "$ETC" "$USR" "$SHARE" "$BIN" "$SBIN" "$DOC"

# Move doc
cp "src/doc/"* "$DOC"

# Copy bin to /usr/bin
echo "Move bin files"
cp -r "$SRC_MODULE/bin/"* "$BIN"
cp -r "$SRC_MODULE/sbin/"* "$SBIN"

# Move private to bin
mv "$BIN/private/"* "$BIN"

# rm private folder
rmdir "$BIN/private"

# Rename files in bin
for f in $(find $BIN $SBIN -type f); do 
    folder=${f%/*}
    name=$(basename $f)
    mv -- "$f" "$folder/$MODULE_NAME-$name" ; 
done
mv "$BIN/$MODULE_NAME-main" "$BIN/$MODULE_NAME"

# Copy config files to /etc 
echo "Move other files to etc"
cp -r "$SRC_MODULE/etc" "$ETC/$MODULE_NAME" 

# Remove git repo
find "$ROOT" -name ".git" -exec rm {} \;

# Edit files to install absolute path
echo "Translate variables and pattern to absolute path"
for file in $(find $ROOT -not \( -path $ANSIBLE_ROLES -prune \) -type f); do
    # Pattern remplacement
    sed -i "s@. {ENV_LOCATION}@mkdir -p \"$TMP\" \"$CONF\" 2>/dev/null@" "$file"
    sed -i "s@{MODULE_NAME}@$MODULE_NAME@" "$file"
    sed -i "s@{BIN_PRIVATE}/@$MODULE_NAME-@" "$file"

    # Variable remplacement
    # $HOME
    sed -i "s@\$ANSIBLE_INVENTORY_LOCAL@$ANSIBLE_INVENTORY_LOCAL@" "$file"
    sed -i "s@\$ANSIBLE_PLAYBOOK_LOCAL@$ANSIBLE_PLAYBOOK_LOCAL@" "$file"
    sed -i "s@\$ANSIBLE_VARS_LOCAL@$ANSIBLE_VARS_LOCAL@" "$file"
    sed -i "s@\$VAGRANT_USER_FOLDER@$VAGRANT_USER_FOLDER@" "$file"
    sed -i "s@\$VAGRANT_FILE_LOCAL@$VAGRANT_FILE_LOCAL@" "$file"
    sed -i "s@\$TMP@$TMP@" "$file"
    sed -i "s@\$CONF@$CONF@" "$file"
    sed -i "s@\$HOSTS@$HOSTS@" "$file"
    sed -i "s@\$VBOX@$VBOX@" "$file"
    sed -i "s@\$DEL_VBOX@$DEL_VBOX@" "$file"

    # /etc/module
    sed -i "s@\$ANSIBLE_INVENTORY@$ANSIBLE_INVENTORY@" "$file"
    sed -i "s@\$ANSIBLE_PLAYBOOK@$ANSIBLE_PLAYBOOK@" "$file"
    sed -i "s@\$ANSIBLE_VARS@$ANSIBLE_VARS@" "$file"
    sed -i "s@\$VAGRANT_FILE@$VAGRANT_FILE@" "$file"
done

# Change access right
echo "Change access right"
chmod -R 755 "$ROOT"

# Tar the result
echo "Tar the result"
tar -zcvf "$BUILD_OUTPUT" "$ETC" "$USR" > /dev/null

# Remove build folder
rm -r "$ROOT"  2> /dev/null

echo "----------- Project can now be packaged"