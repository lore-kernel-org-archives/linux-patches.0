Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CD9268FFA;
	Tue,  8 Apr 2025 11:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110632; cv=none; b=UKwhoqlbmsvBJd7e+/7YoNetrL7M33bXzPQiQ/pub+BACU+DT0+vbZxAx07Q3aW+GV1kyzDdXtGuGLUisgfrh31ZjbMS8WkGMuNfOfLs+9qlvJfaAjPjsrzpnXtTZh09M41jwRwuZiLKw0B4R19yW34z3qiherV3c0lDqI7F+gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110632; c=relaxed/simple;
	bh=i2zbGueRLNb3ntz6sUenxTXj+4mlhTE/H+5395ATVQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngrOC3+a14L+Uc8g372utau2FAQjkf9wyyRTCZbnD/2ssFH+ikYKJ0mw2yFvHAUdrLpjHWd1Z/Dycl2lFtJd8zbPuw8+S5RW83BGr7MEl7J6LzdIFaKcRG5qYOi053CHfKpdBlCw1G2eZ7vQu6oSLWhG8nwmocc+8vsSdhphqjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHPl/Xj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHPl/Xj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE37C4CEE5;
	Tue,  8 Apr 2025 11:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110632;
	bh=i2zbGueRLNb3ntz6sUenxTXj+4mlhTE/H+5395ATVQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHPl/Xj8jVuEcSob93zInlqzguvIXdVDi029DDjfBk0V+pK5wNzuaEArOEf6um5Da
	 +sWb151f2IFuBEB5uQzMA/iwqp2Xbo+VBQyjeCEB6++DJTii0PwPA0B8JjecTGtA+h
	 skuJsKp7wRGwXY5V7dI2/8bWTJvU6luSFgrUAHik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 137/731] arm64: dts: ti: k3-am62p: Enable AUDIO_REFCLKx
Date: Tue,  8 Apr 2025 12:40:34 +0200
Message-ID: <20250408104917.465570578@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 6a02c9aa222ce0fff47f526686690f84b7a97f4e ]

On AM62P-based SoCs the AUDIO_REFCLKx clocks can be used as an input to
external peripherals when configured through CTRL_MMR, so add the
clock nodes.

Link: http://downloads.ti.com/tisci/esd/latest/5_soc_doc/am62px/clocks.html
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20250206153911.414702-1-francesco@dolcini.it
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Stable-dep-of: 33bab9d84e52 ("arm64: dts: ti: k3-am62p: fix pinctrl settings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62p-main.dtsi | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am62p-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62p-main.dtsi
index 420c77c8e9e5e..4b47b07743305 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62p-main.dtsi
@@ -42,6 +42,26 @@
 	ti,interrupt-ranges = <5 69 35>;
 };
 
+&main_conf {
+	audio_refclk0: clock-controller@82e0 {
+		compatible = "ti,am62-audio-refclk";
+		reg = <0x82e0 0x4>;
+		clocks = <&k3_clks 157 0>;
+		assigned-clocks = <&k3_clks 157 0>;
+		assigned-clock-parents = <&k3_clks 157 16>;
+		#clock-cells = <0>;
+	};
+
+	audio_refclk1: clock-controller@82e4 {
+		compatible = "ti,am62-audio-refclk";
+		reg = <0x82e4 0x4>;
+		clocks = <&k3_clks 157 18>;
+		assigned-clocks = <&k3_clks 157 18>;
+		assigned-clock-parents = <&k3_clks 157 34>;
+		#clock-cells = <0>;
+	};
+};
+
 &main_pmx0 {
 	pinctrl-single,gpio-range =
 		<&main_pmx0_range 0 32 PIN_GPIO_RANGE_IOPAD>,
-- 
2.39.5



