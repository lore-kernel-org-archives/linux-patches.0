Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEC619B3FF;
	Tue, 15 Oct 2024 11:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992383; cv=none; b=nKR9C/UG5Nw8oCq2H/gxaFIWSF4g5E4M7AE1FKm7A9Xbpcnfcw7/t71XM2mcii7KeLQgF5JhcfMg8dGp+/BrcM+4b2T492TLjg/Z4wxWOM4MsyviRhNZ12dkNQOw7jcSvVkhfv4QpGOOxXozbAnzsa/T6sP2mAMLc37NtpQZ1IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992383; c=relaxed/simple;
	bh=ybXjkPg5W1NBf48tCocQqTY58FDFudjSXWpEUndXZKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmsuzPTmmlYa9bSIFXtOj8uz+i74ndztAgKd+hVJTg7RmeZgYBPBdOSBO/25VwVGw6iSRXwbQqM8mUsLiqlJO/i++7mY8+cxO0MDeHRMpepWaInF0bdGpaZ5wWvDYUVnGPIw8mFKhr1cB32b8i9+enGtBmoabxuCDM8E4rocqX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UA4TMNqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UA4TMNqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D336C4CEC6;
	Tue, 15 Oct 2024 11:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992382;
	bh=ybXjkPg5W1NBf48tCocQqTY58FDFudjSXWpEUndXZKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UA4TMNqI3DNfqvblXsBCpfgGSSwuhFEoTVp7hmlaOMYL2T3yZlMCFouwGZ+2EbwIq
	 UA3iZA2H1pfrrlEKwc05fDxeuYFE7b6ZlvaCEblwBqjC4rHZ4NrLMVQExDsu92qpb0
	 h2PCa4pzk5jQVmkJwpFPQ97URSAX5lEXs4RnPhhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feiyang Chen <chenfeiyang@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Serge Semin <fancer.lancer@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Yanteng Si <siyanteng@loongson.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/691] net: stmmac: dwmac-loongson: Init ref and PTP clocks rate
Date: Tue, 15 Oct 2024 13:20:48 +0200
Message-ID: <20241015112444.331127027@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yanteng Si <siyanteng@loongson.cn>

[ Upstream commit c70f3163681381c15686bdd2fe56bf4af9b8aaaa ]

Reference and PTP clocks rate of the Loongson GMAC devices is 125MHz.
(So is in the GNET devices which support is about to be added.) Set
the respective plat_stmmacenet_data field up in accordance with that
so to have the coalesce command and timestamping work correctly.

Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Feiyang Chen <chenfeiyang@loongson.cn>
Signed-off-by: Yinggang Gu <guyinggang@loongson.cn>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Yanteng Si <siyanteng@loongson.cn>
Tested-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index da7b5d26a5897..da2e68d616225 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -35,6 +35,9 @@ static int loongson_default_data(struct plat_stmmacenet_data *plat)
 	/* Disable RX queues routing by default */
 	plat->rx_queues_cfg[0].pkt_route = 0x0;
 
+	plat->clk_ref_rate = 125000000;
+	plat->clk_ptp_rate = 125000000;
+
 	/* Default to phy auto-detection */
 	plat->phy_addr = -1;
 
-- 
2.43.0



