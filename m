Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6765B1FBA;
	Tue, 30 Jul 2024 17:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359441; cv=none; b=M69UHho7LDgU0CAxKqlDILmIYywm59NJYpFVAFY6hu+eU8qK9hRNqnMSkJLEcDIUqlFpPjHfYRMjxpzyJdy/7E+zfXtiewdlkY9brcphwJU2M9amGip4K/NKpTZ3KQlwaY2e5xKEDMyRdaCqZ1dY3/BiElhSXxDS6NQm4naoD4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359441; c=relaxed/simple;
	bh=KuqWbI0wG8itLnzn/7VDKu35ZuoENrfVdKBSKZQtnfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNigkCc3yoUzCOZTTiS3XuwvwpiiwYOu5xWlvVUcohk8WN6YBwJUHQQOOC0gRPqgxmOmS3MKxZkR98KdikehlKInK9ssBIMX+6CTm4Ezaphtnl+6KCY38+9uzRnVCkw6KcK2+JY+n+xCIUYyB1+lR0U5+lDWq//DbSv0RWaFBFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CLV2Q7Mp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CLV2Q7Mp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB864C32782;
	Tue, 30 Jul 2024 17:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359441;
	bh=KuqWbI0wG8itLnzn/7VDKu35ZuoENrfVdKBSKZQtnfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CLV2Q7MpXEfMSHn05+8qQXa4jinz+B0THAUTt8S3gTDLl0Dq7t/jMy++PPR6MaDby
	 In2lK9turVjK/5/5mrDjQxjMWjbLTth4T/EYLzipOiE2riMSQUGrWjwAEC0euGYXpe
	 Q9yKFSp5p3yDa1iGILQCwvGIazF5qxWzqU7UnJX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 484/809] fs/ntfs3: Merge synonym COMPRESSION_UNIT and NTFS_LZNT_CUNIT
Date: Tue, 30 Jul 2024 17:46:00 +0200
Message-ID: <20240730151743.854134867@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8e6bcdf99770f..9ccec45190749 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -254,7 +254,7 @@ int attr_make_nonresident(struct ntfs_inode *ni, struct ATTRIB *attr,
 
 	align = sbi->cluster_size;
 	if (is_attr_compressed(attr))
-		align <<= COMPRESSION_UNIT;
+		align <<= NTFS_LZNT_CUNIT;
 	len = (rsize + align - 1) >> sbi->cluster_bits;
 
 	run_init(run);
diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 0008670939a4a..4822cfd6351c2 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1501,7 +1501,7 @@ int ni_insert_nonresident(struct ntfs_inode *ni, enum ATTR_TYPE type,
 
 	if (is_ext) {
 		if (flags & ATTR_FLAG_COMPRESSED)
-			attr->nres.c_unit = COMPRESSION_UNIT;
+			attr->nres.c_unit = NTFS_LZNT_CUNIT;
 		attr->nres.total_size = attr->nres.alloc_size;
 	}
 
diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 40926bf392d28..e47c2105a24e9 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -2996,7 +2996,7 @@ static struct ATTRIB *attr_create_nonres_log(struct ntfs_sb_info *sbi,
 	if (is_ext) {
 		attr->name_off = SIZEOF_NONRESIDENT_EX_LE;
 		if (is_attr_compressed(attr))
-			attr->nres.c_unit = COMPRESSION_UNIT;
+			attr->nres.c_unit = NTFS_LZNT_CUNIT;
 
 		attr->nres.run_off =
 			cpu_to_le16(SIZEOF_NONRESIDENT_EX + name_size);
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 0f1664db94ad9..8521238f5448e 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1508,7 +1508,7 @@ int ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 			attr->size = cpu_to_le32(SIZEOF_NONRESIDENT_EX + 8);
 			attr->name_off = SIZEOF_NONRESIDENT_EX_LE;
 			attr->flags = ATTR_FLAG_COMPRESSED;
-			attr->nres.c_unit = COMPRESSION_UNIT;
+			attr->nres.c_unit = NTFS_LZNT_CUNIT;
 			asize = SIZEOF_NONRESIDENT_EX + 8;
 		} else {
 			attr->size = cpu_to_le32(SIZEOF_NONRESIDENT + 8);
diff --git a/fs/ntfs3/ntfs.h b/fs/ntfs3/ntfs.h
index 3d6143c7abc03..1f2cdb0dbbe1d 100644
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



