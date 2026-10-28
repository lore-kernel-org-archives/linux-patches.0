Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214321;
	b=MBPo7Zdd0SRCB3011bFdMb3aQ7e6dgkUWJbnaBh7x8how/hA7sz5BY/xbBb+7o9pDRSC
	 AXFYEn+2ASdEQZpaREUOu+uiH3qS2QMG5M9re+t/+/aFQnOX/cqbVbHhDCQGwrLGiwCPk
	 yNT2jTNAFeq7Tsj9LJeCJSRaEOFdHAHVr3CD62vD1Jxwui4/Vk53N4gYxxNbewmVnAqGW
	 ypcyOnn/lqF0ouoL3Fc7LmYsFv/HNOHK1kN7GX5RSZgCeHN3bWjCp5Dyy33gmHynmhC1E
	 j+oI/JBQJj37lzFS6OuMcCRO0+ZxjartvxDdglcJGvk52KOwRmkj/Rjf4mVF73eKo8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lNtQCnCG7qf5sfI89HSAbkBOJrMrGQf5e5XJwscdkDA=;
	b=nk5foLtzv8JxR3aJRqL5RhGzeawvEzT/IY8vZmg1Sg6O7BEGm5dWhCI2IjAyOa0EX71o
	 ZYw1rJkDWUAthRIrEKCKo66L4jqJaeKMw5+/W+quCPOWPxr+8HhHbbfaGp5KPGcbK0mLn
	 qidgbRMuu9S8awoZyXVSV/7SdcAW0w+Hmde6whi93pwhqNjvU5fJYXaKTUIuzH2kfln4X
	 6DjxrWT7BU0kgB7iBZRV8Jy5OV4gYBTSKKWofeREhOCe8eFx4UbmwBGlydEsCgNd7xpM1
	 EsTBc4LCbqz4viM22u03s8bCC/z7Jq4SLgjg+R3Vwz8UlVE7c5xZWiPxTNcrCH5lU/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bghQfzfP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7ECC606BF88;
	Wed, 28 Oct 2026 19:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bghQfzfP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147D61F01825;
	Wed, 28 Oct 2026 19:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214320;
	bh=lNtQCnCG7qf5sfI89HSAbkBOJrMrGQf5e5XJwscdkDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bghQfzfPVOWcwLnQbavI8fGNYUB6LCgJQcFclR+rnBa4xge9FnycYxx+WveYK4x8S
	 aNlrXtoXk5uERdV3u0vYX5ffc5UpD6o0etMYsY5PlWK16hlVJh7Ias2N0PiQzGr+nB
	 53MjE7ZtNoIaGdhm8pwMqwHLhbTU9LpY/i4nFqco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1aa90f0eb1fc3e77d969@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0818/1887] fs/ntfs3: cancle set bad inode after removing name fails
Date: Wed, 28 Oct 2026 17:48:34 +0100
Message-ID: <20261028170518.040787212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit d99208b91933fd2a58ed9ed321af07dacd06ddc3 ]

The reproducer uses a file0 on a ntfs3 file system with a corrupted i_link.
When renaming, the file0's inode is marked as a bad inode because the file
name cannot be deleted.

The underlying bug is that make_bad_inode() is called on a live inode.
In some cases it's "icache lookup finds a normal inode, d_splice_alias()
is called to attach it to dentry, while another thread decides to call
make_bad_inode() on it - that would evict it from icache, but we'd already
found it there earlier".
In some it's outright "we have an inode attached to dentry - that's how we
got it in the first place; let's call make_bad_inode() on it just for shits
and giggles".

Fixes: 78ab59fee07f ("fs/ntfs3: Rework file operations")
Reported-by: syzbot+1aa90f0eb1fc3e77d969@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1aa90f0eb1fc3e77d969
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c |  7 +++----
 fs/ntfs3/namei.c   | 10 +++-------
 fs/ntfs3/ntfs_fs.h |  3 +--
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 240983bac9c3c..a44b7338621e0 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -3170,8 +3170,7 @@ int ni_add_name(struct ntfs_inode *dir_ni, struct ntfs_inode *ni,
  * ni_rename - Remove one name and insert new name.
  */
 int ni_rename(struct ntfs_inode *dir_ni, struct ntfs_inode *new_dir_ni,
-	      struct ntfs_inode *ni, struct NTFS_DE *de, struct NTFS_DE *new_de,
-	      bool *is_bad)
+	      struct ntfs_inode *ni, struct NTFS_DE *de, struct NTFS_DE *new_de)
 {
 	int err;
 	struct NTFS_DE *de2 = NULL;
@@ -3194,8 +3193,8 @@ int ni_rename(struct ntfs_inode *dir_ni, struct ntfs_inode *new_dir_ni,
 	err = ni_add_name(new_dir_ni, ni, new_de);
 	if (!err) {
 		err = ni_remove_name(dir_ni, ni, de, &de2, &undo);
-		if (err && ni_remove_name(new_dir_ni, ni, new_de, &de2, &undo))
-			*is_bad = true;
+		WARN_ON(err && ni_remove_name(new_dir_ni, ni, new_de, &de2,
+			&undo));
 	}
 
 	/*
diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index 7b7634b38eea8..1adbc4af6aba8 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -250,7 +250,7 @@ static int ntfs_rename(struct user_namespace *mnt_userns, struct inode *dir,
 	struct ntfs_inode *ni = ntfs_i(inode);
 	struct inode *new_inode = d_inode(new_dentry);
 	struct NTFS_DE *de, *new_de;
-	bool is_same, is_bad;
+	bool is_same;
 	/*
 	 * de		- memory of PATH_MAX bytes:
 	 * [0-1024)	- original name (dentry->d_name)
@@ -314,12 +314,8 @@ static int ntfs_rename(struct user_namespace *mnt_userns, struct inode *dir,
 	ni_lock_dir(dir_ni);
 	ni_lock(ni);
 
-	is_bad = false;
-	err = ni_rename(dir_ni, new_dir_ni, ni, de, new_de, &is_bad);
-	if (is_bad) {
-		/* Restore after failed rename failed too. */
-		_ntfs_bad_inode(inode);
-	} else if (!err) {
+	err = ni_rename(dir_ni, new_dir_ni, ni, de, new_de);
+	if (!err) {
 		inode->i_ctime = dir->i_ctime = dir->i_mtime =
 			current_time(dir);
 		mark_inode_dirty(inode);
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index d29fdefb477bf..34179fba57db8 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -573,8 +573,7 @@ int ni_add_name(struct ntfs_inode *dir_ni, struct ntfs_inode *ni,
 		struct NTFS_DE *de);
 
 int ni_rename(struct ntfs_inode *dir_ni, struct ntfs_inode *new_dir_ni,
-	      struct ntfs_inode *ni, struct NTFS_DE *de, struct NTFS_DE *new_de,
-	      bool *is_bad);
+	      struct ntfs_inode *ni, struct NTFS_DE *de, struct NTFS_DE *new_de);
 
 bool ni_is_dirty(struct inode *inode);
 
-- 
2.53.0



