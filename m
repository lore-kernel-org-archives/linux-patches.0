Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CFB2123F1;
	Tue, 12 Nov 2024 10:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731406998; cv=none; b=jjtYgy/q+ZnFK9cn/DqQLa+8Hjo0sW0Uap3HCjQJ1ZrGoH52E/TkBIUXRka5Z4ewq2gMMMg+Y6SzE6bHU+A2KgfhFgbkKWFANDvcV71cwS7Kz1X84ouqOu3ftgEIaVACvpMH9Q3ncnSVd36vSucOCN5MoJgFfxL/NqUx1FYUChY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731406998; c=relaxed/simple;
	bh=ssBjXT6/vFQnSVo2aZRb8eOWZkJqm7f5T1jSLSWLvSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7Vlc951n5lA3xp96Fd4qkseNpLpCNs1m46H9AyAv36aHEifrAnQO/OjwlZ8rfhljisma2T2vrdoh0wAocbLg1D07tLGQr208qI7FuTD2K1FH1TwYhCWlNF/u5XqeP/Afa5xti1PCM89MXdsSFBdvr0mSIPifd/E9AzRwKY5WUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqK/x5m7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqK/x5m7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A33C4CECD;
	Tue, 12 Nov 2024 10:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731406997;
	bh=ssBjXT6/vFQnSVo2aZRb8eOWZkJqm7f5T1jSLSWLvSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqK/x5m7SvJv0sJvoTvIYeHIWxZbaW/DZil3EHBoX7Ofv5USEYZ8adBSRZUuplP27
	 2hCZwZWpljmxYOkbyNF2MmcfQ/W9O9jl+9Lav5p6Sl4oGVXf5DQEBK+I+veTNs/2tt
	 YKdtrJz66Xft+nVhUQckps+UbzfVg9LNddDJ74eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/76] arm64: dts: rockchip: Remove hdmis 2nd interrupt on rk3328
Date: Tue, 12 Nov 2024 11:20:27 +0100
Message-ID: <20241112101839.875322574@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 21755dd5b4c45..f73cb7667baba 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -711,8 +711,7 @@
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



