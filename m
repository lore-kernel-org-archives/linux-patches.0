Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EF6BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28578C433D2;
	Tue,  7 Mar 2023 17:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209009;
	bh=qLiiu76Zk9G3EoJefkKVTcr2rDyDR3hPVfxdCqXIdSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBB7eKhVlIvkjFczoRBCxacW/mUWbWTfevxXNo532JsTcpKNvJ+xYyQPTUXv5X0K3
	 9B+39Av4GdQhNnt/x3enOHNsKW8P1JzXkv4A/xRRxOm43zugD7zvi4jlVKHNyS4j/N
	 qAWjk96Q8bdQqN2i0MDEVBY0BDgO9lUVxZbZLDI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0081/1001] arm64: dts: amlogic: meson-gxbb-kii-pro: fix led node name
Date: Tue,  7 Mar 2023 17:47:33 +0100
Message-Id: <20230307170025.618550023@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit afdef3b188c934f79ad4b0a7bd8c692742f9b5af ]

Fixes:
leds: status: {...} is not of type 'array'

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-13-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
index 6d8cc00fedc7f..5f2d4317ecfbf 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
@@ -16,7 +16,7 @@ / {
 
 	leds {
 		compatible = "gpio-leds";
-		status {
+		led {
 			gpios = <&gpio_ao GPIOAO_13 GPIO_ACTIVE_LOW>;
 			default-state = "off";
 			color = <LED_COLOR_ID_RED>;
-- 
2.39.2



