Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F264538C42B;
	Sat, 12 Sep 2026 10:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207441; cv=none; b=YlaT6ojts/iuVp/0jMDAXP3qX/vMN9/V2c9nST0P4NxPUcGYRQChVP7cFSYPKvukuHtDGF2TQr5EAMXfCPwsk92RKJKe2Q12jmeidDPqQT47h8PaK3E4tNS0DogLGW2DJnLLIx1wtRpzZgsaTinpsHOHeq7ZSVodcamSt7fAJxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207441; c=relaxed/simple;
	bh=NRCnGTls4Vmi+VRlBicQICu2ypV+8SkfY4cB5O1AEl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Da/EmWtvgn2ZxcocqMh/zGBPDeMGaN6KTqJ2T9ZWXvHkQaa9WY2WBrvDVqNDPHbRJa7DaxX4CCt64eixfV9G/bdKfZgxaX61+RIk+h5IZzZiwg9OQViXeHx5o53WJo7V5aoOnGTRh5Ft3Rvw4oqKwLav1WAFM7Kk2tc1JsYQApA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i62M7wnp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i62M7wnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE12C1F000FF;
	Sat, 12 Sep 2026 10:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207439;
	bh=WukTiOmHIQk/RQnyW1VqVRExLBw/c9qfnGm46ma9R70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i62M7wnpOtlL5cmTxXzA8vt/Iuo2p/XgiYPntnrvZ7aUCDYw2gJX34bTY5PYwAHV9
	 rG9n8gx7dJ8T9RukbdfV6wIsvzQopw2MqqNJHL4HFwa724+LZowyudyjXSWm7B4gPL
	 ogvCib/tteP8k1HxoLgHKNsyKkK+ysqbGklluf94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0411/1518] arm64: dts: qcom: msm8996-xiaomi-gemini: Fix up ti,drv2604 enable GPIO
Date: Sat, 12 Sep 2026 08:43:00 +0200
Message-ID: <20260912065632.754278556@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index bd3f39e1b98fb..9a9c674501202 100644
--- a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
+++ b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
@@ -39,7 +39,7 @@ &blsp2_i2c3 {
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



