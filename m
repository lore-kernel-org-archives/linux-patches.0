Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74BA4B5D7;
	Sat,  3 Feb 2024 04:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933771; cv=none; b=cqYYRK2lpHl80F47tWFk0TLPxnilubnX+Uu1wYOG30JMNC4+U2UpjQEtdGQrNeU4qORSNzcvL3v8o2sZKgJAhnTw88jgzyU/vB62sF+zNYprlzzlsqa1PEpqSDf0/SQD256dMRJcQfz1b5piUTM/vlHlRYQpcfKtJx4HJ7x6ZeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933771; c=relaxed/simple;
	bh=cV4d+rH3Yv0TlsAAMg+squZ4G2EcGPwKuNoA35lu/rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5gAeLFNzZxg4jRDqe2O3IvWM47ifD9mn9IOO5ROfRocsxn4O/VXKUw/WP/yrpjejfiB/jDMgOxZuJMfDM5I2vBqAzgZT6kun4awpNhbl5i3Dkn3NeGzIo4Z/qhYXMXJZMCHs/VoE4CwTCrxsaCFXNYxopROBzPSFdbHFGR7ezk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ca7eD+d9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ca7eD+d9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E54BC433F1;
	Sat,  3 Feb 2024 04:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933771;
	bh=cV4d+rH3Yv0TlsAAMg+squZ4G2EcGPwKuNoA35lu/rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ca7eD+d9YG11xg+o1JyWBlIMCjSCMW+TVUJA8umzrFZyGxwdg/A7t1oWqRLdvqczt
	 bqfh4fxg5mBTFffvLAz9iGZG4O2mAF8MHROPGLiwHtKfZNEAtZBRh/GHQ+pCtw8szo
	 HcehbrIMsggxcebv6SmJB5tB1UwRwN1IShpLsXG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 074/353] ARM: dts: qcom: msm8960: fix PMIC node labels
Date: Fri,  2 Feb 2024 20:03:12 -0800
Message-ID: <20240203035406.166770545@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a10a09f34eb80b83ca7275e23bf982dae2aa7632 ]

Change PM8921 node labels to start with pm8921_ prefix, following other
Qualcomm PMIC device nodes.

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230928110309.1212221-12-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom/qcom-msm8960.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/qcom/qcom-msm8960.dtsi b/arch/arm/boot/dts/qcom/qcom-msm8960.dtsi
index d13080fcbeea..9099b858a76f 100644
--- a/arch/arm/boot/dts/qcom/qcom-msm8960.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-msm8960.dtsi
@@ -264,7 +264,7 @@
 			reg = <0x500000 0x1000>;
 			qcom,controller-type = "pmic-arbiter";
 
-			pmicintc: pmic {
+			pm8921: pmic {
 				compatible = "qcom,pm8921";
 				interrupt-parent = <&msmgpio>;
 				interrupts = <104 IRQ_TYPE_LEVEL_LOW>;
@@ -276,7 +276,7 @@
 				pwrkey@1c {
 					compatible = "qcom,pm8921-pwrkey";
 					reg = <0x1c>;
-					interrupt-parent = <&pmicintc>;
+					interrupt-parent = <&pm8921>;
 					interrupts = <50 IRQ_TYPE_EDGE_RISING>,
 						     <51 IRQ_TYPE_EDGE_RISING>;
 					debounce = <15625>;
@@ -286,7 +286,7 @@
 				keypad@148 {
 					compatible = "qcom,pm8921-keypad";
 					reg = <0x148>;
-					interrupt-parent = <&pmicintc>;
+					interrupt-parent = <&pm8921>;
 					interrupts = <74 IRQ_TYPE_EDGE_RISING>,
 						     <75 IRQ_TYPE_EDGE_RISING>;
 					debounce = <15>;
@@ -296,7 +296,7 @@
 
 				rtc@11d {
 					compatible = "qcom,pm8921-rtc";
-					interrupt-parent = <&pmicintc>;
+					interrupt-parent = <&pm8921>;
 					interrupts = <39 IRQ_TYPE_EDGE_RISING>;
 					reg = <0x11d>;
 					allow-set-time;
-- 
2.43.0



