Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019001;
	b=2EYn7PMpAyiwZOrFyzishQog2Yg7m5bpLhBSH7IHVlH6lkbDtbb/b9AUKJEunu/wA/v5
	 IlxYG2E1pd9265DeXRzJVtv1kbtIeKy8fWH40pHHXkB4HRk3uUl36lnWkSzVdcKD/Vitt
	 Csq2LK5QGdwCyvo/sfk+cI4HEGeyKVe+c6u55HN15CRfq/rEep6ZVWcVd786TyJzEl+qx
	 use2vcfkpl3aS8Lnnu/rYrDZXZomHnnS+pLOxhOpyn+bGDUQYLnWktt56M+pKkI0f0yTl
	 s27sma5KLg33UmNIiDoYQU2+WgVEvI4AJhS9nq1LhlptRdvpz6ZZWzoi67FZA4TUQKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9W0KATH+HsT+FGU8U+lKjmz4t7B53N3GTf7kemn5iXI=;
	b=pttCzHlWtw2pEYQ4YzwcDpO4XuOzOG7NiikU7t7QGgJ2dtH59YNiHbZgWWfT8I72MEu5
	 X2+idiGA7mh5nue4L7PXt/XETYkbgWiXTTBpeahgTxPPGbRWcLSQRU3dUtaeBA49mWr7Q
	 N7jBaxJ/T4shXj8ke+dhDAS5HMQy35H8Xg8HluGzaXCYTh5VcC+cnXaoBru4UjMxv88ia
	 6rZRHnCSfFbkDIvrECSikQ0IFiObTCMRB+IaYyfH8xsS03rleznotV70OsJkxYELfnRKv
	 w3lDj6y8FUH9y82ZUYbhDMhyhwNCkmBECLIBsjuceF2TOXkkwvfG0K/TZww4rttjhyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DDHXk/ec";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EFF606A31C;
	Wed, 18 Nov 2026 16:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DDHXk/ec
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3BF1F000C5;
	Wed, 18 Nov 2026 16:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019001;
	bh=9W0KATH+HsT+FGU8U+lKjmz4t7B53N3GTf7kemn5iXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DDHXk/ecaKHHDlRpkQQ/2cYZkaB3rV3tOCRF+10OgnUr6jMdw9qaeaTfE99mHoqDQ
	 3BAIPghrjd4hSoRh+m5742OvK2MHP0SX5fSXQYZkTwL6VD9sfsdjsHLTBdmLviY8Kz
	 BdUqTdDPtv4+8H9KUXL1u49jyw8ov2VefBqQYSNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1399/2651] ocfs2: allow xattr bucket entries to span multiple blocks
Date: Wed, 18 Nov 2026 15:43:59 +0100
Message-ID: <20261118150338.376491857@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 78cce2082d22d3c56bd3a6146ef0dcf7cd661a33 ]

Patch series "ocfs2: xattr bucket validation fixes", v2.

This series fixes two problems around xattr bucket validation.

Patch 1 fixes a false-corruption failure on blocksize-512 volumes: the
bucket validator limited the entry array to the first bucket block while
the write path stores entries across the whole 4096-byte bucket region, so
a legitimately written, fsck-clean bucket could be rejected and force the
filesystem read-only.  It also adds an alignment check on the bucket block
number, since the entry array is accessed as one contiguous region and a
corrupted xattr tree could otherwise point a bucket at blocks straddling a
page boundary.

Patch 2 converts two mlog_bug_on_msg() checks in the bucket defrag path to
ocfs2_error() returns, so that a corrupt bucket holding overlapping
entries or an inflated xh_free_start marks the filesystem read-only and
fails the setxattr instead of panicking the kernel.

Both patches have been tested in QEMU: the blocksize-512 reproducer (40
xattrs with 100-byte values, previously failing with "entry count 32
exceeds maximum 31") now passes with a clean fsck.ocfs2 result, and the
ocfs2 testsuite xattr tests pass 48/48 across blocksize combinations.

This patch (of 2):

ocfs2_validate_xattr_bucket() limits the entry array to the first bucket
block, but the write path stores entries across the whole
OCFS2_XATTR_BUCKET_SIZE region.  With 512-byte blocks a bucket spans eight
blocks, and a bucket filled with small xattrs places its last entries past
offset 512.  Reading such a bucket back errors out:

  OCFS2: ERROR (device loop0): ocfs2_validate_xattr_bucket: Invalid xattr bucket 86072: entry count 32 exceeds maximum 31
  On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
  OCFS2: File system is now read-only.

This is reproducible by setting ~33 xattrs with 100-byte values on a file
on a blocksize-512 volume; fsck.ocfs2 reports the resulting image clean.

Check the entry count against the full bucket region instead.  The
per-block bounds checks for names and values stay as they are, since
ocfs2_bucket_align_free_start() keeps each name+value pair within a single
block.

The entry array is one contiguous region, so a bucket from a corrupted
xattr tree whose first block is not aligned to OCFS2_XATTR_BUCKET_SIZE
could straddle a page and make the validation loop read out of bounds.
Buckets allocated within clusters are always aligned, so reject any other
block number while validating.

Link: https://lore.kernel.org/20260903131313.2396208-1-joseph.qi@linux.alibaba.com
Link: https://lore.kernel.org/20260903131313.2396208-2-joseph.qi@linux.alibaba.com
Fixes: 2cf82b46d5e4 ("ocfs2: validate external xattr entries when reading metadata")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index ac7e18de81986..e3c50cd120cd1 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1125,11 +1125,30 @@ static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
 	u16 xattr_count = le16_to_cpu(xh->xh_count);
 	size_t region_size = (size_t)sb->s_blocksize * bucket->bu_blocks;
-	size_t entries_limit = sb->s_blocksize;
+	/*
+	 * The entry array grows up from the header across the whole
+	 * bucket region, so it may extend beyond the first bucket block
+	 * when the blocksize is smaller than OCFS2_XATTR_BUCKET_SIZE.
+	 * Name/value pairs, however, always live within a single block.
+	 */
+	size_t entries_limit = region_size;
 	size_t nv_limit = sb->s_blocksize;
 	size_t max_entries;
 	int i;
 
+	/*
+	 * The entry array is one contiguous region that may span the
+	 * bucket's buffer_heads.  Buckets are allocated within clusters,
+	 * so their first block is always aligned to
+	 * OCFS2_XATTR_BUCKET_SIZE and the whole bucket fits in one page.
+	 * A corrupted xattr tree can point a bucket at blocks straddling
+	 * a page, so reject it before touching the entry array.
+	 */
+	if (blkno & (bucket->bu_blocks - 1))
+		return ocfs2_error(sb,
+				   "Invalid xattr bucket %llu: unaligned block number\n",
+				   (unsigned long long)blkno);
+
 	if (region_size < sizeof(*xh))
 		return ocfs2_error(sb,
 				   "Invalid xattr bucket %llu: region size %zu is too small\n",
-- 
2.53.0



