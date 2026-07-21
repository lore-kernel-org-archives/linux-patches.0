Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E53D3EEAC7;
	Tue, 21 Jul 2026 19:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661539; cv=none; b=PpuRnRfZ/zdTRQmhN5qZhjbVZUANCZZWA9zWXc/+2lstEQBwg6hXrEQJoUVtz7uFhnA1TVKlO1unpPnCTzzRa4oDYwszAiRCB5Uen0VtOhcgG33egFmG677rK5oA/5GlEq5gTXi7cHAFBjnESmLAxtKIlI8lcCkUvpL2N/JfHiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661539; c=relaxed/simple;
	bh=Zc5/2pkPNuCcSnLA4vUnTdnqHZLYlbovgQaOhQz3z0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoU8XweRtix3oYD75c+Cxe0KwcJW7A34tvQHemboydDD+mC5aM+g1hkAMJNDgvUwFIAbcFwX7h8fG9ngFj7ErJfvGAGyZ0LhMSSNgymd9CaUKWxuO2HZmEeWSf1RgJRzkSjSkqqzgUBCYYPBVPZpyRvjXS1b+8XDd4lJEEC+0gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4C2pevU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4C2pevU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40001F00A3A;
	Tue, 21 Jul 2026 19:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661537;
	bh=UnmS77gCh8f55gmj7ifSm2SOZsbgXJYngtz9MscUI9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4C2pevU70MD2l2/0+T5LxrQ9wPaHtGjP5EPU75PIG5v48yf6q3Wnp6Cz5TQyVnhs
	 7ULgO4mC9CI4t5WZ+NnkdlEwZKt3cJsGM8c0X8N20jV38PR99bso1W4WSmTPGEITkL
	 9katX8vr6kU0bGLErKelGCip8qDyc2/m4I9GaGl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0105/1276] arm64: dts: mediatek: mt8192-asurada: Move PCIe DMA bounce buffer to host
Date: Tue, 21 Jul 2026 17:09:08 +0200
Message-ID: <20260721152448.446950660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 533275a4b5240a2bf2c592bd4536560388306d26 ]

The DMA bounce buffer is attached to the PCIe host controller, i.e. all
PCIe DMA transfers should use it.

Move it from the PCIe (WiFi) device node down to the PCIe host
controller node.

Fixes: 0dca9f0b3e63 ("arm64: dts: mediatek: asurada: Enable PCIe and add WiFi")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi b/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
index ad52c1d6e4eef7..aa12a14aabf611 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
@@ -515,6 +515,7 @@ flash@0 {
 &pcie {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pcie_pins>;
+	memory-region = <&wifi_restricted_dma_region>;
 
 	pcie0: pcie@0,0 {
 		device_type = "pci";
@@ -529,7 +530,6 @@ pcie0: pcie@0,0 {
 		wifi: wifi@0,0 {
 			reg = <0x10000 0 0 0 0x100000>,
 			      <0x10000 0 0x100000 0 0x100000>;
-			memory-region = <&wifi_restricted_dma_region>;
 		};
 	};
 };
-- 
2.53.0



