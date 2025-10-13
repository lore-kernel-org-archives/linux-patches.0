Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C88E3081AE;
	Mon, 13 Oct 2025 15:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369159; cv=none; b=ndxx/R+Rls9gXT3cdU2dqRAkqe+fc7a0Bo830QTXGNHjyIPiPawjfndjvU6HzZ1/HjgHxtwZGMVJD91IaX7whMBMuN/xaxQ0erxQD4l8Z2Pzxk9OWeVtGcwj7czlDMV2KpdJVfSR8qFPo5mSBIUBBgrQ7DWmWKEy3rMt4Ror7VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369159; c=relaxed/simple;
	bh=IhQL0EEB/qp12jsKNEs4tBDgEtyGN91y6J/gULrLqn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9UXtq42cRRE38ZuuzQWlLULySWqD1LetVyImELPhz2Eks88xiOy5bGELqFt53sBgYSHvdLHEjGf6ZzOm+1pUQnm8E4FLbFXARBhPe0gyr976gV3zM9rh7Pl0tx2wDTQuJZMSZskd3O3VsZa7lkQbawR9UPPefPH3z2zg0csW2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cko0GSnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cko0GSnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD96EC4CEE7;
	Mon, 13 Oct 2025 15:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369159;
	bh=IhQL0EEB/qp12jsKNEs4tBDgEtyGN91y6J/gULrLqn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cko0GSnKDXZEUxvVGVEDy2+8+197LQnnmpVxSpq6HPv3X0RF0gFsv9s9FRGwBkXfQ
	 ATL+LXgVMpQjMf0W49ILPgTH9DPtbamnFp4dkS4L2yiJ96SdPuNX1g06V5YMWcxXmc
	 haN+ioJcNXKFYG5WwIaz+T0/7WjsiAljjO8/5kGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Fei Shao <fshao@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 148/563] arm64: dts: mediatek: mt7986a: Fix PCI-Express T-PHY node address
Date: Mon, 13 Oct 2025 16:40:09 +0200
Message-ID: <20251013144416.652594074@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 6b3fff78c13f1a2ba5a355a101fa1ca0a13054ad ]

The PCIe TPHY is under the soc bus, which provides MMIO, and all
nodes under that must use the bus, otherwise those would clearly
be out of place.

Add ranges to the PCIe tphy and assign the address to the main
node to silence a dtbs_check warning, and fix the children to
use the MMIO range of t-phy.

Fixes: 963c3b0c47ec ("arm64: dts: mediatek: fix t-phy unit name")
Fixes: 918aed7abd2d ("arm64: dts: mt7986: add pcie related device nodes")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Fei Shao <fshao@chromium.org>
Link: https://lore.kernel.org/r/20250724083914.61351-24-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 559990dcd1d17..3211905b6f86d 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -428,16 +428,16 @@ pcie_intc: interrupt-controller {
 			};
 		};
 
-		pcie_phy: t-phy {
+		pcie_phy: t-phy@11c00000 {
 			compatible = "mediatek,mt7986-tphy",
 				     "mediatek,generic-tphy-v2";
-			ranges;
-			#address-cells = <2>;
-			#size-cells = <2>;
+			ranges = <0 0 0x11c00000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			status = "disabled";
 
-			pcie_port: pcie-phy@11c00000 {
-				reg = <0 0x11c00000 0 0x20000>;
+			pcie_port: pcie-phy@0 {
+				reg = <0 0x20000>;
 				clocks = <&clk40m>;
 				clock-names = "ref";
 				#phy-cells = <1>;
-- 
2.51.0



