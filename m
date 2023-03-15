Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25C94431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47986C4339C;
	Wed, 15 Mar 2023 12:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882680;
	bh=anRi+hGmPUdB0A0oCgq7NMi1UWS6Tval1cwYfxhjaIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIhAtrXhMR+SI6RAwcMG7t2uQUi6KXYpREmeWlGdgqhaLh2E5VNSYB47ytceWNKSz
	 6DL9p3UoDMl3PQ6FLKWJ6fyVtdqfkARXFIREohufF7jz5JYaaaMrFbJUNaJmoQC9jD
	 uzRmXwRpa6EPZ6Gw63K0p3eELXH4p0sJEZMvo7Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/68] ARM: dts: exynos: Add GPU thermal zone cooling maps for Odroid XU3/XU4/HC1
Date: Wed, 15 Mar 2023 13:12:23 +0100
Message-Id: <20230315115727.226487057@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 1c651356f482ff08f6acef197a362f2e71d55a98 ]

Add trip points and cooling maps for GPU thermal zone for Odroid
XU3/XU4/HC1 boards. Trip points are based on the CPU thermal zone for the
those boards.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Stable-dep-of: 2e3d0e20d845 ("ARM: dts: exynos: correct TMU phandle in Odroid HC1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5422-odroidhc1.dts    | 30 ++++++++++
 .../boot/dts/exynos5422-odroidxu3-common.dtsi | 59 +++++++++++++++++++
 2 files changed, 89 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5422-odroidhc1.dts b/arch/arm/boot/dts/exynos5422-odroidhc1.dts
index fce5a4579693e..3235d7a27e042 100644
--- a/arch/arm/boot/dts/exynos5422-odroidhc1.dts
+++ b/arch/arm/boot/dts/exynos5422-odroidhc1.dts
@@ -215,6 +215,36 @@
 				};
 			};
 		};
+		gpu_thermal: gpu-thermal {
+			thermal-sensors = <&tmu_gpu 0>;
+			trips {
+				gpu_alert0: gpu-alert-0 {
+					temperature = <70000>;
+					hysteresis = <10000>;
+					type = "active";
+				};
+				gpu_alert1: gpu-alert-1 {
+					temperature = <85000>;
+					hysteresis = <10000>;
+					type = "active";
+				};
+				gpu_crit0: gpu-crit-0 {
+					temperature = <120000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+			};
+			cooling-maps {
+				map0 {
+					trip = <&gpu_alert0>;
+					cooling-device = <&gpu 0 2>;
+				};
+				map1 {
+					trip = <&gpu_alert1>;
+					cooling-device = <&gpu 3 6>;
+				};
+			};
+		};
 	};
 
 };
diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
index 8388720374932..5cf48af9884c9 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
@@ -357,6 +357,65 @@
 				};
 			};
 		};
+		gpu_thermal: gpu-thermal {
+			thermal-sensors = <&tmu_gpu 0>;
+			polling-delay-passive = <250>;
+			polling-delay = <0>;
+			trips {
+				gpu_alert0: gpu-alert-0 {
+					temperature = <50000>;
+					hysteresis = <5000>;
+					type = "active";
+				};
+				gpu_alert1: gpu-alert-1 {
+					temperature = <60000>;
+					hysteresis = <5000>;
+					type = "active";
+				};
+				gpu_alert2: gpu-alert-2 {
+					temperature = <70000>;
+					hysteresis = <5000>;
+					type = "active";
+				};
+				gpu_crit0: gpu-crit-0 {
+					temperature = <120000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+				gpu_alert3: gpu-alert-3 {
+					temperature = <70000>;
+					hysteresis = <10000>;
+					type = "passive";
+				};
+				gpu_alert4: gpu-alert-4 {
+					temperature = <85000>;
+					hysteresis = <10000>;
+					type = "passive";
+				};
+			};
+			cooling-maps {
+				map0 {
+					trip = <&gpu_alert0>;
+					cooling-device = <&fan0 0 1>;
+				};
+				map1 {
+					trip = <&gpu_alert1>;
+					cooling-device = <&fan0 1 2>;
+				};
+				map2 {
+					trip = <&gpu_alert2>;
+					cooling-device = <&fan0 2 3>;
+				};
+				map3 {
+					trip = <&gpu_alert3>;
+					cooling-device = <&gpu 0 2>;
+				};
+				map4 {
+					trip = <&gpu_alert4>;
+					cooling-device = <&gpu 3 6>;
+				};
+			};
+		};
 	};
 };
 
-- 
2.39.2



