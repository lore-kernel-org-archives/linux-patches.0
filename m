Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6F73043A0;
	Tue,  2 Sep 2025 13:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819621; cv=none; b=ZPhL2fSY7mKrDg2gm7p3iA9VJx7slO6RpRzOhDoRdwKY37jvDiZM4uDGnuAkAqe6U4JF5goHnTFyv7b836jHDx2CukPcD2eQELAvffp/yGzlUVJ5hoiwWi0MlN61M416oH23Rs+9waPdNrF38kE6A2J4QxV3aXqcDzonab0xVx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819621; c=relaxed/simple;
	bh=Sy7ZTwcleynj1DjbHcR8nhi1U1b2LgpnlC6W/aFN5o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEO7x5bU9bRDf8AzpCV6N4RRf2fT3mqvjubGpgY+TVcg1nyUHaM9g4OZuLqLeQipIeHMDn2VHY8WcxOdreHiygu+Xp73DF+Z5haND2J3kbUM9Ln/vdISRO511dawOHn+EMZq9ApXFRqHmV+hf10f3ZwDronFwGTs6Pm111S1N3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BF1KiwXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BF1KiwXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47A8C4CEF5;
	Tue,  2 Sep 2025 13:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819621;
	bh=Sy7ZTwcleynj1DjbHcR8nhi1U1b2LgpnlC6W/aFN5o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BF1KiwXCzw3DdAIPGjb2BvH6dzvwewCryHZaDsp9tha+I6iHdwTQivt+KubJ9O5es
	 c5hSREu6Wn+b9mxhcoFsceYfVTMbGEyecadfwCouDyWbonl3B6X7em4NXkVXn6tBGn
	 WOKdYP8EtWXpQjqUD6r5cvedylP3ja1bGsB0ergA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan G Thomas <rohan.g.thomas@altera.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 089/142] net: stmmac: xgmac: Do not enable RX FIFO Overflow interrupts
Date: Tue,  2 Sep 2025 15:19:51 +0200
Message-ID: <20250902131951.676572891@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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
index 5dcc95bc0ad28..7201a38842651 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -203,10 +203,6 @@ static void dwxgmac2_dma_rx_mode(struct stmmac_priv *priv, void __iomem *ioaddr,
 	}
 
 	writel(value, ioaddr + XGMAC_MTL_RXQ_OPMODE(channel));
-
-	/* Enable MTL RX overflow */
-	value = readl(ioaddr + XGMAC_MTL_QINTEN(channel));
-	writel(value | XGMAC_RXOIE, ioaddr + XGMAC_MTL_QINTEN(channel));
 }
 
 static void dwxgmac2_dma_tx_mode(struct stmmac_priv *priv, void __iomem *ioaddr,
-- 
2.50.1



