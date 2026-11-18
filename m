Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058897;
	b=s1e0pKzj0xvxZrYJ/okw3B39bR2r8GJWnBxl39ZNqpujZt2i++awSdlYgF7yTKxCOnrt
	 CGdeo9it4WU+6chkw3cewiNn1LwG9IirPJI2JaIhMrfrN73EYRFGtAb1LbICcOiTyOApM
	 VyNdfGH1kTM2os5plzT8Pxu+2o1Ddmifrxy76LYa6GnFbCyrI2xnMfYWLLAdYBIvObzUn
	 fNChQxem6ppqv5/Uh+KDolW2ewTCC82WW4s8iK0fBTdqLr90/YhpSzH2eAESE5meNM/TC
	 jj97AsBV6TWSXKjfflfmQwUeYsivKM50OhTYC1I+kMcYrhNu3Nbq0cqq5PAMTRH/Osw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fbSpzsgVyjKwyp290OJRadobi3KNCu/welkYATHPcMQ=;
	b=dSUZQKPwzRx/lG5r8HDKNh5Aa6tmuXRrr/zFF086mKzE6//6hr5NodWLT2bPIQseyGq7
	 AH3BMg7FaKpQUhVkg2jDB0e/ygCJZVm2yuTOC84JX88zFi3zrt+p9IomMkcK/ccDmBT2k
	 xM52q3BlBbKvTzyqWxAdqgOCuUTxbdQauJYuyRMuqNSYZlKp88TME9hbKpI9rTDoHRAhD
	 Ch3tbSKRkJKLlFspIXr7bgFQe7rJP1Ppi0e8puFVxZDkjt4JAJJG0LQa6t7RNZTNDFfT9
	 GoKuFVDxNiC1xYaLKE9A0W1LbjvgXYknfH27DS1mDj+LZwkqz9u5rHH86gACwImw41Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WNrL1U9U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73F9606A330;
	Thu, 19 Nov 2026 03:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WNrL1U9U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016921F000C4;
	Thu, 19 Nov 2026 03:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058897;
	bh=fbSpzsgVyjKwyp290OJRadobi3KNCu/welkYATHPcMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNrL1U9U6pztJNf0hhKe5bZm94eAv6Z/UMXLfkzZsGrTyqOPdGsFUtiz5wXbMOq3B
	 kMuKneaOBFN2L3NG4uVva91lMbsEOxrY9lTz3QDSR6tbswvi2FZNnJiw+r1RAsZGy5
	 +CixHiXZIfv6bPV8IkrWd57K2k8+OwLvI8PnRJeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0649/1848] xfs: allow softlimit with no hardlimit in quota scrub
Date: Wed, 18 Nov 2026 15:44:47 +0100
Message-ID: <20261118145942.978493610@linuxfoundation.org>
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

[ Upstream commit 342c2e00b3a99099a7088f7b8c8f075670c603a9 ]

LOLLM observes that the sysadmin can set a user's soft limit to a
nonzero value and the hard limit to zero, so those aren't corruptions.

Cc: stable@vger.kernel.org # v4.15
Fixes: c2fc338c87a31f ("xfs: scrub quota information")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: omitted the quota repair changes in xrep_quota_item() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/quota.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index e34ca20ae8e40..42cccc6505f76 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -103,21 +103,21 @@ xchk_quota_item(
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
-- 
2.53.0



