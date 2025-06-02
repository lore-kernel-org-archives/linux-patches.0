Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316B71A3A80;
	Mon,  2 Jun 2025 13:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872141; cv=none; b=r5l6hFkQ1cmyhcsgnh1Kb01j1mf33zFoLQkckAJVmkhN4xO9zp1h7oig+5D7pSChtT04wnI9ZUfDRM6pYRVqKvBZopQv+RDyRJWmmhkPkXJ3eddhegUwS4YmpKi5EYBpd+6gtCk1A/i8yFfmSNzQo9RH74I1rBn3RMwM/n6aVfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872141; c=relaxed/simple;
	bh=wJp4ExIoQrHIuiIQ30cULMhE0xbqMvCpBkJQbCSGqtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJw+g7vE59CD8O9Ki8p23Wi6+LC7UU+Ey2GdtbHY1brY5Jj3Y95uVYu5smDZ3VEUsitJ05DrCQLn42lJe7LxL/ouj/0BQfbvYHVAugZCv2DBb4AHf3yBX7WN+nz1nh+ddSsf9uHEY7uvTpF7rIHvHl/EJMDgGQnON9xaZyk4+x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqpnfFoq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqpnfFoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9CDC4CEEB;
	Mon,  2 Jun 2025 13:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872139;
	bh=wJp4ExIoQrHIuiIQ30cULMhE0xbqMvCpBkJQbCSGqtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqpnfFoqihjr6Z2X76XUo7JUllIYKIXG9hS0AZH010/3Jazkgkn/sAnTbGsQclKJd
	 7WsRkrauPiaPtLTs3TuD9AxSQ5S0k4loRretSAXrf9eDNhK9m7IPhHf+qMEk8FOYHT
	 3dkbDGNxUXIE/YOJR8eNMxmWpbjMehWkd1JcPg/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.15 03/49] arm64: dts: rockchip: Add missing SFC power-domains to rk3576
Date: Mon,  2 Jun 2025 15:46:55 +0200
Message-ID: <20250602134238.075434733@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
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

From: Sebastian Reichel <sebastian.reichel@collabora.com>

commit ede1fa1384c230c9823f6bf1849cf50c5fc8a83e upstream.

Add the power-domains for the RK3576 SFC nodes according to the
TRM part 1. This fixes potential SErrors when accessing the SFC
registers without other peripherals (e.g. eMMC) doing a prior
power-domain enable. For example this is easy to trigger on the
Rock 4D, which enables the SFC0 interface, but does not enable
the eMMC interface at the moment.

Cc: stable@vger.kernel.org
Fixes: 36299757129c8 ("arm64: dts: rockchip: Add SFC nodes for rk3576")
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20250520-rk3576-fix-fspi-pmdomain-v1-1-f07c6e62dadd@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3576.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/rockchip/rk3576.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
@@ -1364,6 +1364,7 @@
 			interrupts = <GIC_SPI 255 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cru SCLK_FSPI1_X2>, <&cru HCLK_FSPI1>;
 			clock-names = "clk_sfc", "hclk_sfc";
+			power-domains = <&power RK3576_PD_SDGMAC>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			status = "disabled";
@@ -1414,6 +1415,7 @@
 			interrupts = <GIC_SPI 254 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cru SCLK_FSPI_X2>, <&cru HCLK_FSPI>;
 			clock-names = "clk_sfc", "hclk_sfc";
+			power-domains = <&power RK3576_PD_NVM>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			status = "disabled";


