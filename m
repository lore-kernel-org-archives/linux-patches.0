Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB5B26FA77;
	Tue, 12 Aug 2025 19:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025575; cv=none; b=Z+sJbZ+hVg7+7UdWmwowe56gX2rCx8lH/IxO2Ehc7AD5EizVVe1pZLlxjKnRO9msWBO+zgRksxx4111QC8BarRBbheSU2RqMg3M47mdL68N+SLdOmFYOdEKKd4N1kIeqdKcMLjLFiBfeeIfvGXhzalC/7q16Z/IJcnZOiX9n4/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025575; c=relaxed/simple;
	bh=WpnbTSY030UtG5ugd61gmyfcOmuhsx2DQarscQWZJJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9rfipzJ46UqUoGHDaTBdFmZARIOlIqdhH7TqNkHyXbI/N6PVM64QFUo5lAV531baV9j09ZiY7SC/t83zRTes6zdQ6oo5xaWY1VeyHOceF2+Axmsmz1uddFoIyhk2saFAWM5n/Wz0hF8+XDPu0gSEyyfLX1Feq7KKjLkO5jakg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2C7fo0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2C7fo0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9C7C4CEF0;
	Tue, 12 Aug 2025 19:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025575;
	bh=WpnbTSY030UtG5ugd61gmyfcOmuhsx2DQarscQWZJJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2C7fo0xtV2CAxjuRnualwne+ywvcZvmR6o6zNrucQ+KKJBcL8BagOUpA3M3sIzQx
	 fKCBBT/5S1kWC/nTQTgLKk1QZ2/o9vyqyFSSBpc+Rn73Cpez5RxLl+pyBgkkMruCNN
	 79dE+gyaaH8uXckXSIpXCrI5zxTyawMarfOiwPfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 048/480] arm64: dts: ti: k3-am62p-j722s: fix pinctrl-single size
Date: Tue, 12 Aug 2025 19:44:16 +0200
Message-ID: <20250812174359.382672863@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit fdc8ad019ab9a2308b8cef54fbc366f482fb746f ]

Pinmux registers ends at 0x000f42ac (including). Thus, the size argument
of the pinctrl-single node has to be 0x2b0. Fix it.

This will fix the following error:
pinctrl-single f4000.pinctrl: mux offset out of range: 0x2ac (0x2ac)

Fixes: 29075cc09f43 ("arm64: dts: ti: Introduce AM62P5 family of SoCs")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Link: https://lore.kernel.org/r/20250618065239.1904953-1-mwalle@kernel.org
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62p-j722s-common-main.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62p-j722s-common-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62p-j722s-common-main.dtsi
index f9b5c97518d6..8bacb04b3773 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p-j722s-common-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62p-j722s-common-main.dtsi
@@ -250,7 +250,7 @@ secure_proxy_sa3: mailbox@43600000 {
 
 	main_pmx0: pinctrl@f4000 {
 		compatible = "pinctrl-single";
-		reg = <0x00 0xf4000 0x00 0x2ac>;
+		reg = <0x00 0xf4000 0x00 0x2b0>;
 		#pinctrl-cells = <1>;
 		pinctrl-single,register-width = <32>;
 		pinctrl-single,function-mask = <0xffffffff>;
-- 
2.39.5



