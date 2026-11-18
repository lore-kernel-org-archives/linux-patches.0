Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044468;
	b=sdZ6QmeYSFFs35Hfkj+v33rzfkqYE4pOcM1Pf24Xixgzh27/vPjjhtUo7rHsjIXp8ZNZ
	 tUyew5vMzPI1b43jV/YQbkPkGstUUyhT+eGrf8kUrNLScLNMRW3Kg1GpnFTd2Q5EscG4q
	 S0BOp2a6B5tYlbKFc5zHZNiHTnopDJGXau5LqXiv5eCRkJzBwcvNKuH5UBgbtFI+31nux
	 xXp6pkwMOFJBPlSq1eLVIiAxNXP5Zm+4YcNi2RpqqXsuhIkozsKhDwPgmgbju3LxNjHnu
	 578JzJ49ec1KpqtzbmjjDfCeg/kTBlLne5Rx9RMtfQAtdI3GzpVX2opJJHZzB2A2QEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6kIZd3UmWwF7p8Z32Wyw7v3Z41gvVX8RKtFCDsf3g9w=;
	b=szBSJmdOlFDxGygARXaplVOmjxAzBci5gcRECDBZGA/gdiJ0N5ZouR5vcO5E8dNh3m7F
	 2nNSB9eH4n68rqEbd+OTBisIxfkjD9C2igwobY3FC3TTizXivNdEXXF2CRS64Nt1yFtIS
	 Q06Wcv0RXq14lvAmduaRPLQ7itUC3xsjevUT/enfFiYLKSYfXvrIjiQdqtt2hkbJ60B9G
	 xWqcxcvmkBKF4qkT3ZsKLp2hoKU2+cnmYcJTZQLYlH/P0QBZZyi0T4Eflwt/jQGEJN9L8
	 GewhenbnuDEPhXzHo5zRJwPBtHGzCc9ZtJFVhgRPEDlulYdq73AJerZnB/twgQ00wyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WRWgBGEn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E20606A31C;
	Wed, 18 Nov 2026 23:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WRWgBGEn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E7F1F000C4;
	Wed, 18 Nov 2026 23:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044468;
	bh=6kIZd3UmWwF7p8Z32Wyw7v3Z41gvVX8RKtFCDsf3g9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WRWgBGEnhH+n9OBOUUUVFm+Jv6n1NEZRzrAfDEQCXHR/0BMO6bmuYBmPV2F/iXNLR
	 IQO0gEZIJbR2vv/EN5jLnH3pA7mh5VlFZEEgH4ABpKXSGBfqdv4jfATR7lG8BnmvG1
	 1yLqfMGD4eLzklId+ya4ln8TszbzBfl9bctIG4pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.1 0579/2857] ovl: read the nlink xattr of every indexed non-dir
Date: Wed, 18 Nov 2026 15:26:53 +0100
Message-ID: <20261118150222.331965050@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

commit eb644ed5c6d9afdb1554c41cef1f39d150fbc554 upstream.

With nfs_export=on, data written through a file handle to a lower file,
i.e. a file that exists only in a lower layer of the overlay, can be
lost on the next mount. A lookup of the file by name then returns -EIO.
Also, a file with one name reports st_nlink 2 once it has been copied to
the upper layer. After such a file is removed, its file handle can still
open it until the next mount.

Before a lower file is changed for the first time, overlayfs copies it
to the writable upper layer. This is called copy up.

The index directory is $workdir/index, where $workdir is the directory
given by the workdir= option. Each entry is named after the file handle
of a lower inode, so that overlayfs can get from the handle to the
copied up inode.

With nfs_export=on, copy up indexes every non-directory: it copies the
file to an entry in the index directory and then hard links that entry
into the upper directory. The index entry is an extra link to the upper
inode, so overlayfs stores the link count that users should see in the
overlay.nlink xattr.

A file can also be opened by handle, either by an NFS client or by a
process with CAP_DAC_READ_SEARCH calling open_by_handle_at(). If the
file is not in the dcache, its overlay dentry is disconnected, i.e. it
has no parent yet. Copy up then creates the index entry but no hard link
in the upper directory. The index entry has i_nlink 1 and holds the only
copy of the data written to the file.

