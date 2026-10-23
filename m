Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775029;
	b=pkN5fG/1UUXgPTw7IFBHRY/TlcGdZDTfUVt49uTn4/yaZKm+grFjxs4rMX9GmXNTcOkq
	 i536AwmDVNJWv+qWHy+VuFCVNqL9hlAmAZxUdlect1GRPDIgQQjWi677JMtiAEonDqoeX
	 DsdoFshXvDLHfA7XOziCy2xtbOssj5rKmpOJAMrAzmHnARXo4ENe2oOJPQxBo17BcfHvR
	 NJNYZJSMCvsqg3FWOv1rVPyz3PshTXSUc3+KscD4nBQ0dxR09ToJvmjwLVGZjaaTb+CSY
	 SkuVFBz9FxQI6ybuPjtnS2uoLHk1yLvNg1Uz7ikbOfNGpH1IRmV28uGnQfyyYgA1tZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dm1krqc3E5FndO+oqj4DYy/FLXs4ZgvZ9AQ3H3h3o84=;
	b=H5EsOrGcGcg8i4DVi5zxZCKJQXJIsMWY3D63qgSZ0jLcd/+NzcA6yZTbTBwAo1Xf+if0
	 vwaVrEUjUNzsBF04aPJtdVVRVf4IOFzSRjgcVDHsccb9o57LEoOV8z4Ru5zPnLotEsGeT
	 ibRgV0TYXQJ1Q7RXSFd4qob+OSIYufSrG8UkZTlw69Be9WhsHjtpsd1tdVEeZ5yCvOodi
	 NubCu2mM5FiDiptZ+/14f/Llx8F25Sk46Gcl6efegjqiuspHj5jX/b/SvjxJVi9CDUwOC
	 uN85iqS6vNQGcu/oF3i9YKu6Fuyvz/sgyZi6ZaTNdOsvGp6SMpZ1mlYh2et7xhW4fCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zPvMCzX1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9B9606A31A;
	Fri, 23 Oct 2026 17:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zPvMCzX1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB22A1F01829;
	Fri, 23 Oct 2026 17:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775028;
	bh=Dm1krqc3E5FndO+oqj4DYy/FLXs4ZgvZ9AQ3H3h3o84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPvMCzX1jQH78+NPPUJqSdJQbwZToEXiYKVB+8izoAxAbi3FJhKFHp3bo10kDldWp
	 iTaOoVndayLb/XBXbdAjQiIJVlrC18rBcj5XJjwtTqcClbeAlDrXxZ3FKwB9o7Q7nH
	 i4KDClqZelgRHoUbRyWkr47hvO0KUrDoXXzQCTCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 237/242] ntfs: use pagecache_isize_extended() on size extension
Date: Fri, 23 Oct 2026 18:41:19 +0200
Message-ID: <20261023163719.458283455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 5c32f0b8d791c3464d7b280859f312b006e08fab ]

When extending file size, call truncate_pagecache() first, then update
i_size, and use pagecache_isize_extended() instead of manual
iomap_zero_range(). This ensures the straddling folio is properly marked
RO so page_mkwrite() is called and post-EOF area is zeroed.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 9cc5761b8f28 ("ntfs: take invalidate_lock in ntfs_setattr_size()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/file.c |   28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -269,23 +269,19 @@ static int ntfs_setattr_size(struct inod
 		return err;
 
 	inode_dio_wait(vi);
-	truncate_setsize(vi, attr->ia_size);
+	if (attr->ia_size > old_size) {
+		truncate_pagecache(vi, old_size);
+		i_size_write(vi, attr->ia_size);
+		pagecache_isize_extended(vi, old_size, attr->ia_size);
+	} else
+		truncate_setsize(vi, attr->ia_size);
+
 	err = ntfs_truncate_vfs(vi, attr->ia_size, old_size);
 	if (err) {
 		i_size_write(vi, old_size);
 		return err;
 	}
 
-	if (NInoNonResident(ni) && attr->ia_size > old_size &&
-	    old_size % PAGE_SIZE != 0) {
-		loff_t len = min_t(loff_t,
-				round_up(old_size, PAGE_SIZE) - old_size,
-				attr->ia_size - old_size);
-		err = iomap_zero_range(vi, old_size, len,
-				NULL, &ntfs_seek_iomap_ops,
-				&ntfs_iomap_folio_ops, NULL);
-	}
-
 	return err;
 }
 
@@ -1125,13 +1121,9 @@ out:
 		filemap_invalidate_unlock(vi->i_mapping);
 	if (!err) {
 		if (mode == 0 && NInoNonResident(ni) &&
-		    offset > old_size && old_size % PAGE_SIZE != 0) {
-			loff_t len = min_t(loff_t,
-					   round_up(old_size, PAGE_SIZE) - old_size,
-					   offset - old_size);
-			err = iomap_zero_range(vi, old_size, len, NULL,
-					       &ntfs_seek_iomap_ops,
-					       &ntfs_iomap_folio_ops, NULL);
+		    offset > old_size) {
+			truncate_pagecache(vi, old_size);
+			pagecache_isize_extended(vi, old_size, offset);
 		}
 		NInoSetFileNameDirty(ni);
 		inode_set_mtime_to_ts(vi, inode_set_ctime_current(vi));


