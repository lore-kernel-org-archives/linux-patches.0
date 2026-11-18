Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021180;
	b=yFyxuJmVKhhDT/8ARzwrvbhcRdGI3UPppCvNqy8isDOeZFLokbFTqR3MdnvgN4Nt0TYD
	 N7xZIwRV2jF8drMbmUEzM7DW+80YuDh0OnOiPa7hBL68grcQTdaBlXiijcynhdt88HB9Q
	 2VWbxoFuF+4CTkXOIHgwVWAR4NfK2jyIzX8QTzI/kjvNcV5Zu0bTXjRirNEY9a97VnnnV
	 vQacXtOpEPoxn+RvxLrV0cy4HDg+RHE7+WHjjZJ77x/dKtdeTKQ8AyTT23tE6KJQSXf/y
	 yRNeaXY2x0t67L4+PIXiWWcZo7nwwbeStoWIjLh8vS8JI4PYgQNMOJCYm56J7udgY1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dau5aAW3KoRGUElqHbat8FzwaHT5/SRZ3gHnde/fd3A=;
	b=cJa98L45wjl8dxy3bcZqHjE2NYERnGzledreB1olwZaKs6+b6C8xN8pvDasqmolZPtsG
	 VZkVFKPGlNJBIlX9T6zarZ8ssSNBiDKXzlbhkzHjE3N71s/zRrv+xhcSbd8cNnK6h+S97
	 UnuBwwl9E2bCas1NPcwdRmM0e+iLekmeWVN9jXv/9vCUiSzpBzPB0qJ/Tb2TThWjGMM7y
	 67vVYxp5nzwaLUIPAzYBoa9lmyK38gfz16qEIAQd03f8nYGL0JjDmK05xnau5rmg7CESe
	 ZaPgvXpUFhupUxFAT4d+O2CichGCbR4cjS9arCKHguv6G6RHB+sHiQpzmp1U04TbbYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XkrbDe4A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29789606A325;
	Wed, 18 Nov 2026 16:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XkrbDe4A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF961F000C4;
	Wed, 18 Nov 2026 16:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021179;
	bh=dau5aAW3KoRGUElqHbat8FzwaHT5/SRZ3gHnde/fd3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XkrbDe4AYtFBdvZuBaC8vdhHguK4ZTA4b8Pqh2BVMZbM04GBXdALXFmLqbvPG0vLM
	 ZNI6eqBg07omSqe45XzWP5MFtIILzVboYCp5dFcHf8UYg6WFRMXOjEvqPOxqL1h3uO
	 mzHqHWOcHk/aokz0UkgZ18/cXu/CdAEWSsjtXxc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2214/2651] ntfs: reject non-resident attributes whose sizes exceed their allocation
Date: Wed, 18 Nov 2026 15:57:34 +0100
Message-ID: <20261118150405.333420059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit 8e91379152204a9cc18fa7e16724646ad3aec759 ]

ntfs_read_locked_inode(), ntfs_read_locked_attr_inode() and
ntfs_read_locked_index_inode() take a non-resident attribute's data_size
and initialized_size from disk without checking them against its
allocated_size.  The runlist ends at allocated_size and the read path
maps what lies beyond it as a hole, so a data_size larger than the
allocation makes reads return zeros that are not on disk, with no error.

On a crafted volume with 4 KiB clusters where a 6144000-byte file claims
a data_size and initialized_size 64 KiB beyond its allocation, reading
the file returns 16 clusters of such zeros.  A sparse file behaves the
same.  A compressed file instead fails with -EIO after a burst of "Still
have pages left!" errors from ntfs_read_compressed_block().

Require 0 <= initialized_size <= data_size <= allocated_size, with
allocated_size a multiple of the cluster size, when the inode is read,
as fs/ntfs3 does in mi_enum_attr(), and fail with -EIO otherwise, which
marks the inode bad and the volume as having errors.  initialized_size
above data_size is rejected too because an extending write zeroes the
gap it opens only from initialized_size onwards.  An unaligned
allocated_size ends inside a cluster that the read path treats as past
the end: a crafted 66440-byte file with 4 KiB clusters reads its last
904 bytes as zeros.

Sparse and compressed attributes need no exception.  Every non-resident
attribute has a cluster-aligned allocated_size >= data_size, holes
included, on eight public test volumes (seven written by Windows, with
LZNT1-compressed files, a sparse $UsnJrnl:$J and a OneDrive placeholder
whose unnamed $DATA is one hole, and one by mkntfs), on a volume written
by ntfs-3g and on one written by this driver, and the patched driver
reads every file on them as before.  fs/ntfs3 has enforced the same
checks since v6.6, also without exceptions.  The layout.h comment saying
that data_size can exceed allocated_size for compressed and sparse
attributes is corrected.

This also covers a non-resident attribute list, which
load_attribute_list() reads through ntfs_attr_iget(), and $MFT, whose
inode goes through ntfs_read_locked_inode() after the previous patch's
check.  $MFT's own non-resident attribute list goes through neither:
ntfs_read_inode_mount() loads it with load_attribute_list_mount() and
ntfs_read_locked_inode() skips it for $MFT, so the check is added there
too.  The check was already missing in the classic driver; the Fixes
tag names the commit that brought that code back.

