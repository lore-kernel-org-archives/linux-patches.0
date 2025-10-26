Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D302DF13A;
	Sun, 26 Oct 2025 14:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490241; cv=none; b=HWGa6BVADN6GrSRcohBfG+4y5fbFLHeO/p8MHNzSAhaf6SyU1fBu69V84wgXWSh2UQ69q73k+7KYae6wAa517QNleNfDQaZ9i+Eydi6PCViCsObTBPS5TMCocVkYgO+tJmh5xjN9FjwDXCWFkbonUVw+KIRET5Bq2/lbAntg1Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490241; c=relaxed/simple;
	bh=ZF7t5uIV172t+m2t7jx1vVOLVPSTzJbCEn2iGsK/fNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PWTVSd/Jv0N7nV37nmA9E7gCDFvGiLZR46Zt5wR0z1gKzfwpAcCZFSbuKlwEADWbMB1HbduXq8O6L9ktqpJlpLuNyHcQnjfHduqNBHuHIEBfcqLYqa4vi6glXRvx6QEsAyj1rHW42pZzyi7xxHFCE/DBK0EhRH6yE3HaYgT1WLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I4uxg9xA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I4uxg9xA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DC2C4CEFB;
	Sun, 26 Oct 2025 14:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490240;
	bh=ZF7t5uIV172t+m2t7jx1vVOLVPSTzJbCEn2iGsK/fNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4uxg9xA1zacNgtEP7WmqVNIbTU38uqiWwkqMQhQ86uA+9vdt08CIgUkWTO6i1LPp
	 vGHgp7ac1dGy0l5xArTKA7i0ZvHqaV6rn1MKkUT9CKoMNKwaOd+rZsba3U/wQnBr43
	 zPBi2RVVXiuQRurP5xQYICl2vTJNFKbcrq0nqtDz9yauDBfmzMOvJp8kTD0oOOhcId
	 KqbQDHImQXCAnbgTXTzJ/Fvh2nZKjh8f2SY9CCCDaoq5g+gHOoSmvTIE8jERwnbXdX
	 P4/oIH1DMSYInLIH764szsiu4PBGst25GLlqth/plf3MD4qRvsha8/jqKKOM+7RT+H
	 +ajhiJ0OFsg9Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>,
	Cristian Birsan <cristian.birsan@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-5.10] ARM: at91: pm: save and restore ACR during PLL disable/enable
Date: Sun, 26 Oct 2025 10:48:55 -0400
Message-ID: <20251026144958.26750-17-sashal@kernel.org>
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

From: Nicolas Ferre <nicolas.ferre@microchip.com>

[ Upstream commit 0c01fe49651d387776abed6a28541e80c8a93319 ]

Add a new word in assembly to store ACR value during the calls
to at91_plla_disable/at91_plla_enable macros and use it.

Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
[cristian.birsan@microchip.com: remove ACR_DEFAULT_PLLA loading]
Signed-off-by: Cristian Birsan <cristian.birsan@microchip.com>
Link: https://lore.kernel.org/r/20250827145427.46819-4-nicolas.ferre@microchip.com
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – the patch fixes a real suspend/resume regression on the
SAM9X60-style PLLs and is safe to backport.

- `arch/arm/mach-at91/pm_suspend.S:693-767` now snapshots the PMC PLL
  Analog Control Register before disabling PLLA and restores that exact
  value when the PLL comes back up, instead of blindly reloading the
  legacy default `0x00020010`. Without this, every suspend cycle
  overwrote any board-/SoC-specific analog tuning done at boot, so PLLA
  resumed with the wrong charge-pump/loop-filter settings.
- The saved word added at `arch/arm/mach-at91/pm_suspend.S:1214-1215` is
  the only state needed; no other logic changes are introduced.
- Multiple SAM9X60-family clock descriptions (for example
  `drivers/clk/at91/sama7g5.c:110-126`,
  `drivers/clk/at91/sam9x60.c:39-52`) program PLL-specific `acr` values
  via `clk-sam9x60-pll.c`, and that driver explicitly writes those
  values into PMC_PLL_ACR before enabling the PLL
  (`drivers/clk/at91/clk-sam9x60-pll.c:106-134`). After suspend, the old
  code immediately replaced them with `AT91_PMC_PLL_ACR_DEFAULT_PLLA`,
  undoing the driver’s configuration and risking unlock or unstable
  clocks on affected boards.
- The regression has existed since the original SAM9X60 PLL support
  (`4fd36e458392`), so every stable kernel that supports these SoCs can
  lose PLL configuration across low-power transitions. The fix is
  minimal, architecture-local, and does not alter behaviour on older PMC
  version 1 platforms because the new code is gated by both the PMC
  version check and `CONFIG_HAVE_AT91_SAM9X60_PLL`.

Given the clear bug fix, confined scope, and lack of risky side effects,
this change fits the stable backport criteria. A good follow-up when
backporting is to run a suspend/resume cycle on a SAM9X60/SAMA7 board to
confirm PLL lock persists.

 arch/arm/mach-at91/pm_suspend.S | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
index 7e6c94f8edeef..aad53ec9e957b 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -689,6 +689,10 @@ sr_dis_exit:
 	bic	tmp2, tmp2, #AT91_PMC_PLL_UPDT_ID
 	str	tmp2, [pmc, #AT91_PMC_PLL_UPDT]
 
+	/* save acr */
+	ldr	tmp2, [pmc, #AT91_PMC_PLL_ACR]
+	str	tmp2, .saved_acr
+
 	/* save div. */
 	mov	tmp1, #0
 	ldr	tmp2, [pmc, #AT91_PMC_PLL_CTRL0]
@@ -758,7 +762,7 @@ sr_dis_exit:
 	str	tmp1, [pmc, #AT91_PMC_PLL_UPDT]
 
 	/* step 2. */
-	ldr	tmp1, =AT91_PMC_PLL_ACR_DEFAULT_PLLA
+	ldr	tmp1, .saved_acr
 	str	tmp1, [pmc, #AT91_PMC_PLL_ACR]
 
 	/* step 3. */
@@ -1207,6 +1211,8 @@ ENDPROC(at91_pm_suspend_in_sram)
 #endif
 .saved_mckr:
 	.word 0
+.saved_acr:
+	.word 0
 .saved_pllar:
 	.word 0
 .saved_sam9_lpr:
-- 
2.51.0

