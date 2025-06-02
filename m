Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0D61401B;
	Mon,  2 Jun 2025 13:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872641; cv=none; b=JpKsilLKiHR52X/JD+rd/QWblc/JVzlNEAKmzgnXvCdTtwlRqaIOgNOeN2GlC6POdXAotEiiycDQ6FXBVfMirAUJauGPATyjygfsdVZhTrymGnHG3GRdRtSjrFAe3OL3dFXbAqvPoUxY5mwZNSZyIhIarGJcFXMTHCNTCj2iDNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872641; c=relaxed/simple;
	bh=vlHhI/wnfX+cfM81TpAXh/DjSW3GqNA9EQO4yIJXLiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=trZUIvd8vOWRTVp78sc0TjlmVjTRQbk8jMJBcUxE6nzVTR6Ir9pssulMF5Tluox21E7tDHuVta1ewbNkhXulDgJA4rbGspk/EQUJ7uBG5DOLaGca4d+okHkeWR9P8RBG4sJXlP2ofYTtWjA5D4R+8c9ub3+3zczlNksC8rjvEK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n6wjj9Ey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n6wjj9Ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B94C4CEEE;
	Mon,  2 Jun 2025 13:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872640;
	bh=vlHhI/wnfX+cfM81TpAXh/DjSW3GqNA9EQO4yIJXLiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6wjj9EyBXA67gZ3uj/pVxlBWNnmDdOIkATnRIyxXj00G52ReQXeQr/f/fb5cMlXe
	 CQhiB54zG86KN/42FBLPV9YIaK6+VK0YgWvGB3kOlUxjscAEWrr9v7pNZqMVvMhjTI
	 H7LGJxWQRKtPoIyjotpfkfIcps2VP+VEJoFOgpj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.14 25/73] arm64: dts: qcom: x1e80100: Add GPU cooling
Date: Mon,  2 Jun 2025 15:47:11 +0200
Message-ID: <20250602134242.691171064@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 5ba21fa11f473c9827f378ace8c9f983de9e0287 upstream.

Unlike the CPU, the GPU does not throttle its speed automatically when it
reaches high temperatures. With certain high GPU loads it is possible to
reach the critical hardware shutdown temperature of 120°C, endangering the
hardware and making it impossible to run certain applications.

Set up GPU cooling similar to the ACPI tables, by throttling the GPU speed
when reaching 95°C and polling every 200ms.

Cc: stable@vger.kernel.org
Fixes: 721e38301b79 ("arm64: dts: qcom: x1e80100: Add gpu support")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250219-x1e80100-thermal-fixes-v1-3-d110e44ac3f9@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi |  169 +++++++++++++++++----------------
 1 file changed, 89 insertions(+), 80 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -20,6 +20,7 @@
 #include <dt-bindings/soc/qcom,gpr.h>
 #include <dt-bindings/soc/qcom,rpmh-rsc.h>
 #include <dt-bindings/sound/qcom,q6dsp-lpass-ports.h>
