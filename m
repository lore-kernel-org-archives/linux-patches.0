Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030196;
	b=BuFP5f9YzOCFDPxqsi32yu/8j2lDNHPeRjFVmH966R2x/zFK4AIacaQ1bCWODw4mt8zh
	 TNUqLE4l9S+yZ4gSvLPG88fueKQOBfnn/1sIu3xCi6De/nEIdABy2iZB1ZSRmF5RS6gu1
	 HvTJGRgi2pMN0gqAN9YQIJOVkM5oAvrXVD7DjxfBcZrA7IZggXTZMLkPzjtGHr+J4vk8e
	 AcYNc0lbAZNU4phuL8KnRu3vIaqtvzc3RhqRMiOKZZsBy6c9AYTmK6dUsZgLARqbzkPNY
	 t7wYWFgkEFQFvqlKyG92J01jqIHfeyVwXZJc+RAH7kGQPnUJ0RtT8eFZ3R4FS3pB0ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XH0++tdVvXpCYP20ivNUcQtgueGfc7pcKc7o+DALCMA=;
	b=yTadK+gX6gINj3IIZTpWZxc4SJVHYddtQaHuiPb1eF18p18JxsYrcwNBRfOH/QQOD0T3
	 h9dqejXNoIhIqu0JnZiX/7bWnMK4Rn/Ok5d31UXnJ5GSmA2/B+90HLV4j0LCiE/yZKDtc
	 Rlq7r0pXBzLuSf18B+HM2X2A5866EVhzRql0mJHo1KOW9MElsSDMdt613FlrPigNVrhTo
	 daVPzqLpuvbZQjiAPFoY3FBWrAdiQKo3cQwY/RWnwiwFBHC7CzXuiFFl6xz+7yzfZdIHS
	 eGm67P5ThBCd1d/l+wWbjZDnHIF5ezmMr1zdVRLepSkG84Hh/yeAp85ZGmgeD3p6zZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gd12uVlh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DC2606D35D;
	Wed, 18 Nov 2026 19:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gd12uVlh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E401F000C4;
	Wed, 18 Nov 2026 19:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030196;
	bh=XH0++tdVvXpCYP20ivNUcQtgueGfc7pcKc7o+DALCMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gd12uVlhjlXL7v6SoJbmqUrnKkFsieS4ja3WHEavkn1j0f4JyRdTK4RrHjPaYCHFB
	 +8AiIV0r0BY3owmnLEmr6SVwi1TffbpWSx9WnEsRQbNSuDOCxI77G7S/329o3ZEBK+
	 yWPiYekFPImvt6K9/29xBhk2lDX0G2ScWBb/oYWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0620/1756] arm64: dts: qcom: sm8150: Use SM8150_CX for the SDHC power domain
Date: Wed, 18 Nov 2026 15:45:47 +0100
Message-ID: <20261118150033.591594683@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0aeceffd872c0..e52c1a4677946 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3562,7 +3562,7 @@ sdhc_2: mmc@8804000 {
 			iommus = <&apps_smmu 0x6a0 0x0>;
 			qcom,dll-config = <0x0007642c>;
 			qcom,ddr-config = <0x80040868>;
-			power-domains = <&rpmhpd 0>;
+			power-domains = <&rpmhpd SM8150_CX>;
 			operating-points-v2 = <&sdhc2_opp_table>;
 
 			status = "disabled";
-- 
2.53.0



