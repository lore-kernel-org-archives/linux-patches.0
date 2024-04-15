Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFB3763EC;
	Mon, 15 Apr 2024 14:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191572; cv=none; b=otNXRIr8LpGwXXymKW68oylPLMMs1m21ktf7anfY9t5GTyD3o6QvHtilhTKNtpHzXX59C9bm996P+UH3NVYWw2AJwp7pTADK/0U0VivPifRxYxkULSgZqabbsMckLrrqoCxlP7/oBCsfFehOK3r63vIlHEtFc3i0syx+hZyu0+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191572; c=relaxed/simple;
	bh=rc78fJFh1EFuncVC+Fp3PSKpTJ1RTBzsMXbqUo8dvR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvQcAHbDFatp21Hi4p4ZrQUERZEFr8lt9eLN0eBD3MhxeQYtUFCYDxs8SziSeT0xffN8ekWlHHpV0REy4iI1TnF0zM1M7Qexoy1N3n43ely6n4eM/me4S02m6TTbtlji9uHEqJpt0zvL+FeVpQGF/oJVSC43L3F/ak8xM4MnmBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=it7fXzQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="it7fXzQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA99C113CC;
	Mon, 15 Apr 2024 14:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191571;
	bh=rc78fJFh1EFuncVC+Fp3PSKpTJ1RTBzsMXbqUo8dvR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=it7fXzQoYBPsOxtu9mazVn/lLKJu3zdvwXGAG2huu82PPrz22i+99rGQpd8rsPrBM
	 +xKmpzt515WlDrFjk00BNabnzUurqXETUW73lD6HNXG3s1r0ItfPzS1cVgDi6dq9vy
	 zdEjRJ0ZRb/U2mcOSf/MPHYWNy+OaX9FSlMX6K+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/122] ARM: OMAP2+: fix bogus MMC GPIO labels on Nokia N8x0
Date: Mon, 15 Apr 2024 16:19:40 +0200
Message-ID: <20240415141953.835045704@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit 95f37eb52e18879a1b16e51b972d992b39e50a81 ]

The GPIO bank width is 32 on OMAP2, so all labels are incorrect.

Fixes: e519f0bb64ef ("ARM/mmc: Convert old mmci-omap to GPIO descriptors")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Message-ID: <20240223181439.1099750-2-aaro.koskinen@iki.fi>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/board-n8x0.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
index 8e3b5068d4ab0..5ac27ed650e0e 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -144,8 +144,7 @@ static struct gpiod_lookup_table nokia8xx_mmc_gpio_table = {
 	.dev_id = "mmci-omap.0",
 	.table = {
 		/* Slot switch, GPIO 96 */
-		GPIO_LOOKUP("gpio-80-111", 16,
-			    "switch", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("gpio-96-127", 0, "switch", GPIO_ACTIVE_HIGH),
 		{ }
 	},
 };
@@ -154,11 +153,9 @@ static struct gpiod_lookup_table nokia810_mmc_gpio_table = {
 	.dev_id = "mmci-omap.0",
 	.table = {
 		/* Slot index 1, VSD power, GPIO 23 */
-		GPIO_LOOKUP_IDX("gpio-16-31", 7,
-				"vsd", 1, GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP_IDX("gpio-0-31", 23, "vsd", 1, GPIO_ACTIVE_HIGH),
 		/* Slot index 1, VIO power, GPIO 9 */
-		GPIO_LOOKUP_IDX("gpio-0-15", 9,
-				"vio", 1, GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP_IDX("gpio-0-31", 9, "vio", 1, GPIO_ACTIVE_HIGH),
 		{ }
 	},
 };
-- 
2.43.0



