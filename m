Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E2544376;
	Thu, 15 Aug 2024 13:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729604; cv=none; b=NdS0tOuk1ubJh28B7PITBU5tsnOxbQrvdzDtjRcHqGN0GtjY4KRrSl7f3eWmAyFcb+J61Il7XwziJIP4lagdziX9JpUsA1O+x4eeVC3EemsAdcEPMaF0MRZFcZNJp1KKdX0rq6yUk5r0Cf1k0bbbajW3/zcGrrUUoRozfiXcdzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729604; c=relaxed/simple;
	bh=ac5MApzJBke8XqnUwI5/07tALhRsPY1UX6oiKRaZZRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KS7j8+5mhub0zsCfoezorWwt4hJN+gjePSiQNCQciAqx7x4B+ZaZKFXPCJ8hi8X0HCj2NbcyobERyv4qJPJonYd3znFLcSCCR571XgkecEHi0728LQl8dzdaNErnkhaIEzezxZ2Qqx3cdVdAAYDf3uIit/Yyemse+VffqBVn7eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0Yk2j/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0Yk2j/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4259C32786;
	Thu, 15 Aug 2024 13:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729604;
	bh=ac5MApzJBke8XqnUwI5/07tALhRsPY1UX6oiKRaZZRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0Yk2j/I+T+Ymr+5/+2sI2Ze1Jo22A9pbKRYpouhCTNjRWomF8m1AR53oE6KXkeqn
	 eOE6tVF9ySpzIpIk6JoK82vhQmgG2Kgm2BH+FC4Pcf2+10T5wQeW4EvRlwNfR7qJ2r
	 8LJMU9RQh4MLy2GoEyasYtuziHNnvPXUQDBrQuqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/484] fs/ntfs3: Merge synonym COMPRESSION_UNIT and NTFS_LZNT_CUNIT
Date: Thu, 15 Aug 2024 15:20:08 +0200
Message-ID: <20240815131947.210464166@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 487f8d482a7e51a640b8f955a398f906a4f83951 ]

COMPRESSION_UNIT and NTFS_LZNT_CUNIT mean the same thing
(1u<<NTFS_LZNT_CUNIT) determines the size for compression (in clusters).

COMPRESS_MAX_CLUSTER is not used in the code.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 25610ff98d4a ("fs/ntfs3: Fix transform resident to nonresident for compressed files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c  | 2 +-
 fs/ntfs3/frecord.c | 2 +-
 fs/ntfs3/fslog.c   | 2 +-
 fs/ntfs3/inode.c   | 2 +-
 fs/ntfs3/ntfs.h    | 3 ---
 5 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 64a6d255c4686..558a7e9bf1ef2 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -265,7 +265,7 @@ int attr_make_nonresident(struct ntfs_inode *ni, struct ATTRIB *attr,
 
 	align = sbi->cluster_size;
 	if (is_attr_compressed(attr))
-		align <<= COMPRESSION_UNIT;
+		align <<= NTFS_LZNT_CUNIT;
 	len = (rsize + align - 1) >> sbi->cluster_bits;
 
 	run_init(run);
diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index b02778cbb1d34..da21a044d3f86 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1453,7 +1453,7 @@ int ni_insert_nonresident(struct ntfs_inode *ni, enum ATTR_TYPE type,
 
 	if (is_ext) {
 		if (flags & ATTR_FLAG_COMPRESSED)
-			attr->nres.c_unit = COMPRESSION_UNIT;
+			attr->nres.c_unit = NTFS_LZNT_CUNIT;
 		attr->nres.total_size = attr->nres.alloc_size;
 	}
 
diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 8ac677e3b250c..8b8125b0e7fb8 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -2999,7 +2999,7 @@ static struct ATTRIB *attr_create_nonres_log(struct ntfs_sb_info *sbi,
 	if (is_ext) {
 		attr->name_off = SIZEOF_NONRESIDENT_EX_LE;
 		if (is_attr_compressed(attr))
-			attr->nres.c_unit = COMPRESSION_UNIT;
+			attr->nres.c_unit = NTFS_LZNT_CUNIT;
 
 		attr->nres.run_off =
 			cpu_to_le16(SIZEOF_NONRESIDENT_EX + name_size);
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index ff45ad967fb82..7adfa19a2f067 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1465,7 +1465,7 @@ struct inode *ntfs_create_inode(struct user_namespace *mnt_userns,
 			attr->size = cpu_to_le32(SIZEOF_NONRESIDENT_EX + 8);
 			attr->name_off = SIZEOF_NONRESIDENT_EX_LE;
 			attr->flags = ATTR_FLAG_COMPRESSED;
-			attr->nres.c_unit = COMPRESSION_UNIT;
+			attr->nres.c_unit = NTFS_LZNT_CUNIT;
 			asize = SIZEOF_NONRESIDENT_EX + 8;
 		} else {
 			attr->size = cpu_to_le32(SIZEOF_NONRESIDENT + 8);
diff --git a/fs/ntfs3/ntfs.h b/fs/ntfs3/ntfs.h
index 1197d1a232962..b992ec42a1d92 100644
--- a/fs/ntfs3/ntfs.h
+++ b/fs/ntfs3/ntfs.h
@@ -82,9 +82,6 @@ typedef u32 CLST;
 #define RESIDENT_LCN   ((CLST)-2)
 #define COMPRESSED_LCN ((CLST)-3)
 
-#define COMPRESSION_UNIT     4
-#define COMPRESS_MAX_CLUSTER 0x1000
-
 enum RECORD_NUM {
 	MFT_REC_MFT		= 0,
 	MFT_REC_MIRR		= 1,
-- 
2.43.0



