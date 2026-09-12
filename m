Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB41331A6E;
	Sat, 12 Sep 2026 18:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238785; cv=none; b=HcedE+VvizimBsy9A5NY8PteSZ2GL4AatrRrVIijQuHy2QecP57+Ie17J+l+h6vsL7DA+rC/kU5mRsP+NMwg947Y3bgjTfvvVujh9zeR9zq/wcWEA2dqH8mIa7zwW/d6xtTjbK25SUazUdxhorTo6Yzvh/+IAti7M5n5DocJQw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238785; c=relaxed/simple;
	bh=J9tanByR5XEH85LSc9/Q4eKqVxPsJWGifW/Ek09O0Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNa1LFqHZieuM0HbG9D9BXBolHuF7dKSTeup+rC33zgnf1vAGNvEKKwtyfsbDnwzX7/Q7XhB8mE6AHxGqFJLe+cIb62641pl7PUthC9hzuKlQG1brWCQsBPEI7EvDf0XhnJVEKa26yaWeOw/84lVomgBKvMlZUmX9bsJKaUz5Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uX2jh0gh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uX2jh0gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EC41F000FF;
	Sat, 12 Sep 2026 18:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238783;
	bh=DX0172Vg+HHJFKsqPW3ijrZ9h9FSCLvoh1Tnc5zgEEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uX2jh0ghnZYeqgMG49y7qLD6tpLp1RnfZxOxM7foj0kF7iD40ntvUTbxGyLrwuNR0
	 RMCAr7s1JQn8lIfBHo4SAaRbUYco2sglle3ERG3s0e4X9Fc9cK4IkHniYGYh+oP/MD
	 Y4F+m3pGNUZqVEGh0Kj6Kd+LDL14RpBWic5q5roU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <sibis@codeaurora.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 530/935] arm64: dts: qcom: sm8250: Use QMP property to control load state
Date: Sat, 12 Sep 2026 08:59:20 +0200
Message-ID: <20260912065538.977626821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Sibi Sankar <sibis@codeaurora.org>

[ Upstream commit b74ee2d71be84837648695465ce81dfb44420b7b ]

Use the Qualcomm Mailbox Protocol (QMP) property to control the load
state resources on SM8250 SoCs and drop deprecated power-domains exposed
by AOSS QMP node.

Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1631800770-371-10-git-send-email-sibis@codeaurora.org
Stable-dep-of: d5c8efda722e ("arm64: dts: qcom: sm8250: sort out Iris power domains")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index bf91e0acd435f..735dca94e20b8 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -13,7 +13,6 @@
 #include <dt-bindings/interconnect/qcom,osm-l3.h>
 #include <dt-bindings/interconnect/qcom,sm8250.h>
 #include <dt-bindings/mailbox/qcom-ipcc.h>
-#include <dt-bindings/power/qcom-aoss-qmp.h>
 #include <dt-bindings/power/qcom-rpmpd.h>
 #include <dt-bindings/soc/qcom,apr.h>
 #include <dt-bindings/soc/qcom,rpmh-rsc.h>
@@ -2099,13 +2098,14 @@ slpi: remoteproc@5c00000 {
 			clocks = <&rpmhcc RPMH_CXO_CLK>;
 			clock-names = "xo";
 
-			power-domains = <&aoss_qmp AOSS_QMP_LS_SLPI>,
-					<&rpmhpd SM8250_LCX>,
+			power-domains = <&rpmhpd SM8250_LCX>,
 					<&rpmhpd SM8250_LMX>;
-			power-domain-names = "load_state", "lcx", "lmx";
+			power-domain-names = "lcx", "lmx";
 
 			memory-region = <&slpi_mem>;
 
+			qcom,qmp = <&aoss_qmp>;
+
 			qcom,smem-states = <&smp2p_slpi_out 0>;
 			qcom,smem-state-names = "stop";
 
@@ -2165,12 +2165,12 @@ cdsp: remoteproc@8300000 {
 			clocks = <&rpmhcc RPMH_CXO_CLK>;
 			clock-names = "xo";
 
-			power-domains = <&aoss_qmp AOSS_QMP_LS_CDSP>,
-					<&rpmhpd SM8250_CX>;
-			power-domain-names = "load_state", "cx";
+			power-domains = <&rpmhpd SM8250_CX>;
 
 			memory-region = <&cdsp_mem>;
 
+			qcom,qmp = <&aoss_qmp>;
+
 			qcom,smem-states = <&smp2p_cdsp_out 0>;
 			qcom,smem-state-names = "stop";
 
@@ -2915,7 +2915,6 @@ IPCC_MPROC_SIGNAL_GLINK_QMP
 					IPCC_MPROC_SIGNAL_GLINK_QMP>;
 
 			#clock-cells = <0>;
-			#power-domain-cells = <1>;
 		};
 
 		spmi_bus: spmi@c440000 {
@@ -3832,13 +3831,14 @@ adsp: remoteproc@17300000 {
 			clocks = <&rpmhcc RPMH_CXO_CLK>;
 			clock-names = "xo";
 
-			power-domains = <&aoss_qmp AOSS_QMP_LS_LPASS>,
-					<&rpmhpd SM8250_LCX>,
+			power-domains = <&rpmhpd SM8250_LCX>,
 					<&rpmhpd SM8250_LMX>;
-			power-domain-names = "load_state", "lcx", "lmx";
+			power-domain-names = "lcx", "lmx";
 
 			memory-region = <&adsp_mem>;
 
+			qcom,qmp = <&aoss_qmp>;
+
 			qcom,smem-states = <&smp2p_adsp_out 0>;
 			qcom,smem-state-names = "stop";
 
-- 
2.53.0



