Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6DA2F617C;
	Sat, 12 Sep 2026 16:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229606; cv=none; b=NsRxkhyvVHcvJj3rCZJa+GhiDNCb22AL9DOISuvxkve5OOG9lS2uUPSUbgziwQ3eD9/KtJOq/F5JG8l4ldigk6tNEnYdfV2Q7cfptP8o2kz65rvMPXcjYcshBqfPqZnW5luU3IOEHd0Z6Uy6tTeecIklXXnUReTTuxoQpt79wBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229606; c=relaxed/simple;
	bh=w7AdSOpoBQKDQnRFPK71eN1GgdTRB1ddDHzMN5bVa60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wj13iDI8FoMMVSqYnvxFup043U9dreP9PQWu3QRgsiP/V9u/XVuuEa9QGpnzrdHT6GAhNxpFcAHIFGHed4isnROi3MQzFFGFU/WmTwPiDcydg5rA6o2n0KsDLpEyjhWweBcw5bS7TG6lD7xh8aHcgVeevla80uXNCsEaS0R864Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xa5PVQrP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xa5PVQrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23C91F000FF;
	Sat, 12 Sep 2026 16:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229604;
	bh=Ovm7clhimw+dNUlVUkXRkuI5fVPA8xRb1roXl2AUb+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xa5PVQrP4mm9+GyDw+K2/4wyPm2xv212tAwdiWjNmrYnMy8i86qvk9Ss+J/Xi2dlb
	 42lnMvWmTtfDuChQSwRE2jgxgGNo7AHob/qlWGx3MAzDBE9i8UBx6Nscb81YsD0G5R
	 8TJ0Xu4jbApr8Kwb3mno8l5yXV772mMSRXNtjzw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0624/1191] arm64: dts: qcom: msm8996-xiaomi-gemini: Fix up ti,drv2604 enable GPIO
Date: Sat, 12 Sep 2026 08:55:52 +0200
Message-ID: <20260912065602.268029107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 569413a98a1761782a0770aa85d20a2c78893279 ]

Update the 'enable-gpio' property name to 'enable-gpios' to conform to
the bindings for the TI DRV2604 haptics module. While at it, use the
GPIO_ACTIVE_HIGH define instead of the raw literal.

Fixes: 4ac46b3682c5 ("arm64: dts: qcom: msm8996: xiaomi-gemini: Add support for Xiaomi Mi 5")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260625-topic-ti_drv2604_dtwarn-v1-1-76e91fcafbe8@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
index 543282fe2abbd..47fdd93ca8b33 100644
--- a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
+++ b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
@@ -40,7 +40,7 @@ &blsp2_i2c3 {
 	haptics: drv2604@5a {
 		compatible = "ti,drv2604";
 		reg = <0x5a>;
-		enable-gpio = <&tlmm 93 0x00>;
+		enable-gpios = <&tlmm 93 GPIO_ACTIVE_HIGH>;
 		mode = <DRV260X_LRA_MODE>;
 		library-sel = <DRV260X_LIB_LRA>;
 		pinctrl-names = "default","sleep";
-- 
2.53.0



