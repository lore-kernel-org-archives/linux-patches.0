Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D12135AC03;
	Fri,  4 Sep 2026 05:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501272; cv=none; b=gjKTZanQO0eTYvlxBr9CKOJoy1dhfOCFLiq7Quk/UCZyEawAP0bgjkdg7dPTlIWG5G/1OwDu1z2pNYu4twYwdNv3GTM1IsVPR1/EAPNjrWZFA6PapLkf9ul3xs6en3E842XlM/BemU+hi5zsieDoDuIJn31kD8EERkZtSF2x5Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501272; c=relaxed/simple;
	bh=9XWIv7W5UuhVgOvLfalYNfrEDvITAo8K7fIt3LyQ3VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnWqNI9XgaMH/AIJnwsrmPateDmKaFkE64pNFYjudUqyGLESpYzZakVLPg8hawoVHqQrmQXDNPpbs/kWovCNwX8Gi/NClPHE2hpIjqM4vhZoFp0mleO7CDgtLWl2hEAU9jJwBeybn8sHW2AdmnSAzCKUh1KLNYDz+GgeEjr3Dg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jh04yd5M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jh04yd5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014C41F00A3D;
	Fri,  4 Sep 2026 05:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501271;
	bh=SFsLDM+/thj7bYKVOutLMKBuqZRNROev3obX4H29Y9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jh04yd5MbajFohimPS4C8ropONpx3TQLsb96qlguEmW3nnUM2H1lNJVY5MNqEiH+z
	 t6PExmvRKZLjmAv9KoMkSWLt6rvuMgVZplMJjbt+2/BcJOYZy6ue5d3Co650jibU7Y
	 cfYJ/oHXLBJIbe6iPTcqeABJRJe+U8Rg2jqOXFGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Peter Robinson <pbrobinson@gmail.com>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Oren Klopfer <oklopfer37@gmail.com>
Subject: [PATCH 6.18 308/552] Revert "arm64: dts: rockchip: Further describe the WiFi for the Pinephone Pro"
Date: Fri,  4 Sep 2026 06:57:45 +0200
Message-ID: <20260904045757.265973221@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Oren Klopfer <oklopfer37@gmail.com>

commit 5f19535351bf28f28d702f452d11a1216ec2bd28 upstream.

This reverts commit 096bd8c679185f898cae9933c6a68650fa26ea4f.

Just as with the Pinebook Pro, there are multiple chipset variants for
the Pinephone Pro, and multiple firmware binaries for different
distributions. The change causes issues with some of these combinations,
and reverting it resolves the issues. See the Closes below for the full
report.

Similarly with the Pinebook Pro adjustment, the original commit only
indicates "further description" and not indicative of fixing any
existing issues, so reverting should not kick any back up.

Fixes: 096bd8c67918 ("arm64: dts: rockchip: Further describe the WiFi for the Pinephone Pro")
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Peter Robinson <pbrobinson@gmail.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/r/20260607225901.64019-1-oklopfer37@gmail.com/
Signed-off-by: Oren Klopfer <oklopfer37@gmail.com>
Link: https://patch.msgid.link/20260703201010.67311-1-oklopfer37@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts |   18 ------------------
 1 file changed, 18 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
@@ -689,12 +689,6 @@
 		};
 	};
 
-	wifi {
-		wifi_host_wake_l: wifi-host-wake-l {
-			rockchip,pins = <4 RK_PD0 RK_FUNC_GPIO &pcfg_pull_none>;
-		};
-	};
-
 	wireless-bluetooth {
 		bt_wake_pin: bt-wake-pin {
 			rockchip,pins = <2 RK_PD2 RK_FUNC_GPIO &pcfg_pull_none>;
@@ -721,19 +715,7 @@
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
-		interrupt-parent = <&gpio4>;
-		interrupts = <RK_PD0 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "host-wake";
-		pinctrl-names = "default";
-		pinctrl-0 = <&wifi_host_wake_l>;
-	};
 };
 
 &pwm0 {


