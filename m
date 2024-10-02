Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D761D042F;
	Wed,  2 Oct 2024 13:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875283; cv=none; b=meYLIDO1Sah1ZuaLuNsX9Ef27VhW+t/v67cNdq7gsZK1IhPggDhZzsZoaaE1P01sD7RQyZjFlHBxOGU/zWL1n+zrd6rZfICSgYu6Oojtly19T4SpHu5hTHFkBESwE2neCbydmXzLXejLL5ZCLD7zNaqn9iib5UFmLyXlMA1ZTIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875283; c=relaxed/simple;
	bh=QU6v/+E0WLQkULsQhWCfxkrpcwKB4wypHden2Qmgjls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6dKsTmakaEBNNHF/ZoE6zL2JvhxKiakHp6N8ETMrEOWgKxrqpb6V4LuRIaWQCb0KJOW1uvKx3vIF3fdpaEW6M+zpouoBgO+2r22sQXGF1WrLUYbwubPThb0vmxuHAACedFjQwEtiSN8MFDy7/dKVJxl44jBrfi1tPgPakwLl6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VnWokyLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnWokyLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32C4C4CEC5;
	Wed,  2 Oct 2024 13:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875283;
	bh=QU6v/+E0WLQkULsQhWCfxkrpcwKB4wypHden2Qmgjls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VnWokyLx0cKSWmrQtqb6nsb1kr4gt1rq3ciwkEiStIau81ebY9IcsxS/ajW6msxby
	 ZZn6vfdwBJ95Oov+XnqUWf1JZjP4u27aQVlHGV06FGFgY7le6RZiW4qWYnEMC/hgvz
	 q+MqA5sPBGksKor8r3lK61FAYUM2+LQhcFGxWWz4=
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
Subject: [PATCH 6.11 018/695] net: stmmac: dwmac-loongson: Init ref and PTP clocks rate
Date: Wed,  2 Oct 2024 14:50:16 +0200
Message-ID: <20241002125823.219899988@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



