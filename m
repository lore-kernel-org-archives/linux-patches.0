Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14341A76C7;
	Tue, 12 Nov 2024 10:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407613; cv=none; b=st8oLxZhY9eadbL12hwsjHK5urkJDGsrKfQlbfYbZ0sr42J+ySeU9KozMznyFqpT6hVepnkwo9OYPxwSHyprR7R1ZhhnpUT4nr6jIg1ez7UJYGYKQh6/7qNzuQYuaHzTD6PDOL59KAQxbGg0Aus2yUZNPPk+7XWG38FbcBCNd6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407613; c=relaxed/simple;
	bh=7vyKNok4DnMh2QfjEU73bd0OgSijzDL4kJCDWbdIgwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEdDD8EKW4J0inmcPSnps6LDoImNRueHbzuaRgznp59FuEBGLkT1afK59yKC2ldohaT/mAXAxJZU1JxK2VP4mAUo0FvlBL21swWm00qo+3Btve19bgnyKAhUzrNmH6THovRegju+gn3TQgagdCb2MM3FO7aF/YBo5vjSAaowBbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=me+P5Mtj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="me+P5Mtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEBCC4CED4;
	Tue, 12 Nov 2024 10:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407612;
	bh=7vyKNok4DnMh2QfjEU73bd0OgSijzDL4kJCDWbdIgwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=me+P5MtjgdfZ9BaPVBkMhtj6hhgJLJVrdUq1cw1ez6WGiGbGXcoFkllLgpPFk6mJ7
	 0+sAV1CJaJ0tStIfOyH4agk9icHFpCVr2pu4gpFklycPlP29Z1azO4MkRvyOU44844
	 BzplOK8jw8QPINguiWPp5pxBS+e+KHu18UoRTKL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/119] arm64: dts: rockchip: Fix bluetooth properties on Rock960 boards
Date: Tue, 12 Nov 2024 11:20:16 +0100
Message-ID: <20241112101849.034374247@linuxfoundation.org>
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

[ Upstream commit ea74528aaea5a1dfc8e3de09ef2af37530eca526 ]

The expected clock-name is different, and extclk also is deprecated
in favor of txco for clocks that are not crystals.

So fix it to match the binding.

Fixes: c72235c288c8 ("arm64: dts: rockchip: Add on-board WiFi/BT support for Rock960 boards")
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-5-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi
index c920ddf44bafd..55ac7145c0850 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi
@@ -577,7 +577,7 @@
 	bluetooth {
 		compatible = "brcm,bcm43438-bt";
 		clocks = <&rk808 1>;
-		clock-names = "ext_clock";
+		clock-names = "txco";
 		device-wakeup-gpios = <&gpio2 RK_PD3 GPIO_ACTIVE_HIGH>;
 		host-wakeup-gpios = <&gpio0 RK_PA4 GPIO_ACTIVE_HIGH>;
 		shutdown-gpios = <&gpio0 RK_PB1 GPIO_ACTIVE_HIGH>;
-- 
2.43.0



