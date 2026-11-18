Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043989;
	b=lSNKMhwyUUwBVxlnS3n6K7OJUqrUIYdNTTTkMxY+MJfP51qbsb7nkkwlptx8AFvSilSd
	 9353/PXHikeNoBqYrOFkAwj4ktFDJ0qO+RncWmWov/z28Hdgf6+almrPdpk100H9phDIJ
	 0iXPSkxRsGvo6aeTAJ1B56aXoGqfjbVMAWKjdBcdYM2jOL+QH2V+srHtW4AjEg+RpP+yy
	 MfMDKnQa6fefWYuxJZ/21x9AbFt8A+RLazdxL2DqppKNRB7bvnvXwK1YPlo6kpH0EmQRy
	 5aKhL72lMTuOn756x3D1chsErPogtJfs4gfSZ27wHPaBRt2PIkrAVQ1UPLvYn5ILJiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2JEWgnvM2cUeGSO17sd7XPoOy/tgju4ccTdPjd2UpbE=;
	b=hzX6QVTKje6nnuAXF2l4s13YjqMXNvuwIfsuokwZf4BSAcaGJYIYAvMTODddGsSg48G1
	 fYQgJTKL4h1kGYhpIuZGm2SFlxMhtGUEldYvSOqWw5cEkrlE5udoU8TG1CnCDn/z40/4g
	 hd1iKvobkSv4jhuo9D5tWDNGHPpMYWcv3Fmu6HcQ3/Ej8dDtpQ3QRYoDfRxygTNuMx1Ie
	 Dp94ktgA4JpXMZ2R/CT3mGbPROmsGxqeEcfZUBxxNPAZRS9RX0h/G2JQpvu2QU4eFLDqd
	 Qe1E5jEP6aANS37jqy3jTxMafrGtVlpM/MhB+Z8g9Cmz6m97tkVORx3bL9fcwv0tCHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Do4i+zWO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA4360A381B;
	Wed, 18 Nov 2026 23:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Do4i+zWO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD721F000D3;
	Wed, 18 Nov 2026 23:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043989;
	bh=2JEWgnvM2cUeGSO17sd7XPoOy/tgju4ccTdPjd2UpbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Do4i+zWOR5e55D9YQUEgEOcEu9Y9PEs0hEaH8VSKCdD8aAeyw4thtK5e4lrcQLT8j
	 VzQLvXdSJG9C1hMBQL56bONXILCNrvZC63GvQZ02pTnsEyXS6Dlisw2NJsGbAFEvdv
	 hxL6WrEMZrAGBIKumUkvb+jBY6I4ZjUOPpgadgzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0405/2857] configfs:get_target() - release path as soon as we grab configfs_item reference
Date: Wed, 18 Nov 2026 15:23:59 +0100
Message-ID: <20261118150215.971587697@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 1b25dea3867abc9bad6f0337d395c6f0ce4e4f6f ]

... and get rid of path argument - it turns into a local variable in get_target()

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: a7c1290eef60 ("configfs: pin the symlink target's dirent instead of chasing ->ci_dentry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/configfs/symlink.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index 0623c3edcfb9d..31b3a4ad5ea66 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -114,26 +114,21 @@ static int create_link(struct config_item *parent_item,
 }
 
 
-static int get_target(const char *symname, struct path *path,
-		      struct config_item **target, struct super_block *sb)
+static int get_target(const char *symname, struct config_item **target,
+		      struct super_block *sb)
 {
+	struct path path __free(path_put) = {};
 	int ret;
 
-	ret = kern_path(symname, LOOKUP_FOLLOW|LOOKUP_DIRECTORY, path);
-	if (!ret) {
-		if (path->dentry->d_sb == sb) {
-			*target = configfs_get_config_item(path->dentry);
-			if (!*target) {
-				ret = -ENOENT;
-				path_put(path);
-			}
-		} else {
-			ret = -EPERM;
-			path_put(path);
-		}
-	}
-
-	return ret;
+	ret = kern_path(symname, LOOKUP_FOLLOW|LOOKUP_DIRECTORY, &path);
+	if (ret)
+		return ret;
+	if (path.dentry->d_sb != sb)
+		return -EPERM;
+	*target = configfs_get_config_item(path.dentry);
+	if (!*target)
+		return -ENOENT;
+	return 0;
 }
 
 
@@ -141,7 +136,6 @@ int configfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 		     struct dentry *dentry, const char *symname)
 {
 	int ret;
-	struct path path;
 	struct configfs_dirent *sd;
 	struct config_item *parent_item;
 	struct config_item *target_item = NULL;
@@ -188,7 +182,7 @@ int configfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 	 *  AV, a thoroughly annoyed bastard.
 	 */
 	inode_unlock(dir);
-	ret = get_target(symname, &path, &target_item, dentry->d_sb);
+	ret = get_target(symname, &target_item, dentry->d_sb);
 	inode_lock(dir);
 	if (ret)
 		goto out_put;
@@ -210,7 +204,6 @@ int configfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 	}
 
 	config_item_put(target_item);
-	path_put(&path);
 
 out_put:
 	config_item_put(parent_item);
-- 
2.53.0



