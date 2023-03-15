Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD374431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8673AC433EF;
	Wed, 15 Mar 2023 12:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882603;
	bh=8GtTQQEOEd7vDsT0Q6yzwt3NSNi7Vch7oGPawkArPSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xmi8StnFl+Zgp3P5Z4B+GM1XHIoSgXKXFJpH69lIuK/4U2Y7up8p/TbUFTM+HFm6v
	 hZHkTwOy3ebIAuViOIXcQv8wX3oDfG2NbrX2LdW6IDYz5JJxJdSQ4sUfvQE6ZYWEk0
	 PdBZI/KkSGm8uhcL6s8N2879Zd+b/8EeD+CBeIHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/39] ARM: dts: exynos: Override thermal by label in Exynos5250
Date: Wed, 15 Mar 2023 13:12:33 +0100
Message-Id: <20230315115721.932102351@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 7e86ef5cc89609cbad8b9dd2f476789c638dbb92 ]

Using full paths to extend or override a device tree node is error prone
since if there was a typo error, a new node will be created instead of
extending the node as it was desired.  This will lead to run-time errors
that could be hard to detect.

A mistyped label on the other hand, will cause a dtc compile error
(during build time).

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20200901075417.22481-8-krzk@kernel.org
Stable-dep-of: 33e2c595e2e4 ("ARM: dts: exynos: correct TMU phandle in Exynos5250")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5250.dtsi | 38 +++++++++++++++----------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 59e5f0016b862..1883b8c2cd7b9 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -1043,26 +1043,6 @@
 		};
 	};
 
-	thermal-zones {
-		cpu_thermal: cpu-thermal {
-			polling-delay-passive = <0>;
-			polling-delay = <0>;
-			thermal-sensors = <&tmu 0>;
-
-			cooling-maps {
-				map0 {
-				     /* Corresponds to 800MHz at freq_table */
-				     cooling-device = <&cpu0 9 9>, <&cpu1 9 9>;
-				};
-				map1 {
-				     /* Corresponds to 200MHz at freq_table */
-				     cooling-device = <&cpu0 15 15>,
-						      <&cpu1 15 15>;
-			       };
-		       };
-		};
-	};
-
 	timer {
 		compatible = "arm,armv7-timer";
 		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
@@ -1078,6 +1058,24 @@
 	};
 };
 
+&cpu_thermal {
+	polling-delay-passive = <0>;
+	polling-delay = <0>;
+	thermal-sensors = <&tmu 0>;
+
+	cooling-maps {
+		map0 {
+			/* Corresponds to 800MHz at freq_table */
+			cooling-device = <&cpu0 9 9>, <&cpu1 9 9>;
+		};
+		map1 {
+			/* Corresponds to 200MHz at freq_table */
+			cooling-device = <&cpu0 15 15>,
+					 <&cpu1 15 15>;
+		};
+	};
+};
+
 &dp {
 	power-domains = <&pd_disp1>;
 	clocks = <&clock CLK_DP>;
-- 
2.39.2



