Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F389379C3C;
	Tue, 21 Jul 2026 15:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648403; cv=none; b=f6ANPzxg2rqlA2g8CW/E+S3gcl5d6OuXnjZPyLIFxI/7hbGmsjoeJZH/0f3GIz3XBFRE6ETUlR7KSJenJvcIeTvQ4DLpehYDAKwlkoHl6mFci+3TRAAYgjE3LNFzFLhO/XLoKkS+IfIWwV+BUfNp2laje9+SCY+CycT8Vb3wu6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648403; c=relaxed/simple;
	bh=cE5VlByDkY42eakG710RJwgeHnIXg+fvrmAcaYMD2FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szUOMPQIQzTeoDukJytSlYWBoVpFjGodzSy2UvTdIjMWKLNvmwjS2Jz7TTitP1dXImRnr9Sl+bqqCmx7biINNbGylqT4h90T2LAAjNKlS2IDYBBg5S42jrWaoFiPu5yVOYx+PXLpLJnuFadlMXk5K+kNeH/dVZLOK2wV6dXzYx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9Xfme52; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9Xfme52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D131F000E9;
	Tue, 21 Jul 2026 15:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648402;
	bh=csdNEubSA6NXyLUZPwtza+JZeMIyeYmun10axyMdHYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d9Xfme52Kpdt9YpFbsPngeePGM0V/FkOK/I6b3v4hC0rfqjSJxrzf47Sjx7a/J57g
	 ZwPkgOP6ofjfHM0NN/gcMzu1Ix5junRvFcs06CLLbvtPDoUTcIDLha7/xtCkIaiKCG
	 5NUMQelrKrdQplzsMacCPXXkv2cS5a4rXlq/ZcQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0187/2077] arm64: dts: mediatek: mt8192-asurada: Move PCIe DMA bounce buffer to host
Date: Tue, 21 Jul 2026 16:57:40 +0200
Message-ID: <20260721152557.094886442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index eadf1b2d156f29..95d4db2b797941 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
@@ -525,6 +525,7 @@ flash@0 {
 &pcie {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pcie_pins>;
+	memory-region = <&wifi_restricted_dma_region>;
 
 	pcie0: pcie@0,0 {
 		device_type = "pci";
@@ -539,7 +540,6 @@ pcie0: pcie@0,0 {
 		wifi: wifi@0,0 {
 			reg = <0x10000 0 0 0 0x100000>,
 			      <0x10000 0 0x100000 0 0x100000>;
-			memory-region = <&wifi_restricted_dma_region>;
 		};
 	};
 };
-- 
2.53.0



