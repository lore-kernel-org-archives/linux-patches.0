Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF88213ED2;
	Tue, 12 Nov 2024 10:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407330; cv=none; b=erN1zj9J9nZbbPd48iffdg+1s5E8+s5eYRs22k7eXlYpOq6cD4A4P2zw+QyLOW9pbQB3g5S9+57MjmgMiQMfKXut0SPxYIiL+FS2+VfxUMMfrYD/1+r773OzsPUJUVoiIsGPWaP37RXf2988kODBFO02Iqy4KjEdFh+EswumPVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407330; c=relaxed/simple;
	bh=8av7FckwtDsvfCcp+kN0KTdr1C/fe4kPOH2ifluYnzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eaz18J16Andyd1oz1OkXTlTvTPFrX+JnJtUJP4a33o0K+LBHwVv6fzDXthtt1XMcjnhq7KFiBZHfU9P8l6U5HtDIV2XGukScso5FOLZ1imSSWMwVDwwpqx/W6za5heuCAN+0HrWQ9wm+d5IEItQqD7Z91nlA1PS65JjiiyOAlYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3DO3pVB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3DO3pVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD9AC4CECD;
	Tue, 12 Nov 2024 10:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407330;
	bh=8av7FckwtDsvfCcp+kN0KTdr1C/fe4kPOH2ifluYnzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3DO3pVBXAfSQWMQAgpDyvzrktRTo89BbMebwKDaQDmiS/ZzfuV5nbNOkFtnUR7R8
	 StyUREjEc6IdGjaGivvqBcVp0hff4pAQi6voGPtCud0j0tU7ofXOcvyKzzVuFWfHzl
	 4Lvb9PZNAKbP9UfEld1zRuoHfu8461F6wC4YTk/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caesar Wang <wxt@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 13/98] ARM: dts: rockchip: drop grf reference from rk3036 hdmi
Date: Tue, 12 Nov 2024 11:20:28 +0100
Message-ID: <20241112101844.776242161@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e6bb1d7a2b4ec..4e208528eebf2 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
@@ -398,7 +398,6 @@
 		interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru  PCLK_HDMI>;
 		clock-names = "pclk";
-		rockchip,grf = <&grf>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&hdmi_ctl>;
 		status = "disabled";
-- 
2.43.0



