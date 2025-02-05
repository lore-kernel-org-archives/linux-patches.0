Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9DF1FECB9;
	Wed,  5 Feb 2025 14:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767014; cv=none; b=Ls0I8Gz1gEGCiiEATnaXzcBqjboyEOXLY1iV8/lm0TzE/yqNu2g7ycmSQLPINlUhNjd/KBNfJAXqaoHUF7GW1vmHXbWNvZfEtBA6+lC0Bff70HU+8ysvfkzg/jftxwd6m2Ym06WUaWhkjlJRvU+bYOsnxMgD66AyI+NGZtTAdBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767014; c=relaxed/simple;
	bh=U9ihAmSQrGNq000MWIpoQbwkbHQn2n9k/GFwB7exlgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leBjeVoIcGAs3r++aAJKYTtklvxNzPmFQId/LmwCz8T2AxnkcVBwI6k7lTQ5LR25lXSdppilNYsCb/VaaglJXdyVbxUutFzE4dVSp/VVJ4wSuUhCEjIg+1U6zgG0WOOAkoHR7S2ajKS2Bdq46BGSDZaYrCg7gzTdV7KN7t8BDZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mkb/Ymd6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mkb/Ymd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C760FC4CED1;
	Wed,  5 Feb 2025 14:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767014;
	bh=U9ihAmSQrGNq000MWIpoQbwkbHQn2n9k/GFwB7exlgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mkb/Ymd6R0F8dp1qeyFa6drlWkfj5QskoMdqnxBpIUPoDU1l7vLHdFpxOug/JTC+O
	 leBhQZJl5NCcZ3/OCCTJaPkRjt0d8IrMs4Ss24+qtt9YkpknYP2xGvNBiGFEWbJffo
	 2QbQEVC7uzRUdUnJ3GIFMTQDvCrH+J/ROLYCsfUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Linus Walleij <linus.walleij@linaro.org>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 370/590] ARM: omap1: Fix up the Retu IRQ on Nokia 770
Date: Wed,  5 Feb 2025 14:42:05 +0100
Message-ID: <20250205134509.425345684@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit ad455e48bba7f21bb5108406da0854cf8dede8ea ]

The Retu IRQ is off by one, as a result the power button does not work.
Fix it.

Fixes: 084b6f216778 ("ARM: omap1: Fix up the Nokia 770 board device IRQs")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/Z3UxH_fOzuftjnuX@darkstar.musicnaut.iki.fi
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap1/board-nokia770.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap1/board-nokia770.c b/arch/arm/mach-omap1/board-nokia770.c
index 3312ef93355da..a5bf5554800fe 100644
--- a/arch/arm/mach-omap1/board-nokia770.c
+++ b/arch/arm/mach-omap1/board-nokia770.c
@@ -289,7 +289,7 @@ static struct gpiod_lookup_table nokia770_irq_gpio_table = {
 		GPIO_LOOKUP("gpio-0-15", 15, "ads7846_irq",
 			    GPIO_ACTIVE_HIGH),
 		/* GPIO used for retu IRQ */
-		GPIO_LOOKUP("gpio-48-63", 15, "retu_irq",
+		GPIO_LOOKUP("gpio-48-63", 14, "retu_irq",
 			    GPIO_ACTIVE_HIGH),
 		/* GPIO used for tahvo IRQ */
 		GPIO_LOOKUP("gpio-32-47", 8, "tahvo_irq",
-- 
2.39.5



