Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D771E21263E;
	Tue, 12 Nov 2024 10:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407031; cv=none; b=CPfQn8z6KZONct2Y/U7sf26ayUsx/PIStGMnV4endjX792M+PIB+1VWNfJwqawW3q+wyIvcTzyvNUGZz/LZQ8ryI6zkKzGq5JDBQX0KSYEhHrwsXDmhDRIzGh7LagcYLOgmSN+RB+RmHNvLOOmB2vidkzWpQLpW+sbtW/PRgl8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407031; c=relaxed/simple;
	bh=43ndCtTTIO5IrN3BD8zByq7EJwMilS+t4XUufRnxHlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XofkgSDwQCGx3E0ZBHAxJfpG5d769l+WMUNP/11P1O2I0LgxlACcHlcUSPViFs9sJv/LqZluMMHQO6KnYVYwTeAI96WiYoRqBvpMTPaEHn7ZEzC5LO8zVd3aTxeFwPdxTDCUIEKk35n5z8KMuJStzoW2xw15abPG4wLFdYYfY9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSplS3OA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSplS3OA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54263C4CECD;
	Tue, 12 Nov 2024 10:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407031;
	bh=43ndCtTTIO5IrN3BD8zByq7EJwMilS+t4XUufRnxHlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSplS3OA0hQoqtxTefCa8bNolgRX7xrrOXstx8mvatK29LeNpbSHEA8/D2HxDzPm4
	 SKBS+Lb+qlg+UI+CyBsN/SDvjWqArU8MnlDx28yTqCVMd3CX2QOChjsGrbh2DvupWW
	 l67Thc/7od7KfbLFYcDCm5ccxlQ0POuZGxuJAuQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caesar Wang <wxt@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 08/76] ARM: dts: rockchip: drop grf reference from rk3036 hdmi
Date: Tue, 12 Nov 2024 11:20:33 +0100
Message-ID: <20241112101840.100476185@linuxfoundation.org>
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
index 4db4e19b22a1e..e0d4c71f109a7 100644
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



