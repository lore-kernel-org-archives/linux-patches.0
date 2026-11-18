Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058878;
	b=p6RzJV2BskoYbH1wm9Q0HistPHsm5kVrHqeXHKpsbrnr+vUErHzYPeTUB8V3jI8z25ap
	 I3Qx1TRvIr+9oqBb3J6PNwXfDbTeM4ZGVDgzWwqOSMfVYDg7uq4e0YTUxlYWo7fu0oQFq
	 iBOlMNJ4dENkHUfIth+36BtUgDJ7G6j+Skn2K29hMdqZAXSts2ui3VGPmj3zINCTixefA
	 yK5vec3jqTRVCuOiQKStccGDwNOhhpTWyUBEtOzlzPSr89hXaC4onhB8DtC+v2S5QlnRc
	 wUj6uMXWwWDkyLEdWq0SA11/oCL72WG1tYHg0JYUfRY2wGII0CAk2wUKOjbFXijv3ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DSxc2OluUaB82OHw1UT8cq1hT7hdv4i19u/r1heoOME=;
	b=Aq3N6w9iXAPDlLNoFLWpzY/geBi+u4OspZF7TDUbnHiEA0mQmJXiwZcE9qjc+mc6BlmJ
	 Fzn4DtgA+CiaPAs9fC1g80d9KxOh7nkBJGiCI3VbGHA5B2HLP0yuq7vWPEUUA9vmh3Oi3
	 +5INhc9rNnA4rJ0FdLBE8CPAqJHlPsBXV2KW4SMqmUCRbWBMsIGWQk7aP6mxDz5gpldPQ
	 OVQCW2eT5AO/4T8suuRPFhn3XaZP7tJn0QdY2XbwZCFVXK+2iof2H53z2LxUjB9I/Y3mJ
	 k5hrpOiuEoKbIqt3nNOnohK8jUnDqtALTJ2AdEBuqAsFHgG8gndEJ8yVW8+F8Qe240w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KUVhpN5Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B212606A31C;
	Thu, 19 Nov 2026 03:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KUVhpN5Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB2C1F000C4;
	Thu, 19 Nov 2026 03:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058877;
	bh=DSxc2OluUaB82OHw1UT8cq1hT7hdv4i19u/r1heoOME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUVhpN5YbCssFe5UITIursqXZMXkzVnxDd7u+MRxCFnPgZzAoqiB+ctamkIoDz3hF
	 VB9E9dSvlyuAiQPK9qnTnqjLy+yU37Qh9X0nIRoP9u8tOgM4w2QSnCE0PVU3v+EFe8
	 3ma7Z3wT+n39FomJCTnLtIWY3WcI70sckT/m5rSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Hsieh <victorhsieh@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <yuchao0@huawei.com>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0643/1848] fs-verity: factor out fsverity_get_descriptor()
Date: Wed, 18 Nov 2026 15:44:41 +0100
Message-ID: <20261118145942.677767570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit c2c8261151b32f1956fc4ecd71c9a3e7972084b6 upstream.

The FS_IOC_READ_VERITY_METADATA ioctl will need to return the fs-verity
descriptor (and signature) to userspace.

There are a few ways we could implement this:

- Save a copy of the descriptor (and signature) in the fsverity_info
  struct that hangs off of the in-memory inode.  However, this would
  waste memory since most of the time it wouldn't be needed.

- Regenerate the descriptor from the merkle_tree_params in the
  fsverity_info.  However, this wouldn't work for the signature, nor for
  the salt which the merkle_tree_params only contains indirectly as part
  of the 'hashstate'.  It would also be error-prone.

- Just get them from the filesystem again.  The disadvantage is that in
  general we can't trust that they haven't been maliciously changed
  since the file has opened.  However, the use cases for
  FS_IOC_READ_VERITY_METADATA don't require that it verifies the chain
  of trust.  So this is okay as long as we do some basic validation.

In preparation for implementing the third option, factor out a helper
function fsverity_get_descriptor() which gets the descriptor (and
appended signature) from the filesystem and does some basic validation.

As part of this, start checking the sig_size field for overflow.
Currently fsverity_verify_signature() does this.  But the new ioctl will
need this too, so do it earlier.

Link: https://lore.kernel.org/r/20210115181819.34732-2-ebiggers@kernel.org
Reviewed-by: Victor Hsieh <victorhsieh@google.com>
Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/verity/fsverity_private.h |   7 +-
 fs/verity/open.c             | 130 +++++++++++++++++++++++------------
 2 files changed, 91 insertions(+), 46 deletions(-)

diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index e96d99d5145e1..08cd74c193d40 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -152,12 +152,17 @@ int fsverity_init_merkle_tree_params(struct merkle_tree_params *params,
 				     const u8 *salt, size_t salt_size);
 
 struct fsverity_info *fsverity_create_info(const struct inode *inode,
-					   void *desc, size_t desc_size);
+					   struct fsverity_descriptor *desc,
+					   size_t desc_size);
 
 void fsverity_set_info(struct inode *inode, struct fsverity_info *vi);
 
 void fsverity_free_info(struct fsverity_info *vi);
 
+int fsverity_get_descriptor(struct inode *inode,
+			    struct fsverity_descriptor **desc_ret,
+			    size_t *desc_size_ret);
+
 int __init fsverity_init_info_cache(void);
 void __init fsverity_exit_info_cache(void);
 
