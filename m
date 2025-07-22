Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D5A2E1724;
	Tue, 22 Jul 2025 14:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193296; cv=none; b=a1+D9AjPssDZqkefNE0/3caWPzrfTKsDFEGgvci2Hq/sVBgz4m8CRFPyPC0F+7PfjDp8n49fM8M8viK4o0CIh2uk7V5DVwbrEBXQvfMJnuVf8dOK3nAmI4tewnR8gcnqvXH46rNUjl71SGVeQmo5BAoDp3v9WBsZyOCEpPaVrd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193296; c=relaxed/simple;
	bh=edxix39iVIEOv0hk2ApyviBgcy/Piuz/SSnfpjSuoRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZeDAtnKPBcwwGIttBW3WhcHcg2YvVQbfjwHzRxxXYMcaf0xrkUkigasmtef8+LMDeydtsy41CmGv5kTvXq0uwxjf7SUlSyxlMyNYvKwSEw0vSL2+DFg1rpqJiOL5YytTVUiyam06z+z4tujMhwgs75HcAniuGK5NI/BiRiU8AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wue6j1SF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wue6j1SF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619D7C4CEEB;
	Tue, 22 Jul 2025 14:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193295;
	bh=edxix39iVIEOv0hk2ApyviBgcy/Piuz/SSnfpjSuoRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wue6j1SF5citkwCcwRc4JjOQv/YlsA91hIiS55TL6MS+sRyWoRNGDOKaML2JDjCny
	 3YDBQjVVvquDTlhnsGSypXIk2kno7kb46tVF142fBBsB0SyhAlXMX88zntNbIOcE6m
	 NmyTm/3aZgJ6zsq5NkuRwxaZqFilerecJtq5pQhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meng Li <Meng.Li@windriver.com>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.15 050/187] arm64: dts: add big-endian property back into watchdog node
Date: Tue, 22 Jul 2025 15:43:40 +0200
Message-ID: <20250722134347.622953561@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

From: Meng Li <Meng.Li@windriver.com>

commit 720fd1cbc0a0f3acdb26aedb3092ab10fe05e7ae upstream.

Watchdog doesn't work on NXP ls1046ardb board because in commit
7c8ffc5555cb("arm64: dts: layerscape: remove big-endian for mmc nodes"),
it intended to remove the big-endian from mmc node, but the big-endian of
watchdog node is also removed by accident. So, add watchdog big-endian
property back.

In addition, add compatible string fsl,ls1046a-wdt, which allow big-endian
property.

Fixes: 7c8ffc5555cb ("arm64: dts: layerscape: remove big-endian for mmc nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
@@ -687,11 +687,12 @@
 		};
 
 		wdog0: watchdog@2ad0000 {
-			compatible = "fsl,imx21-wdt";
+			compatible = "fsl,ls1046a-wdt", "fsl,imx21-wdt";
 			reg = <0x0 0x2ad0000 0x0 0x10000>;
 			interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(2)>;
+			big-endian;
 		};
 
 		edma0: dma-controller@2c00000 {


