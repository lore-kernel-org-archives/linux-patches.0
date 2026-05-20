Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245A53B0AD6;
	Wed, 20 May 2026 17:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298519; cv=none; b=sSZtR20lBo5NmHQTMT8jABF73ActlGlpweWvjQ8yyjiJzwy6MAVHFrXjZxjhLo0u5CRyUCVdxjPNvIVscc5cIXTAK7ShvLk/gsE3Bvp5yXewdOusIxLay27Mx+JxZlCXnDJ/BUT6pJzKdpyRLNyaJYRecewaTxbvi42BlRhfOII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298519; c=relaxed/simple;
	bh=YkUf8r+h1G/GJdL40pSgODggFAiVQZT7Nso8cWFbtWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9Dff5wIP5DvdsJLOQO+8dwnNvZuNnWAPYY9K4F5AeMTRr4jH6sEBKjlSoaA1D09bDCSy1/MXC8v7tjdc7Edj+gIzPkY8uOOcUs6LqakrJHYPBsm3g0X4u+grex95b0OonvGtjbuojcVVkiLenfOK2OGZbZoR/a/i71D87/MHcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDC57oGt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDC57oGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CE61F000E9;
	Wed, 20 May 2026 17:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298518;
	bh=IbQeBOAXMrRPFuj3n59g7tJA+4Qh1GBMJ2BxTL0ELIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDC57oGtVEFfyo69kXNv8MADWbDexJfXZOgeK3wIvIuhYyF3VsIoYvXh8t1joXiNY
	 hhGLtmMQI2ZrKVcBLfod+gNKDMLR2QIb3lu3R+sYHsKSYi2lyIm82A1gdee2ZfTAgU
	 PPAZBPdr2eE/dEOKawKluUel39m0iP2o8cdTlwbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 400/957] arm64: dts: qcom: sm8450: Fix GIC_ITS range length
Date: Wed, 20 May 2026 18:14:43 +0200
Message-ID: <20260520162143.199937758@linuxfoundation.org>
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

[ Upstream commit 14044fa192c50265bc1f636108371044bbdcf7b7 ]

Currently, the GITS_SGIR register is cut off. Fix it up.

Fixes: fc8b0b9b630d ("arm64: dts: qcom: sm8450 add ITS device tree node")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260317-topic-its_range_fixup-v1-3-49be8076adb1@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 23420e6924728..68f5e7bca7cde 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -5079,7 +5079,7 @@ intc: interrupt-controller@17100000 {
 
 			gic_its: msi-controller@17140000 {
 				compatible = "arm,gic-v3-its";
-				reg = <0x0 0x17140000 0x0 0x20000>;
+				reg = <0x0 0x17140000 0x0 0x40000>;
 				msi-controller;
 				#msi-cells = <1>;
 			};
-- 
2.53.0