diff --git a/fs/verity/open.c b/fs/verity/open.c
index 67d71f7b1b483..804bd717c4d32 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -142,45 +142,17 @@ static int compute_file_measurement(struct fsverity_hash_alg *hash_alg,
 }
 
 /*
- * Validate the given fsverity_descriptor and create a new fsverity_info from
- * it.  The signature (if present) is also checked.
+ * Create a new fsverity_info from the given fsverity_descriptor (with optional
+ * appended signature), and check the signature if present.  The
+ * fsverity_descriptor must have already undergone basic validation.
  */
 struct fsverity_info *fsverity_create_info(const struct inode *inode,
-					   void *_desc, size_t desc_size)
+					   struct fsverity_descriptor *desc,
+					   size_t desc_size)
 {
-	struct fsverity_descriptor *desc = _desc;
 	struct fsverity_info *vi;
 	int err;
 
-	if (desc_size < sizeof(*desc)) {
-		fsverity_err(inode, "Unrecognized descriptor size: %zu bytes",
-			     desc_size);
-		return ERR_PTR(-EINVAL);
-	}
-
-	if (desc->version != 1) {
-		fsverity_err(inode, "Unrecognized descriptor version: %u",
-			     desc->version);
-		return ERR_PTR(-EINVAL);
-	}
-
-	if (memchr_inv(desc->__reserved, 0, sizeof(desc->__reserved))) {
-		fsverity_err(inode, "Reserved bits set in descriptor");
-		return ERR_PTR(-EINVAL);
-	}
-
-	if (desc->salt_size > sizeof(desc->salt)) {
-		fsverity_err(inode, "Invalid salt_size: %u", desc->salt_size);
-		return ERR_PTR(-EINVAL);
-	}
-
-	if (le64_to_cpu(desc->data_size) != inode->i_size) {
-		fsverity_err(inode,
-			     "Wrong data_size: %llu (desc) != %lld (inode)",
-			     le64_to_cpu(desc->data_size), inode->i_size);
-		return ERR_PTR(-EINVAL);
-	}
-
 	vi = kmem_cache_zalloc(fsverity_info_cachep, GFP_KERNEL);
 	if (!vi)
 		return ERR_PTR(-ENOMEM);
@@ -245,15 +217,57 @@ void fsverity_free_info(struct fsverity_info *vi)
 	kmem_cache_free(fsverity_info_cachep, vi);
 }
 
-/* Ensure the inode has an ->i_verity_info */
-static int ensure_verity_info(struct inode *inode)
+static bool validate_fsverity_descriptor(struct inode *inode,
+					 const struct fsverity_descriptor *desc,
+					 size_t desc_size)
 {
-	struct fsverity_info *vi = fsverity_get_info(inode);
-	struct fsverity_descriptor *desc;
-	int res;
+	if (desc_size < sizeof(*desc)) {
+		fsverity_err(inode, "Unrecognized descriptor size: %zu bytes",
+			     desc_size);
+		return false;
+	}
 
-	if (vi)
-		return 0;
+	if (desc->version != 1) {
+		fsverity_err(inode, "Unrecognized descriptor version: %u",
+			     desc->version);
+		return false;
+	}
+
+	if (memchr_inv(desc->__reserved, 0, sizeof(desc->__reserved))) {
+		fsverity_err(inode, "Reserved bits set in descriptor");
+		return false;
+	}
+
+	if (desc->salt_size > sizeof(desc->salt)) {
+		fsverity_err(inode, "Invalid salt_size: %u", desc->salt_size);
+		return false;
+	}
+
+	if (le64_to_cpu(desc->data_size) != inode->i_size) {
+		fsverity_err(inode,
+			     "Wrong data_size: %llu (desc) != %lld (inode)",
+			     le64_to_cpu(desc->data_size), inode->i_size);
+		return false;
+	}
+
+	if (le32_to_cpu(desc->sig_size) > desc_size - sizeof(*desc)) {
+		fsverity_err(inode, "Signature overflows verity descriptor");
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * Read the inode's fsverity_descriptor (with optional appended signature) from
+ * the filesystem, and do basic validation of it.
+ */
+int fsverity_get_descriptor(struct inode *inode,
+			    struct fsverity_descriptor **desc_ret,
+			    size_t *desc_size_ret)
+{
+	int res;
+	struct fsverity_descriptor *desc;
 
 	res = inode->i_sb->s_vop->get_verity_descriptor(inode, NULL, 0);
 	if (res < 0) {
@@ -272,20 +286,46 @@ static int ensure_verity_info(struct inode *inode)
 	res = inode->i_sb->s_vop->get_verity_descriptor(inode, desc, res);
 	if (res < 0) {
 		fsverity_err(inode, "Error %d reading verity descriptor", res);
-		goto out_free_desc;
+		kfree(desc);
+		return res;
+	}
+
+	if (!validate_fsverity_descriptor(inode, desc, res)) {
+		kfree(desc);
+		return -EINVAL;
 	}
 
-	vi = fsverity_create_info(inode, desc, res);
+	*desc_ret = desc;
+	*desc_size_ret = res;
+	return 0;
+}
+
+/* Ensure the inode has an ->i_verity_info */
+static int ensure_verity_info(struct inode *inode)
+{
+	struct fsverity_info *vi = fsverity_get_info(inode);
+	struct fsverity_descriptor *desc;
+	size_t desc_size;
+	int err;
+
+	if (vi)
+		return 0;
+
+	err = fsverity_get_descriptor(inode, &desc, &desc_size);
+	if (err)
+		return err;
+
+	vi = fsverity_create_info(inode, desc, desc_size);
 	if (IS_ERR(vi)) {
-		res = PTR_ERR(vi);
+		err = PTR_ERR(vi);
 		goto out_free_desc;
 	}
 
 	fsverity_set_info(inode, vi);
-	res = 0;
+	err = 0;
 out_free_desc:
 	kfree(desc);
-	return res;
+	return err;
 }
 
 /**
-- 
2.53.0



