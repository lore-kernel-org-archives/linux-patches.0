Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9311BD031;
	Tue, 12 Nov 2024 10:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407596; cv=none; b=lqGgIWMzsAa4m6jUo+ntuW+kh7TT8oQOJc6ZUVx98h9s+mEVlyLzw6whT4tksibvv29eJHOkcep3n+5v4E2rXqqNw+xayTml/sA2RC5OIv+uKSEWJ17g/c15SLkmgEpDbkP75jXIqj1fWqnqYQTYQAfefsHsyOi+vuoDUCdOfl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407596; c=relaxed/simple;
	bh=ivx90jr6bObSfagPzuUzG9sQ50+T+tKd6/+eEqoVTps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUAeLs4C+dBeaEe/eoiPhb6RSN41Eb2/UBhpiltMI0IPoVF/cslO+iQYnOqQXR5+Mj7FF6Chx9J1lrhXOcoUJ5wQ720KfFAR3NfefXwBgfboiF158ENMip3akA6ThoaOTfj+/07RvSIJrnuCEIucjSCuxoX2Yufs/6iPIysJR2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGn26plo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGn26plo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1C6C4CECD;
	Tue, 12 Nov 2024 10:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407596;
	bh=ivx90jr6bObSfagPzuUzG9sQ50+T+tKd6/+eEqoVTps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGn26plo2og4pd5HFfZ3qmM7OT8IgHsIwePqrsIdRE68frQTNAqgR7LrnjRnCllaF
	 KfeFCsJxJ1H2C3OksWdJV9UD3J15Ymuc36TEO+jEbrFU94QoZi3eTIWtEUo/pI2UXb
	 UxSFj7QWVjsQQbIROW1aOQgaUm4aJXN1jmD1r4qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/119] arm64: dts: rockchip: Remove hdmis 2nd interrupt on rk3328
Date: Tue, 12 Nov 2024 11:20:11 +0100
Message-ID: <20241112101848.842345082@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diederik de Haas <didi.debian@cknow.org>

[ Upstream commit de50a7e3681771c6b990238af82bf1dea9b11b21 ]

The "synopsys,dw-hdmi.yaml" binding specifies that the interrupts
property of the hdmi node has 'maxItems: 1', so the hdmi node in
rk3328.dtsi having 2 is incorrect.

Paragraph 1.3 ("System Interrupt connection") of the RK3328 TRM v1.1
page 16 and 17 define the following hdmi related interrupts:
-  67 hdmi_intr
- 103 hdmi_intr_wakeup

The difference of 32 is due to a different base used in the TRM.

The RK3399 (which uses the same binding) has '23: hdmi_irq' and
'24: hdmi_wakeup_irq' according to its TRM (page 19).
The RK3568 (also same binding) has '76: hdmi_wakeup' and '77: hdmi'
according to page 17 of its TRM.
In both cases the non-wakeup IRQ was used, so use that too for rk3328.

Helped-by: Heiko Stuebner <heiko@sntech.de>
Fixes: 725e351c265a ("arm64: dts: rockchip: add rk3328 display nodes")
Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
Link: https://lore.kernel.org/r/20241008113344.23957-3-didi.debian@cknow.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index 126165ba1ea26..5d47acbf4a249 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -726,8 +726,7 @@
 		compatible = "rockchip,rk3328-dw-hdmi";
 		reg = <0x0 0xff3c0000 0x0 0x20000>;
 		reg-io-width = <4>;
-		interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru PCLK_HDMI>,
 			 <&cru SCLK_HDMI_SFC>,
 			 <&cru SCLK_RTC32K>;
-- 
2.43.0



