Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E65939A27B;
	Wed,  3 Dec 2025 16:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780823; cv=none; b=DT/Avg2MIT59sRz2r0/7z6vWX7/OWmXKg6bh1P79h2JNxbqdEi9axPTnbuNWyRBMVJJfvnRdqkQwVVmbwth//qbWXPC5gmE1YFvbiVtcUTUIkEHZWPRUZU+Y1YOFYSEHkBXxvcNlB4afGns9Rl/mjIw3CP4vuCbmpu0css4N/QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780823; c=relaxed/simple;
	bh=9bbMl+VR//pz9hOQjx6eQmrkN9HOBfIlgGzUTjpvhbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkZEAfd/3XNKhyJ/Lb2TaW8qllsFOCkhcyWBp7yDu3ZAEwcJqP0H61vJrog7nxlohM2pWlI7Gw4ih7xEVW56jsyXni6XIJtDkCt0ujOP9yiPBIomHeBFHll4Qd0hFVkgcIyGfx+QCO/bQpnGo2pX6T73IypKLA1QDtV8oLzIxDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCooicbO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCooicbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BD4C4CEF5;
	Wed,  3 Dec 2025 16:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780822;
	bh=9bbMl+VR//pz9hOQjx6eQmrkN9HOBfIlgGzUTjpvhbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCooicbOdhHsynfIRQRzS0DF0jGewx2owWxjV2cYXbB4YpvmzCu1iBCT58bZWhdNo
	 rpPJugeBgCFT9PG7o3t9Uh/xqz+hfyHWZJlplbYBYQMrBrIG6aOOxUz0ReNnA0rlNt
	 kBsSyw4/v1w6TyFjKg/YJx9owOlDtX+njgks+1ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Alexander Dahl <ada@thorsis.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.12 067/132] arm64: dts: imx8dxl-ss-conn: swap interrupts number of eqos
Date: Wed,  3 Dec 2025 16:29:06 +0100
Message-ID: <20251203152345.779604914@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit 5b6677d6451bbbac3b6ab93fae6506b59e2c19bd upstream.

Swap interrupt numbers of eqos because the below commit just swap
interrupt-names and missed swap interrupts also.

The driver (drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c) use
interrupt-names to get irq numbers.

Fixes: f29c19a6e488 ("arm64: dts: imx8dxl-ss-conn: Fix Ethernet interrupt-names order")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Tested-by: Alexander Dahl <ada@thorsis.com>
Cc: stable@vger.kernel.org
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi
@@ -27,8 +27,8 @@
 		compatible = "nxp,imx8dxl-dwmac-eqos", "snps,dwmac-5.10a";
 		reg = <0x5b050000 0x10000>;
 		interrupt-parent = <&gic>;
-		interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-names = "macirq", "eth_wake_irq";
 		clocks = <&eqos_lpcg IMX_LPCG_CLK_4>,
 			 <&eqos_lpcg IMX_LPCG_CLK_6>,


