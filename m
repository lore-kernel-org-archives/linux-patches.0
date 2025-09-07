Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433B6189BB0;
	Sun,  7 Sep 2025 20:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276979; cv=none; b=TZLbCge52TiCWnWNvDn2j7aZzBUojcBdho73IbnZ2v9VdVuILGLWFWQBxnhbBtorX8Bb54w6KeN33ywICEMiCvg4PieFNoL9JaImnUxhYTVl0QwJ6J3oclMBZCoMNRmR81unX84WV9Zf9kXwCphG+1XYPatEPjYxe1i6FvDR71U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276979; c=relaxed/simple;
	bh=sE90EDh4drFZLaF7yVur5drJqkrn06eG4ysZqsJ0Zmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyOG3T2xjDTatFpscmH+jx2ov7Z/IIS8E5V3KdyiqVBLg7Dmbt0Y6FU10eRMvUjnkN8rpkwhct4/U386AogqQEF5acipGchZt01S2ewjLIZR6ohLb3+/xgghbpzBUcA7Y4Jhgh/hVX3dMdFALcsTABR3Xsy4wUlPFYWe7REbJ9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUwIybD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUwIybD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E07C4CEF0;
	Sun,  7 Sep 2025 20:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276979;
	bh=sE90EDh4drFZLaF7yVur5drJqkrn06eG4ysZqsJ0Zmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUwIybD77IHaz44VmYrJMB06pN2+/Tw2M3dNhI98EtUO3kboBWdIy47z+tum3RaTo
	 bin7+duB1iEfU4+K/6tOpQpiI/5KoklMqikCl6wRSdLkCyeJBGVnGns+L/JSsujmES
	 jyPCQ0CiEUfWsJDPQEH4s2OJHACUIUJHo77NcF/I=
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
Subject: [PATCH 6.12 049/175] bnxt_en: fix incorrect page count in RX aggr ring log
Date: Sun,  7 Sep 2025 21:57:24 +0200
Message-ID: <20250907195616.007776955@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 08886c3a28c61..8a6f3e230fce6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4207,7 +4207,7 @@ static void bnxt_alloc_one_rx_ring_page(struct bnxt *bp,
 	for (i = 0; i < bp->rx_agg_ring_size; i++) {
 		if (bnxt_alloc_rx_page(bp, rxr, prod, GFP_KERNEL)) {
 			netdev_warn(bp->dev, "init'ed rx ring %d with %d/%d pages only\n",
-				    ring_nr, i, bp->rx_ring_size);
+				    ring_nr, i, bp->rx_agg_ring_size);
 			break;
 		}
 		prod = NEXT_RX_AGG(prod);
-- 
2.50.1



