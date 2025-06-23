Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36082192EC;
	Mon, 23 Jun 2025 22:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717463; cv=none; b=HWarVKpx32lr2QLAIMOKGAzkLmecngUgLP1Kn/YhuLxbdmCoY/VtMGXeloeVd/R71JK2v0rXmVhSxH7MyxaQKaOea7g2cXzMoUll+KeEa4BoNzAgT83HEKTmuaWFt8lT34u0CvVfMvC0It/CLrOxamCCe/IRMjRIgwrJO9f0Q5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717463; c=relaxed/simple;
	bh=PwgU+Q/Yn4UJiafBT4ffcVksqJ31Nl3BVGdq7+eGIU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNhslWoQIWZKUoCf0jIyBc4BeD78+hQmCeacLwHynynod6S5eD4dsOPgOVmL4Rf9SKLI0JdXLckp2/4dEYApZwU7ZKFTAHqbwEtGfFFQ5w2Gh0Dhclmi7QGtgXZiBFCogB7P60cBB91gL6irI6G/YzuUlhmp3o0BQygP4P/q2Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=maCvrJg9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="maCvrJg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F60C4CEEA;
	Mon, 23 Jun 2025 22:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717462;
	bh=PwgU+Q/Yn4UJiafBT4ffcVksqJ31Nl3BVGdq7+eGIU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=maCvrJg922T1IaIeZc+fXr9zASzCoaMiXdelHEnvZKZytQBMDDDPDa0KRJLDRaL5g
	 ZPpfO/364h27IFvaTODsIygGAKdtpT02rif/nbQn3JidfPy+EAky1AUG6Oj0pKIUNr
	 BPGKD1NAarr+uCcJLYM7ZzM+dLfCReGAW+S2rWmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 431/508] octeontx2-pf: Add error log forcn10k_map_unmap_rq_policer()
Date: Mon, 23 Jun 2025 15:07:56 +0200
Message-ID: <20250623130655.778623008@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 9c056ec6dd1654b1420dafbbe2a69718850e6ff2 ]

The cn10k_free_matchall_ipolicer() calls the cn10k_map_unmap_rq_policer()
for each queue in a for loop without checking for any errors.

Check the return value of the cn10k_map_unmap_rq_policer() function during
each loop, and report a warning if the function fails.

Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250408032602.2909-1-vulab@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
index 7417087b6db59..a2807a1e4f4a6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
@@ -352,9 +352,12 @@ int cn10k_free_matchall_ipolicer(struct otx2_nic *pfvf)
 	mutex_lock(&pfvf->mbox.lock);
 
 	/* Remove RQ's policer mapping */
-	for (qidx = 0; qidx < hw->rx_queues; qidx++)
-		cn10k_map_unmap_rq_policer(pfvf, qidx,
-					   hw->matchall_ipolicer, false);
+	for (qidx = 0; qidx < hw->rx_queues; qidx++) {
+		rc = cn10k_map_unmap_rq_policer(pfvf, qidx, hw->matchall_ipolicer, false);
+		if (rc)
+			dev_warn(pfvf->dev, "Failed to unmap RQ %d's policer (error %d).",
+				 qidx, rc);
+	}
 
 	rc = cn10k_free_leaf_profile(pfvf, hw->matchall_ipolicer);
 
-- 
2.39.5



