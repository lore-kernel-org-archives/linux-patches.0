Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4695A2853F3;
	Wed, 25 Feb 2026 01:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983888; cv=none; b=IbWXV9ndjZGXgleyDCXi/yOmWCBwQnu+WVzmzNnHaPaR2wGIivycx6XwI5Wuo42u9oLWjqcou3lRw6EzkKJLOH+AdPc0xa/RHZCkkuzBnu6zP8sW+43NGjxdboW4j+ny5kA/0lvrSCOVEBHp8YCFVyyrjlb+kPnJ4jZ6gNHvgAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983888; c=relaxed/simple;
	bh=5aQuH+hZnUiE1UsczNtccT/fIBec0spYsf8EJFvZbCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWEEvRQY+xAxW+5HCLGLeOhvYN/3UVBIT3s/3h6MWwkJE1n7jL80Te5QPxRgObB0xB90B8/iGymGHW82E/QZoLw6nGRMx/nJ5J1kCudTqAuJbaaLmjZClIN+9geNsi62jfiDDNVoRRbxKa3Xxy77FJ7RbaFBYsmtqwjNRWB/9UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xg/ODwkw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xg/ODwkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38E8C116D0;
	Wed, 25 Feb 2026 01:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983887;
	bh=5aQuH+hZnUiE1UsczNtccT/fIBec0spYsf8EJFvZbCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xg/ODwkw5I+2vjsa3Amf1iJaMgFSfoxH/gZpvBMZFg+7AisHlzakbnQn57QVCc1qk
	 gq0F+b77lziGG+h0LughiySRakQ4wLfH+us1SqkN2dlhCKuNDn2OFLkGpwJndXLg3N
	 lIIHv1Vce0T4Ric1qbu4rMnPLn4qS0o0WdcK8Rug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 161/641] arm64: dts: qcom: sdm845-db845c: drop CS from SPIO0
Date: Tue, 24 Feb 2026 17:18:07 -0800
Message-ID: <20260225012352.970253121@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 8abf3e909502f..384be2f8b1411 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -850,7 +850,6 @@ &spi0 {
 	status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&qup_spi0_default>;
-	cs-gpios = <&tlmm 3 GPIO_ACTIVE_LOW>;
 
 	can@0 {
 		compatible = "microchip,mcp2517fd";
-- 
2.51.0



