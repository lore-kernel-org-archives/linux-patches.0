Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828912;
	b=pBZ34wyO0aqbEm77JulKCBptLA3PmG7c4mckMoQW1ITEti7n0U8PbQKhuqFoe3KqcZ6C
	 4Vry/T7VCHrYHOFwR2D5FY0ciWA5MIDeLdLsLiIP33Bx+CI8LDyR+kFtPJayiHH68VG4m
	 aUwxnssMn7+532JCareB2rINyObDGIW1y7RiCNFukTV11PzBO5jR4ebYTrY3KPVI/WyUO
	 GiM+H9ftWVxp5aRAsJp+m+8BDmR/I/H8f+tbGXoeOEFTMcx9GoSryW1/b79LGml0EnL1v
	 Qc8I+5jcqX0zXUeXpRaASeLvviOoNH+2gFktQwYZjjnKT1/YgQvzmHI4PRbSCgR/USg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ScvKp8C2XGjZSXRbp2WMhLwNQ4k43AlBQfybjNrD59c=;
	b=qy2pqcJYFVkLd5zv8jLmxFumWELIQ0tYto9x4jBx0ZrTD5LPzZUAeyqItDhwi4q/2gVj
	 XGnQw89ApH+eq6azOiHFRsjidL8uknKog/wCgojaJD3TPRqsqKlMPcIerGlJ2VPLh5Kg2
	 m9HVoPs32FpoymJ8F1uF/AfL94S/v2BMsGBSVJisJ/g9GNz4nzhLBs2VXbEaIjY4ohBdg
	 eLW56w9gNIy28DOJoWTGMrkBgpcruZu8nqsAcrL9CmQT6mhuQa6WTojzj1h9CDrsfrVVG
	 b3cKNZaIKZEScfdpCV1E+K2iKAsIf+nObd/GhTy1rdfF/I1DU4pBitIvbHSkcg88sJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lFDp7pmI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753C86072641;
	Wed,  4 Nov 2026 21:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lFDp7pmI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0371F000C1;
	Wed,  4 Nov 2026 21:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828912;
	bh=ScvKp8C2XGjZSXRbp2WMhLwNQ4k43AlBQfybjNrD59c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lFDp7pmIDkQqarlogVTzArc6tyQDBf7CrCyNORgVOfGAIxl8UhuTiQQJTQxkPKds1
	 8maT0c+92K/CFM7ejgC6xH8pEokSVlPGX9b1wsU4N8GjbB/VgvW+K5W5K3/ZWGguwu
	 Sgrc9xDG/FtbIJWG2bdDyVliehs3+01/SFFKPl30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 322/547] xfs: allow softlimit with no hardlimit in quota scrub
Date: Wed,  4 Nov 2026 16:08:26 -0500
Message-ID: <20261104211047.369141334@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 342c2e00b3a99099a7088f7b8c8f075670c603a9 upstream.

LOLLM observes that the sysadmin can set a user's soft limit to a
nonzero value and the hard limit to zero, so those aren't corruptions.

Cc: stable@vger.kernel.org # v4.15
Fixes: c2fc338c87a31f ("xfs: scrub quota information")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/quota.c        |    8 ++++----
 fs/xfs/scrub/quota_repair.c |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -182,21 +182,21 @@ xchk_quota_item(
 	 * suspect, which is why we flag it for review.
 	 *
 	 * Complain about corruption if the soft limit is greater than
-	 * the hard limit.
+	 * the hard limit and there's a hard limit set.
 	 */
 	if (dq->q_blk.hardlimit > mp->m_sb.sb_dblocks)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (dq->q_blk.softlimit > dq->q_blk.hardlimit)
+	if (dq->q_blk.hardlimit && dq->q_blk.softlimit > dq->q_blk.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	if (dq->q_ino.hardlimit > M_IGEO(mp)->maxicount)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (dq->q_ino.softlimit > dq->q_ino.hardlimit)
+	if (dq->q_ino.hardlimit && dq->q_ino.softlimit > dq->q_ino.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	if (dq->q_rtb.hardlimit > mp->m_sb.sb_rblocks)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (dq->q_rtb.softlimit > dq->q_rtb.hardlimit)
+	if (dq->q_rtb.hardlimit && dq->q_rtb.softlimit > dq->q_rtb.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	/* Check the resource counts. */
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -193,17 +193,17 @@ xrep_quota_item(
 		goto out_unlock_dquot;
 
 	/* Check the limits. */
-	if (dq->q_blk.softlimit > dq->q_blk.hardlimit) {
+	if (dq->q_blk.hardlimit && dq->q_blk.softlimit > dq->q_blk.hardlimit) {
 		dq->q_blk.softlimit = dq->q_blk.hardlimit;
 		dirty = true;
 	}
 
-	if (dq->q_ino.softlimit > dq->q_ino.hardlimit) {
+	if (dq->q_ino.hardlimit && dq->q_ino.softlimit > dq->q_ino.hardlimit) {
 		dq->q_ino.softlimit = dq->q_ino.hardlimit;
 		dirty = true;
 	}
 
-	if (dq->q_rtb.softlimit > dq->q_rtb.hardlimit) {
+	if (dq->q_rtb.hardlimit && dq->q_rtb.softlimit > dq->q_rtb.hardlimit) {
 		dq->q_rtb.softlimit = dq->q_rtb.hardlimit;
 		dirty = true;
 	}


