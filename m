Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F321C1AD1;
	Tue, 12 Nov 2024 10:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407593; cv=none; b=EqSq00CNUsrSRJhIC2YrYXx6ARngQI9elI/Jbj8MEJRFPAuqyN5hJgWRjpyGw4QP2w7Wpr/7JzHV3a1dTgOP0SHkvokaPDdtNBVS1JQMrL5/EUzdyhfQvXQSDGi7kejD8LjsRJXbpDe6fI/9SLPgIj1g3CMRABhcJ7z5f61c57E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407593; c=relaxed/simple;
	bh=XRP3PJBSg85XYO666mPwI/gW2K3mEvYhU7+L7vihBR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEtNr/32LkorazWNu3Gn4eNCa+tYBKEbmuyLoB6hlwT6lSDDus7puCJgbNWV5IrwwUYs88PVycqnvS1YZFAB5N+v+aut/z6XUoZ8xlSA/FN0lmeyU6iB3V5yZ0HaamatF065cN/5zFgnp/r3Uq2SrPIIy9A1om5pHzbzifNvJXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EY81eQlI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EY81eQlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549EDC4CECD;
	Tue, 12 Nov 2024 10:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407592;
	bh=XRP3PJBSg85XYO666mPwI/gW2K3mEvYhU7+L7vihBR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EY81eQlID1U6bFghQfFFb4AgOqZd5BNOumd80RPzCWRCIb9bSrZ1O1H35YalVQU2r
	 ctwnVLJ9zsfbSZQRk+QOihtCFFi2gOdeOfsZFf1Pv4nZu1pQn8z4aUarQwNbLRIGkg
	 CJqJ7gQj27VMBiwzvNmvDVgo9ls8GESPplbTkFFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caesar Wang <wxt@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/119] ARM: dts: rockchip: Fix the realtek audio codec on rk3036-kylin
Date: Tue, 12 Nov 2024 11:20:30 +0100
Message-ID: <20241112101849.560864392@linuxfoundation.org>
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
 arch/arm/boot/dts/rockchip/rk3036-kylin.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/rockchip/rk3036-kylin.dts b/arch/arm/boot/dts/rockchip/rk3036-kylin.dts
index 67e1e04139e73..43926d0962bbd 100644
--- a/arch/arm/boot/dts/rockchip/rk3036-kylin.dts
+++ b/arch/arm/boot/dts/rockchip/rk3036-kylin.dts
@@ -304,8 +304,8 @@
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