Fixes: 1e9ea7e04472 ("Revert "fs: Remove NTFS classic"")
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/inode.c  | 27 +++++++++++++++++++++++++++
 fs/ntfs/layout.h | 13 ++++++++-----
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 71b364e2ca73f..f3e42ec65bdc7 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -651,6 +651,25 @@ void ntfs_set_vfs_operations(struct inode *inode, mode_t mode, dev_t dev)
 	}
 }
 
+static bool ntfs_non_resident_sizes_inconsistent(struct inode *vi,
+						 const struct attr_record *a)
+{
+	s64 allocated_size = le64_to_cpu(a->data.non_resident.allocated_size);
+	s64 data_size = le64_to_cpu(a->data.non_resident.data_size);
+	s64 initialized_size = le64_to_cpu(a->data.non_resident.initialized_size);
+
+	if (initialized_size >= 0 && initialized_size <= data_size &&
+	    data_size <= allocated_size &&
+	    !ntfs_bytes_to_cluster_off(NTFS_I(vi)->vol, allocated_size))
+		return false;
+
+	ntfs_error(vi->i_sb,
+		   "Attribute 0x%x of inode 0x%llx is corrupt (initialized size %lld, data size %lld, allocated size %lld).",
+		   le32_to_cpu(a->type), NTFS_I(vi)->mft_no, initialized_size,
+		   data_size, allocated_size);
+	return true;
+}
+
 /*
  * ntfs_read_locked_inode - read an inode from its device
  * @vi:		inode to read
@@ -1191,6 +1210,8 @@ static int ntfs_read_locked_inode(struct inode *vi)
 					"First extent of $DATA attribute has non zero lowest_vcn.");
 				goto unm_err_out;
 			}
+			if (ntfs_non_resident_sizes_inconsistent(vi, a))
+				goto unm_err_out;
 			vi->i_size = ni->data_size = le64_to_cpu(a->data.non_resident.data_size);
 			ni->initialized_size = le64_to_cpu(a->data.non_resident.initialized_size);
 			ni->allocated_size = le64_to_cpu(a->data.non_resident.allocated_size);
@@ -1453,6 +1474,8 @@ static int ntfs_read_locked_attr_inode(struct inode *base_vi, struct inode *vi)
 			ntfs_error(vi->i_sb, "First extent of attribute has non-zero lowest_vcn.");
 			goto unm_err_out;
 		}
+		if (ntfs_non_resident_sizes_inconsistent(vi, a))
+			goto unm_err_out;
 		vi->i_size = ni->data_size = le64_to_cpu(a->data.non_resident.data_size);
 		ni->initialized_size = le64_to_cpu(a->data.non_resident.initialized_size);
 		ni->allocated_size = le64_to_cpu(a->data.non_resident.allocated_size);
@@ -1682,6 +1705,8 @@ static int ntfs_read_locked_index_inode(struct inode *base_vi, struct inode *vi)
 			"First extent of $INDEX_ALLOCATION attribute has non zero lowest_vcn.");
 		goto unm_err_out;
 	}
+	if (ntfs_non_resident_sizes_inconsistent(vi, a))
+		goto unm_err_out;
 	vi->i_size = ni->data_size = le64_to_cpu(a->data.non_resident.data_size);
 	ni->initialized_size = le64_to_cpu(a->data.non_resident.initialized_size);
 	ni->allocated_size = le64_to_cpu(a->data.non_resident.allocated_size);
@@ -2015,6 +2040,8 @@ int ntfs_read_inode_mount(struct inode *vi)
 					"Attribute list has non zero lowest_vcn. $MFT is corrupt. You should run chkdsk.");
 				goto put_err_out;
 			}
+			if (ntfs_non_resident_sizes_inconsistent(vi, a))
+				goto put_err_out;
 
 			rl = ntfs_mapping_pairs_decompress(vol, a, NULL, &new_rl_count);
 			if (IS_ERR(rl)) {
diff --git a/fs/ntfs/layout.h b/fs/ntfs/layout.h
index 9438fd9b668e2..e4d246f0159fe 100644
--- a/fs/ntfs/layout.h
+++ b/fs/ntfs/layout.h
@@ -811,14 +811,17 @@ enum {
  *                                  on XP SP2+.
  * @data.non_resident.reserved:     5 bytes for 8-byte alignment.
  * @data.non_resident.allocated_size:
- *                                  Allocated disk space in bytes.
- *                                  For compressed: logical allocated size.
+ *                                  Allocated size in bytes, a multiple of
+ *                                  the cluster size.  For compressed and
+ *                                  sparse attributes holes count as
+ *                                  allocated; the clusters actually in use
+ *                                  are in compressed_size.
  * @data.non_resident.data_size:    Logical attribute value size in bytes.
- *                                  Can be larger than allocated_size if
- *                                  compressed/sparse.
+ *                                  Never larger than allocated_size, also
+ *                                  when compressed/sparse.
  * @data.non_resident.initialized_size:
  *                                  Initialized portion size in bytes.
- *                                  Usually equals data_size.
+ *                                  Usually equals data_size, never larger.
  * @data.non_resident.compressed_size:
  *                                  Compressed on-disk size in bytes.
  *                                  Only present when compressed or sparse.
-- 
2.53.0



