Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B9DBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC97C433EF;
	Tue,  7 Mar 2023 18:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214772;
	bh=iaE5AMR1s4xCcv9A7OF8oAI1+5GeNpIqZ1XPFo5A7QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HzHSTSyR2Cp5Scq6GHVHzh1KSzhnSX35BOcU8+GrVN3lssWLsbNnPPZFzWuLcOCX+
	 n+V4OnT4T2sddtDZ4MfaFuiKqlWyGiaalZosDfLM7ZPV59op5HITLucSIOIGRrE2me
	 gvUv1brbMxLbgVImQ6b3HTB2z38pg4ySbYM3OcHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/567] arm64: dts: amlogic: meson-gxbb-kii-pro: fix led node name
Date: Tue,  7 Mar 2023 17:56:20 +0100
Message-Id: <20230307165907.828256843@linuxfoundation.org>
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
index e8394a8269ee1..802faf7e4e3cb 100644
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



