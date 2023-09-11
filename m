Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8261170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A51C433C7;
	Mon, 11 Sep 2023 14:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440992;
	bh=C68iTZBEjbJN5ogy6Ct7d62itQTgMMpQ1/yY17/qf5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYfWNGVQjhcHnwSKPc+CfroMiZNvbi+bujnfr/2tZQhjMANcJJynZQd0Su2cVJJC6
	 3KQcrlHeVBeUGRxELCykCj9Ec4RZHK6C9aCPOXb8FoWpQJVD3m/TPff8n2V4LAd7Ul
	 /TwSfFts0Aj3vgM5cCBv42n/hXJO7kHnkkYiXmoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 231/739] arm64: dts: qcom: sm8350: Use proper CPU compatibles
Date: Mon, 11 Sep 2023 15:40:30 +0200
Message-ID: <20230911134657.622904395@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 4390730cc12af25f7c997f477795f5f4200149c0 ]

The Kryo names (once again) turned out to be fake. The CPUs report:

0x412fd050 (CA55 r2p0) (0 - 3)
0x411fd410 (CA78 r1p1) (4 - 6)
0x411fd440 (CX1  r1p1) (7)

Use the compatibles that reflect that.

Fixes: b7e8f433a673 ("arm64: dts: qcom: Add basic devicetree support for SM8350 SoC")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230706-topic-sm8350-cpu-compat-v1-1-f8d6a1869781@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 35b68de50e227..435a807841158 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -48,7 +48,7 @@ cpus {
 
 		CPU0: cpu@0 {
 			device_type = "cpu";
-			compatible = "qcom,kryo685";
+			compatible = "arm,cortex-a55";
 			reg = <0x0 0x0>;
 			clocks = <&cpufreq_hw 0>;
 			enable-method = "psci";
@@ -72,7 +72,7 @@ L3_0: l3-cache {
 
 		CPU1: cpu@100 {
 			device_type = "cpu";
-			compatible = "qcom,kryo685";
+			compatible = "arm,cortex-a55";
 			reg = <0x0 0x100>;
 			clocks = <&cpufreq_hw 0>;
 			enable-method = "psci";
@@ -91,7 +91,7 @@ L2_100: l2-cache {
 
 		CPU2: cpu@200 {
 			device_type = "cpu";
-			compatible = "qcom,kryo685";
+			compatible = "arm,cortex-a55";
 			reg = <0x0 0x200>;
 			clocks = <&cpufreq_hw 0>;
 			enable-method = "psci";
@@ -110,7 +110,7 @@ L2_200: l2-cache {
 
 		CPU3: cpu@300 {
 			device_type = "cpu";
-			compatible = "qcom,kryo685";
+			compatible = "arm,cortex-a55";
 			reg = <0x0 0x300>;
 			clocks = <&cpufreq_hw 0>;
 			enable-method = "psci";
@@ -129,7 +129,7 @@ L2_300: l2-cache {
 
 		CPU4: cpu@400 {
 			device_type = "cpu";
-			compatible = "qcom,kryo685";
+			compatible = "arm,cortex-a78";
 			reg = <0x0 0x400>;
 			clocks = <&cpufreq_hw 1>;
 			enable-method = "psci";
@@ -148,7 +148,7 @@ L2_400: l2-cache {
 
 		CPU5: cpu@500 {
 			device_type = "cpu";
-			compatible = "qcom,kryo685";
+			compatible = "arm,cortex-a78";
 			reg = <0x0 0x500>;
 			clocks = <&cpufreq_hw 1>;
 			enable-method = "psci";
@@ -167,7 +167,7 @@ L2_500: l2-cache {
 
 		CPU6: cpu@600 {
 			device_type = "cpu";
-			compatible = "qcom,kryo685";
+			compatible = "arm,cortex-a78";
 			reg = <0x0 0x600>;
 			clocks = <&cpufreq_hw 1>;
 			enable-method = "psci";
@@ -186,7 +186,7 @@ L2_600: l2-cache {
 
 		CPU7: cpu@700 {
 			device_type = "cpu";
-			compatible = "qcom,kryo685";
+			compatible = "arm,cortex-x1";
 			reg = <0x0 0x700>;
 			clocks = <&cpufreq_hw 2>;
 			enable-method = "psci";
-- 
2.40.1



