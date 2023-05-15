Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45112FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD6DC433D2;
	Mon, 15 May 2023 17:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172220;
	bh=RQAyKoxJPXp2/5Zu2X3PvEEINs1sMUK/6e47PO81TjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Omt2TSeaLYMWgIiSJTZ6QCQ7eD2nDUp4pESuA5qJKxDYHOR1kDb9RbkbeG/p5gLj/
	 AuLNpEUQQ1qbXsDPCDsSL809135/axGA/NIpiEAalLq1M+wXqRhuk2YeV5g5zR6T62
	 DNh2ABG8um3K4BzVDYHMZo9N5iPTUrmdmuH0vEmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danny Lin <danny@kdrag0n.dev>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/381] arm64: dts: qcom: sdm845: correct dynamic power coefficients
Date: Mon, 15 May 2023 18:25:34 +0200
Message-Id: <20230515161740.558788935@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 0e0a8e35d72533b3eef3365e900baacd7cede8e2 ]

Following sm8150/sm8250 update sdm845 capacity-dmips-mhz and
dynamic-power-coefficient based on the measurements [1], [2].

The energy model dynamic-power-coefficient values were calculated with
    DPC = µW / MHz / V^2
for each OPP, and averaged across all OPPs within each cluster for the
final coefficient. Voltages were obtained from the qcom-cpufreq-hw
driver that reads voltages from the OSM LUT programmed into the SoC.

Normalized DMIPS/MHz capacity scale values for each CPU were calculated
from CoreMarks/MHz (CoreMark iterations per second per MHz), which
serves the same purpose. For each CPU, the final capacity-dmips-mhz
value is the C/MHz value of its maximum frequency normalized to
SCHED_CAPACITY_SCALE (1024) for the fastest CPU in the system.

For more details on measurement process see the commit message for the
commit 6aabed5526ee ("arm64: dts: qcom: sm8250: Add CPU capacities and
energy model").

[1] https://github.com/kdrag0n/freqbench
[2] https://github.com/kdrag0n/freqbench/tree/master/results/sdm845/main

Cc: Danny Lin <danny@kdrag0n.dev>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220315141104.730235-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 9beb3c34fcdb5..076b6949a0eed 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -196,8 +196,8 @@
 			cpu-idle-states = <&LITTLE_CPU_SLEEP_0
 					   &LITTLE_CPU_SLEEP_1
 					   &CLUSTER_SLEEP_0>;
-			capacity-dmips-mhz = <607>;
-			dynamic-power-coefficient = <100>;
+			capacity-dmips-mhz = <611>;
+			dynamic-power-coefficient = <290>;
 			qcom,freq-domain = <&cpufreq_hw 0>;
 			operating-points-v2 = <&cpu0_opp_table>;
 			interconnects = <&gladiator_noc MASTER_APPSS_PROC 3 &mem_noc SLAVE_EBI1 3>,
@@ -221,8 +221,8 @@
 			cpu-idle-states = <&LITTLE_CPU_SLEEP_0
 					   &LITTLE_CPU_SLEEP_1
 					   &CLUSTER_SLEEP_0>;
-			capacity-dmips-mhz = <607>;
-			dynamic-power-coefficient = <100>;
+			capacity-dmips-mhz = <611>;
+			dynamic-power-coefficient = <290>;
 			qcom,freq-domain = <&cpufreq_hw 0>;
 			operating-points-v2 = <&cpu0_opp_table>;
 			interconnects = <&gladiator_noc MASTER_APPSS_PROC 3 &mem_noc SLAVE_EBI1 3>,
@@ -243,8 +243,8 @@
 			cpu-idle-states = <&LITTLE_CPU_SLEEP_0
 					   &LITTLE_CPU_SLEEP_1
 					   &CLUSTER_SLEEP_0>;
-			capacity-dmips-mhz = <607>;
-			dynamic-power-coefficient = <100>;
+			capacity-dmips-mhz = <611>;
+			dynamic-power-coefficient = <290>;
 			qcom,freq-domain = <&cpufreq_hw 0>;
 			operating-points-v2 = <&cpu0_opp_table>;
 			interconnects = <&gladiator_noc MASTER_APPSS_PROC 3 &mem_noc SLAVE_EBI1 3>,
@@ -265,8 +265,8 @@
 			cpu-idle-states = <&LITTLE_CPU_SLEEP_0
 					   &LITTLE_CPU_SLEEP_1
 					   &CLUSTER_SLEEP_0>;
-			capacity-dmips-mhz = <607>;
-			dynamic-power-coefficient = <100>;
+			capacity-dmips-mhz = <611>;
+			dynamic-power-coefficient = <290>;
 			qcom,freq-domain = <&cpufreq_hw 0>;
 			operating-points-v2 = <&cpu0_opp_table>;
 			interconnects = <&gladiator_noc MASTER_APPSS_PROC 3 &mem_noc SLAVE_EBI1 3>,
@@ -288,7 +288,7 @@
 			cpu-idle-states = <&BIG_CPU_SLEEP_0
 					   &BIG_CPU_SLEEP_1
 					   &CLUSTER_SLEEP_0>;
-			dynamic-power-coefficient = <396>;
+			dynamic-power-coefficient = <442>;
 			qcom,freq-domain = <&cpufreq_hw 1>;
 			operating-points-v2 = <&cpu4_opp_table>;
 			interconnects = <&gladiator_noc MASTER_APPSS_PROC 3 &mem_noc SLAVE_EBI1 3>,
@@ -310,7 +310,7 @@
 			cpu-idle-states = <&BIG_CPU_SLEEP_0
 					   &BIG_CPU_SLEEP_1
 					   &CLUSTER_SLEEP_0>;
-			dynamic-power-coefficient = <396>;
+			dynamic-power-coefficient = <442>;
 			qcom,freq-domain = <&cpufreq_hw 1>;
 			operating-points-v2 = <&cpu4_opp_table>;
 			interconnects = <&gladiator_noc MASTER_APPSS_PROC 3 &mem_noc SLAVE_EBI1 3>,
@@ -332,7 +332,7 @@
 			cpu-idle-states = <&BIG_CPU_SLEEP_0
 					   &BIG_CPU_SLEEP_1
 					   &CLUSTER_SLEEP_0>;
-			dynamic-power-coefficient = <396>;
+			dynamic-power-coefficient = <442>;
 			qcom,freq-domain = <&cpufreq_hw 1>;
 			operating-points-v2 = <&cpu4_opp_table>;
 			interconnects = <&gladiator_noc MASTER_APPSS_PROC 3 &mem_noc SLAVE_EBI1 3>,
@@ -354,7 +354,7 @@
 			cpu-idle-states = <&BIG_CPU_SLEEP_0
 					   &BIG_CPU_SLEEP_1
 					   &CLUSTER_SLEEP_0>;
-			dynamic-power-coefficient = <396>;
+			dynamic-power-coefficient = <442>;
 			qcom,freq-domain = <&cpufreq_hw 1>;
 			operating-points-v2 = <&cpu4_opp_table>;
 			interconnects = <&gladiator_noc MASTER_APPSS_PROC 3 &mem_noc SLAVE_EBI1 3>,
-- 
2.39.2



