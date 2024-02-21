Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871D776C99;
	Wed, 21 Feb 2024 13:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523896; cv=none; b=U8HJMybx3RaOXqqngBFjqsolSoJu3YRWBal+FbwcIjOOWLJJxhs8fIIkUfCAIiLPMV8VCwxffK9fodnl+mQjlvzb5xcnj0O5N90OHNcoFEnAzSgtJmo+EPO8hBYaKqrJl97JNo9ABvxtLdWwVWhFTm6LrP2vM+a6wIpE3TcjBz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523896; c=relaxed/simple;
	bh=QPNzf+Wecf9ofXYfNwpZ52YdkkjiHV395XME/SdDyO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BADCTpnJqZHDX7033g5/7o1sj2aiOuG72X72YCRw9TvI9ymkpwQEiTIRSOkWh4j+w1aEEewjhlYd671wLLq2M4SS9opNLYBrlznAGalMlSMDVzoqCP5zJ7815i5GKa4v51wjO56/hLuxuFpjYN9MIyiwCYmR9h+l1OBBGHN+g+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dUFBL/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dUFBL/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70E3C433F1;
	Wed, 21 Feb 2024 13:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523896;
	bh=QPNzf+Wecf9ofXYfNwpZ52YdkkjiHV395XME/SdDyO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0dUFBL/568BaG8Obuj9cpqdJreMemZa28U5vx2EWRuZTWr/Bba09zp+q7RCiN9seb
	 /bVDBwvmQ2uxfG871d24KGVTLRYt534H5J4s4GGZ6c7UYqpsi9iw/frOHh2+4Dw6Qq
	 SSUVFWr6IPiRuf9hkR2Vh+VR25r7kkQhR+k7PnNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <swboyd@chromium.org>,
	Sandeep Maheswaram <sanm@codeaurora.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/379] arm64: dts: qcom: sc7180: Use pdc interrupts for USB instead of GIC interrupts
Date: Wed, 21 Feb 2024 14:04:23 +0100
Message-ID: <20240221125957.393671797@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandeep Maheswaram <sanm@codeaurora.org>

[ Upstream commit 1e6e6e7a080ca3c1e807473e067ef04d4d005097 ]

Using pdc interrupts for USB instead of GIC interrupts to
support wake up in case xo shutdown.

Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Sandeep Maheswaram <sanm@codeaurora.org>
Link: https://lore.kernel.org/r/1594235417-23066-4-git-send-email-sanm@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Stable-dep-of: 9b956999bf72 ("arm64: dts: qcom: sc7180: fix USB wakeup interrupt types")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index eb07a882d43b..6eb82699a4a1 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -2688,10 +2688,10 @@ usb_1: usb@a6f8800 {
 					  <&gcc GCC_USB30_PRIM_MASTER_CLK>;
 			assigned-clock-rates = <19200000>, <150000000>;
 
-			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 488 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 489 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc 6 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc 8 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc 9 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 
-- 
2.43.0