ovl_get_nlink() reads the stored count. Its caller passes a default,
which the function returns if there is no stored count. If the lower
inode has i_nlink 1, the function returns the default without reading
the xattr. That was correct as long as only lower files with multiple
links were indexed.

On the next mount, ovl_verify_index() looks for orphans, i.e. index
entries of files whose last name was removed. For an index entry with
i_nlink 1, it passes a default of 0 to ovl_get_nlink() and treats a
result of 0 as an orphan. Here the lower inode also has i_nlink 1, so
the result is the default. ovl_indexdir_cleanup() then replaces the
entry with a whiteout, which in the index marks a file as deleted. The
written data is lost.

A lookup by name then returns -EIO, because a whiteout as the index
entry of a lower file that still exists is a bad index.

ovl_get_inode() gets the wrong count the same way. Its default is the
i_nlink of the upper inode, which includes the index entry, so a copied
up file with one name reports st_nlink 2.

When that name is removed, the count drops to 1 rather than 0.
ovl_nlink_end() replaces the index entry with a whiteout only at a count
of 0, so the entry stays, and the handle of the removed file still opens
it.

Reproduced by writing through open_by_handle_at() to an uncached lower
file with one link. After a remount the data was lost, and the name
returned EIO.

Fix this by adding an argument to ovl_get_nlink() that says whether the
caller found an index entry, and by skipping the xattr only if the
caller found none.

Known gaps:
- An index entry that a kernel without this patch left behind for a
  removed file now stays, and the handle of that file keeps working. The
  entry has i_nlink 1 and a stored count of 1, just like the entry of a
  file that was only written by handle. Without this patch, the next
  mount treated it as an orphan.

Fixes: fbd2d2074bde ("ovl: index all non-dir on copy up for NFS export")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/inode.c     |   14 +++++++++++---
 fs/overlayfs/namei.c     |    2 +-
 fs/overlayfs/overlayfs.h |    2 +-
 3 files changed, 13 insertions(+), 5 deletions(-)

--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -976,7 +976,7 @@ int ovl_set_nlink_lower(struct dentry *d
 }
 
 unsigned int ovl_get_nlink(struct ovl_fs *ofs, struct dentry *lowerdentry,
-			   struct dentry *upperdentry,
+			   struct dentry *upperdentry, bool indexed,
 			   unsigned int fallback)
 {
 	int nlink_diff;
@@ -984,7 +984,15 @@ unsigned int ovl_get_nlink(struct ovl_fs
 	char buf[13];
 	int err;
 
-	if (!lowerdentry || !upperdentry || d_inode(lowerdentry)->i_nlink == 1)
+	if (!lowerdentry || !upperdentry)
+		return fallback;
+
+	/*
+	 * A lower inode with one link is not indexed on copy up, unless all
+	 * files are indexed for NFS export.  If the caller found an index entry,
+	 * then the xattr holds the union nlink, whatever the lower nlink is.
+	 */
+	if (!indexed && d_inode(lowerdentry)->i_nlink == 1)
 		return fallback;
 
 	err = ovl_getxattr_upper(ofs, upperdentry, OVL_XATTR_NLINK,
@@ -1239,7 +1247,7 @@ struct inode *ovl_get_inode(struct super
 		/* Recalculate nlink for non-dir due to indexing */
 		if (!is_dir)
 			nlink = ovl_get_nlink(ofs, lowerdentry, upperdentry,
-					      nlink);
+					      oip->index, nlink);
 		set_nlink(inode, nlink);
 		ino = key->i_ino;
 	} else {
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -599,7 +599,7 @@ int ovl_verify_index(struct ovl_fs *ofs,
 		if (err)
 			goto fail;
 
-		if (ovl_get_nlink(ofs, origin.dentry, index, 0) == 0)
+		if (ovl_get_nlink(ofs, origin.dentry, index, true, 0) == 0)
 			goto orphan;
 	}
 
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -581,7 +581,7 @@ static inline bool ovl_dir_is_real(struc
 int ovl_set_nlink_upper(struct dentry *dentry);
 int ovl_set_nlink_lower(struct dentry *dentry);
 unsigned int ovl_get_nlink(struct ovl_fs *ofs, struct dentry *lowerdentry,
-			   struct dentry *upperdentry,
+			   struct dentry *upperdentry, bool indexed,
 			   unsigned int fallback);
 int ovl_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 		struct iattr *attr);


