Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238291C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2EFC433D6;
	Wed, 23 Nov 2022 09:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196637;
	bh=piWcSl0qjqaE+gCyLZKfMtR6AKFAfsFF7ZgBncUJQCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TXmgzELL7RoniltEk25qnUtrDQZ2DI8DRct2QEG48b5WJXySpK54bB0m4rx5YVF1
	 bLds4UfLWq9dDYiP/yLBG1VYbTTNvR0h3zCSZTxToANU3IpJImz2b/tgqAJqm8Yboa
	 AVmxsZizqah+KbEFrjXM4HKGracFFgzzaQe4xs+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mihai Sain <mihai.sain@microchip.com>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 087/314] ARM: dts: at91: sama7g5: fix signal name of pin PB2
Date: Wed, 23 Nov 2022 09:48:52 +0100
Message-Id: <20221123084629.421028649@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mihai Sain <mihai.sain@microchip.com>

[ Upstream commit 2b4337c8409b4e9e5aed15c597e4031dd567bdd8 ]

The signal name of pin PB2 with function F is FLEXCOM11_IO1
as it is defined in the datasheet.

Fixes: 7540629e2fc7 ("ARM: dts: at91: add sama7g5 SoC DT and sama7g5-ek")
Signed-off-by: Mihai Sain <mihai.sain@microchip.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20221017083119.1643-1-mihai.sain@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sama7g5-pinfunc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sama7g5-pinfunc.h b/arch/arm/boot/dts/sama7g5-pinfunc.h
index 4eb30445d205..6e87f0d4b8fc 100644
--- a/arch/arm/boot/dts/sama7g5-pinfunc.h
+++ b/arch/arm/boot/dts/sama7g5-pinfunc.h
@@ -261,7 +261,7 @@
 #define PIN_PB2__FLEXCOM6_IO0		PINMUX_PIN(PIN_PB2, 2, 1)
 #define PIN_PB2__ADTRG			PINMUX_PIN(PIN_PB2, 3, 1)
 #define PIN_PB2__A20			PINMUX_PIN(PIN_PB2, 4, 1)
-#define PIN_PB2__FLEXCOM11_IO0		PINMUX_PIN(PIN_PB2, 6, 3)
+#define PIN_PB2__FLEXCOM11_IO1		PINMUX_PIN(PIN_PB2, 6, 3)
 #define PIN_PB3				35
 #define PIN_PB3__GPIO			PINMUX_PIN(PIN_PB3, 0, 0)
 #define PIN_PB3__RF1			PINMUX_PIN(PIN_PB3, 1, 1)
-- 
2.35.1



