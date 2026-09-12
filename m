Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5A62E718B;
	Sat, 12 Sep 2026 07:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198429; cv=none; b=lQgVX6wVqLe1CgG634dPmrlNDy964kY93qzEdwcdOZDLxduc1cuOvMJlBJ8j7b7u4ry2YuxY7FdYeEYh324OpL+G5doBOakMzQVqvdb7vpvIt3dciVp4a9xNJGCFaNMZ/FzL98prpX0XlEbT/8GwGXudBo6GgBKcZVCML3Hi/eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198429; c=relaxed/simple;
	bh=2oeXu91w966C0o9bRWAnkZygLTuk/3Bh0OLQVzBE0Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psfEBYcOZ0lkM+4m3PhdGrecLQW5+9nAz5Kb3GAkAuoq4ciV+21lF2hWUjBPxtah6Cu3U38GsRjpEA803/GmydH2BAaTuyya7gf/8tqcJWPNpH/IwQOcRBerR5Wllnnotfe6xAQS9au85KASGHgrxD2OckXVcbJ2Wg1tN+bHt9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXHwqyit; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXHwqyit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FB91F000FF;
	Sat, 12 Sep 2026 07:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198427;
	bh=Td9PFJqeW/gamXBqaX3ZNIiobaeNQ3CqtQY57I5cNLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FXHwqyit8hz/TZi4NzYLbWUal0uL15VXEstf4Fu6AJAQ7HBA3AFTJIVy3We3mwk6Y
	 Hz31ONOLD/g4HK2cCaHIPRU6bLicmaNslxfeseDPyq99+P8YBXPG5XNtoUJwp4oRDj
	 s39EglFkIZipTJtFVn936y63PAFu92E14uz4Dvqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0379/1815] arm64: dts: renesas: r9a09g047: Fix PCIe dma-ranges memory space code
Date: Sat, 12 Sep 2026 08:35:29 +0200
Message-ID: <20260912065657.797282099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 24afcb87e6aca1ff3face276223eeea0012f8e2b ]

The RZ/G3E SoC supports up to 8 GiB of memory. Update the PCIe dma-ranges
property to use the 64-bit prefetchable memory space code.

Fixes: 1ac57c9830cb ("arm64: dts: renesas: r9a09g047: Add PCIe node")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260708172849.227915-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a09g047.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g047.dtsi b/arch/arm64/boot/dts/renesas/r9a09g047.dtsi
index b48da8534a3df..b6193c1583706 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g047.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a09g047.dtsi
@@ -931,7 +931,7 @@ pcie: pcie@13400000 {
 			reg = <0 0x13400000 0 0x10000>;
 			ranges = <0x02000000 0 0x30000000 0 0x30000000 0 0x08000000>,
 				 <0x43000000 4 0x40000000 4 0x40000000 6 0x00000000>;
-			dma-ranges = <0x42000000 0 0x40000000 0 0x40000000 2 0x00000000>;
+			dma-ranges = <0x43000000 0 0x40000000 0 0x40000000 2 0x00000000>;
 			bus-range = <0x0 0xff>;
 			interrupts = <GIC_SPI 800 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 801 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.53.0



