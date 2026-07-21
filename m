Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008C3386571;
	Tue, 21 Jul 2026 17:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655777; cv=none; b=kjn4e63Kf4vZ6XFIrZb2xhkkU2oWRnl3hQOETkQq7NrOAXrwPCfckuBDL9GT1QM7UzLhBo78TxbJw21MRqCPtCniZwly6v78qWYw8N5nn94+m4VmwUrbqJVLTvwiM9OMJ4hX/ySf0M25u7mf9lhrwnzJBbE01pgN1db3KW9j7to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655777; c=relaxed/simple;
	bh=RyueFDQzgPjBmMBn/6q7PaMmEjbq0Lgo/LKBsp28pNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Km65BZT92cogH/S67fLxL8rE6xkoner7Wt9T7lVt/+izi7d9GVCu5BEnO+F+CX+1xFjLN/55m6+vbFmWWueAxxWxjLV/euI2hP8NAY/RGvlM8bPXkBP7BGfl7KFIBRWs7UzEA0G1N+WhRMn/Etkdx52MHBjWhMJA0U1jvZuYzds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZV49oSC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZV49oSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DCA1F000E9;
	Tue, 21 Jul 2026 17:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655775;
	bh=WqOXrAA1XAVxTqXHlfw1nF6ADbtMDDh7dHiYyM9nwmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZV49oSCCR7HNanK0of4l3Upf5Uu9Ll9cq4t7UAjF3U4IvnNGPp1WPiHWQ8reUBcE
	 JAvQTFxBjtu6ycjAs+dTQYLCvgCRd/zkHRxxR4mbFkFs7b67z+YLvGHBQkApdRdZoA
	 irTH/uhjFS4uI3ihVoLgz0xd7c++KMnugWkNeKUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0135/1611] arm64: dts: mediatek: mt8192-asurada: Move PCIe DMA bounce buffer to host
Date: Tue, 21 Jul 2026 17:04:11 +0200
Message-ID: <20260721152517.911837058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 0b4664f044a159..ff2eb9e10f3643 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
@@ -526,6 +526,7 @@ flash@0 {
 &pcie {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pcie_pins>;
+	memory-region = <&wifi_restricted_dma_region>;
 
 	pcie0: pcie@0,0 {
 		device_type = "pci";
@@ -540,7 +541,6 @@ pcie0: pcie@0,0 {
 		wifi: wifi@0,0 {
 			reg = <0x10000 0 0 0 0x100000>,
 			      <0x10000 0 0x100000 0 0x100000>;
-			memory-region = <&wifi_restricted_dma_region>;
 		};
 	};
 };
-- 
2.53.0



