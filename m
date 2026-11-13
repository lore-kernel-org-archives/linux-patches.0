Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590615;
	b=04vTrfO4dvnBVn1z/tr+j1SneZxWk+qIXsGayqpMlpQz43gfP1M4p4K6afpD60yccX9G
	 cqBn/yM2i6cznwiVc5QW8uUassKnDTy/ZRn+oI4vJg0mrzugkKcbwSwtDdUTk6qF/stzQ
	 Z5SBbd0aqEjyVuv9B7VEAyTZ0+sEDJSpgwGlslrFuKcXY58gIW7EE2Liy70jcYMwRNKaU
	 bNOUBECkOtHOw6MLvKzFWaNxlGEY9k1lgcfQ336THULWnnDWk6SastiPWiG6iiVbjVR5J
	 x6uaGaruGsDPAleCbW/D1+zBOcTn3llbE3V5yzJsQpvFGRxMV0GxQOABK/BM/T+g4TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/vK4m5z5HgBz4kT8lfCgfqDgIUe13QyZNIKg982jOZo=;
	b=HWKTmL1LmltB0owbXVGciOdFaEmiMGRjKXwe2fYgYLlMLHzevCjsPIcCNaMgVvPCXH3d
	 9eKyFIgc5HqCI4xpekGbft76peFq+z0yEIm3efeQ61gjJxQUbnUnLpUgEmtAeAbgExYdR
	 rs7xxVc8zhqY+BA57ngUr4en8xA8uz7uIYVLrXubiVkEHpudDG2EOIS+BOCSUBqpVKvBd
	 fDmBTp+gp5Y+LHeCHruiiDTSUuCTyj8OTiKT5Wp1cytrjCkJQQz28bgcNSxo329laMNY5
	 agKGsosfql28hdqeFFCxq+zhRaW206AGht3ABB+fvelHYQj1+d5rDjEKWMGoYty1FPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fBCPtbkq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEF5607586B;
	Fri, 13 Nov 2026 17:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fBCPtbkq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0881F000C4;
	Fri, 13 Nov 2026 17:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590614;
	bh=/vK4m5z5HgBz4kT8lfCgfqDgIUe13QyZNIKg982jOZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fBCPtbkqRJ93SQ0Frtk/HNheB1ZL3mjdJJpRh30Mm7AU7d+HQug2szziZk+jdVnbH
	 fgS0kKsNZOlSIUioxOhRGU3FZ9CPhRvsWHs/wWhWT38mwUQps5t3BdtlJe+RNIXriK
	 ufyw+YoLhZxKOZvzOcNmTN5Cx2joT+VxINPxxedQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 540/686] spi: cadence-xspi: Use FIELD_MODIFY()
Date: Fri, 13 Nov 2026 10:51:13 -0500
Message-ID: <20261113153839.572246877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Zhang <18255117159@163.com>

[ Upstream commit 6fa473f4c5dcc20db9799f90da48b977730e05f1 ]

Use FIELD_MODIFY() to remove open-coded bit manipulation.
No functional change intended.

Signed-off-by: Hans Zhang <18255117159@163.com>
Link: https://patch.msgid.link/20260430155456.36998-4-18255117159@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: ea9854a169e9 ("spi: cadence-xspi: reject SDMA transfers larger than the requested length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-xspi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence-xspi.c b/drivers/spi/spi-cadence-xspi.c
index b6b42daae1bce..90c6d9fa4dbb9 100644
--- a/drivers/spi/spi-cadence-xspi.c
+++ b/drivers/spi/spi-cadence-xspi.c
@@ -453,8 +453,7 @@ static bool cdns_mrvl_xspi_setup_clock(struct cdns_xspi_dev *cdns_xspi,
 		writel(clk_reg,
 		       cdns_xspi->auxbase + MRVL_XSPI_CLK_CTRL_AUX_REG);
 		clk_reg = FIELD_PREP(MRVL_XSPI_CLK_DIV, i);
-		clk_reg &= ~MRVL_XSPI_CLK_DIV;
-		clk_reg |= FIELD_PREP(MRVL_XSPI_CLK_DIV, i);
+		FIELD_MODIFY(MRVL_XSPI_CLK_DIV, &clk_reg, i);
 		clk_reg |= MRVL_XSPI_CLK_ENABLE;
 		clk_reg |= MRVL_XSPI_IRQ_ENABLE;
 		update_clk = true;
-- 
2.53.0



