Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058948;
	b=Wqxx5Ezvys59PW7OfUPRBliR6o1eITUjnk8AEaofIV7GV/2X9Eqke67IFWIuKG2PnFbS
	 tarNCSWnUFy8ezR0vzwrCQ3JSI97YOTJDDhtM6G4LzgQKBMvrfxNPjOLt29jVGnm8KOAO
	 o6n2yXvkKF/SPFQvdI4WqcXxR/8tp+2kPbqCFhRWMtrJuW4I1NK9DJPEJ/2ZqfI0pKxNI
	 5WkdJJE5B2LBDsG+CDCGkTQVmzb5PDedEwGRO/nl+sOi/COINChQP7oj1pwgFeITVECdo
	 XQP2kBeogt7aPX9lkyCoz1D1VHsN0aqaK+gaibdItC3pv0Kd05Pgk/6ADFE0CjfCrYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kto5gzJas7An4vrkQOWWoAxBHVZmkVROvKgsdWaJv0g=;
	b=VLX5ncbTAWYhcULoEPVTyKtUKAK70m9/GX7cAjnT14Xg82jwwLGnLZuVS4BV6LF8+GkY
	 wjaXNswyfra60ueMB0uB+2cnv22SS3QXSp2wt0g5/Fqt1wodiDqDf6VTpaKyY8ocbLWe1
	 pI21pg0VKda9myEmRW0kHAjJHv0XL5d7zEpp4VLJQgVjQBPmsEuhhXhfW10N8c8ZAwr6Q
	 nhmppcse5B8TFdYgVRrmcdnmXAA7ft9YdUtNtK6fnRlu8+NIrxufynTnuHVL+3Ro4TCtz
	 mkXh5I1rmVqZAjOF78q1t8u84VoOpzKzs6drFT6cXyRdo66bFDvxk3/YXrINbSL61Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="p5f/xCdm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94259606A31C;
	Thu, 19 Nov 2026 03:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p5f/xCdm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E571F000C4;
	Thu, 19 Nov 2026 03:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058948;
	bh=kto5gzJas7An4vrkQOWWoAxBHVZmkVROvKgsdWaJv0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p5f/xCdmuil2cxBssBPImfDn+a2LvzrhcZKQQP70jtTV6OeQlo81ljf30VWu9dc56
	 TvS5tITniBKx2PWl9QULClo7eQ6qfIY5aDAzlCKIF03SnfWTjVhCQE/ex7ZD7mvDOX
	 Gl3oyNFDG5fBK7m8VHIDcR3/F9vzpkZPzVeI/gtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0626/1848] xfs: improve dirent bounds checking in scrub and repair
Date: Wed, 18 Nov 2026 15:44:24 +0100
Message-ID: <20261118145941.726172573@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 5d470234d04dae6fe2ca2cf4b9ef277b78c7e05a ]

LOLLM complains that we don't do enough bounds checking of the directory
entries in directory blocks when we're looking for errors or trying to
salvage entries.  Let's improve that with more detailed checks.

Cc: stable@vger.kernel.org # v4.16
Fixes: ce92d29ddf9908 ("xfs: directory scrubber must walk through data block to offset")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: adapted helper-based checks to the existing inline xchk_dir_rec() loop ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/dir.c | 61 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 55 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index b045e95c2ea73..5b6263e8a956d 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -205,6 +205,7 @@ xchk_dir_rec(
 	xfs_dahash_t			hash;
 	struct xfs_dir3_icleaf_hdr	hdr;
 	unsigned int			tag;
+	bool				foundit = false;
 	int				error;
 
 	ASSERT(blk->magic == XFS_DIR2_LEAF1_MAGIC ||
@@ -249,28 +250,68 @@ xchk_dir_rec(
 	dent = bp->b_addr + off;
 
 	/* Make sure we got a real directory entry. */
-	iter_off = geo->data_entry_offset;
 	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
 	if (!end) {
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 		goto out_relse;
 	}
-	for (;;) {
+	iter_off = geo->data_entry_offset;
+	while (iter_off < end) {
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + iter_off;
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + iter_off;
+		unsigned int			advance;
 
-		if (iter_off >= end) {
+		/* must have freetag */
+		advance = offsetof(typeof(*dup), length);
+		if (iter_off + advance >= end) {
 			xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 			goto out_relse;
 		}
 
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			iter_off += be16_to_cpu(dup->length);
+			if (iter_off + sizeof(*dup) > end) {
+				xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK,
+						rec_bno);
+				goto out_relse;
+			}
+
+			advance = round_up(be16_to_cpu(dup->length),
+					XFS_DIR2_DATA_ALIGN);
+			if (!advance || iter_off + advance > end) {
+				xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK,
+						rec_bno);
+				goto out_relse;
+			}
+
+			iter_off += advance;
 			continue;
 		}
-		if (dep == dent)
+
+		/* must have namelen */
+		advance = offsetof(typeof(*dep), name);
+		if (iter_off + advance >= end) {
+			xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+			goto out_relse;
+		}
+
+		/* Don't walk off the end of the block. */
+		advance = xfs_dir2_data_entsize(mp, dep->namelen);
+		if (!advance || iter_off + advance > end) {
+			xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+			goto out_relse;
+		}
+
+		if (dep == dent) {
+			foundit = true;
 			break;
-		iter_off += xfs_dir2_data_entsize(mp, dep->namelen);
+		}
+		iter_off += advance;
+	}
+
+	/* Hash tree must point to the exact dirent */
+	if (!foundit) {
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		goto out_relse;
 	}
 
 	/* Retrieve the entry, sanity check it, and compare hashes. */
@@ -283,6 +324,14 @@ xchk_dir_rec(
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 		goto out_relse;
 	}
+
+	/* Name must not overflow end of block */
+	if ((char *)dent->name + dent->namelen >
+	    (char *)bp->b_addr + BBTOB(bp->b_length)) {
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		goto out_relse;
+	}
+
 	calc_hash = xfs_da_hashname(dent->name, dent->namelen);
 	if (calc_hash != hash)
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
-- 
2.53.0



