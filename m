Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93BB29D26E;
	Wed, 20 May 2026 17:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298521; cv=none; b=YNSKyfZ6TU+9N3LVOY7HIFuyCUL+uXme4kHHNzK8H8CtqBzDlrdF6vjB6bK3h9yTTAtn7Yxegcj8U/3jAAGNtTlX4Vyc3vZaMoi5q4nWt/TXAxCfBdMys861ZXxKOS4UZSZgh57NQCo41TkeHe6XbRu8PyMBd9Qpr2vjHifqN9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298521; c=relaxed/simple;
	bh=NjThOIlmbZbtqkKja9ZA6tVaRMuML9hOobjT1Idj6lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBTwcveAP12mxerq8x+mbogrPZR8xsgRvuyOojzV9FSeN7KCA+i4Q8rd4apkLpnjvTogVTzIGlvwGiD3DiAUv1tZ1z9cP6ejsfRsB/WlEVMzBnev6Kh20BN+jD3cng+bYAbdTxO6EQEWGXoxIWkGwGv3bwRmX7U8bLGOMe42nvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVuMf+ci; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVuMf+ci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314F01F000E9;
	Wed, 20 May 2026 17:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298520;
	bh=71iTSvr0Ho/Xr/HdGJaQdGdbmMKM+b7N7zdWVCap2uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QVuMf+ciRHBbWhEVp3GeL/8GNQoht7Nqv/T+fVyS26hmxy8kAz/2+tipG3CknS943
	 PVMTrubhsoi/V46e69F2r+YVJFWo96ONBbhI/kI3Ucen6Qv17cn1gk4grk6PyCLnrc
	 wC2FY7hRFh1mDCFbtDx640qb/deFv6pV41rP4vnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 401/957] arm64: dts: qcom: sm8550: Fix GIC_ITS range length
Date: Wed, 20 May 2026 18:14:44 +0200
Message-ID: <20260520162143.221009716@linuxfoundation.org>
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
index 63e17c3014061..c9a781273e842 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -5094,7 +5094,7 @@ ppi_cluster3: interrupt-partition-3 {
 
 			gic_its: msi-controller@17140000 {
 				compatible = "arm,gic-v3-its";
-				reg = <0 0x17140000 0 0x20000>;
+				reg = <0 0x17140000 0 0x40000>;
 				msi-controller;
 				#msi-cells = <1>;
 			};
-- 
2.53.0



