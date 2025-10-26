Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2935921255B;
	Sun, 26 Oct 2025 14:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490238; cv=none; b=Ymd4Hsn2nLLbliyoc2auKnafnEloVsOtEcVFW0Ey5RyDAtL4IYxSQyABvD2smXgod6KijeYPsuj4H5+LH8d8hfWbAkL74upEyyR4sUXz+frvKbCE8of9uppnTwI6U3Tgm69nA7ljOL+DbPeuRDf3r6aWUx028Ki4QJCrWYEh5I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490238; c=relaxed/simple;
	bh=ZJuHNoGLmIbXSdjWvZ3Ub/oxRuillLG3+TXl5+O9TO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hz6MkVB/ssyE6Zcb9oweYgWYa3MeJjZw6stpJ8xuXR5/m7wOemtzIX0+hMOV4DoFjqLGt5zsqi+0437eoD5DeaupYC6d1CVDTRMslHgsz8r7u9bzC6goPZv7L7Hj+AKSix0FVPtrQ1HkcgAkwcQ4I345pq3Sbuz7AilybH3UORg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M2TcAogo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2TcAogo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A374C4CEE7;
	Sun, 26 Oct 2025 14:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490238;
	bh=ZJuHNoGLmIbXSdjWvZ3Ub/oxRuillLG3+TXl5+O9TO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2TcAogo2HJ+nESN7maP0Jg+Fn88K/24cbe7Of3C2IRELwEY3+kiRWuRW4jfitztY
	 BmOUkPYLAnnlLIl5/MiNGIczwW979PdvjG4jufuanwaVK7iOeFan5ZUWpLX0RMI0I2
	 qDsju2wsT0juEW49dSEDYokj4xAxkUPoAUCOsMs6Qs1ySVQtHur8bi/60uESJoW5tK
	 ULepQctmfXPwJd6ocWPpwLqMm1vHAF6tECFpfwkLK1gFPn0XLE2JLUI6lMDuIATQea
	 SwzRv74pJw3ymRUjyDI69ALxHaFOhljlQp96uxLlXvSvXJC9WLqWRxIYvf4VeD5n4f
	 IzrNRORa9xUqg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cristian Birsan <cristian.birsan@microchip.com>,
	Mihai Sain <mihai.sain@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com,
	balamanikandan.gunasundar@microchip.com,
	varshini.rajendran@microchip.com,
	Ryan.Wanner@microchip.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17] clk: at91: add ACR in all PLL settings
Date: Sun, 26 Oct 2025 10:48:53 -0400
Message-ID: <20251026144958.26750-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES – this patch is a low-risk dependency that stable trees need before
they can pick up the actual bug fix for the Atmel/Microchip PLL driver.

- `drivers/clk/at91/clk-sam9x60-pll.c:107` (from the follow-up fix) now
  reads `core->characteristics->acr`; without this commit the field is
  absent/zero, so the driver would push an invalid value into
  PMC_PLL_ACR.
- This change extends `struct clk_pll_characteristics` with an explicit
  `acr` slot (`drivers/clk/at91/pmc.h:83`) and populates per-SoC values
  for every platform that feeds the sam9x60-style PLL driver: sam9x60
  (`drivers/clk/at91/sam9x60.c:39` and `:52`), sam9x7
  (`drivers/clk/at91/sam9x7.c:110`/`119`/`127`/`135`/`143`), sama7d65
  (`drivers/clk/at91/sama7d65.c:141`/`150`/`158`/`166`), and sama7g5
  (`drivers/clk/at91/sama7g5.c:116`/`125`).
- The new constants differ from the old hard-coded defaults (e.g.
  sama7*d* CPU PLLs need `0x00070010` instead of `0x00020010`), so once
  the driver starts using `characteristics->acr` the hardware finally
  receives the correct analog-control parameters.
- The struct growth is internal to the driver, and all in-tree users
  either get an explicit initializer (updated here) or safely default to
  zero, so the risk to stable is negligible.

Follow-up: backport `ARM: at91: remove default values for PMC_PLL_ACR`
(e204c148c83025205eaf9be89593edf350d327a0) right after this so the
stored ACR values are actually written.

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

