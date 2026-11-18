Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017535;
	b=lsLck7fol9mTmjGiuEvrPfKbMLYEdfj/9plzjTqNGlbYl5RgRHiy/kp/jqaCS2+/cbDx
	 ViU03pYkRh4WM17LUXHXLH9yqpQ7tNNZnaaFu3TQp99jESt+xJlevJyb4xyYZFD6cdCp5
	 8yxg8nmK8p5usuu8OfXbHMVRDbbiQEPNCNXAzXZbCUPP8GFVCR1cPAUlE0yUHgDHx3Ux+
	 X9hIpES3qZqOJjS6R2OBxPqymrFAXu2yCARs3cUCr2UkAgpcvFSVfBb2ljBEbXVEFqElP
	 FLaoWjWTVWBJqg8khBZ3bWZSLRCIXyTVaap8D75z908jE5HjoMhPIiIrIlcaIF+JTzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bV0a29puUMUgFKcwx3kzLQgASGnvcTy4ZJ1c0YCykTM=;
	b=ZOsBC8coaJvEcXRTeRyxylKoeC0XZdUdz9OOTLcc+S64SgCgR97nvMUsKx8G50TdXo8p
	 E2wyYOeKnanIqMy8DIl5D/YN5vxdmRNBsrUkcIsSdfUL8PU6lxtCmci3gWKopMP7qkd4M
	 BDH9nKWC2X1JbtvDsg3EpuJpw3wYoQRp/aMSzccV0O2PKGJ/kbL/A6OIf06HLcnSd9zBd
	 oz+JkfjiGFDzLkiXT7dXTA5FEVrgdwUx3QzD9ZFUHxEku22IsBFjnKTPp0Ts2rW5dNWyG
	 XGBKIwaMODKUbl0nShRKTgvE6niSjOgrYXU53iV9CmMbDssgiNu1xJQasAFPGT9za8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2mpIheYh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A51D606A339;
	Wed, 18 Nov 2026 15:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2mpIheYh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19B11F000C9;
	Wed, 18 Nov 2026 15:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017535;
	bh=bV0a29puUMUgFKcwx3kzLQgASGnvcTy4ZJ1c0YCykTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2mpIheYhO/aEuXay9taCIpI5RKaxuJSGVa1iR66W+JcYAQ4CbfkKsJt6NmwrmRQvj
	 jI4npDzJsnIAkYat4bQpfkAMhEaze+peu9aR7b3fYrW4l7jdg2w4pE62gMUcgCs49f
	 Zf8p19X6zuvhZKW1IzBK1wVCu2J7lsao3dAaWpjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0920/2651] arm64: dts: qcom: sm8150: Use SM8150_CX for the SDHC power domain
Date: Wed, 18 Nov 2026 15:36:00 +0100
Message-ID: <20261118150321.014963733@linuxfoundation.org>
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
index 94a3b02cb2897..e83fe8daa7c29 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3574,7 +3574,7 @@ sdhc_2: mmc@8804000 {
 			iommus = <&apps_smmu 0x6a0 0x0>;
 			qcom,dll-config = <0x0007642c>;
 			qcom,ddr-config = <0x80040868>;
-			power-domains = <&rpmhpd 0>;
+			power-domains = <&rpmhpd SM8150_CX>;
 			operating-points-v2 = <&sdhc2_opp_table>;
 
 			status = "disabled";
-- 
2.53.0



