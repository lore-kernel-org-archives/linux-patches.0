Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251D1185924;
	Fri, 15 Nov 2024 06:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653765; cv=none; b=aYPIaTYVBLdl5NJnulhTJB0kuDEqV3gXLctO/A1mqXAKlr6iVxEMpR09PxMW2s0xbGBksiZVZAyVq/jPWz7DvLcYSie1aZNF0x+q6zzVc8IA7u4c72/i8H8kEiRdpW2QLZeEB3redJVSAHd8Y1c6ZQqdTPijFCJ159fhZK9kM1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653765; c=relaxed/simple;
	bh=gz4V7lPnUlnIDV4GWCDq/JL1wZrQ8tvDcT3r9U6geCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naFTY+78M76t9jxwkYulD2ju0VyoQ3y3uJo7Xp1gegWCM4eWg+zmoHev/uoyFkbEHuDnld8ub2ucN+CSAsCx+E8HjFuGtWVqSaXoeEwhklihTd3o6NNyGNFvMXUmk5C1XSo+8z30xraSZD4ItUb8tw5a9TKf9MiUsbPITrNZSmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4nmOZeM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4nmOZeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAC6C4CECF;
	Fri, 15 Nov 2024 06:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653765;
	bh=gz4V7lPnUlnIDV4GWCDq/JL1wZrQ8tvDcT3r9U6geCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4nmOZeMrTFRo78GR8dFKcElT6hGj17pI7SkhurT0GkbEvNxOnJGlR3Qy6c5yDJF2
	 JffFFkydQIZbzkF2lsKpTuvVZRECYhVs8GV5t4oVybXE7kLXF0Wbj5F8EsGN0HgLM2
	 EXYm91U0BSvgkI58F16P0FRfgFuIMwCF+IYgt8T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caesar Wang <wxt@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 08/82] ARM: dts: rockchip: drop grf reference from rk3036 hdmi
Date: Fri, 15 Nov 2024 07:37:45 +0100
Message-ID: <20241115063725.866454806@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 1580ccb6ed9dc76b8ff3e2d8912e8215c8b0fa6d ]

Neither the binding nor the driver implementation specify/use the grf
reference provided in the rk3036. And neither does the newer rk3128
user of the hdmi controller. So drop the rockchip,grf property.

Fixes: b7217cf19c63 ("ARM: dts: rockchip: add hdmi device node for rk3036")
Cc: Caesar Wang <wxt@rock-chips.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-13-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3036.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3036.dtsi b/arch/arm/boot/dts/rk3036.dtsi
index 4dabcb9cd4b8c..f8f9f1bffd9bc 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
@@ -332,7 +332,6 @@
 		interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru  PCLK_HDMI>;
 		clock-names = "pclk";
-		rockchip,grf = <&grf>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&hdmi_ctl>;
 		status = "disabled";
-- 
2.43.0



