Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1963446B0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302093; cv=none; b=ExNHyPNgX+uwi/5vbvvVJigOy9ck0o0MFeZVhcTQAYN4Vt+AOMwv6KegkObinM+NHNRoAeEbzpATXZAh4Q5zfh8BA0hocmTPeyfOcNUmD8F1LYz1OodWd+GbFM0bb1mxcTwyInrGp4Z2CsYlq2ps8qd+fqNQ9ZGBNn5DT630xgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302093; c=relaxed/simple;
	bh=87buuuaHIFJgEEmH7PKfpR9SzRpH8IWA+n9gn7ytg3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/CLdMK2KncpoPWhEJ8Z9A0ErfSONG/GwQhz5Ax2gHsAO03Dg24R9SfYg/V6ZY4XEToo3LQGDC7TSwdC35xVGqnkUO/nm+ynfHsZvLfwQ5Guyr5WKaQiLKkitylmDW0hAxF76HdskSxemOE1/mCRAo5z9aSK+IRBtF1YSmUTjR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KAF5mqQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KAF5mqQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A24C116D0;
	Sat, 28 Feb 2026 18:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302093;
	bh=87buuuaHIFJgEEmH7PKfpR9SzRpH8IWA+n9gn7ytg3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KAF5mqQry3qwwag4s82lTyCdw0ijOsmv3aPPti6PI40xin8GoiImW+WqiyQzbcwn3
	 AUoUqV7Pu7Nv6v/HdetJNovzOTNP7m07LlPEAitLHfcKsX0tLtvMjRvTZSdUZhokaq
	 GZ26K4tcEtr53hrVaHv1iyjBFBAq/xs3VS7IYC4kVDUfV1/vTYtfohDjwjyZyahLYm
	 TDu3uo7G1ESBSrngCSpn1bYsaJrOhxMGcP7sYtClHVFjeqt8Xxka8g4bpzrsnZxfsF
	 XzfVHAKeoLXWgTFQBdDktgLROcYb/WC5tdkftrU1RI+Ml9o4bLBF6gqC/7vtRb/LPN
	 MAYRTdHbQm4kg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/283] arm64: dts: qcom: sdm845-db845c: drop CS from SPIO0
Date: Sat, 28 Feb 2026 13:03:40 -0500
Message-ID: <20260228180709.1583486-78-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 8bfb696ccdc5bcfad7a45b84c2c8a36757070e19 ]

On SDM845 SPI uses hardware-provided chip select, while specifying
cs-gpio makes the driver request GPIO pin, which on DB845c conflicts
with the normal host controllers pinctrl entry.

Drop the cs-gpios property to restore SPI functionality.

Fixes: cb29e7106d4e ("arm64: dts: qcom: db845c: Add support for MCP2517FD")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260106-wcn3990-pwrctl-v2-7-0386204328be@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index 0a891a0122446..d2924abd91d22 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -852,7 +852,6 @@ &spi0 {
 	status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&qup_spi0_default>;
-	cs-gpios = <&tlmm 3 GPIO_ACTIVE_LOW>;
 
 	can@0 {
 		compatible = "microchip,mcp2517fd";
-- 
2.51.0

