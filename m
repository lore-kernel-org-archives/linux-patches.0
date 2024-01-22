Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F9115443C;
	Tue, 23 Jan 2024 00:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969373; cv=none; b=agP+1FkpMxcN2/FjxaNzBx2+QHokQ72O6+dci9qosL3XZXhI469OYpqW0WXA118agazCQN3wGFUYp7XJzIL5jJMlXb2tiS3qIVt6E56PXatSoTVnvEihemhbKQGxTM5OCiyC/de7B0gjVXwqov44vaMR1uHZDROu3u+raTNYDsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969373; c=relaxed/simple;
	bh=QyrfuBdgTkYJGn/CX/c5z/hEAzYTDuxh108kwyaGUhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iaer7+4jPsEctaevkJwuTm9FQlzVsoGyiwC69hkYSgL/Af5Yv+XoODl5/CYCo0XBYKRS0F14ELb7kyvk9GjqwCC7LwYF4WpwMEoqdClgebLTGrdm232hzRkBoLhXP2ywStNBJS61KmfP1xtJRXiJESuMmpawxV/JyABa0pM/0Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7ePHbvN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7ePHbvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFE5C43394;
	Tue, 23 Jan 2024 00:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969373;
	bh=QyrfuBdgTkYJGn/CX/c5z/hEAzYTDuxh108kwyaGUhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7ePHbvNBLj+DH8KJjfxgNd1ALMela7qduM5YuSfkDuKg3XwGrI4PaIlyfCKavKJE
	 QA3RHrQQkTfLCY+ul0AuyiiKPWEkP/n0gt2DQXYApinKMOk2zyB7ZytoXWD48+u7M6
	 CF0n0eJOmRN4KAbRxHQ/VPu2p9zeXoMSTa+CCo1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 203/641] arm64: dts: qcom: sm8550: Update idle state time requirements
Date: Mon, 22 Jan 2024 15:51:47 -0800
Message-ID: <20240122235824.309073526@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit ad6556fb45d4ab91ad786a2025cbe2b0f2e6cf77 ]

The idle state entry/exit/residency times differ from what shipped on
production devices, mostly being overly optimistic in entry times and
overly pessimistic in minimal residency times. Align them with
downstream sources.

Fixes: ffc50b2d3828 ("arm64: dts: qcom: Add base SM8550 dtsi")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231218-topic-8550_fixes-v1-12-ce1272d77540@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index a3aba04e4c4a..5cf813a579d5 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -285,9 +285,9 @@ LITTLE_CPU_SLEEP_0: cpu-sleep-0-0 {
 				compatible = "arm,idle-state";
 				idle-state-name = "silver-rail-power-collapse";
 				arm,psci-suspend-param = <0x40000004>;
-				entry-latency-us = <800>;
+				entry-latency-us = <550>;
 				exit-latency-us = <750>;
-				min-residency-us = <4090>;
+				min-residency-us = <6700>;
 				local-timer-stop;
 			};
 
@@ -296,8 +296,8 @@ BIG_CPU_SLEEP_0: cpu-sleep-1-0 {
 				idle-state-name = "gold-rail-power-collapse";
 				arm,psci-suspend-param = <0x40000004>;
 				entry-latency-us = <600>;
-				exit-latency-us = <1550>;
-				min-residency-us = <4791>;
+				exit-latency-us = <1300>;
+				min-residency-us = <8136>;
 				local-timer-stop;
 			};
 
@@ -316,17 +316,17 @@ domain-idle-states {
 			CLUSTER_SLEEP_0: cluster-sleep-0 {
 				compatible = "domain-idle-state";
 				arm,psci-suspend-param = <0x41000044>;
-				entry-latency-us = <1050>;
-				exit-latency-us = <2500>;
-				min-residency-us = <5309>;
+				entry-latency-us = <750>;
+				exit-latency-us = <2350>;
+				min-residency-us = <9144>;
 			};
 
 			CLUSTER_SLEEP_1: cluster-sleep-1 {
 				compatible = "domain-idle-state";
 				arm,psci-suspend-param = <0x4100c344>;
-				entry-latency-us = <2700>;
-				exit-latency-us = <3500>;
-				min-residency-us = <13959>;
+				entry-latency-us = <2800>;
+				exit-latency-us = <4400>;
+				min-residency-us = <10150>;
 			};
 		};
 	};
-- 
2.43.0



