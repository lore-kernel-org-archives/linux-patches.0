Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F4736C9E0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302347; cv=none; b=I4U5DYDqZYSiLMI/HeIOE1SYNtvUTMaOmvyA4YOVld2ff2yOCyfI1zgiQ2bMglvthBpnlfXegOCuMMFMK7rKiTGdwN94R/NEsQRwXibjv7lg5cdayH/piJl5gPAcGNaYjKEX3YneRgNY2n15Yck1fuwn9XKzsGAJU4x650oIR2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302347; c=relaxed/simple;
	bh=aEtAGWHLi89IKl5oYbzgis6UjJC3uhe2DnHctnOoCZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Od8tSUDJfia739hKRalS/CiYKAB8gbAVRfNC4FeIcNEBGiECemseOXNlSxIy6ZHa6NPSOkCmsmaGhA+H2M9VyavYjJYLEJAGM/spuwNkY2kPi8oWfskxuC0nmpLHnTTeUcxf2fXq3AlhKajB0qjW6kRIabNMtNo5GEAdu1mSlUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HnMU1s3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HnMU1s3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECC6C116D0;
	Sat, 28 Feb 2026 18:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302347;
	bh=aEtAGWHLi89IKl5oYbzgis6UjJC3uhe2DnHctnOoCZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HnMU1s3G0tqJjYKNE+TKoYinQ5nI2ijwhzkHkpvV2vVsOAmlNPVLNOn337j9vd+/7
	 QMZ4WZj6JZbH7+Dp9K1l11ggp6zfXRjUDskWlMegWE1Ads3X3K54pCnsvgdEMKpr3g
	 LumRyrzhdHPImB0oj7VcXEyEvhZQQ9Yk4Ru/wU6DePcFklBpRjLeaAvqcNynufCwyF
	 yi8ZuXY2kVl2JyPxkT8xVcerwlGBE3M26GRynOJFS8jlg/iLKrojyuNKNb9X5LldqM
	 SymjhGfdckcJ+Qi2duhwnhgEjiQfZNZMXzO9ckMfssoJupwmwoasJmGujwxACvlIAx
	 5fiNzpwNUKFaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/232] arm64: dts: qcom: sdm845-db845c: drop CS from SPIO0
Date: Sat, 28 Feb 2026 13:08:44 -0500
Message-ID: <20260228181127.1592657-71-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 5c04c91b0ee2b..feb75ad70d570 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -809,7 +809,6 @@ &spi0 {
 	status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&qup_spi0_default>;
-	cs-gpios = <&tlmm 3 GPIO_ACTIVE_LOW>;
 
 	can@0 {
 		compatible = "microchip,mcp2517fd";
-- 
2.51.0

