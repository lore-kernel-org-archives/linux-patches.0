Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8815F30507B;
	Tue,  2 Sep 2025 13:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820438; cv=none; b=p776IJ46UBc7cS7tfQq7Rxu3qi1gEyHOFf/EZKpQbLPaNwqU61wZbo5pltsUsYTs+Dyaejj4wuxoDLBrGg6UE2gnRzwaBg8jSSguVxcYTLXUGlzug9/oNPIypvBCY3RcYGpfPw+3MV//ZyElwlcZFv9hTDKzmLQLQcoKOd/k/es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820438; c=relaxed/simple;
	bh=I5t7WsdqlfwI3WQonZPyopyHj93l9JQ5lsEz+he0bro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTCAhoBIXoWwBtx/HNM8rf4c+b0tpzeOQqwlvzReC1LK6n9/ZKiuIzKm1+pnvho4vE1xjOjia4umkYpzDJa+ljRPYNCnwd4TM/L1O5jLTfYsZD8SgxMJA+mXt/WX/NidAhb+fzaL4BQajYVC1WEzXy2UUjQEsxz+cmZcgoLCOPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpeNPmcM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpeNPmcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DECC4CEED;
	Tue,  2 Sep 2025 13:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820438;
	bh=I5t7WsdqlfwI3WQonZPyopyHj93l9JQ5lsEz+he0bro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpeNPmcMwNnuPtjiLWYKTqG+9ru3jLmxKoG+702wYR9/FVB/buSKmOJVeHXQ8Dfel
	 3pMOoYicdvSqW+GpeXn4uP2wuaLZVdl7NcemRGGlBPUF9s3Eet7UG6gmRQbCumDftg
	 IunLeqjcMcpQGFARnrsW1qR+D1Dt/D3stlgsR69g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan G Thomas <rohan.g.thomas@altera.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 29/50] net: stmmac: xgmac: Do not enable RX FIFO Overflow interrupts
Date: Tue,  2 Sep 2025 15:21:20 +0200
Message-ID: <20250902131931.677469351@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

From: Rohan G Thomas <rohan.g.thomas@altera.com>

[ Upstream commit 4f23382841e67174211271a454811dd17c0ef3c5 ]

Enabling RX FIFO Overflow interrupts is counterproductive
and causes an interrupt storm when RX FIFO overflows.
Disabling this interrupt has no side effect and eliminates
interrupt storms when the RX FIFO overflows.

Commit 8a7cb245cf28 ("net: stmmac: Do not enable RX FIFO
overflow interrupts") disables RX FIFO overflow interrupts
for DWMAC4 IP and removes the corresponding handling of
this interrupt. This patch is doing the same thing for
XGMAC IP.

Fixes: 2142754f8b9c ("net: stmmac: Add MAC related callbacks for XGMAC2")
Signed-off-by: Rohan G Thomas <rohan.g.thomas@altera.com>
Reviewed-by: Matthew Gerlach <matthew.gerlach@altera.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250825-xgmac-minor-fixes-v3-1-c225fe4444c0@altera.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 5e98355f422b3..3e4318d5dcdf5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -199,10 +199,6 @@ static void dwxgmac2_dma_rx_mode(void __iomem *ioaddr, int mode,
 	}
 
 	writel(value, ioaddr + XGMAC_MTL_RXQ_OPMODE(channel));
-
-	/* Enable MTL RX overflow */
-	value = readl(ioaddr + XGMAC_MTL_QINTEN(channel));
-	writel(value | XGMAC_RXOIE, ioaddr + XGMAC_MTL_QINTEN(channel));
 }
 
 static void dwxgmac2_dma_tx_mode(void __iomem *ioaddr, int mode,
-- 
2.50.1



