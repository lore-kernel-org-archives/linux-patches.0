Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896A42472A6;
	Tue, 11 Nov 2025 01:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825207; cv=none; b=U5GPC2vMdE9D1UK43FMgWUVFJru2Pp8qB3sTDFF2poAAu6e5rcax+qTNM7757ZgKYDjgQKN1lNeNZYNqt9tk9KFOjigVpgINmTVC+GksXNkCy25MbOVG5ZnmSgXHtdU6IKuWhC9GZNClo4blL6+AO9hrWydhr9zM7ZK880jV8Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825207; c=relaxed/simple;
	bh=m4gF+LED3juunftsZZ5jLV7SP9U2jlFHQd5kf7S9vUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aY2W1/Rp99O4l/KYjfHKh9sivSMfylOb3zcaeFj9dw+pWa7IoYWjmsPBzaDGEDZSQqpC8rTJLaIZLwb6fcHzdY6Fk9eSFfGJyv4ncM0R+qZJ1k21C0q/AaFUJpIPbPHeNicDLXJiBVYbqkD3WdnpsQRU+Ib1WMIW1UFGUFNMwvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0X19y7En; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0X19y7En"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4161C2BC87;
	Tue, 11 Nov 2025 01:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825207;
	bh=m4gF+LED3juunftsZZ5jLV7SP9U2jlFHQd5kf7S9vUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0X19y7Enmh6h4PTg+QFrum53MKlYOkpmFF95bGvd9WtKcdXVZ2a99b2braUgF2A0G
	 7w7mhPpanW8UI1vRKcrYMWTzOgaav/AuDq9pa64LuzGiwG8ea20ctAhygIaOwtB2Xo
	 qBxdsAJ5fNVflBriZr/fW91+ok8CXVDuikKaYkT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mihai Sain <mihai.sain@microchip.com>,
	Cristian Birsan <cristian.birsan@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 704/849] clk: at91: add ACR in all PLL settings
Date: Tue, 11 Nov 2025 09:44:34 +0900
Message-ID: <20251111004553.454367065@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Birsan <cristian.birsan@microchip.com>

[ Upstream commit bfa2bddf6ffe0ac034d02cda20c74ef05571210e ]

Add the ACR register to all PLL settings and provide the correct
ACR value for each PLL used in different SoCs.

Suggested-by: Mihai Sain <mihai.sain@microchip.com>
Signed-off-by: Cristian Birsan <cristian.birsan@microchip.com>
[nicolas.ferre@microchip.com: add sama7d65 and review commit message]
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/pmc.h      | 1 +
 drivers/clk/at91/sam9x60.c  | 2 ++
 drivers/clk/at91/sam9x7.c   | 5 +++++
 drivers/clk/at91/sama7d65.c | 4 ++++
 drivers/clk/at91/sama7g5.c  | 2 ++
 5 files changed, 14 insertions(+)

diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index 4fb29ca111f7d..5daa32c4cf254 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -80,6 +80,7 @@ struct clk_pll_characteristics {
 	u16 *icpll;
 	u8 *out;
 	u8 upll : 1;
+	u32 acr;
 };
 
 struct clk_programmable_layout {
diff --git a/drivers/clk/at91/sam9x60.c b/drivers/clk/at91/sam9x60.c
index db6db9e2073eb..18baf4a256f47 100644
--- a/drivers/clk/at91/sam9x60.c
+++ b/drivers/clk/at91/sam9x60.c
@@ -36,6 +36,7 @@ static const struct clk_pll_characteristics plla_characteristics = {
 	.num_output = ARRAY_SIZE(plla_outputs),
 	.output = plla_outputs,
 	.core_output = core_outputs,
+	.acr = UL(0x00020010),
 };
 
 static const struct clk_range upll_outputs[] = {
@@ -48,6 +49,7 @@ static const struct clk_pll_characteristics upll_characteristics = {
 	.output = upll_outputs,
 	.core_output = core_outputs,
 	.upll = true,
+	.acr = UL(0x12023010), /* fIN = [18 MHz, 32 MHz]*/
 };
 
 static const struct clk_pll_layout pll_frac_layout = {
diff --git a/drivers/clk/at91/sam9x7.c b/drivers/clk/at91/sam9x7.c
index ffab32b047a01..7322220418b45 100644
--- a/drivers/clk/at91/sam9x7.c
+++ b/drivers/clk/at91/sam9x7.c
@@ -107,6 +107,7 @@ static const struct clk_pll_characteristics plla_characteristics = {
 	.num_output = ARRAY_SIZE(plla_outputs),
 	.output = plla_outputs,
 	.core_output = plla_core_outputs,
+	.acr = UL(0x00020010), /* Old ACR_DEFAULT_PLLA value */
 };
 
 static const struct clk_pll_characteristics upll_characteristics = {
@@ -115,6 +116,7 @@ static const struct clk_pll_characteristics upll_characteristics = {
 	.output = upll_outputs,
 	.core_output = upll_core_outputs,
 	.upll = true,
+	.acr = UL(0x12023010), /* fIN=[20 MHz, 32 MHz] */
 };
 
 static const struct clk_pll_characteristics lvdspll_characteristics = {
@@ -122,6 +124,7 @@ static const struct clk_pll_characteristics lvdspll_characteristics = {
 	.num_output = ARRAY_SIZE(lvdspll_outputs),
 	.output = lvdspll_outputs,
 	.core_output = lvdspll_core_outputs,
+	.acr = UL(0x12023010), /* fIN=[20 MHz, 32 MHz] */
 };
 
 static const struct clk_pll_characteristics audiopll_characteristics = {
@@ -129,6 +132,7 @@ static const struct clk_pll_characteristics audiopll_characteristics = {
 	.num_output = ARRAY_SIZE(audiopll_outputs),
 	.output = audiopll_outputs,
 	.core_output = audiopll_core_outputs,
+	.acr = UL(0x12023010), /* fIN=[20 MHz, 32 MHz] */
 };
 
 static const struct clk_pll_characteristics plladiv2_characteristics = {
@@ -136,6 +140,7 @@ static const struct clk_pll_characteristics plladiv2_characteristics = {
 	.num_output = ARRAY_SIZE(plladiv2_outputs),
 	.output = plladiv2_outputs,
 	.core_output = plladiv2_core_outputs,
+	.acr = UL(0x00020010),  /* Old ACR_DEFAULT_PLLA value */
 };
 
 /* Layout for fractional PLL ID PLLA. */
diff --git a/drivers/clk/at91/sama7d65.c b/drivers/clk/at91/sama7d65.c
index a5d40df8b2f27..7dee2b160ffb3 100644
--- a/drivers/clk/at91/sama7d65.c
+++ b/drivers/clk/at91/sama7d65.c
@@ -138,6 +138,7 @@ static const struct clk_pll_characteristics cpu_pll_characteristics = {
 	.num_output = ARRAY_SIZE(cpu_pll_outputs),
 	.output = cpu_pll_outputs,
 	.core_output = core_outputs,
+	.acr = UL(0x00070010),
 };
 
 /* PLL characteristics. */
@@ -146,6 +147,7 @@ static const struct clk_pll_characteristics pll_characteristics = {
 	.num_output = ARRAY_SIZE(pll_outputs),
 	.output = pll_outputs,
 	.core_output = core_outputs,
+	.acr = UL(0x00070010),
 };
 
 static const struct clk_pll_characteristics lvdspll_characteristics = {
@@ -153,6 +155,7 @@ static const struct clk_pll_characteristics lvdspll_characteristics = {
 	.num_output = ARRAY_SIZE(lvdspll_outputs),
 	.output = lvdspll_outputs,
 	.core_output = lvdspll_core_outputs,
+	.acr = UL(0x00070010),
 };
 
 static const struct clk_pll_characteristics upll_characteristics = {
@@ -160,6 +163,7 @@ static const struct clk_pll_characteristics upll_characteristics = {
 	.num_output = ARRAY_SIZE(upll_outputs),
 	.output = upll_outputs,
 	.core_output = upll_core_outputs,
+	.acr = UL(0x12020010),
 	.upll = true,
 };
 
diff --git a/drivers/clk/at91/sama7g5.c b/drivers/clk/at91/sama7g5.c
index 8385badc1c706..1340c2b006192 100644
--- a/drivers/clk/at91/sama7g5.c
+++ b/drivers/clk/at91/sama7g5.c
@@ -113,6 +113,7 @@ static const struct clk_pll_characteristics cpu_pll_characteristics = {
 	.num_output = ARRAY_SIZE(cpu_pll_outputs),
 	.output = cpu_pll_outputs,
 	.core_output = core_outputs,
+	.acr = UL(0x00070010),
 };
 
 /* PLL characteristics. */
@@ -121,6 +122,7 @@ static const struct clk_pll_characteristics pll_characteristics = {
 	.num_output = ARRAY_SIZE(pll_outputs),
 	.output = pll_outputs,
 	.core_output = core_outputs,
+	.acr = UL(0x00070010),
 };
 
 /*
-- 
2.51.0



