Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891613093DB;
	Mon, 13 Apr 2026 16:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096310; cv=none; b=KoNZn5P2napr3wdL/uZa6DxiPvFnOQFe+s+sEVp6uEY8ADsri9R4oPZCWfZ/zpwomkRCToUAQRGygZmwfAY+HWL/4/vB9KLf2LDaQioYCEAD2ZzRXsoS2ifsGe90RZQ31you3SH7sfbLhzqbiA9Qdd8534VES8u6U0rTfRxUV2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096310; c=relaxed/simple;
	bh=LBBrDN8l84vTa66b/ajXvXP1t9qYO6XuHkYbHK1kUqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHa+f64PVSvNJ1UnynAC866HJYg/K22G5uqQ00GJWwLbqgi1sbMikaDowmdocQzva+AaZEfusm3tnyl3CLf/G4zgoMa2kzIWBYMlWgkST9p5arINgsxOgrFYoUYRitOv59M3mqVMe8FNBxuhFDCNZcFtQ0Q0gx9bwxXK6isZ+1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBbZWM31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBbZWM31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20148C2BCC9;
	Mon, 13 Apr 2026 16:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096310;
	bh=LBBrDN8l84vTa66b/ajXvXP1t9qYO6XuHkYbHK1kUqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBbZWM31VM6grnZrNbGAJUMhLSd0AQGRItzTup+o8dypS0EKjNiIsvnmv2SPeEkD3
	 JZWVuOjUK6ALU1Q7woE9uNmnyjSGR4bCQhqfOOzg+n+fT+r7374U3VEIEFWA6atR7w
	 uJEGFef/OUWC7D6cXjYZd0ErVOFHARsIJS7SWfFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Palus <jpalus@fastmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.19 31/86] Revert "arm64: dts: rockchip: Further describe the WiFi for the Pinebook Pro"
Date: Mon, 13 Apr 2026 17:59:38 +0200
Message-ID: <20260413155732.735269666@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

commit 29d1f56c4f3001b7f547123e0a307c009ac717f8 upstream.

This reverts commit 6d54d935062e2d4a7d3f779ceb9eeff108d0535d.

It seems there are different variants of the Wifi chipset in use on the
Pinebook Pro. And according to the reported regression - see Closes
below, the reverted change causes issues with one Wifi chipset.

The original commit message indicates a "further description" only and
does not indicate this would fix an actual problem, so a revert should
not cause further problems.

Fixes: 6d54d935062e ("arm64: dts: rockchip: Further describe the WiFi for the Pinebook Pro")
Cc: Jan Palus <jpalus@fastmail.com>
Cc: Peter Robinson <pbrobinson@gmail.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/r/aUKOlj-RvTYlrpiS@rock.grzadka/
Tested-by: Jan Palus <jpalus@fastmail.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260210120142.698512-1-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts |   18 ------------------
 1 file changed, 18 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
@@ -879,12 +879,6 @@
 		};
 	};
 
-	wifi {
-		wifi_host_wake_l: wifi-host-wake-l {
-			rockchip,pins = <0 RK_PA3 RK_FUNC_GPIO &pcfg_pull_none>;
-		};
-	};
-
 	wireless-bluetooth {
 		bt_wake_pin: bt-wake-pin {
 			rockchip,pins = <2 RK_PD3 RK_FUNC_GPIO &pcfg_pull_none>;
@@ -942,19 +936,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&sdio0_bus4 &sdio0_cmd &sdio0_clk>;
 	sd-uhs-sdr104;
-	#address-cells = <1>;
-	#size-cells = <0>;
 	status = "okay";
-
-	brcmf: wifi@1 {
-		compatible = "brcm,bcm4329-fmac";
-		reg = <1>;
-		interrupt-parent = <&gpio0>;
-		interrupts = <RK_PA3 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "host-wake";
-		pinctrl-names = "default";
-		pinctrl-0 = <&wifi_host_wake_l>;
-	};
 };
 
 &sdhci {


