Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1F828ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42C8C433D2;
	Mon, 12 Dec 2022 13:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853193;
	bh=tuTZRKQvIVg0VPFRHHdRD2tcLBm5KfyTRfETN9cjyt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhVduBPJmIkaE0rD2kPCgwJbGVDBeWY5PZGTRWM+m6r98P5qNf+3kql5HOg83WAgV
	 UZpx24UQ62qdH3lONgYDMp3byvnJ3A/wD5dJ/EgCJhB1GBYg5snbrE4o2jFLTDAXbA
	 O7jsLcK7SkBFZE5XeF2bndCu43uLOiV1PQD1LMqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 30/38] net: stmmac: fix "snps,axi-config" node property parsing
Date: Mon, 12 Dec 2022 14:19:31 +0100
Message-Id: <20221212130913.610831333@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130912.069170932@linuxfoundation.org>
References: <20221212130912.069170932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 61d4f140943c47c1386ed89f7260e00418dfad9d ]

In dt-binding snps,dwmac.yaml, some properties under "snps,axi-config"
node are named without "axi_" prefix, but the driver expects the
prefix. Since the dt-binding has been there for a long time, we'd
better make driver match the binding for compatibility.

Fixes: afea03656add ("stmmac: rework DMA bus setting and introduce new platform AXI structure")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://lore.kernel.org/r/20221202161739.2203-1-jszhang@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 14d11f9fcbe8..07951b43de21 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -115,10 +115,10 @@ static struct stmmac_axi *stmmac_axi_setup(struct platform_device *pdev)
 
 	axi->axi_lpi_en = of_property_read_bool(np, "snps,lpi_en");
 	axi->axi_xit_frm = of_property_read_bool(np, "snps,xit_frm");
-	axi->axi_kbbe = of_property_read_bool(np, "snps,axi_kbbe");
-	axi->axi_fb = of_property_read_bool(np, "snps,axi_fb");
-	axi->axi_mb = of_property_read_bool(np, "snps,axi_mb");
-	axi->axi_rb =  of_property_read_bool(np, "snps,axi_rb");
+	axi->axi_kbbe = of_property_read_bool(np, "snps,kbbe");
+	axi->axi_fb = of_property_read_bool(np, "snps,fb");
+	axi->axi_mb = of_property_read_bool(np, "snps,mb");
+	axi->axi_rb =  of_property_read_bool(np, "snps,rb");
 
 	if (of_property_read_u32(np, "snps,wr_osr_lmt", &axi->axi_wr_osr_lmt))
 		axi->axi_wr_osr_lmt = 1;
-- 
2.35.1



