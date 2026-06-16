Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77C544CF4E;
	Tue, 16 Jun 2026 15:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623403; cv=none; b=hh3dsYNt6HvRTsniu5fWnSe8d3zAfDUhm9H8FUyoulyx0HTFAA19/jrp+8nf7WYJaRp0zeBDT649aUBeLvIxfaF0GSPOi8hQc3lSpWzPm3L6GQeo8e/TgnsYExYUaXl08k9yhqe2xTeSq6Tqdt6r7x5yCg60ZGiZL+isizY6HNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623403; c=relaxed/simple;
	bh=Lh9A2WXB47La7tdLzXw7GaIT8CPFq3L+2LbbHHi6OC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sv1h0hoIa8iTWZnl8+wPKlF8iTC52pQofEIzgFoXxErwZBWiKXtyir8YI3NmjoGZ8JtvKlWktxAsc8jSGWb3ne09olwBxRMI4vwAAC99N5azg8N9PYzsxgEJ+yxNI14mWAQXV7qF4X6SP3fBYlxVdz4g7WuJjwwh3SgvD54lgs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15bVgA8P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15bVgA8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857B31F000E9;
	Tue, 16 Jun 2026 15:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623402;
	bh=MBV0it6997MHVUpHzMW2IXLAR8mgcLHwZuE6RzDwovE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=15bVgA8PZOWF8mP0zEooJFZPV0BRoyoccgI77kFwFSH4secv/TW1qSqobDOpzWLbt
	 MMbLU5MrNudfu4WELImfOxpW6QZ2or6U6294UBSC5JuT6UqmQj7BZ8zqs/TPag8Pjz
	 GsRiZToug9ztmoZ093t+4gMEkTlXxA53au3bfUao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Felix Gu <ustc.gu@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 140/378] spi: rzv2h-rspi: Fix SPDR read access width for 16-bit RX
Date: Tue, 16 Jun 2026 20:26:11 +0530
Message-ID: <20260616145117.644200505@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 310628484ef06f95c5589374fade917a5689787b ]

The RZ/V2H hardware manual (section 7.5.2.2.1) specifies that read access
size for the SPI Data Register (SPDR) are fixed at 32 bits. The
RZV2H_RSPI_RX macro for the 16-bit data path used readw(), violating
this requirement.

Switch to readl() for the 16-bit RX path to conform to the hardware
specification.

Fixes: 8b61c8919dff ("spi: Add driver for the RZ/V2H(P) RSPI IP")
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Link: https://patch.msgid.link/20260610-rzv2h-rspi-v2-1-40c80b4a2c90@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rzv2h-rspi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rzv2h-rspi.c b/drivers/spi/spi-rzv2h-rspi.c
index 53c44799fab71d..6fc81ccbcad5a2 100644
--- a/drivers/spi/spi-rzv2h-rspi.c
+++ b/drivers/spi/spi-rzv2h-rspi.c
@@ -133,8 +133,9 @@ static inline void rzv2h_rspi_rx_##type(struct rzv2h_rspi_priv *rspi,	\
 RZV2H_RSPI_TX(writel, u32)
 RZV2H_RSPI_TX(writew, u16)
 RZV2H_RSPI_TX(writeb, u8)
+/* The read access size for RSPI_SPDR is fixed at 32 bits */
 RZV2H_RSPI_RX(readl, u32)
-RZV2H_RSPI_RX(readw, u16)
+RZV2H_RSPI_RX(readl, u16)
 RZV2H_RSPI_RX(readl, u8)
 
 static void rzv2h_rspi_reg_rmw(const struct rzv2h_rspi_priv *rspi,
-- 
2.53.0



