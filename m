Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2621A704B;
	Sun,  7 Sep 2025 20:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277574; cv=none; b=qcw470bAwZ+YDGX3SXebDKZgMgN8oKUeCsj8QlFp7oJhBsMW1+5zK/Nj7wqNSdbDqc4TBpJUyFXktfIFRiLXOl0A1FgYNlciVBzUyHCYpwlrrKPLzz5V0LbJ8LQAOyZmgN9Ju1B7hlbrO1VvEu4X8LbO0nhcUiL+FUC+UKcNXSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277574; c=relaxed/simple;
	bh=Ez8HvcrETu5iSWfpifBO+vOYYaUXCLI0qlkmDwjO04U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyQlK6VZ3YchF1eDR4PvAOMCnjTWro4Gg9DiwViz/7XcvAgBoXn+1+G2ryt2VEdLTNGuX2sERIvFMXT0Mi0+SaxDFpgoc6jth+NYl5rYU5FcSa+ypVVDK8mEzx46hHqAk6x1TY2EAXvFG7/zLR9hCNxz9Ol8wN6A+J4p0ntT9B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2PoI6or; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2PoI6or"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5225C4CEF0;
	Sun,  7 Sep 2025 20:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277574;
	bh=Ez8HvcrETu5iSWfpifBO+vOYYaUXCLI0qlkmDwjO04U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2PoI6orzlTfgNZ6wiKH3NvIrANjoMl5OVrL7mzsuXII9va17pRMM6UHGaA5ens2e
	 XPyOIhWgQ89cLzSzFw390iKs2fGEVaZyxwwkb2n3SL/XKIdDdVOonpW5d9Yzho5Spn
	 oCiXFiS7hCqTW9ggy6cBwchLTPIKQPaHCUp5HDvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 056/183] bnxt_en: fix incorrect page count in RX aggr ring log
Date: Sun,  7 Sep 2025 21:58:03 +0200
Message-ID: <20250907195617.116188197@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 7000f4fa9b24ae2511b07babd0d49e888db5d265 ]

The warning in bnxt_alloc_one_rx_ring_netmem() reports the number
of pages allocated for the RX aggregation ring. However, it
mistakenly used bp->rx_ring_size instead of bp->rx_agg_ring_size,
leading to confusing or misleading log output.

Use the correct bp->rx_agg_ring_size value to fix this.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Link: https://patch.msgid.link/20250830062331.783783-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index cb76ab78904fc..d47c1d81c49b8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4390,7 +4390,7 @@ static void bnxt_alloc_one_rx_ring_netmem(struct bnxt *bp,
 	for (i = 0; i < bp->rx_agg_ring_size; i++) {
 		if (bnxt_alloc_rx_netmem(bp, rxr, prod, GFP_KERNEL)) {
 			netdev_warn(bp->dev, "init'ed rx ring %d with %d/%d pages only\n",
-				    ring_nr, i, bp->rx_ring_size);
+				    ring_nr, i, bp->rx_agg_ring_size);
 			break;
 		}
 		prod = NEXT_RX_AGG(prod);
-- 
2.50.1



