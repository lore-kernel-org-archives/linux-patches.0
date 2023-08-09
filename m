Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D06415AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108AEC433C7;
	Wed,  9 Aug 2023 10:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577934;
	bh=iPaa9r7atXl47JPGr+2Ljzu2q7SBLJtZu2Y/1elZZiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fsdvqoIaKkP1O1Uodje3taxQ2mDHFJ4dyQUM/CzTxmwTm/m7j7Psrf0r/QYuMlZ4+
	 KSDKsI31t5PpoJ4SzJxzUCVOTuUMtNnT4CBtkOolNmdbA77Rp/BcXxfjmzuFEkPqXo
	 i7T/BgZkomJYchzm/QXoNLKQkSS78MKCCy3jh5ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thierry Reding <treding@nvidia.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 047/165] net: stmmac: tegra: Properly allocate clock bulk data
Date: Wed,  9 Aug 2023 12:39:38 +0200
Message-ID: <20230809103644.362688776@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit a0b1b2055be34c0ec1371764d040164cde1ead79 ]

The clock data is an array of struct clk_bulk_data, so make sure to
allocate enough memory.

Fixes: d8ca113724e7 ("net: stmmac: tegra: Add MGBE support")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
index bdf990cf2f310..0880048ccdddc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
@@ -234,7 +234,8 @@ static int tegra_mgbe_probe(struct platform_device *pdev)
 	res.addr = mgbe->regs;
 	res.irq = irq;
 
-	mgbe->clks = devm_kzalloc(&pdev->dev, sizeof(*mgbe->clks), GFP_KERNEL);
+	mgbe->clks = devm_kcalloc(&pdev->dev, ARRAY_SIZE(mgbe_clks),
+				  sizeof(*mgbe->clks), GFP_KERNEL);
 	if (!mgbe->clks)
 		return -ENOMEM;
 
-- 
2.40.1



