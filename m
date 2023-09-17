Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFCE7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E89C433CB;
	Sun, 17 Sep 2023 20:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981954;
	bh=KpcSjzMlrTPLaTfGT4P2k+1TqlSqipQM+ciHARCZgF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrxjXB1+GCdyNqaGdN/56HEszfKdDnoe8z/TApZURe4zOi8js5k4mmC1G3cmFZs0j
	 KYNYyFeAkm5c51l6gk83P8g4rAdrNRhhYIDxugU29tejHrtb107SwlMthpcjzEhmLq
	 E4eciWIBYaqbOxTRoWUsrnxhPsKsyyHXGAKytqAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/511] arm64: dts: qcom: sm8250: correct dynamic power coefficients
Date: Sun, 17 Sep 2023 21:09:18 +0200
Message-ID: <20230917191117.028399375@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 775a5283c25d160b2a1359018c447bc518096547 ]

sm8250 faces the same problem with its Energy Model as sdm845. The energy
cost of LITTLE cores is reported to be higher than medium or big cores

EM computes the energy with formula:

energy = OPP's cost / maximum cpu capacity * utilization

On v6.4-rc6 we have:
max capacity of CPU0 = 284
capacity of CPU0's OPP(1612800 Hz) = 253
cost of CPU0's OPP(1612800 Hz) = 191704

max capacity of CPU4 = 871
capacity of CPU4's OPP(710400 Hz) = 255
cost of CPU4's OPP(710400 Hz) = 343217

Both OPPs have almost the same compute capacity but the estimated energy
per unit of utilization will be estimated to:

energy CPU0 = 191704 / 284 * 1 = 675
energy CPU4 = 343217 / 871 * 1 = 394

EM estimates that little CPU0 will consume 71% more than medium CPU4 for
the same compute capacity. According to [1], little consumes 25% less than
medium core for Coremark benchmark at those OPPs for the same duration.

Set the dynamic-power-coefficient of CPU0-3 to 105 to fix the energy model
for little CPUs.

[1] https://github.com/kdrag0n/freqbench/tree/master/results/sm8250/k30s

Fixes: 6aabed5526ee ("arm64: dts: qcom: sm8250: Add CPU capacities and energy model")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20230615154852.130076-1-vincent.guittot@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 181e32b8a2728..005e75dc6919e 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -97,7 +97,7 @@ CPU0: cpu@0 {
 			reg = <0x0 0x0>;
 			enable-method = "psci";
 			capacity-dmips-mhz = <448>;
-			dynamic-power-coefficient = <205>;
+			dynamic-power-coefficient = <105>;
 			next-level-cache = <&L2_0>;
 			qcom,freq-domain = <&cpufreq_hw 0>;
 			#cooling-cells = <2>;
@@ -116,7 +116,7 @@ CPU1: cpu@100 {
 			reg = <0x0 0x100>;
 			enable-method = "psci";
 			capacity-dmips-mhz = <448>;
-			dynamic-power-coefficient = <205>;
+			dynamic-power-coefficient = <105>;
 			next-level-cache = <&L2_100>;
 			qcom,freq-domain = <&cpufreq_hw 0>;
 			#cooling-cells = <2>;
@@ -132,7 +132,7 @@ CPU2: cpu@200 {
 			reg = <0x0 0x200>;
 			enable-method = "psci";
 			capacity-dmips-mhz = <448>;
-			dynamic-power-coefficient = <205>;
+			dynamic-power-coefficient = <105>;
 			next-level-cache = <&L2_200>;
 			qcom,freq-domain = <&cpufreq_hw 0>;
 			#cooling-cells = <2>;
@@ -148,7 +148,7 @@ CPU3: cpu@300 {
 			reg = <0x0 0x300>;
 			enable-method = "psci";
 			capacity-dmips-mhz = <448>;
-			dynamic-power-coefficient = <205>;
+			dynamic-power-coefficient = <105>;
 			next-level-cache = <&L2_300>;
 			qcom,freq-domain = <&cpufreq_hw 0>;
 			#cooling-cells = <2>;
-- 
2.40.1