+#include <dt-bindings/thermal/thermal.h>
 
 / {
 	interrupt-parent = <&intc>;
@@ -9359,24 +9360,25 @@
 		};
 
 		gpuss-0-thermal {
-			polling-delay-passive = <10>;
+			polling-delay-passive = <200>;
 
 			thermal-sensors = <&tsens3 5>;
 
-			trips {
-				trip-point0 {
-					temperature = <85000>;
-					hysteresis = <1000>;
-					type = "passive";
+			cooling-maps {
+				map0 {
+					trip = <&gpuss0_alert0>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
+			};
 
-				trip-point1 {
-					temperature = <90000>;
+			trips {
+				gpuss0_alert0: trip-point0 {
+					temperature = <95000>;
 					hysteresis = <1000>;
-					type = "hot";
+					type = "passive";
 				};
 
-				trip-point2 {
+				gpu-critical {
 					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
@@ -9385,24 +9387,25 @@
 		};
 
 		gpuss-1-thermal {
-			polling-delay-passive = <10>;
+			polling-delay-passive = <200>;
 
 			thermal-sensors = <&tsens3 6>;
 
-			trips {
-				trip-point0 {
-					temperature = <85000>;
-					hysteresis = <1000>;
-					type = "passive";
+			cooling-maps {
+				map0 {
+					trip = <&gpuss1_alert0>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
+			};
 
-				trip-point1 {
-					temperature = <90000>;
+			trips {
+				gpuss1_alert0: trip-point0 {
+					temperature = <95000>;
 					hysteresis = <1000>;
-					type = "hot";
+					type = "passive";
 				};
 
-				trip-point2 {
+				gpu-critical {
 					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
@@ -9411,24 +9414,25 @@
 		};
 
 		gpuss-2-thermal {
-			polling-delay-passive = <10>;
+			polling-delay-passive = <200>;
 
 			thermal-sensors = <&tsens3 7>;
 
-			trips {
-				trip-point0 {
-					temperature = <85000>;
-					hysteresis = <1000>;
-					type = "passive";
+			cooling-maps {
+				map0 {
+					trip = <&gpuss2_alert0>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
+			};
 
-				trip-point1 {
-					temperature = <90000>;
+			trips {
+				gpuss2_alert0: trip-point0 {
+					temperature = <95000>;
 					hysteresis = <1000>;
-					type = "hot";
+					type = "passive";
 				};
 
-				trip-point2 {
+				gpu-critical {
 					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
@@ -9437,24 +9441,25 @@
 		};
 
 		gpuss-3-thermal {
-			polling-delay-passive = <10>;
+			polling-delay-passive = <200>;
 
 			thermal-sensors = <&tsens3 8>;
 
-			trips {
-				trip-point0 {
-					temperature = <85000>;
-					hysteresis = <1000>;
-					type = "passive";
+			cooling-maps {
+				map0 {
+					trip = <&gpuss3_alert0>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
+			};
 
-				trip-point1 {
-					temperature = <90000>;
+			trips {
+				gpuss3_alert0: trip-point0 {
+					temperature = <95000>;
 					hysteresis = <1000>;
-					type = "hot";
+					type = "passive";
 				};
 
-				trip-point2 {
+				gpu-critical {
 					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
@@ -9463,24 +9468,25 @@
 		};
 
 		gpuss-4-thermal {
-			polling-delay-passive = <10>;
+			polling-delay-passive = <200>;
 
 			thermal-sensors = <&tsens3 9>;
 
-			trips {
-				trip-point0 {
-					temperature = <85000>;
-					hysteresis = <1000>;
-					type = "passive";
+			cooling-maps {
+				map0 {
+					trip = <&gpuss4_alert0>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
+			};
 
-				trip-point1 {
-					temperature = <90000>;
+			trips {
+				gpuss4_alert0: trip-point0 {
+					temperature = <95000>;
 					hysteresis = <1000>;
-					type = "hot";
+					type = "passive";
 				};
 
-				trip-point2 {
+				gpu-critical {
 					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
@@ -9489,24 +9495,25 @@
 		};
 
 		gpuss-5-thermal {
-			polling-delay-passive = <10>;
+			polling-delay-passive = <200>;
 
 			thermal-sensors = <&tsens3 10>;
 
-			trips {
-				trip-point0 {
-					temperature = <85000>;
-					hysteresis = <1000>;
-					type = "passive";
+			cooling-maps {
+				map0 {
+					trip = <&gpuss5_alert0>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
+			};
 
-				trip-point1 {
-					temperature = <90000>;
+			trips {
+				gpuss5_alert0: trip-point0 {
+					temperature = <95000>;
 					hysteresis = <1000>;
-					type = "hot";
+					type = "passive";
 				};
 
-				trip-point2 {
+				gpu-critical {
 					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
@@ -9515,24 +9522,25 @@
 		};
 
 		gpuss-6-thermal {
-			polling-delay-passive = <10>;
+			polling-delay-passive = <200>;
 
 			thermal-sensors = <&tsens3 11>;
 
-			trips {
-				trip-point0 {
-					temperature = <85000>;
-					hysteresis = <1000>;
-					type = "passive";
+			cooling-maps {
+				map0 {
+					trip = <&gpuss6_alert0>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
+			};
 
-				trip-point1 {
-					temperature = <90000>;
+			trips {
+				gpuss6_alert0: trip-point0 {
+					temperature = <95000>;
 					hysteresis = <1000>;
-					type = "hot";
+					type = "passive";
 				};
 
-				trip-point2 {
+				gpu-critical {
 					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
@@ -9541,24 +9549,25 @@
 		};
 
 		gpuss-7-thermal {
-			polling-delay-passive = <10>;
+			polling-delay-passive = <200>;
 
 			thermal-sensors = <&tsens3 12>;
 
-			trips {
-				trip-point0 {
-					temperature = <85000>;
-					hysteresis = <1000>;
-					type = "passive";
+			cooling-maps {
+				map0 {
+					trip = <&gpuss7_alert0>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
+			};
 
-				trip-point1 {
-					temperature = <90000>;
+			trips {
+				gpuss7_alert0: trip-point0 {
+					temperature = <95000>;
 					hysteresis = <1000>;
-					type = "hot";
+					type = "passive";
 				};
 
-				trip-point2 {
+				gpu-critical {
 					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";


