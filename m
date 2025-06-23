Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753BE1D86DC;
	Mon, 23 Jun 2025 22:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716228; cv=none; b=DsY6StFfzg4vNkwVyLofgNwykwZduW3RkdOqBteX3sQbwuB/EqqrtsC+woFZsaBw6CS3riET/QEEVOkOjbkUoYEyMVhBBeRyRUAdP258DPgfjHAcz37BFj4XaRSiNy7jFBm51abs5ELxCgkb+GkbIzcEh9orfXAllwjTYA8Pb50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716228; c=relaxed/simple;
	bh=OKAZI3OYjSNPXFoL7eiMqjezk3tn8iu3TbBrU5TbHv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B59YQKLLD44i+y2OZ1L0kC/sQwOoU1Mey+aANrA4HQ58GSx51CIeWAuWVyXCPJm5TjF0nZm2Bl1E8zZkXA1VFAHQElJkvK2oKcDxr8NGzDRvAMZp15B3R65HTLkLVNYkYhKkoGHlg7KcKptyDqArw1X7HSUJcp+1J4+/qb21+3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qk3DUM8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qk3DUM8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1D0C4CEEA;
	Mon, 23 Jun 2025 22:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716228;
	bh=OKAZI3OYjSNPXFoL7eiMqjezk3tn8iu3TbBrU5TbHv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qk3DUM8ujINURBIWUG1y1API+v78yiktYacHCRfFwPKmYqt1FTVjky9Jf6AY6p77G
	 6NBLrDEyusQE2kRW+Xu6yUutzNlcliG0PcEW1t72eYiIG92fuaPUkpDJ6bj9zYmm3M
	 6/ODxC2zPBBi85vRSUhmMsnqvEQ7KoFsIDBVI7DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 336/411] octeontx2-pf: Add error log forcn10k_map_unmap_rq_policer()
Date: Mon, 23 Jun 2025 15:08:00 +0200
Message-ID: <20250623130642.107286440@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 942ec8f394559..59fef7b50ebb6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
@@ -351,9 +351,12 @@ int cn10k_free_matchall_ipolicer(struct otx2_nic *pfvf)
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



