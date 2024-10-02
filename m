Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332C61D0427;
	Wed,  2 Oct 2024 13:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877236; cv=none; b=AI0ITJHTdU7HA2nizFGdAKciLSPPDLVKPTA6i9v1QCsqwOqlNm4tjdFqYXKRgamO/STafAhRR93HUYQ+v1/mUyz7vLb96gZmWJySIMIZo0IrZG2qbvoKkLWMgh4uqVYYumoLEsr1t/vEwAkWi5DfaSv3dCwj83kRmMu8SOrowhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877236; c=relaxed/simple;
	bh=QmhftXYamL44kwM9xXYyJih8XF2l+iRAWRJsxW2tEN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQ86PbcyVb8Q17xWoJKN1ZklhVx6bjk9U2rV6faiOPR8VrAmH5y4Y1IkRmTR7xkD5x0NfQhUgX0YRHZQBZkW2N/d+ibuagj5jdXJA4FVSTmSzO+V/0cDjD7VRgCEhojoIUYF1Lz8pX01ZyTzWuzhl0xBnJIxscFWrKaJ9l+seEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqRM8u89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqRM8u89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11A4C4CED5;
	Wed,  2 Oct 2024 13:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877236;
	bh=QmhftXYamL44kwM9xXYyJih8XF2l+iRAWRJsxW2tEN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqRM8u89QKmqGTIyfJs2ndS8SergWGLXBFTYn8sV1CNjw5csb3K/5sO+PmPlvEL75
	 ngulIC3jfE4D9/98fToy8xgKRDk5MdRQ7gRwAeVQmaRDethAk4mA8EClzqMuBu9lZB
	 UfI5HOSVfYfClkZ76m3t/MHUcqC0TSPkLb5f/yx8=
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
Subject: [PATCH 6.10 015/634] net: stmmac: dwmac-loongson: Init ref and PTP clocks rate
Date: Wed,  2 Oct 2024 14:51:55 +0200
Message-ID: <20241002125811.696024020@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9e40c28d453ab..ee3604f58def5 100644
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



