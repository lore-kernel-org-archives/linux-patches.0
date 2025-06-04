Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEF627726;
	Wed,  4 Jun 2025 01:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998919; cv=none; b=IbZeU6tSG/DexlidMdJ3uSPF8kfoQZMKcm+8hu5F13Vksdx25UI9QJ6gfwBmDJ3KV1nna9JxfrJA4aJl+JLa3jiZOUMWo/kCnmGLortvn0v7hsEthYcvShCdZcku70t7bLE2QcCeAOdrw+rgYUXWv/wjETlpark7InY2ytXTZlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998919; c=relaxed/simple;
	bh=MvGwxb1nGpNl3HKAqwe7s4gwLuUugy6nHJI4sBa7Qvg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=muvEsp8To3kb6+jVbS50rUnqycxMBWi1tjGmOP+9CbLP1DCmaYDJrm8MNplHKqX4Rv1yCC8ptI76AgaGfzMrdPLiuFSvR4M02IN2wuLexnUDsYcT6C9Qm/lVplEoWGD3ib516I2oeGhEFlMKESWrRUwooxPxF41Xy2PAeTotvTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RShiCjwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RShiCjwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436E7C4CEF3;
	Wed,  4 Jun 2025 01:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998919;
	bh=MvGwxb1nGpNl3HKAqwe7s4gwLuUugy6nHJI4sBa7Qvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RShiCjwuS6wpzL1qBZBZnxqZinG+E3V239pIpZ5lffbo8qGiaELs1ym+FYx9Ocr9a
	 ikK73pwSaoki8lsM82rOq/xjVHJ5TO2lTlJ7Z+3IBewwwV0SrLqBO1LO2xjrz6GxtD
	 1EO4btJAcxfHw9NpRcYlfX6vKQPXBGfKp0H2aEJLGJoVfiTrOwswGiiuM48bfJc6Ez
	 5kYudbl+Naeg2fGlKXIu/a7f3SxxSkda3XvvtTdGWhNLmcMZjcR6ch6+xT0UtXOLCx
	 zdJNPT6j/NLpS1QW5AWeV2IWfqEm9vyso4REwa69OMR3U5O48TppaaRI/VCq0xPuwj
	 Vhe9rLSk7PAKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wentao Liang <vulab@iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sgoutham@marvell.com,
	gakula@marvell.com,
	sbhatta@marvell.com,
	hkelam@marvell.com,
	bbhushan2@marvell.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 88/93] octeontx2-pf: Add error log forcn10k_map_unmap_rq_policer()
Date: Tue,  3 Jun 2025 20:59:14 -0400
Message-Id: <20250604005919.4191884-88-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005919.4191884-1-sashal@kernel.org>
References: <20250604005919.4191884-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Transfer-Encoding: 8bit

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

**YES** Based on my analysis of the commit and the surrounding codebase
context, this commit should be backported to stable kernel trees. Here's
my extensive analysis: ## Code Analysis ### The Specific Change The
commit adds error checking to a loop in `cn10k_free_matchall_ipolicer()`
that was previously ignoring return values from
`cn10k_map_unmap_rq_policer()` calls: **Before:** ```c for (qidx = 0;
qidx < hw->rx_queues; qidx++) cn10k_map_unmap_rq_policer(pfvf, qidx,
hw->matchall_ipolicer, false); ``` **After:** ```c for (qidx = 0; qidx <
hw->rx_queues; qidx++) { rc = cn10k_map_unmap_rq_policer(pfvf, qidx,
hw->matchall_ipolicer, false); if (rc) dev_warn(pfvf->dev, "Failed to
unmap RQ %d's policer (error %d).", qidx, rc); } ``` ### Why This Should
Be Backported 1. **Fixes a Real Bug**: The function was silently
ignoring failures from critical hardware unmapping operations. Based on
my analysis of `otx2_tc.c`, this function can return various error codes
including `-ENOMEM` and mailbox communication failures. 2. **Consistent
Error Handling**: Every other usage of `cn10k_map_unmap_rq_policer()` in
the codebase properly checks return values and logs errors. For example,
in `otx2_tc.c:1216-1221`, the same operation uses: ```c err =
cn10k_map_unmap_rq_policer(nic, flow_node->rq, flow_node->leaf_profile,
false); if (err) netdev_err(nic->netdev, "Unmapping RQ %d & profile %d
failed\n", flow_node->rq, flow_node->leaf_profile); ``` 3. **Meets
Stable Criteria**: This commit: - Fixes a clear bug (missing error
handling) - Is small and contained (only adds error checking) - Has
minimal risk of regression (only adds logging) - Improves system
robustness - Follows the driver's established error handling patterns 4.
**Hardware Resource Management**: The `cn10k_map_unmap_rq_policer()`
function deals with hardware policer resource management. Silent
failures during cleanup could potentially: - Leave hardware in an
inconsistent state - Cause resource leaks - Make debugging network QoS
issues extremely difficult 5. **Alignment with Similar Commits**:
Looking at the provided examples, this commit is very similar to
"Similar Commit #1" and "Similar Commit #4" which both received
"Backport Status: YES". Those commits also added error checking to
`otx2_mbox_get_rsp()` calls that were previously unchecked. 6. **Low
Risk**: The change only adds warning messages and doesn't change the
control flow. Even if the warning message format had issues (which it
doesn't), it wouldn't cause functional problems. 7. **Driver Quality**:
This fix improves the overall quality and debuggability of the OcteonTX2
network driver, which is important for enterprise and datacenter
deployments where these cards are commonly used. The commit represents a
straightforward bug fix that improves error visibility and follows
established patterns in the driver, making it an excellent candidate for
stable tree backporting.

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

