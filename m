Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DEA238D49;
	Tue, 17 Jun 2025 16:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177658; cv=none; b=b1Gcsxk+qKiiosjuvhKue3J7f+5cMtffkxFwS5t2eJF8c4ICrVehS4HzdWkLnRYR6t2hIRNcTFUMmd5hbui9ysbaW8Z5tsSCJstu2adR7+0EVceoAdYWACXqRmqCK/v5YdfIKSGGrfwEEijId6Vuqvr+5s1EfvYGdM9eNQ1HLl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177658; c=relaxed/simple;
	bh=nMmi431Re2rC0lwPNhh/GWPl5lOSSEKCgtpLIOkq2yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cE8p1o6tAC9zTy62EFIC0GpoPCx63ztZDtoVZoiBYU7Yo7gX1brDjJi0oQu/tzZ89KxZgh3QV3Gv9OuyRMT7XNwZW/+osbT/7Tvdj+d7uT2BJRug5GViVia6EQGcF+7Iz16Gp6Oz3S9ME0t7TxLds6YvXb2HtCZYpJoPXm5E0bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5idy+/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5idy+/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20437C4CEE3;
	Tue, 17 Jun 2025 16:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177658;
	bh=nMmi431Re2rC0lwPNhh/GWPl5lOSSEKCgtpLIOkq2yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5idy+/iIgHSWs/0YzQHnRauZEFRRoKoIA3khqxPXVuiH/f1uG8Orwlw9M2dPRUm2
	 tb1iq0xj8oC1b7f+B+7jo7U5cUCLfWKwhvXP2PFi02UVqjmq+4Y76hLrRuPE+eKrbp
	 8JVjLXPODslgctYALa6cAoaPcW1KJ2WAhf4Skszg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 342/780] arm64: dts: qcom: sm8650: setup gpu thermal with higher temperatures
Date: Tue, 17 Jun 2025 17:20:50 +0200
Message-ID: <20250617152505.381016484@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 2250f65b32565eb8b757e89248c75977f370f498 ]

On the SM8650, the dynamic clock and voltage scaling (DCVS) for the GPU
is done from the HLOS, but the GPU can achieve a much higher temperature
before failing according the reference downstream implementation.

Set higher temperatures in the GPU trip points corresponding to
the temperatures provided by Qualcomm in the dowstream source, much
closer to the junction temperature and with a higher critical
temperature trip in the case the HLOS DCVS cannot handle the
temperature surge.

The tsens MAX_THRESHOLD is set to 120C on those platforms, so set
the hot to 110C to leave a chance to HLOS to react and critical to
115C to avoid the monitor thermal shutdown.

Fixes: 497624ed5506 ("arm64: dts: qcom: sm8650: Throttle the GPU when overheating")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250203-topic-sm8650-thermal-cpu-idle-v4-2-65e35f307301@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 64 ++++++++++++++--------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index c8a2a76a98f00..9591c13edbb9d 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -6537,20 +6537,20 @@
 
 			trips {
 				gpu0_alert0: trip-point0 {
-					temperature = <85000>;
+					temperature = <95000>;
 					hysteresis = <1000>;
 					type = "passive";
 				};
 
 				trip-point1 {
-					temperature = <90000>;
+					temperature = <110000>;
 					hysteresis = <1000>;
 					type = "hot";
 				};
 
 				trip-point2 {
-					temperature = <110000>;
-					hysteresis = <1000>;
+					temperature = <115000>;
+					hysteresis = <0>;
 					type = "critical";
 				};
 			};
@@ -6570,20 +6570,20 @@
 
 			trips {
 				gpu1_alert0: trip-point0 {
-					temperature = <85000>;
+					temperature = <95000>;
 					hysteresis = <1000>;
 					type = "passive";
 				};
 
 				trip-point1 {
-					temperature = <90000>;
+					temperature = <110000>;
 					hysteresis = <1000>;
 					type = "hot";
 				};
 
 				trip-point2 {
-					temperature = <110000>;
-					hysteresis = <1000>;
+					temperature = <115000>;
+					hysteresis = <0>;
 					type = "critical";
 				};
 			};
