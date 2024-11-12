Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1644F1CBE8F;
	Tue, 12 Nov 2024 10:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407586; cv=none; b=fPWdj2k3PCcq1DXiqskgC3eOZWQGbNW2zdAhl1Ds41UZhvuVSmEqcFtSTEZNR94qHoZIDTmx7PtnGlJwYBb1nAZ1AundaFvY1DXmaLmJytFcH9q133cmyX3gRo+7fQoQobjagU52Kaf7lMTwvDTnIyezJHT/DjG4tvXJtTyP3oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407586; c=relaxed/simple;
	bh=Ofzr6tH5whNx8/wrcj+7nkWiQBmTgyUq6+D9KfpexZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXRRFfrU7g7NBdw1v0HRuQ0RHDum4eVcdy8cb+e5KUwNTMRs/t19RD1pu7JVCpG2SUwuus3PpOSwsCMs4klXkVpdYe+IFtGLRaSf5PKXZCSUCVZZKLM+CmOBiLx/F9GIhgqO8H3DeXqL18dxWr9OI9beKrcp3XonXIi9u0qNfvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xU8ZDjSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xU8ZDjSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776CEC4CECD;
	Tue, 12 Nov 2024 10:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407586;
	bh=Ofzr6tH5whNx8/wrcj+7nkWiQBmTgyUq6+D9KfpexZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xU8ZDjSSxSs0UiH3vxRQgBqupnFjMTgGe947KEVJLzMc9suIkVQYq6ZIFq6YbXS8u
	 Ra33zISWq+hm6eGwyCtDq4RBg+JjGKbMvVUsYigZFBOq8W2prTq8lJB5in+uiLhwkG
	 JNBTk+F0UB0bHifjRALFPA7h+lSQJthlk/pWzPQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caesar Wang <wxt@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/119] ARM: dts: rockchip: drop grf reference from rk3036 hdmi
Date: Tue, 12 Nov 2024 11:20:28 +0100
Message-ID: <20241112101849.486656693@linuxfoundation.org>
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
 arch/arm/boot/dts/rockchip/rk3036.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/rockchip/rk3036.dtsi b/arch/arm/boot/dts/rockchip/rk3036.dtsi
index e6bb1d7a2b4ec..4e208528eebf2 100644
--- a/arch/arm/boot/dts/rockchip/rk3036.dtsi
+++ b/arch/arm/boot/dts/rockchip/rk3036.dtsi
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



