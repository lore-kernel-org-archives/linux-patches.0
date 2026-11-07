Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061689;
	b=HjrIcpitSGnzUEDJaj/mpQiP6UytyMNURWofl/DhBXVrJh72b0jy0My9ZVbT4Ozhb1mW
	 ncbntK1dU6leYPAyy/d+hpz8xFZO9ud4fJUlH90yZqhzlv8kUMZqRx2iyoiQjIPeyz0J9
	 UqYsJB/MDznjY8UnL2UVDWxbb/t6iFHQpyOp2S16vU2c/GyD+jxZj43l8m3Qzjapt8qFc
	 eCOss0TMCb2bR642IFyMn5XoNIrawg4km9ynk6ZG1fMNr9RoPX9CLjQm8KfwBwNgEymEW
	 DYWgY2RnhtZ/Nw6slIAG0uUSSK8TeT8bKeXvcGUeZh1mLExhp0C5fc7v0Su8iz6XYGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Ux94dwCteUxtXK0d61d/XfUZBg/sOid5QLDwS0J5Tw=;
	b=RwNEfUNjoc44I5TYoN9ffYx+GL9izdXGQEhr0HDjrdYHc2bNkSwu3MtOwYd+ezNVUMDP
	 oomDDWGwZFEVUq772L5OtypyV9qsUhpEZICEJfssTEQxMHc8GngubZLi4pq7/xbxD0bk5
	 FlyP9CtaVPSXItS2tal3n16wfxXZJWy4aZf6NTI6N6aGsYiuJcOoiuUA3pFfLrOWL7hbt
	 QTF/Im4coqEjY4bm8Az8wL/p/gAzl2WrFS2Ux8ntBfIu/9R5zjwjbRaVlm0y6zny2e4fV
	 lQC06hiAxJpqip/hW6cdjrXuqPJyef4H2jjr27dyY9AqSg5L4ngC29lQnBTQxQ3GXZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wkNiMrJx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F9B606A32C;
	Sat,  7 Nov 2026 14:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wkNiMrJx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AA21F008A1;
	Sat,  7 Nov 2026 14:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061689;
	bh=6Ux94dwCteUxtXK0d61d/XfUZBg/sOid5QLDwS0J5Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wkNiMrJxS0WOeGbMArYspECd41XDXL+PKYR0WR2aMt+k8iDxzC6r0WQn3Qn2ENJ90
	 tk4OxWP/xC3Qr6/IrqIXsePVdMQ8RGh9h1ECJG9nJn6LESGyP6NQb4G/GDS2Ps4Wuu
	 8vZC/BEkXHo8q+9nDJ7fRQX0cVRwvJVo3kp42pAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0739/1536] xfs: dont subtract excess usage twice when computing agf_btreeblks
Date: Sat,  7 Nov 2026 08:45:55 -0500
Message-ID: <20261107135018.276634319@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 4439b626fb5104204952aa2f169451688fb6be26 upstream.

LOLLM noticed that the free space btree repair code calculates
agf_btreeblks from the number of blocks we wrote to rebuild the free
space btrees (minus the roots).  That's correct.  However, it observes
that we subtract the "excess" reservation, which is not correct.  Fix
this accounting problem.

Cc: stable@vger.kernel.org # v6.8
Fixes: 4bdfd7d15747b1 ("xfs: repair free space btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/alloc_repair.c |    6 +-----
 fs/xfs/scrub/newbt.c        |   13 -------------
 fs/xfs/scrub/newbt.h        |    1 -
 3 files changed, 1 insertion(+), 19 deletions(-)

--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -663,15 +663,11 @@ xrep_abt_reset_counters(
 
 	/*
 	 * Compute the contribution to agf_btreeblks for the new free space
-	 * btrees.  This is the computed btree size minus anything we didn't
-	 * use.
+	 * btrees.  This is the computed btree size minus the root block.
 	 */
 	freesp_btreeblks += ra->new_bnobt.bload.nr_blocks - 1;
 	freesp_btreeblks += ra->new_cntbt.bload.nr_blocks - 1;
 
-	freesp_btreeblks -= xrep_newbt_unused_blocks(&ra->new_bnobt);
-	freesp_btreeblks -= xrep_newbt_unused_blocks(&ra->new_cntbt);
-
 	/*
 	 * The AGF header contains extra information related to the free space
 	 * btrees, so we must update those fields here.
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -555,16 +555,3 @@ xrep_newbt_claim_block(
 	/* Relog all the EFIs. */
 	return xrep_defer_finish(xnr->sc);
 }
-
-/* How many reserved blocks are unused? */
-unsigned int
-xrep_newbt_unused_blocks(
-	struct xrep_newbt	*xnr)
-{
-	struct xrep_newbt_resv	*resv;
-	unsigned int		unused = 0;
-
-	list_for_each_entry(resv, &xnr->resv_list, list)
-		unused += resv->len - resv->used;
-	return unused;
-}
--- a/fs/xfs/scrub/newbt.h
+++ b/fs/xfs/scrub/newbt.h
@@ -70,6 +70,5 @@ void xrep_newbt_cancel(struct xrep_newbt
 int xrep_newbt_commit(struct xrep_newbt *xnr);
 int xrep_newbt_claim_block(struct xfs_btree_cur *cur, struct xrep_newbt *xnr,
 		union xfs_btree_ptr *ptr);
-unsigned int xrep_newbt_unused_blocks(struct xrep_newbt *xnr);
 
 #endif /* __XFS_SCRUB_NEWBT_H__ */


