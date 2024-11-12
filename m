Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C6320EA2D;
	Tue, 12 Nov 2024 10:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731406963; cv=none; b=TZX8He15PKoIQcrKlMeOJ0A3jvYNI+2Ul7VwTnaRvRp4/auIa+mNXtyFBznD5PL06psd7zAyU8xZvmb9CuFX3p7FdKogumy5EB5N+rr0uwgcfuh+XjdQ1abTbdG1g7b/sn01DhoY1Hw/SoEK8/Z/jhKpeERWd7RIclbT1JqJ+z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731406963; c=relaxed/simple;
	bh=VhGpLIoz8yYIEZDezp/4i7mZQ+EcliZWBE5bN92oXjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKurOZfeDH44J2yUzGFKIybwAJl4ZNeFeQf9ly7eC1id6v51fLIZGna9azpNGsoUMEpR5FQLnV9YcDCVrQ8Zqi9RrV2vZ22vSSKO7y1uGafyr79+MXRB4CXXjNCvxii3l+RcZM9GXKKFtzKyrHA2xSNvfqKOtbng8Wd3Ew6hhFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sl4+kCgE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sl4+kCgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF62CC4CECD;
	Tue, 12 Nov 2024 10:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731406963;
	bh=VhGpLIoz8yYIEZDezp/4i7mZQ+EcliZWBE5bN92oXjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sl4+kCgExx16GxqzCnOMvGWbV0Q4+FBboWI9u+bTrWlKhE8Q3tsepzIxDkSiWlags
	 pOfTfYPTOUAsuzyAJ0JBOrX4fyQHvlDQkFrW+fzoRG/KZhDoeIX1R8Ov74hGXtV6im
	 bCtNqFUG9iye/KkxCDpqd7WETiet5P9dsakWd+XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caesar Wang <wxt@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 10/76] ARM: dts: rockchip: Fix the realtek audio codec on rk3036-kylin
Date: Tue, 12 Nov 2024 11:20:35 +0100
Message-ID: <20241112101840.175203220@linuxfoundation.org>
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

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 77a9a7f2d3b94d29d13d71b851114d593a2147cf ]

Both the node name as well as the compatible were not named
according to the binding expectations, fix that.

Fixes: 47bf3a5c9e2a ("ARM: dts: rockchip: add the sound setup for rk3036-kylin board")
Cc: Caesar Wang <wxt@rock-chips.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-15-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3036-kylin.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/rk3036-kylin.dts b/arch/arm/boot/dts/rk3036-kylin.dts
index e817eba8c622b..0c8cd25d0ba5c 100644
--- a/arch/arm/boot/dts/rk3036-kylin.dts
+++ b/arch/arm/boot/dts/rk3036-kylin.dts
@@ -300,8 +300,8 @@
 &i2c2 {
 	status = "okay";
 
-	rt5616: rt5616@1b {
-		compatible = "rt5616";
+	rt5616: audio-codec@1b {
+		compatible = "realtek,rt5616";
 		reg = <0x1b>;
 		clocks = <&cru SCLK_I2S_OUT>;
 		clock-names = "mclk";
-- 
2.43.0



