Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024531;
	b=3DHdOqM7FMapm3m5jTThgvttlqo5AfSDu84C63rz0fpSn96rGdBi9/5QQB/zR603o/zN
	 iDb8Em6SdsZjZEv+0CGbCOOBwWVkWHrEcgXAsEb0ICpBUC55tZ6VMSr2XEwxXOV6LyCPH
	 IixPNDI5+YgB45hE9TpN1r3BMOim5xGv4B2XBPTc09rpUa226zLhRIAYjOkvKouUjhPI7
	 hmtfqKq2SOaVfSEuFnz/RcHKTD4uz1I9WFJ2z6rKmbn9u84r3AlvKD+PnUO9vhFNCsF9r
	 UL+soFTTcPtiTOJ7JOgO/0izRb8Hcoy7yxz3OF4CDEODqglYK0XTa/TuEEskXm4JWIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Tuvdrw17ak2K/srn5ei8/DxTO7MA0FJkBfnIRpbuNA=;
	b=jFe6We1CEqsHuePNDnM375G4UJTliQMsl6sEdUoAY+cYeujfDQezGxzVKTJ3ok8sXnzb
	 4Y0Znykh+tkW/hV9uzNPy/kF+f7TNYRhS4kDdJFOs8RzpiVGmcsp1GeSozxzz0hILiGEO
	 J+qksAbbf5n4/fUAfbrkxOJ3QtFWhEGBXm8kMRMARJARlk5tZa2kLne4IMn8yhTQ9DfGB
	 91dkNMRlkTPQAdAEGTh5dPv+zLf9lagTaLZE8Gq6NgtRNtOxgNgsOh2/+SCIduj2sel/J
	 5QqQDmLqQ2ZTVoACnsl+5z3ZaMvxLO5Ltj1ghBc5s01VNBUYG6Cr2lGx2gYAarFhjKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eDPqqgfL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30AF606A333;
	Wed, 18 Nov 2026 17:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eDPqqgfL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672681F000C6;
	Wed, 18 Nov 2026 17:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024530;
	bh=6Tuvdrw17ak2K/srn5ei8/DxTO7MA0FJkBfnIRpbuNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDPqqgfLi1J4yi3akzrVAwuu5TU1vvWT6VTecAJkZuai9YY7+HBn6MghlWfkoaE/M
	 O91qEno/OyHpccwhi73QsHJdO59Ksvz8q1QRq4RH8eD0eFAx8CLNmADSjjutGAPNnY
	 ZWxDsga7GoPrPUcj0e57zBnMraLeo4ICmUXNQy2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0758/2151] ARM: dts: qcom: msm8974: add MDSS reset
Date: Wed, 18 Nov 2026 15:41:33 +0100
Message-ID: <20261118150149.656619678@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 542991a1d77e5fea5263c2406773a0cd09a8ec48 ]

Commit 13a4b7fb6260 ("pmdomain: core: Leave powered-on genpds on until
late_initcall_sync") kept power-domains on longer during boot which is
causing DSI clock to get stuck and fail to acquire its configuration on
DSI bringup. Follow the example of other platforms and add MDSS reset to
the display subsystem node, fixing DSI issues.

Fixes: 5a9fc531f6ec ("ARM: dts: msm8974: add display support")
Suggested-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260810-msm8974-mmcc-fix-v2-1-5c787d79c0fa@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom/qcom-msm8974.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
index 8459a840d9ffe..8212eb0513e61 100644
--- a/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
@@ -9,6 +9,7 @@
 #include <dt-bindings/interconnect/qcom,msm8974.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/reset/qcom,gcc-msm8974.h>
+#include <dt-bindings/reset/qcom,mmcc-msm8974.h>
 
 / {
 	#address-cells = <1>;
@@ -1910,6 +1911,8 @@ mdss: display-subsystem@fd900000 {
 			interrupt-controller;
 			#interrupt-cells = <1>;
 
+			resets = <&mmcc MDSS_RESET>;
+
 			status = "disabled";
 
 			#address-cells = <1>;
-- 
2.53.0



