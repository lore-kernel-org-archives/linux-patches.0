Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECEC2C327B;
	Mon,  2 Jun 2025 14:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872849; cv=none; b=cwGAPWTcNMxYMYLk+4v0PvGk37xdgQEqukgbvvxXGVOv46zyD5D515CZdJ9UkxT1YyEiV5LMzRPC98q2XxGW31kMDETgFNSmOREQo3livt7Gy4gYjGzUil9VzKd6+13YM3pECCh70yudZ/bzIHHFzgYgZmuvpJOqHKJP4pnqMKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872849; c=relaxed/simple;
	bh=XABGkuuwMKZN1adBkDPBI+URQbXVO7LeMGOYxOl2cqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3cHcR/RiJR1Pin+clBuzhoWQMd572MiSI+QsVqNKiWZWxRY6tLUoQOwlnPavll+2TFUdJBUoSjS0uqV/eTTGwCQvxm3wh1BEwRMqa5AT91cUN+rkEanpgf7xBYKF8cbHDjTO4ja0FXjadbBErUkIqmD36VwTT+MuX3zEz7c0ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lA+xeOmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lA+xeOmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B285C4CEEB;
	Mon,  2 Jun 2025 14:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872848;
	bh=XABGkuuwMKZN1adBkDPBI+URQbXVO7LeMGOYxOl2cqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lA+xeOmnzB0/jGgqj2bxc5+x9OWp+IRpYdcZPyCMbk+iV1OFpCVvsxkrTtcEDpqrX
	 90Do0vAqt6JDocRbQEA+/OmuPn+A5x1fptKv/6CIr3R1DjxzhacZ3YcnukxqJMb9N8
	 aQ3U91ao87VP+o50o/5EC6TulQJKKl/UXlIm5/gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.12 15/55] arm64: dts: ti: k3-am62-main: Set eMMC clock parent to default
Date: Mon,  2 Jun 2025 15:47:32 +0200
Message-ID: <20250602134238.883599740@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

commit 3a71cdfec94436079513d9adf4b1d4f7a7edd917 upstream.

Set eMMC clock parents to the defaults which is MAIN_PLL0_HSDIV5_CLKOUT
for eMMC. This change is necessary since DM is not implementing the
correct procedure to switch PLL clock source for eMMC and MMC CLK mux is
not glich-free. As a preventative action, lets switch back to the defaults.

Fixes: c37c58fdeb8a ("arm64: dts: ti: k3-am62: Add more peripheral nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Acked-by: Udit Kumar <u-kumar1@ti.com>
Acked-by: Bryan Brattlof <bb@ti.com>
Link: https://lore.kernel.org/r/20250429163337.15634-2-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
@@ -552,8 +552,6 @@
 		power-domains = <&k3_pds 57 TI_SCI_PD_EXCLUSIVE>;
 		clocks = <&k3_clks 57 5>, <&k3_clks 57 6>;
 		clock-names = "clk_ahb", "clk_xin";
-		assigned-clocks = <&k3_clks 57 6>;
-		assigned-clock-parents = <&k3_clks 57 8>;
 		bus-width = <8>;
 		mmc-ddr-1_8v;
 		mmc-hs200-1_8v;


