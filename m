Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916B1366075;
	Wed, 20 May 2026 17:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298424; cv=none; b=fX4NfHbuVrIPYApKwlB/vdzlKW4vEPBt6IUrnT+hPbSQuWXIPaP97v7WdsumGnVyU39aHZcZPmdQ/m3/A36/XCCT4uxhR9WhOW3VNVnLqFDpXnRmCbhyz6Y4pMTBtsq21a+X6X6Yni3/lodResrLpf4iTrJvudb+PZ9AUPhdytU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298424; c=relaxed/simple;
	bh=B/hdV2sW0TDnnsFRxdbA/kGkKqDyoFKDmv2d2A8aDys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxNkoQnr6al4lH/BkynfvffVrvfxjv+536yK+cbhZZza/X6wjBkshiarySTIysMThDqt9/9TeYD3UI4Iswpl6/BDl0oik4dRTu4xG7ezadifReNDMXLDpwpDLHVWo/TiBv+ixXQoNckrhymZjKcMjfkD5oBwQ3kVjs3uHIReeps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wR1xj9o3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wR1xj9o3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039D21F000E9;
	Wed, 20 May 2026 17:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298423;
	bh=fu1lAJehUQ6nuMMKdOORd0BW2BQuEJIcEhFPAH4lDL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wR1xj9o3ywcuQOlxm1UUCQRXMoSj4S71sXbKTcQ3+ebJcAhhc1ysOmW3t4jxCuX/n
	 CTHZhznG0ycvma3VAsVTKC0yIW3MvUCuVrXmH5jD3vz2Rsxoifha7w49ATOomDgUcx
	 foc1zjVHVv3Zec1OScMSVZSpSzd0Cy2HfZc+g5K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 406/957] arm64: dts: qcom: hamoa: Fix xo clock supply of platform SD host controller
Date: Wed, 20 May 2026 18:14:49 +0200
Message-ID: <20260520162143.329415977@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit d094f79960e1da20c1380083c95945371baa3668 ]

The expected frequency of SD host controller core supply clock is 19.2MHz,
while RPMH_CXO_CLK clock frequency on SM8650 platform is 38.4MHz.

Apparently the overclocked supply clock could be good enough on some
boards and even with the most of SD cards, however some low-end UHS-I
SD cards in SDR104 mode of the host controller produce I/O errors in
runtime, fortunately this problem is gone, if the "xo" clock frequency
matches the expected 19.2MHz clock rate.

Fixes: ffb21c1e19b1 ("arm64: dts: qcom: x1e80100: Describe the SDHC controllers")
Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20260314023715.357512-4-vladimir.zapolskiy@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index 66c31c1799421..ee9c12600f95a 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -4579,7 +4579,7 @@ sdhc_2: mmc@8804000 {
 
 			clocks = <&gcc GCC_SDCC2_AHB_CLK>,
 				 <&gcc GCC_SDCC2_APPS_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>;
+				 <&bi_tcxo_div2>;
 			clock-names = "iface", "core", "xo";
 			iommus = <&apps_smmu 0x520 0>;
 			qcom,dll-config = <0x0007642c>;
@@ -4632,7 +4632,7 @@ sdhc_4: mmc@8844000 {
 
 			clocks = <&gcc GCC_SDCC4_AHB_CLK>,
 				 <&gcc GCC_SDCC4_APPS_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>;
+				 <&bi_tcxo_div2>;
 			clock-names = "iface", "core", "xo";
 			iommus = <&apps_smmu 0x160 0>;
 			qcom,dll-config = <0x0007642c>;
-- 
2.53.0



