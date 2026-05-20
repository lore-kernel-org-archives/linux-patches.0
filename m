Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF76347514;
	Wed, 20 May 2026 18:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302255; cv=none; b=PZZsS7L1Enk4BCeOpyHPziG+mF+eSklXSpNd+pFCbmnHgT8BGlOS+3go+GTf1u/1FOyd//el/bSibXYK+sNo/olhr42X93xeLcdb5/ClPykNSU8Ep9frtOFpLZTOq+8rSb1gFTObD6ZqUjv+Xz4fyhNIcplCURbBCraIpJDj91I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302255; c=relaxed/simple;
	bh=b5aBCH2XDi3Muc5ljrLNu01rUr5EjYSh5h9hqEz3RuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwS34rEnbyLxx+aG3Pnboxi/ZnNjrTJx+NZcurlQwiASCFkZkCvI6+O/Nx1OdhA/w9+ujEOV2nc9dvDFpKnHWtJczLSJCbC78qvGVGqDtW1wP3prCpC9O++zY+9HYbGhND/AZeHDQt+vRtlkxrnPrH8SBx2F/0MA+PgtQby2Lss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xt+PpUgK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xt+PpUgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7370B1F000E9;
	Wed, 20 May 2026 18:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302253;
	bh=Pu2MxgPdCZD1r6JWd6cAiBxYEexwjSQzmFBnqupNuZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xt+PpUgKEbkdKJfzMHfJCswUpnD1FLr6nPIdv+OyVrEEVmGRN0qGS7QdcPiLlcPhM
	 UeSEjAD4IGmD3vegZPGAd2EyDQ2B12Xlnac6/ILEyrmSfWXwZjCeMQtJacwJfDbvYK
	 YACIZsFBPDVp736KjVUSAyGR0te1UK+gGeyY3y2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/508] arm64: dts: qcom: sm8550: Fix GIC_ITS range length
Date: Wed, 20 May 2026 18:20:19 +0200
Message-ID: <20260520162102.883147479@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 357c559e386705609b6b9dc0544c420e3f91f3a0 ]

Currently, the GITS_SGIR register is cut off. Fix it up.

Fixes: ffc50b2d3828 ("arm64: dts: qcom: Add base SM8550 dtsi")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260317-topic-its_range_fixup-v1-4-49be8076adb1@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 2f0f1c2ab7391..beab9fd10da87 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -3830,7 +3830,7 @@ intc: interrupt-controller@17100000 {
 
 			gic_its: msi-controller@17140000 {
 				compatible = "arm,gic-v3-its";
-				reg = <0 0x17140000 0 0x20000>;
+				reg = <0 0x17140000 0 0x40000>;
 				msi-controller;
 				#msi-cells = <1>;
 			};
-- 
2.53.0



