Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF047DF59;
	Wed, 20 May 2026 18:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302257; cv=none; b=d0qPUPP45Sept3ki9IHJi6MviGHZbncJOOQA2yIDtBW9a3fbSRoxkDGX6BNJngHeuZnscoLWVj0bWGVH0oagljoL/n30kv1jdqEDyvDbJYZo9uhYjrdF30QN3OTxmMJTzPxc02heArpxosZS93P5Cvnm/CiPZIxx8lTGk7pikUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302257; c=relaxed/simple;
	bh=54j1qpbVs9u2aUjhwX6ZF7SESM1FExfCj+bYuuDOwU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sA2wtfU+C5Dmpnk7lLMxtHrFrK5QV1IcnTXe3oqLzYnC/x6mlzotnJKtr8aZn50QydU3SUViBsp96UtvRTwjb83QvzF3lp0XkJXozCtHRugzaqmuupG6t6blihBKBAAuDH8SuAuAAY+14gQ1eaKItt6A+okgGl9ohAJf/ZSSAtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMhGBH6m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMhGBH6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184531F000E9;
	Wed, 20 May 2026 18:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302256;
	bh=S2asAyCDwdaOBo5S2tNKLGdmhdW1wGAR0KX05DpkwK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMhGBH6mWFv+sU6qAjX8sxjxX22T+EP/AqcS9p5MeovlC/6wZm0vgLtzn1nok4DzP
	 N26XIfoSiVRBo1nhjy5QLa/y4SxHMgFxNLaEuNIYZ1uw3a6s7qF6ngwSfUVb0UsbE+
	 1I1lshlKtGVR9pjZKV9fW9ZEsTUSXCL9wl+To2tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/508] arm64: dts: qcom: sm8550: Fix xo clock supply of platform SD host controller
Date: Wed, 20 May 2026 18:20:20 +0200
Message-ID: <20260520162102.904459617@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 30ac651c69bddbc83cab6d52fc5d2e03bed83282 ]

The expected frequency of SD host controller core supply clock is 19.2MHz,
while RPMH_CXO_CLK clock frequency on SM8650 platform is 38.4MHz.

Apparently the overclocked supply clock could be good enough on some
boards and even with the most of SD cards, however some low-end UHS-I
SD cards in SDR104 mode of the host controller produce I/O errors in
runtime, fortunately this problem is gone, if the "xo" clock frequency
matches the expected 19.2MHz clock rate.

Fixes: ffc50b2d3828 ("arm64: dts: qcom: Add base SM8550 dtsi")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20260314023715.357512-2-vladimir.zapolskiy@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index beab9fd10da87..3d14575e5aace 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -2521,7 +2521,7 @@ sdhc_2: mmc@8804000 {
 
 			clocks = <&gcc GCC_SDCC2_AHB_CLK>,
 				 <&gcc GCC_SDCC2_APPS_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>;
+				 <&bi_tcxo_div2>;
 			clock-names = "iface", "core", "xo";
 			iommus = <&apps_smmu 0x540 0>;
 			qcom,dll-config = <0x0007642c>;
-- 
2.53.0



