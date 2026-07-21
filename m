Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19843471425;
	Tue, 21 Jul 2026 20:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665676; cv=none; b=af8jjurbduUuOcQKR4ywMgXA633YalZ14HtW48bqxfMv0TKTlLVjx1f+cTwl2exGqC5W5hjkQY8/VgwRz3xtR0StOsmXLYAt2fHSBNFN6yrdtUO7cmZJyOP96GWThVekUOEadIorsGMo2J46D6d7ziFyzTdn+FfK3x4OCZnXjKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665676; c=relaxed/simple;
	bh=EqFaSOqerj8UuI7ZzH+VEAB5O4GjtD7aHWk6SRhGpzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGnGpfPUkLrlXc0i8UbGJJGrLBFRusBtcPpFVbS4Cyp8xqh7JL5GwgyoxT6qYx0GlI8kdUJHEf7IyPbhPJsiBsTmszSnli9Ja2bhI8zrVYcmvrA1BuUotEK1lzSgnJJW/6RIwGHG+jSGiKzjn9jrdpj3ziPgGF7OZuR3hgtC98g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnbLv6vd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnbLv6vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318B61F00A3A;
	Tue, 21 Jul 2026 20:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665673;
	bh=CzPHwFF9cKzoU9MAxiMZYKFcLu7hAjVgYX3CxjFEclE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnbLv6vdY/1ftWSH2ZymBq+taiRSwzWF10CdJ24vXuS6AJtsx15ZEibauApLbddQE
	 kgi4z2NVp2Y6w05A0z/3UMAmrKkxqPjogowTk3MxpQE+d0OSawDyrgwqDflErP981k
	 IEZStgO2QuMQEf4tQTWw18bdmpgl0E12kgM/3jB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0393/1266] arm64: dts: mediatek: mt8192-asurada: Move PCIe DMA bounce buffer to host
Date: Tue, 21 Jul 2026 17:13:50 +0200
Message-ID: <20260721152450.621289914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 54e3ec168fa9a4..0788db329b785e 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
@@ -494,6 +494,7 @@ flash@0 {
 &pcie {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pcie_pins>;
+	memory-region = <&wifi_restricted_dma_region>;
 
 	pcie0: pcie@0,0 {
 		device_type = "pci";
@@ -508,7 +509,6 @@ pcie0: pcie@0,0 {
 		wifi: wifi@0,0 {
 			reg = <0x10000 0 0 0 0x100000>,
 			      <0x10000 0 0x100000 0 0x100000>;
-			memory-region = <&wifi_restricted_dma_region>;
 		};
 	};
 };
-- 
2.53.0



