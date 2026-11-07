Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065074;
	b=wvhHdBe7NvoTLr8prThATFE4VuMp0rycESx7aNAlwM5e3ckp+//qLi0poq6m9E56nE/H
	 AljspP7sewFsbOT51Sou8/hm7SwDxS402BImhLTAZXK1umIQzq/bqf3COhuKC0aA5f8U9
	 VkbFtwD/bK2uMbEQWDEMwPvDw7CWhvKTt1bLrcX9ePPkEI6AzeNAWOBgXgr5C5NkyEHM9
	 oMFbLMTweqAxiChXaG+8Q6NfnDj37QPmzGp0+ZyMB1l/hfO7DBEzvGmm7dhGsQwecoFmu
	 U5SedJVSkVBO+6Bbs9Z2wUo79VWZ3bbaC5v2NNPoKi1+nHx9qIb8FFrHUL2+7j6rSrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xrMNg2m+rt3FOTcqn92wuMLq4gZ/OieOg7IG1VlVkeU=;
	b=cixm2IIIoP95Dvllx3BPlbValNPrhkSyi+rgW8R6gJ/8ex/k1d6jnglPcIj6NvtFG5P0
	 dlegb8nGEXyoU1/iazO9o9EoCotlhSa7xDzS+TfbLDQtBOLQQUdiMQL8LihwuYJKM/tzb
	 t2OHNrvtLPdM4POASHzgj3r1lqPVsZoXcNrLDDaUU53qzvsqlT2JyrtCoNjdqiF8PqSkC
	 d1MzcnBRj/5DVNyrDz6dX5Y4+COubNWMeoD0it/wS/wZ19fhWV09SPg9C6qSNo0OxOFkv
	 T82pSU06V9m2ZYAS1lXE9HZS8KgKuWOPhtVAa5hTrWvH3NFlqqvai/f+raIniFd/FdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CwJwvq9t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8978F606A32C;
	Sat,  7 Nov 2026 15:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CwJwvq9t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3353D1F0089F;
	Sat,  7 Nov 2026 15:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065074;
	bh=xrMNg2m+rt3FOTcqn92wuMLq4gZ/OieOg7IG1VlVkeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwJwvq9tnHIwbiXnoyL/qENLQHsIeBEm69+KVYHVu5r6l3NZIjpj+ctjHk4uhRVMz
	 BFKooNYiRFQCwLVURJR03NFHDvSe2sstduPUFc6Lv+JpaDIPYQ9lSdBswSZSWst2aI
	 bsBveUX2nxCOZh3jq4DPfYh5gK3IU7KJkdZsrIAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0913/1257] ntfs: trigger page_mkwrite for native 4Kn size extension
Date: Sat,  7 Nov 2026 08:53:29 -0500
Message-ID: <20261107135004.563291413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 7823d72305f03928f3093e91cd7159542981162b ]

On native 4Kn volumes, pagecache_isize_extended() can leave a writable
mapping for a partial old-EOF page. A subsequent shared mmap write can
then bypass ntfs_filemap_page_mkwrite(), leaving NTFS initialized_size at
the old EOF.

Invalidate the partial old-EOF page after size extension, independent of
the filesystem block size, so the next mmap write enters the NTFS
page_mkwrite path. Apply the same helper to zero-fill fallocate
extensions and compare the actual new size after the operation so
extensions overlapping the old EOF are handled as well.

Fixes: 115380f9a2f9 ("ntfs: update mft operations")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/file.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 007d1614b9ac6..7c7cbd16e9446 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -252,6 +252,22 @@ static int ntfs_file_fsync(struct file *filp, loff_t start, loff_t end,
 	return ret;
 }
 
+static void ntfs_pagecache_extend(struct inode *vi, loff_t from, loff_t to)
+{
+	pagecache_isize_extended(vi, from, to);
+
+	/*
+	 * NTFS initialized_size is byte-granular, so a partial old-EOF page
+	 * must stay write-protected until page_mkwrite() updates it. The
+	 * generic helper skips this when the block size is at least a page,
+	 * the extension ends before the rounded block boundary, or that
+	 * boundary is page-aligned.
+	 */
+	if (from < to && from & (PAGE_SIZE - 1))
+		unmap_mapping_range(vi->i_mapping, round_down(from, PAGE_SIZE),
+				    PAGE_SIZE, 0);
+}
+
 static int ntfs_setattr_size(struct inode *vi, struct iattr *attr)
 {
 	struct ntfs_inode *ni = NTFS_I(vi);
@@ -281,7 +297,7 @@ static int ntfs_setattr_size(struct inode *vi, struct iattr *attr)
 	if (attr->ia_size > old_size) {
 		truncate_pagecache(vi, old_size);
 		i_size_write(vi, attr->ia_size);
-		pagecache_isize_extended(vi, old_size, attr->ia_size);
+		ntfs_pagecache_extend(vi, old_size, attr->ia_size);
 	} else {
 		truncate_setsize(vi, attr->ia_size);
 	}
@@ -1131,7 +1147,7 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t offset, loff_t le
 	struct ntfs_inode *ni = NTFS_I(vi);
 	struct ntfs_volume *vol = ni->vol;
 	int err = 0;
-	loff_t old_size;
+	loff_t old_size, new_size;
 
 	if (mode & ~(NTFS_FALLOC_FL_SUPPORTED))
 		return -EOPNOTSUPP;
@@ -1159,13 +1175,12 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t offset, loff_t le
 			return err;
 	}
 
-	old_size = i_size_read(vi);
-
 	inode_lock(vi);
 	if (NInoCompressed(ni) || NInoEncrypted(ni) || NInoWofCompressed(ni)) {
 		inode_unlock(vi);
 		return -EOPNOTSUPP;
 	}
+	old_size = i_size_read(vi);
 
 	inode_dio_wait(vi);
 	/* Take invalidate_lock for all fallocate operations to prevent races */
@@ -1194,10 +1209,12 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t offset, loff_t le
 
 	err = file_modified(file);
 out:
-	if (!err && mode == 0 && NInoNonResident(ni) &&
-	    offset > old_size) {
-		truncate_pagecache(vi, old_size);
-		pagecache_isize_extended(vi, old_size, offset);
+	if (!err && mode == 0 && NInoNonResident(ni)) {
+		new_size = i_size_read(vi);
+		if (new_size > old_size) {
+			truncate_pagecache(vi, old_size);
+			ntfs_pagecache_extend(vi, old_size, new_size);
+		}
 	}
 
 	filemap_invalidate_unlock(vi->i_mapping);
-- 
2.53.0



