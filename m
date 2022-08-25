Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547904C77
	for <patches@lists.linux.dev>; Thu, 25 Aug 2022 21:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0ACCC433D6
	for <patches@lists.linux.dev>; Thu, 25 Aug 2022 21:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1661461791;
	bh=a6IKMC/2AK0dADCt8U8gaMryBimjAhLClTg+QqGCqFA=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=H8FuIr6J3IpO2E1RMVzMUfUP793qvqVvjx2lB8zLz3m6puW4MtdVryLhjwGFwRqtc
	 ND0hY1e93Q7HA2fP8+6hflSU4QzwR6PgAwksnh0e0aBnziwC90hiVnUTObVjFxAkcK
	 DPq0y6uy3tgtSGwABr0Io9PtxIut69UK44yvImT8=
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76E7ECAAD1
	for <patches@lists.linux.dev>; Thu, 25 Aug 2022 21:09:50 +0000 (UTC)
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Thu, 25 Aug 2022 17:09:18 -0400
Subject: [PATCH v1 2/4] arm64: dts: allwinner: h6: Add cooling map for GPU
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <20220825-test-endpoint-send-2-v1-2-e732ebcaa48a@linuxfoundation.org>
References: <20220825-test-endpoint-send-2-v1-0-e732ebcaa48a@linuxfoundation.org>
In-Reply-To: <20220825-test-endpoint-send-2-v1-0-e732ebcaa48a@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-65ba7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1268;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=8EeB0wWMntMKiDLhAaZ+QQ6lyux+ywxl6EQgii2JRlw=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJLZn8pNW/P7zRruVzozq91WxwVG7+/+tGeCV/PpI9FFe0xU
 rSKVO0pZGMS4GGTFFFnK9sVuCip86CGX3mMKM4eVCWQIAxenAExklSzDf6+/i35/v7pstvf5JKU/P6
 efX/Bm5XKBxTEGKntfFnzt2HOVkWH2TP2D5xTr56RrRh6ed0nyCCtD2z+hN0oK4c2fLwfcXMEFAA==
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E
X-Endpoint-Received: by B4 Submission Endpoint with auth_id=1

From: Clément Péron <peron.clem@gmail.com>

Add a simple cooling map for the GPU.

Signed-off-by: Clément Péron <peron.clem@gmail.com>
Acked-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
index 5a28303d3d4c..943ae5374dd6 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -186,6 +186,7 @@ gpu: gpu@1800000 {
 			clocks = <&ccu CLK_GPU>, <&ccu CLK_BUS_GPU>;
 			clock-names = "core", "bus";
 			resets = <&ccu RST_BUS_GPU>;
+			#cooling-cells = <2>;
 			status = "disabled";
 		};
 
@@ -1075,6 +1076,27 @@ gpu-thermal {
 			polling-delay-passive = <0>;
 			polling-delay = <0>;
 			thermal-sensors = <&ths 1>;
+
+			trips {
+				gpu_alert: gpu-alert {
+					temperature = <85000>;
+					hysteresis = <2000>;
+					type = "passive";
+				};
+
+				gpu-crit {
+					temperature = <100000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+			};
+
+			cooling-maps {
+				map0 {
+					trip = <&gpu_alert>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+				};
+			};
 		};
 	};
 };

-- 
b4 0.10.0-dev-65ba7

