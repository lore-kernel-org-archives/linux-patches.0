Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D806369D67;
	Wed, 20 May 2026 17:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298395; cv=none; b=jvSaSzY1Ts4McIguivGy89KI75R9gfFXQHOZW1P6++1t9t7y/jZ5aSvRnV56vA6agYFwe7giRxcHADfFxp5MtVz4zIZXsVt4xX2kjuxtIYOEuXCIJEZeF0cwyplTqkB6VIYd7czZJbaVg3GpF3K2VFIgnXsXuIbsrE6MKk3xAlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298395; c=relaxed/simple;
	bh=7yNiLhe2PRS4TPNI+qRyPAfZ85t/fsa9NJ7sFdYpTQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jOj9WFNDu86o3je2lmLsYjKwHHgigDmLxTTZuMGcnC0WD20krOGnabjkMXKVtssGRarpWliNV8BwoIl6SbV+vlTi/Pd6Xb3zN0kucju2mFH5zWY71QLdqsSocSP9p7zrHpz5JrN++sG4yzZBLknIbSrkcTZ9Rxk24S/0OAff/E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbmSx5La; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbmSx5La"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37681F000E9;
	Wed, 20 May 2026 17:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298394;
	bh=W4lce2/IFuNypEsc47zB8viRUw8DoDvAt8ekf+GJZT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hbmSx5LaWKXCxF1h3vVaW53EAHCFHwpADkMFVXDzbz6e8D31S+cjVQmvWMDUQWAI9
	 pjoD2rDn+pe14mtOLAABOPkwpbYC/ZgDuyC6VBmNVHuTgB/9JOTyFyeoCPGYXzAkom
	 U0Yq8NA/opJe7Mhqphk0qg8xU7x3Y6cEv2Fbldy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20 ?= <Yeking@Red54.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 392/957] arm64: dts: rockchip: Fix RK3562 EVB2 model name
Date: Wed, 20 May 2026 18:14:35 +0200
Message-ID: <20260520162143.028951879@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>

[ Upstream commit ede6a05606892bab4f6d785ffcfc124150c2eb32 ]

The model name should be "Rockchip RK3562 EVB2 V10 Board".

Fixes: ceb6ef1ea900 ("arm64: dts: rockchip: Add RK3562 evb2 devicetree")
Signed-off-by: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>
Link: https://patch.msgid.link/tencent_78E7E3F6991FB4403D5ADC9E6A6BC3BF8307@qq.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3562-evb2-v10.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3562-evb2-v10.dts b/arch/arm64/boot/dts/rockchip/rk3562-evb2-v10.dts
index 6a84db154a7d5..387062eea5208 100644
--- a/arch/arm64/boot/dts/rockchip/rk3562-evb2-v10.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3562-evb2-v10.dts
@@ -13,7 +13,7 @@
 #include "rk3562.dtsi"
 
 / {
-	model = "Rockchip RK3562 EVB V20 Board";
+	model = "Rockchip RK3562 EVB2 V10 Board";
 	compatible = "rockchip,rk3562-evb2-v10", "rockchip,rk3562";
 
 	chosen: chosen {
-- 
2.53.0



