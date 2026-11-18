Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040972;
	b=T8Z+pN/L8/Al5l5T55fvdO/5TKRSkBlBG361dKqzhIclxmXas918fIpSwpFLlzZvWwEK
	 lZCxe4vACO+4jojsVxnfXgBamdkmV5B8bCAB6vc45sZZH4SA7r7JsRNqaQUn8J5CbIC8H
	 /hQhrXXfsyJLmosiS7+qyu9wSFeNULIPWgR0H0OaFzPRY0T7U/56DTUqRapoquZgT74Ps
	 qmPf3FxPqPiVVBaLnMW94XdTshRtv2Kd1UwX4HhTel4V7fTGCy1pImJA/7RDcVP2pb2pP
	 8B1bgIxXPI0yoHFDb4st0YjrmSDF30xksyujiSpRcrMHLEjRWfiPXaSaKsr/dFN6jjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0fn4ouD4KcEY1AUX1Nw7EB9zJCN2W7YgvoC1lptwpkM=;
	b=G8X2ah9LEog+lNYSZQQ1MQEvmWAU/sWszYuabau+0pR3LInzfMA9imVpFRXFVVnTI4Td
	 E4mLUkh7Bn9Jwg7sjkOqmjxJhqgqP+Xy1p1csKqZvoTXxa2vJg8+84Cpo1GI3WG4Zeklm
	 ar6AKf/qr1yaPpTKfdzWzUqwR1RA1OdnqP7LQTcFzpN8iXuFGXgUqEvg3t3MwD5o+df2p
	 MDVvlM8h3GT2p/i1WsEbrOL8UM+RHG0oKwwV1bvUOIoDU69INAE51NlzhIEki0w1/gJfu
	 z11JGKuSEAtLE2C3nXf8w9kaNi5vlNzRl6i64/7wpq3QM6Fq16Yq44TO8hrIp5sMDTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c0sdUHs+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4597606A31C;
	Wed, 18 Nov 2026 22:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c0sdUHs+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C7D1F000C4;
	Wed, 18 Nov 2026 22:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040972;
	bh=0fn4ouD4KcEY1AUX1Nw7EB9zJCN2W7YgvoC1lptwpkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0sdUHs+XWD6RVMZ8TEvXua0XE4KCpu/oOM+cB4vc8wodQ2V0dT07TGsHBnG0vk+A
	 4yO8IisOPxm2cbroDDI68hGyXgoVKvAf3oDuJe1898wZnNy+IM5oBDg8Y9y0Gq8+TO
	 5xZHhGWyn9LuKMHjjDHKxHvevxXaU7HfvJRMzMe8=
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
Subject: [PATCH 6.6 2647/3318] ocfs2: allow xattr bucket entries to span multiple blocks
Date: Wed, 18 Nov 2026 15:54:29 +0100
Message-ID: <20261118150440.465062765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9752fcfff1091..e0f2939978709 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1121,11 +1121,30 @@ static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
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



