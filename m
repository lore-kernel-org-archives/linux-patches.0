Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74322419FC9;
	Sat, 12 Sep 2026 10:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209847; cv=none; b=IqG44WWz3cMfKOQA4DjCsow+0mydld6puyK9Jwrl5WbCirpQml/FTLkraW5vUzlstJZsGZ5vC4MyG+spXEBTFIzZWGJY19DhbHY6zNzClmmvVRO2QCpLe1m3kkVB6yo4lO/kjdRV/LmNp739d0incu9tbplv0eqjAnhKecOXHIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209847; c=relaxed/simple;
	bh=7mDqnNWYc16uBhELdQc5PkOHTNr0eCq3KYN8wHjxelg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bY6cLO4h19stqwaYEXDUhyj8d+MXaekBX7HRFNd8LcU+WHvV+0N+TxHQnajqlOEa3rt/PCauMBi6dFziPbkBSpOmKJFTEfrRUz8Rb38f71EOJ2osl1gieffiQjjWTMlXkPhs7TTJYx93WN58SUkrrVZ/c/KkuKQU40cybmg8D6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skm9p1Jf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skm9p1Jf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1D71F000FF;
	Sat, 12 Sep 2026 10:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209846;
	bh=GFlLLZTWZx4R0oVOcuGumsKA8Hvdyg0B1MPINeCQZgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=skm9p1Jf8rnz57dfT7nMUwRte+BAmLBzU/TvmSVV3yhoJEC0kf1MQTAgZaiNqcAt4
	 6zuIoHc+vmKEsIXEpeqUdDY5nUyh/ZWozdarOS6w2xe4lkkqFNk3h/P1TL2rhjudlL
	 7/vPjuDOGLXhLr9HskOUCNO8czEfa9fiokumFZNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Charkov <alchark@flipper.net>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0904/1518] clk: rockchip: rk3576: fix source muxes for SPI0..SPI4
Date: Sat, 12 Sep 2026 08:51:13 +0200
Message-ID: <20260912065643.903823649@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Charkov <alchark@flipper.net>

[ Upstream commit 586ff159ec02533c17dd928641529cb0b52e9c62 ]

The TRM defines available source muxes for SPI0..SPI4 as
 - b00: clk_gpll_div6_src
 - b01: clk_gpll_div8_src
 - b10: clk_cpll_div10_src
 - b11: clk_xin_osc0_func

Which doesn't match what the current clock driver implements, making it
impossible to derive some SPI clock rates such as 37.125 MHz (which
requires clk_gpll_div8_src as the source mux).

Add a correct mux definition per TRM and point SPI0..SPI4 clocks at it.

Fixes: cc40f5baa91b ("clk: rockchip: Add clock controller for the RK3576")
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Link: https://patch.msgid.link/20260805-rk3576-spi-clk-v1-1-2f040d0d163b@flipper.net
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3576.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3576.c b/drivers/clk/rockchip/clk-rk3576.c
index 9bc0ef51ef682..95693e4381430 100644
--- a/drivers/clk/rockchip/clk-rk3576.c
+++ b/drivers/clk/rockchip/clk-rk3576.c
@@ -315,6 +315,7 @@ PNAME(mux_100m_24m_lclk0_p)		= { "clk_cpll_div10", "xin24m", "lclk_asrc_src_0" }
 PNAME(mux_100m_24m_lclk1_p)		= { "clk_cpll_div10", "xin24m", "lclk_asrc_src_1" };
 PNAME(mux_150m_100m_50m_24m_p)		= { "clk_gpll_div8", "clk_cpll_div10", "clk_cpll_div20", "xin24m" };
 PNAME(mux_200m_100m_50m_24m_p)		= { "clk_gpll_div6", "clk_cpll_div10", "clk_cpll_div20", "xin24m" };
+PNAME(mux_200m_150m_100m_24m_p)		= { "clk_gpll_div6", "clk_gpll_div8", "clk_cpll_div10", "xin24m" };
 PNAME(mux_400m_200m_100m_24m_p)		= { "clk_gpll_div3", "clk_gpll_div6", "clk_cpll_div10", "xin24m" };
 PNAME(mux_500m_250m_100m_24m_p)		= { "clk_cpll_div2", "clk_cpll_div4", "clk_cpll_div10", "xin24m" };
 PNAME(mux_600m_400m_300m_24m_p)		= { "clk_gpll_div2", "clk_gpll_div3", "clk_gpll_div4", "xin24m" };
@@ -706,19 +707,19 @@ static struct rockchip_clk_branch rk3576_clk_branches[] __initdata = {
 			RK3576_CLKGATE_CON(16), 0, GFLAGS),
 	GATE(PCLK_SPI4, "pclk_spi4", "pclk_bus_root", 0,
 			RK3576_CLKGATE_CON(16), 1, GFLAGS),
-	COMPOSITE_NODIV(CLK_SPI0, "clk_spi0", mux_200m_100m_50m_24m_p, 0,
+	COMPOSITE_NODIV(CLK_SPI0, "clk_spi0", mux_200m_150m_100m_24m_p, 0,
 			RK3576_CLKSEL_CON(70), 13, 2, MFLAGS,
 			RK3576_CLKGATE_CON(16), 2, GFLAGS),
-	COMPOSITE_NODIV(CLK_SPI1, "clk_spi1", mux_200m_100m_50m_24m_p, 0,
+	COMPOSITE_NODIV(CLK_SPI1, "clk_spi1", mux_200m_150m_100m_24m_p, 0,
 			RK3576_CLKSEL_CON(71), 0, 2, MFLAGS,
 			RK3576_CLKGATE_CON(16), 3, GFLAGS),
-	COMPOSITE_NODIV(CLK_SPI2, "clk_spi2", mux_200m_100m_50m_24m_p, 0,
+	COMPOSITE_NODIV(CLK_SPI2, "clk_spi2", mux_200m_150m_100m_24m_p, 0,
 			RK3576_CLKSEL_CON(71), 2, 2, MFLAGS,
 			RK3576_CLKGATE_CON(16), 4, GFLAGS),
-	COMPOSITE_NODIV(CLK_SPI3, "clk_spi3", mux_200m_100m_50m_24m_p, 0,
+	COMPOSITE_NODIV(CLK_SPI3, "clk_spi3", mux_200m_150m_100m_24m_p, 0,
 			RK3576_CLKSEL_CON(71), 4, 2, MFLAGS,
 			RK3576_CLKGATE_CON(16), 5, GFLAGS),
-	COMPOSITE_NODIV(CLK_SPI4, "clk_spi4", mux_200m_100m_50m_24m_p, 0,
+	COMPOSITE_NODIV(CLK_SPI4, "clk_spi4", mux_200m_150m_100m_24m_p, 0,
 			RK3576_CLKSEL_CON(71), 6, 2, MFLAGS,
 			RK3576_CLKGATE_CON(16), 6, GFLAGS),
 	GATE(PCLK_WDT0, "pclk_wdt0", "pclk_bus_root", 0,
-- 
2.53.0



