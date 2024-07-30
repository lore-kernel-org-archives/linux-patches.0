Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556E38BE8;
	Tue, 30 Jul 2024 16:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355612; cv=none; b=nzP5mr6aShyZNnSljF3NdxPCsneavSgEHpUkvt+Q0bC37PsZEtWVoQSFtbHiD09zKXsewvpk1dGXk9SYNZGcVibRQUFwFaRb1VgF0wwjnfEFmKfavH7WyadG4ugtqayeEz/0oIAfAV+nI1TZuP7+k+Wj7Ff5NruP/0K5NAsEcbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355612; c=relaxed/simple;
	bh=PV3J7OaIZsZ04D9RhBNvP4yGPfa0nmsH/thm643Sof4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlGIDBZLEnRW1bma1K2OZ+hlkZDI8yY5TiZXvrEjy0lbB3hHfcPiYVlI5bi63U1pi8J0+v2RJeKU9oawDT0T+WQVM170eO4sBX2WiMauxWe6R8gobIbEJSqBoM5d63wmwEvOonpLvg2MtxJ5whznKfQeWvQ8i3qAJSUq1PTZLHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIdvmgHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIdvmgHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BA2C32782;
	Tue, 30 Jul 2024 16:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355612;
	bh=PV3J7OaIZsZ04D9RhBNvP4yGPfa0nmsH/thm643Sof4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIdvmgHdDR3evIUzq4tQTxpLsb3/39O2Ir9mNiDwPta9O7YO5zqjTLsfi9uX4j31V
	 1ovCVJC6xpwYiwbVXTzVW6+9XtklpFwYf4D+pWO0CkPteodsyohFpjDivmutUnL6r6
	 /i+C7yn5xlqjRI73wc2Fuayo3irFyAqJelFzAmg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 071/809] arm64: dts: qcom: sc8280xp-*: Remove thermal zone polling delays
Date: Tue, 30 Jul 2024 17:39:07 +0200
Message-ID: <20240730151727.445172156@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit e388421387e8b1b51c507883aaf13f40277fe137 ]

All of the thermal zone suppliers are interrupt-driven, remove the
bogus and unnecessary polling that only wastes CPU time.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240510-topic-msm-polling-cleanup-v2-19-436ca4218da2@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: f7fd6d04c104 ("arm64: dts: qcom: sc8280xp: Throttle the GPU when overheating")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts |  2 +-
 arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi        |  4 ++--
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi              | 13 -------------
 3 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
index 4bf99b6b6e5fb..6b759e67f4d3d 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -299,7 +299,7 @@ linux,cma {
 	thermal-zones {
 		skin-temp-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
+
 			thermal-sensors = <&pmk8280_adc_tm 5>;
 
 			trips {
diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi
index 945de77911de1..1e3babf2e40d8 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi
@@ -14,7 +14,7 @@ / {
 	thermal-zones {
 		pm8280_1_thermal: pm8280-1-thermal {
 			polling-delay-passive = <100>;
-			polling-delay = <0>;
+
 			thermal-sensors = <&pm8280_1_temp_alarm>;
 
 			trips {
@@ -34,7 +34,7 @@ trip1 {
 
 		pm8280_2_thermal: pm8280-2-thermal {
 			polling-delay-passive = <100>;
-			polling-delay = <0>;
+
 			thermal-sensors = <&pm8280_2_temp_alarm>;
 
 			trips {
diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 59f0a850671a3..de554d5d02010 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -5833,7 +5833,6 @@ sound: sound {
 	thermal-zones {
 		cpu0-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <1000>;
 
 			thermal-sensors = <&tsens0 1>;
 
@@ -5848,7 +5847,6 @@ cpu-crit {
 
 		cpu1-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <1000>;
 
 			thermal-sensors = <&tsens0 2>;
 
@@ -5863,7 +5861,6 @@ cpu-crit {
 
 		cpu2-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <1000>;
 
 			thermal-sensors = <&tsens0 3>;
 
@@ -5878,7 +5875,6 @@ cpu-crit {
 
 		cpu3-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <1000>;
 
 			thermal-sensors = <&tsens0 4>;
 
@@ -5893,7 +5889,6 @@ cpu-crit {
 
 		cpu4-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <1000>;
 
 			thermal-sensors = <&tsens0 5>;
 
@@ -5908,7 +5903,6 @@ cpu-crit {
 
 		cpu5-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <1000>;
 
 			thermal-sensors = <&tsens0 6>;
 
@@ -5923,7 +5917,6 @@ cpu-crit {
 
 		cpu6-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <1000>;
 
 			thermal-sensors = <&tsens0 7>;
 
@@ -5938,7 +5931,6 @@ cpu-crit {
 
 		cpu7-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <1000>;
 
 			thermal-sensors = <&tsens0 8>;
 
@@ -5953,7 +5945,6 @@ cpu-crit {
 
 		cluster0-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <1000>;
 
 			thermal-sensors = <&tsens0 9>;
 
@@ -5967,9 +5958,6 @@ cpu-crit {
 		};
 
 		gpu-thermal {
-			polling-delay-passive = <0>;
-			polling-delay = <0>;
-
 			thermal-sensors = <&tsens2 2>;
 
 			trips {
@@ -5983,7 +5971,6 @@ gpu-crit {
 
 		mem-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <1000>;
 
 			thermal-sensors = <&tsens1 15>;
 
-- 
2.43.0



