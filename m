Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3A8134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D90C433D2;
	Mon, 12 Jun 2023 10:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566645;
	bh=CSN9F9CwtS/9vqspZimVD2cuF3+T8YvVHArdng57dkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Su9LWHPqB3OiQiKaCepcUtASgllzAmHhNz+GgWK2q8sQRr16urpVSmBMvfHnLNYT6
	 nCHMKyJwqf6AEaWXVoaFkMKoiFIKbPTRJxwKHtzafFBAAlfdP8QhesDxCbzN0TS9LG
	 NQkYlSPbEdAomsj9F9zTGMULAIF++FXdIyNdZ/7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/132] ARM: dts: at91: sama7g5ek: fix debounce delay property for shdwc
Date: Mon, 12 Jun 2023 12:27:17 +0200
Message-ID: <20230612101714.999157402@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
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
index 3b25c67795ddb..4af8a1c96ed63 100644
--- a/arch/arm/boot/dts/at91-sama7g5ek.dts
+++ b/arch/arm/boot/dts/at91-sama7g5ek.dts
@@ -789,7 +789,7 @@ &sdmmc2 {
 };
 
 &shdwc {
-	atmel,shdwc-debouncer = <976>;
+	debounce-delay-us = <976>;
 	status = "okay";
 
 	input@0 {
-- 
2.39.2



