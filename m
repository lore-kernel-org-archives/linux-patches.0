Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C80BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0B2C433D2;
	Tue,  7 Mar 2023 18:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214769;
	bh=lhRyszxxxRvvZhpTL2woDqoWb+vfLMFo4sqnUs/T6xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NxALh+tM9cNbchKCBkXHqne7Dk12HQ5xuXviDK2+VjI0Mp74r7Do6c4BkYScOFgsE
	 5E1VlxKwXR5850WxY2SA46QhaTN+2xsqIw4ASIzLJtmMY/QdAqRPfqsCshoWYbF6+Q
	 XxtgFD9vbg0yZnTlZzoXxlHT4oTsWisyUYsTCqNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/567] arm64: dts: amlogic: meson-gxl-s905d-phicomm-n1: fix led node name
Date: Tue,  7 Mar 2023 17:56:19 +0100
Message-Id: <20230307165907.795846903@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit eee64d8fbbdaab72bbab3e462f3a7b742d20c8c2 ]

Fixes:
leds: status: {...} is not of type 'array'

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-12-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts
index 9ef210f17b4aa..393d3cb33b9ee 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts
@@ -18,7 +18,7 @@ cvbs-connector {
 	leds {
 		compatible = "gpio-leds";
 
-		status {
+		led {
 			label = "n1:white:status";
 			gpios = <&gpio_ao GPIOAO_9 GPIO_ACTIVE_HIGH>;
 			default-state = "on";
-- 
2.39.2



