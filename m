Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F243A41A794;
	Fri,  4 Sep 2026 05:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499467; cv=none; b=X2mCTYN3BBOMlBSxqCMkrN8CJ+rSIeFItnVH3qjEGda/WVTpTUSd8RhK6YIahvme4lkHi20kFOCO9kipBeHugXJDjnw0fz9cretgbGm6jVhQjHXQ7hcuWtmZGzeOOUeTULLE8F4mjQj/6Fo7zaTp5w6tIyeVLgyqMQ7rEsVrYEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499467; c=relaxed/simple;
	bh=Jw2+DN+vgNrkc377WOeFwMDOXJeMOOxs/LNRPv816VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h6UkJzzKx1USsU4/oFOpkdzksmXPV8FCjKI34Q220B44rvEXaOeUkNz2t+ukDoUE/nUK7V3BfX22oiWWSLem/W6tBAFLrpImPLtLDKVt4N6jBVsi+WuYFAGTLBAs8KTG4X2zdczEy55bl2mPHMCnRs9gpRyWn3dqixjnCXWk/40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnsnyReG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnsnyReG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B771F00A3E;
	Fri,  4 Sep 2026 05:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499465;
	bh=d5nQFCBqx6jHq9R5w17zz8Q5WZSzxxHv36AdQqtPhyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OnsnyReGG4TZB0IPzEr3vKYocrhIWCmVZbbtF8xLSzK3awsnBFp5bOb4wyH/gNrGT
	 W2Z9l+LDSHjNYGtlpW7PPcPmtKCJ8b/VAXCtJmoiUptVV4rq9cPb/RA4z9ITdVBfZo
	 950mJnFl+Ju0J4pZQQixdWIycAC3T+bPzPI9pzD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 7.2 427/713] arm64: dts: rockchip: fix eMMC reset polarity on PX30 Ringneck
Date: Fri,  4 Sep 2026 06:56:35 +0200
Message-ID: <20260904045813.398222737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@cherry.de>

commit dfe078755706ed50651ebbe0442843ecd4ae8389 upstream.

According to the Jedec 5.1 specification, the device is held in reset
when RST_n is low, therefore the polarity of the line must be that, as
specified in the Device Tree binding (mmc/mmc-pwrseq-emmc.yaml).

Due to the wrong polarity, eMMC devices with RST_n_FUNCTION[162]
bitfield [1:0] set to 0x1 (the default is 0x0) will be held in reset
forever.

Cc: stable@vger.kernel.org
Fixes: c484cf93f61b ("arm64: dts: rockchip: add PX30-µQ7 (Ringneck) SoM with Haikou baseboard")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://patch.msgid.link/20260626-ringneck-emmc-polarity-v1-1-90cefe57b316@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
@@ -26,7 +26,7 @@
 		compatible = "mmc-pwrseq-emmc";
 		pinctrl-0 = <&emmc_reset>;
 		pinctrl-names = "default";
-		reset-gpios = <&gpio1 RK_PB3 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpio1 RK_PB3 GPIO_ACTIVE_LOW>;
 	};
 
 	leds {


