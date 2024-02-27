Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10A213A87C;
	Tue, 27 Feb 2024 13:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040815; cv=none; b=WYgSYMCnCKpHn79hZM+HSX3IQIgPj+B8D46BG8l5rlkvPGq7Kd8Jk7kQ+GC8j+548PIouoIWKMZIDeMGg+SdiOTs3g9p2o3Qzs/LplXfLZcD3LYa63ihLoj7wshZpcWNJpobqTkwzLyIDTTIn0KGIhxffCm8de6m284/6KdyGQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040815; c=relaxed/simple;
	bh=EANWjd2RrO8BvVpQFHcKrcYLRX+gV5XykwdnyvxCszw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUPqz2TwiP+bhGqFbXxdSAFg1Cgq2P/ET1dAnQnWMdpQkmHZesVYFTD0ew+2GxoSuFSh7go8ATH6tIQ1/232EqjU7qLvmP4sJcQXo+EJRLzrrosEum8VWPhpkawBOGjVfc7Zu/EqPO9OzlSyC/LkXbwsuiBglxm0kUsjVDH/jhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZMp635Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZMp635Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560D2C433F1;
	Tue, 27 Feb 2024 13:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040815;
	bh=EANWjd2RrO8BvVpQFHcKrcYLRX+gV5XykwdnyvxCszw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZMp635Yx+Lz09dFN1ly4FwtgE+8uxkl487yje14hx/26t0//iWzdKOyNfGS4DZCT
	 F2GUeTDATcrxhUd5kYufuKd0u4++h+ElB1G90rI9L2sEtB6tz70bljWSMdpqfgZeZj
	 0qYPpVuriUr9f5rpRB4PLK42kt9qUYe/XiFVJ7As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 089/334] fs/ntfs3: Add and fix comments
Date: Tue, 27 Feb 2024 14:19:07 +0100
Message-ID: <20240227131633.391662099@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit d6ca2d253900b9b0a3a1ad77541d606010f5e5eb ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/dir.c     | 4 +++-
 fs/ntfs3/fsntfs.c  | 2 +-
 fs/ntfs3/ntfs.h    | 2 +-
 fs/ntfs3/ntfs_fs.h | 2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index 726122ecd39b4..9f6dd445eb04d 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -536,8 +536,10 @@ static int ntfs_dir_count(struct inode *dir, bool *is_empty, size_t *dirs,
 			e = Add2Ptr(hdr, off);
 			e_size = le16_to_cpu(e->size);
 			if (e_size < sizeof(struct NTFS_DE) ||
-			    off + e_size > end)
+			    off + e_size > end) {
+				/* Looks like corruption. */
 				break;
+			}
 
 			if (de_is_last(e))
 				break;
diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 350461d8cece5..321978019407f 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -2129,8 +2129,8 @@ int ntfs_insert_security(struct ntfs_sb_info *sbi,
 			if (le32_to_cpu(d_security->size) == new_sec_size &&
 			    d_security->key.hash == hash_key.hash &&
 			    !memcmp(d_security + 1, sd, size_sd)) {
-				*security_id = d_security->key.sec_id;
 				/* Such security already exists. */
+				*security_id = d_security->key.sec_id;
 				err = 0;
 				goto out;
 			}
diff --git a/fs/ntfs3/ntfs.h b/fs/ntfs3/ntfs.h
index 13e96fc63dae5..c8981429c7213 100644
--- a/fs/ntfs3/ntfs.h
+++ b/fs/ntfs3/ntfs.h
@@ -523,7 +523,7 @@ struct ATTR_LIST_ENTRY {
 	__le64 vcn;		// 0x08: Starting VCN of this attribute.
 	struct MFT_REF ref;	// 0x10: MFT record number with attribute.
 	__le16 id;		// 0x18: struct ATTRIB ID.
-	__le16 name[];		// 0x1A: Just to align. To get real name can use name_off.
+	__le16 name[];		// 0x1A: To get real name use name_off.
 
 }; // sizeof(0x20)
 
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 3fc027ce6e4d9..8079f3069a1bf 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -874,7 +874,7 @@ int ntfs_init_acl(struct mnt_idmap *idmap, struct inode *inode,
 
 int ntfs_acl_chmod(struct mnt_idmap *idmap, struct dentry *dentry);
 ssize_t ntfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
-extern const struct xattr_handler * const ntfs_xattr_handlers[];
+extern const struct xattr_handler *const ntfs_xattr_handlers[];
 
 int ntfs_save_wsl_perm(struct inode *inode, __le16 *ea_size);
 void ntfs_get_wsl_perm(struct inode *inode);
-- 
2.43.0



