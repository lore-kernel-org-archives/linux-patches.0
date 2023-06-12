Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3293DD512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB45C433EF;
	Mon, 12 Jun 2023 10:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566320;
	bh=wPajnjI2ZaldRsSTBBex9VJWKQOYdR+EMv8mPP5pRtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZPWjFFBahzPGiqhFqxsiE8TKG5Lw94h7voqz6//KkZTvVUSMvTs9uH7cSa4vgg/y
	 EHf4rU099O9qC/iPjZphyOzbUupTNedv4vpd8X4t1aXDYaAlQEXFQTJKmU7wPYXPdU
	 M1pqlzfpHwjI2ffjvETTIbNOPCKqSE39glaXLsb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 71/91] ARM: dts: at91: sama7g5ek: fix debounce delay property for shdwc
Date: Mon, 12 Jun 2023 12:27:00 +0200
Message-ID: <20230612101705.036145253@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 6b0db163ff9200a55dc77a652dad1d4b0a853f63 ]

There is no atmel,shdwc-debouncer property for SHDWC. The right DT property
is debounce-delay-us. Use it.

Fixes: 16b161bcf5d4 ("ARM: dts: at91: sama7g5: add shdwc node")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20230523052750.184223-1-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sama7g5ek.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91-sama7g5ek.dts b/arch/arm/boot/dts/at91-sama7g5ek.dts
index 2038e387be288..0ba856066ffb2 100644
--- a/arch/arm/boot/dts/at91-sama7g5ek.dts
+++ b/arch/arm/boot/dts/at91-sama7g5ek.dts
@@ -659,7 +659,7 @@ &sdmmc2 {
 };
 
 &shdwc {
-	atmel,shdwc-debouncer = <976>;
+	debounce-delay-us = <976>;
 	status = "okay";
 
 	input@0 {
-- 
2.39.2



