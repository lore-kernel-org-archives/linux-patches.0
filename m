Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F270246EF91;
	Tue, 21 Jul 2026 19:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661256; cv=none; b=VHqUoomAltBgW05CMUccUCmjZUY/gFTXW4CpkrMmo5z2KyYxoDGatOSgwpKs+vZYpDTWZppy+Qi+B7+wBab4k6L6ZOnMtAlOTEwJYbu59uRHzTjlvan3l4P0PoXRfgKKzFynxUOiA9q24VyP/IlConhgAkwqcXmxTbOE7kN0css=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661256; c=relaxed/simple;
	bh=vmAZwGxntjCUxY4uTJ/mSl8JHQL9GsnMAuwhrtm+9Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVndl+O614oku1trMjZg2Ow8SjBzqiVoSe9gwz6daeL28ECE5A7wNT94a3Hgq+xwbZ5MZSWjEG04Twq64cAuysnTCXXeHPexl08+0lb2C83dxVTRo8H2+N5OmHZEiisYPXe3kWL5rba5OxpVVtDSbZN8z+i4FJV4KUAWp7dkjx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f27YZBcn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f27YZBcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8951F00A3A;
	Tue, 21 Jul 2026 19:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661253;
	bh=xJj7m935gMSN4Qxal/4E+/FqxX1ptHT5gSrp2KmHX5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f27YZBcnKLt1WDjDYDA9+LJvp8EfYdvpsSIAwq+hF1mHQtuy3l81l7CEJ4cwGI9Yb
	 ADuaxDH03sw603/Av5JkY3eNro0zs3R5WXtEKnZ/iHgWeK3/YgEjMRR3/3mPZGbaTS
	 0Hzj3btr2DQTFdJD7NBEjOVkMnWtWlp+UN2m/41o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1287/2077] net: stmmac: dwmac-spacemit: Fix wrong irq definition
Date: Tue, 21 Jul 2026 17:16:00 +0200
Message-ID: <20260721152623.175187799@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Inochi Amaoto <inochiama@gmail.com>

[ Upstream commit bf5cd5d4ca423d348e01b3bbcdccd0e02b1b408b ]

The current irq definition of the wake irq and the lpi irq
is wrong, replace them with the right number and name.

Fixes: 30f0ba420ed3 ("net: stmmac: Add glue layer for Spacemit K3 SoC")
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260623074637.503864-3-inochiama@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-spacemit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-spacemit.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-spacemit.c
index 3bfb6d49be6c0c..322bdf167a4a68 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-spacemit.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-spacemit.c
@@ -22,8 +22,8 @@
 #define CTRL_PHY_INTF_RMII		FIELD_PREP(CTRL_PHY_INTF_MODE, 0)
 #define CTRL_PHY_INTF_RGMII		FIELD_PREP(CTRL_PHY_INTF_MODE, 1)
 #define CTRL_PHY_INTF_MII		FIELD_PREP(CTRL_PHY_INTF_MODE, 3)
-#define CTRL_WAKE_IRQ_EN		BIT(9)
-#define CTRL_PHY_IRQ_EN			BIT(12)
+#define CTRL_LPI_IRQ_EN			BIT(9)
+#define CTRL_WAKE_IRQ_EN		BIT(12)
 
 /* dline register bits */
 #define RGMII_RX_DLINE_EN		BIT(0)
-- 
2.53.0



