Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA56BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A984C433EF;
	Tue,  7 Mar 2023 19:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678216230;
	bh=Lr/k4R5Dqp1IQhSV4OfB8ht77k2DDGyB/TM5qz+sgMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gW3VD6rQTA9TQScEtxjPQ2dtcdRjl3JGYK966be4A1hcnU4jpLuRDlsE9cqI/aa1Q
	 Cp26svm7J4xbQ9wCtteQZ2XTnxH7cxa3R+oV0yCQvjABYDMenFzvcVduW4WSzVEH5M
	 QFesBT85rLgCXZmRCcxx6ZjqIQnB/yue0gfWuPBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.15 518/567] ARM: dts: exynos: correct TMU phandle in Odroid XU3 family
Date: Tue,  7 Mar 2023 18:04:14 +0100
Message-Id: <20230307165928.409655646@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit a3583e92d188ec6c58c7f603ac5e72dd8a11c21a upstream.

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.  This was not critical before,
but since rework of thermal Devicetree initialization in the
commit 3fd6d6e2b4e8 ("thermal/of: Rework the thermal device tree
initialization"), this leads to errors registering thermal zones other
than first one:

  thermal_sys: cpu0-thermal: Failed to read thermal-sensors cells: -2
  thermal_sys: Failed to find thermal zone for tmu id=0
  exynos-tmu 10064000.tmu: Failed to register sensor: -2
  exynos-tmu: probe of 10064000.tmu failed with error -2

Fixes: f1722d7dd8b8 ("ARM: dts: Define default thermal-zones for exynos5422")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230209105841.779596-6-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
@@ -50,7 +50,7 @@
 
 	thermal-zones {
 		cpu0_thermal: cpu0-thermal {
-			thermal-sensors = <&tmu_cpu0 0>;
+			thermal-sensors = <&tmu_cpu0>;
 			polling-delay-passive = <250>;
 			polling-delay = <0>;
 			trips {
@@ -139,7 +139,7 @@
 			};
 		};
 		cpu1_thermal: cpu1-thermal {
-			thermal-sensors = <&tmu_cpu1 0>;
+			thermal-sensors = <&tmu_cpu1>;
 			polling-delay-passive = <250>;
 			polling-delay = <0>;
 			trips {
@@ -212,7 +212,7 @@
 			};
 		};
 		cpu2_thermal: cpu2-thermal {
-			thermal-sensors = <&tmu_cpu2 0>;
+			thermal-sensors = <&tmu_cpu2>;
 			polling-delay-passive = <250>;
 			polling-delay = <0>;
 			trips {
@@ -285,7 +285,7 @@
 			};
 		};
 		cpu3_thermal: cpu3-thermal {
-			thermal-sensors = <&tmu_cpu3 0>;
+			thermal-sensors = <&tmu_cpu3>;
 			polling-delay-passive = <250>;
 			polling-delay = <0>;
 			trips {
@@ -358,7 +358,7 @@
 			};
 		};
 		gpu_thermal: gpu-thermal {
-			thermal-sensors = <&tmu_gpu 0>;
+			thermal-sensors = <&tmu_gpu>;
 			polling-delay-passive = <250>;
 			polling-delay = <0>;
 			trips {


