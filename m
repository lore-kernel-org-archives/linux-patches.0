Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896D02C0F69;
	Mon, 13 Apr 2026 16:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096488; cv=none; b=ODue3/yV8Trum/58pgX9rSCiyb6Kw0NtPAUur+rf314j3pdbsuotT47UAs8C/tdMhFjpbLDVviwICRNSO//ipjsQJBmQG4Haj9Vk97vsUJI7Mh8lk2JhDgr3FN3NJHYWtzmCt39KGh9Zv/Gh2wG6HeIFdAXXDxl/pv4kEo9J+Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096488; c=relaxed/simple;
	bh=4HA+vEzmykvIe+HA5EXVBvpUPrnO8Nm36AshjL3UetM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ix0wvFqrsysT9go8Ix5HZpla1dKXV/uGqtBphmUHgRoDao/UnRdm4kUrN3WQgsIvP+J3Ye4zq0bxbwTA0JdsgMMIRaKglN6EPrieXKojleYoMu+EfqVO/uSFWoICfehhfqgBAZ7JjargsL1y0F0xSCLEdMTpSPp/RBOvUPTP3PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQvvmQx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQvvmQx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA3EC2BCAF;
	Mon, 13 Apr 2026 16:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096488;
	bh=4HA+vEzmykvIe+HA5EXVBvpUPrnO8Nm36AshjL3UetM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FQvvmQx804+ygEerP5bZg3WBKbSi9FCthAW+tE1rMhDAztEcnCF6TCAbSOLbY+8Rz
	 MIvwpN6aOBEo4pjCkU5wfq3jVUz0SA0CEQ654uCcLjTI65TmAnWyYZ7KkXuLFDFNW8
	 Xv+Zc4gsesCWngzVe4Mdv5tWPkZTmsUnt9I3Fq8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Palus <jpalus@fastmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.18 30/83] Revert "arm64: dts: rockchip: Further describe the WiFi for the Pinebook Pro"
Date: Mon, 13 Apr 2026 17:59:58 +0200
Message-ID: <20260413155732.144775653@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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
 .../boot/dts/rockchip/rk3399-pinebook-pro.dts  | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
index 753d51344954..ae937a3afa11 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
@@ -879,12 +879,6 @@ vcc5v0_host_en_pin: vcc5v0-host-en-pin {
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
@@ -942,19 +936,7 @@ &sdio0 {
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
-- 
2.53.0



