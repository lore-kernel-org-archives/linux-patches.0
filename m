Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024718;
	b=m98WXPPLmRUi7Kzc46r8dP2oqr17g/NvkL6WONHKY1NSV34Nw0NC4Mcgh87Hi1kVr8qi
	 /WRakCOkfci1+B+PZF0qjgW9fNS2tgn30v9KjHvVpFZNTGg0AHkq2/U9GxobnoySypjKr
	 1c3ImxRnLagW3t03cSG8omF5aj2yNW30GIQh8yviqrIYFOKKl8TQBzfYEg1bzL4TgoVvB
	 O2nJUaXbob0MsIqE2RkTDbJcRFwyn+CC/CH7yzKEVzb+QgkdiwFe3SDBjwps7eScaRvcY
	 pcheioWXtBWg2XR3GpyJgmzBXdSdeDbpa0LuOxiW9brXieRLRFlAj7lv8HMH0S3c5nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hRT1PY2/XkYzJi9VwBNN2SZiBWRh2m8LyOpdfMk/E18=;
	b=Foz54wl3WpVHVJx8kIjtv19OOwH2Zd0Phifyc3RD2BbbrdDouAz181A3sLedLMtEq8ox
	 NTl1l9NjBW6GxupbEnzKPcD6c2BOToDzH/gqYTQn64vl3/23APcIFnw05yvj4cm23g7wj
	 IRozLJrfL29E37JW0JWBIOv1da2yd53jDkM9IHb/I4hjtulKlZtWHIhOocK2oCxsZ8gMo
	 LOPch34PStnmRgCYZMGjhIOfU6PAHqhC0M1vWyCjdCm0x/LxzvrwqIdAoSEY8saewrSAG
	 V/Q/mRF440YPGFmtJKvGKJU9akr4C9Ur5G5a/yTs7ZWekB/1qcqZaMq3Iy0JzeZSXxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ERfW90h1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1550606A32A;
	Wed, 18 Nov 2026 17:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ERfW90h1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A311F000C4;
	Wed, 18 Nov 2026 17:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024718;
	bh=hRT1PY2/XkYzJi9VwBNN2SZiBWRh2m8LyOpdfMk/E18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERfW90h1IO9Od7gX55BfPWqV/yfM11MnTiqnLq2G2VTcJ39rpye8vBF0Hwp46jzwF
	 0opukFwovxHwb24Rz+60H8syxZwVH0yAYsDe9lczDnONxARLuq5Ksw1CSpZhJ2kqDk
	 yJR83yPDd7iS90wJRf+l399aTqoDtRC/54/2vaAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0784/2151] arm64: dts: qcom: sm8150: Use SM8150_CX for the SDHC power domain
Date: Wed, 18 Nov 2026 15:41:59 +0100
Message-ID: <20261118150150.665418623@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 475aab59d9870d250f521e202d191899c50a3ded ]

Replace the raw power-domain index of SDHC2 with the SM8150_CX binding
constant, which is the correct power domain in this case.

Fixes: 876644c76034 ("arm64: dts: qcom: sm8150: Add support for SDC2")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260914-qcom-tie-cx-to-gcc-v4-0-9d5a606ada33@oss.qualcomm.com?part=45
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-dts-qcom-sm8150-sdhc-use-mss-for-pd-index-v2-1-a8610199483d@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index e1f480e3ed0b7..f3b67175777db 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3559,7 +3559,7 @@ sdhc_2: mmc@8804000 {
 			iommus = <&apps_smmu 0x6a0 0x0>;
 			qcom,dll-config = <0x0007642c>;
 			qcom,ddr-config = <0x80040868>;
-			power-domains = <&rpmhpd 0>;
+			power-domains = <&rpmhpd SM8150_CX>;
 			operating-points-v2 = <&sdhc2_opp_table>;
 
 			status = "disabled";
-- 
2.53.0



