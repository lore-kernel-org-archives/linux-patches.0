Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015323;
	b=kKk6I4YL0agHU59HiwXqmvQDoThKireDpS2zxIWWrgLjPob3gDjKM06dWzoJr4TiG1rD
	 KyrFGJ7me4v60r3FqPg9yghf1JsKo4oYRGtcBvT7LnnDYou3qGzR0L2MNUELaChA0Zkp9
	 vVOOYx9rW9vw7lbbWM1nQKmQBZVuUulOc+bfydU35xkD7BmYtfF2Q9TXcUQIWv3po5CJS
	 Xus26b4/2DnNubeukKzm9CGI1yrU1zNfoY6jyNpzvYs6DeVrrhUZBpfCnqR4DMGYTEHSZ
	 sDZeChm6cJi1C4hgDf/I7NerGGOqNY0WI/PtJH/4r70zzNZ802bJcikthLnxv3r7FfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SUa1O0y8+iGvgZz5lu2Z90vChthGQfBM71bElSVQbhk=;
	b=CDZTLarC9FPaZgvRhRva6CB6+yitw6WrUUp/y01/lOdFyRYieTSBGACds9oRh9z9TTqI
	 4uADVOsU3bGJzUzkdJrrsr3DS9/8UhGCdNZXP1oGcRSTN4AqMrnnj1vq60PadaTrc/SdK
	 X37hk61MKyQ++YsSVioCFrffCFHPjUQI6ALxthHsMm5Pm79UT7FACkrdHIQTNC94wqtAY
	 /3rxZE2qt8u3VHjrWXm135e4bGL97l7nNFy9kfOBG9Tbp0yIAMAnpNmzvsInBEhOwmaNx
	 ABrlZ0NdQ4nTbmronnCAW1LbtALH5tADxzgxSIQz5YSzJMeA/pa+ahBN4LhDUwjdMTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uVSlSA94;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37386606A31C;
	Wed, 18 Nov 2026 15:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uVSlSA94
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2A71F000C4;
	Wed, 18 Nov 2026 15:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015322;
	bh=SUa1O0y8+iGvgZz5lu2Z90vChthGQfBM71bElSVQbhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uVSlSA94k0bFEwQ8gGpAfYkWMGV52BDtiiaeNV2LlW/tzSUOIM87Lq1VP+xnRAXYC
	 MEyIzrh9HWOH3McHKDn8YX1Z/VLI4dA2Bop8amZ091ejUHZ8iffs73xfM36evf5BVC
	 3pwLU5F69LlsEV0B7tG3CS8DFJ1pQX0wzIeSv2EY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0133/2651] arm64: dts: qcom: milos: Add power-domains for camcc and videocc
Date: Wed, 18 Nov 2026 15:22:53 +0100
Message-ID: <20261118150252.641836672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit a21b23f7ec4d849db9044f83787a7939acb639dd ]

The Milos camera and video clock controllers operate on the CX and MX
power rails, and require these power domains along with their
associated performance state votes to be specified for accessing the
clock controller and its GDSC. Add the 'power-domains' and
'required-opps' properties to the camcc and videocc nodes.

Fixes: d9d59d105f98 ("arm64: dts: qcom: Add initial Milos dtsi")
Reviewed-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260806-eliza-mm-cc-v9-v10-3-6ba52dd14343@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/milos.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/milos.dtsi b/arch/arm64/boot/dts/qcom/milos.dtsi
index aad8bf6789162..f3af1d759e098 100644
--- a/arch/arm64/boot/dts/qcom/milos.dtsi
+++ b/arch/arm64/boot/dts/qcom/milos.dtsi
@@ -1949,6 +1949,11 @@ videocc: clock-controller@aaf0000 {
 				 <&sleep_clk>,
 				 <&gcc GCC_VIDEO_AHB_CLK>;
 
+			power-domains = <&rpmhpd RPMHPD_CX>,
+				<&rpmhpd RPMHPD_MX>;
+			required-opps = <&rpmhpd_opp_low_svs>,
+				<&rpmhpd_opp_low_svs>;
+
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 			#power-domain-cells = <1>;
@@ -2031,6 +2036,11 @@ camcc: clock-controller@adb0000 {
 			interconnects = <&mmss_noc MASTER_CAMNOC_HF QCOM_ICC_TAG_ALWAYS
 					 &mmss_noc SLAVE_MNOC_HF_MEM_NOC QCOM_ICC_TAG_ALWAYS>;
 
+			power-domains = <&rpmhpd RPMHPD_CX>,
+				<&rpmhpd RPMHPD_MX>;
+			required-opps = <&rpmhpd_opp_low_svs>,
+				<&rpmhpd_opp_low_svs>;
+
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 			#power-domain-cells = <1>;
-- 
2.53.0