@@ -6603,20 +6603,20 @@
 
 			trips {
 				gpu2_alert0: trip-point0 {
-					temperature = <85000>;
+					temperature = <95000>;
 					hysteresis = <1000>;
 					type = "passive";
 				};
 
 				trip-point1 {
-					temperature = <90000>;
+					temperature = <110000>;
 					hysteresis = <1000>;
 					type = "hot";
 				};
 
 				trip-point2 {
-					temperature = <110000>;
-					hysteresis = <1000>;
+					temperature = <115000>;
+					hysteresis = <0>;
 					type = "critical";
 				};
 			};
@@ -6636,20 +6636,20 @@
 
 			trips {
 				gpu3_alert0: trip-point0 {
-					temperature = <85000>;
+					temperature = <95000>;
 					hysteresis = <1000>;
 					type = "passive";
 				};
 
 				trip-point1 {
-					temperature = <90000>;
+					temperature = <110000>;
 					hysteresis = <1000>;
 					type = "hot";
 				};
 
 				trip-point2 {
-					temperature = <110000>;
-					hysteresis = <1000>;
+					temperature = <115000>;
+					hysteresis = <0>;
 					type = "critical";
 				};
 			};
@@ -6669,20 +6669,20 @@
 
 			trips {
 				gpu4_alert0: trip-point0 {
-					temperature = <85000>;
+					temperature = <95000>;
 					hysteresis = <1000>;
 					type = "passive";
 				};
 
 				trip-point1 {
-					temperature = <90000>;
+					temperature = <110000>;
 					hysteresis = <1000>;
 					type = "hot";
 				};
 
 				trip-point2 {
-					temperature = <110000>;
-					hysteresis = <1000>;
+					temperature = <115000>;
+					hysteresis = <0>;
 					type = "critical";
 				};
 			};
@@ -6702,20 +6702,20 @@
 
 			trips {
 				gpu5_alert0: trip-point0 {
-					temperature = <85000>;
+					temperature = <95000>;
 					hysteresis = <1000>;
 					type = "passive";
 				};
 
 				trip-point1 {
-					temperature = <90000>;
+					temperature = <110000>;
 					hysteresis = <1000>;
 					type = "hot";
 				};
 
 				trip-point2 {
-					temperature = <110000>;
-					hysteresis = <1000>;
+					temperature = <115000>;
+					hysteresis = <0>;
 					type = "critical";
 				};
 			};
@@ -6735,20 +6735,20 @@
 
 			trips {
 				gpu6_alert0: trip-point0 {
-					temperature = <85000>;
+					temperature = <95000>;
 					hysteresis = <1000>;
 					type = "passive";
 				};
 
 				trip-point1 {
-					temperature = <90000>;
+					temperature = <110000>;
 					hysteresis = <1000>;
 					type = "hot";
 				};
 
 				trip-point2 {
-					temperature = <110000>;
-					hysteresis = <1000>;
+					temperature = <115000>;
+					hysteresis = <0>;
 					type = "critical";
 				};
 			};
@@ -6768,20 +6768,20 @@
 
 			trips {
 				gpu7_alert0: trip-point0 {
-					temperature = <85000>;
+					temperature = <95000>;
 					hysteresis = <1000>;
 					type = "passive";
 				};
 
 				trip-point1 {
-					temperature = <90000>;
+					temperature = <110000>;
 					hysteresis = <1000>;
 					type = "hot";
 				};
 
 				trip-point2 {
-					temperature = <110000>;
-					hysteresis = <1000>;
+					temperature = <115000>;
+					hysteresis = <0>;
 					type = "critical";
 				};
 			};
-- 
2.39.5



