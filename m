Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9DB44AB97;
	Tue, 21 Jul 2026 21:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668766; cv=none; b=f+F73hCtxzFReZQdGQ3Nhy//VBGO4IRRgG7A4flJny99acZGqw2N5B0ERo3W2i0OsyMm8iC3qXLOLVgBrl7PM7VdbXXQ+4Jrjweqsc6Do+77WZou0XS81wnQZ0oq3lusspW4W5AMS9ItXCODiILVPuLEjBPXv02QKRo0aLIh8r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668766; c=relaxed/simple;
	bh=IndEYByR8kcVulr6w1nezU7QP+2FjgA+Cxwrk46VnFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUzgVf/tsxaslaj98lpLiCgt/rcfrELbNmVBapZrJtOnGPadB3LAIcRhfCF9M/wr5M73l7UCBd8wkluLG4/9JuOH+b19d3YkFoqUB6NlisYursMkjby7bhtxQSHNhMeFap9RfIvPikmwbyS2HhhGTzUn9kv8yvZh6HliWBXkNZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZWZ+rzk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZWZ+rzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA301F000E9;
	Tue, 21 Jul 2026 21:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668765;
	bh=niJx5u3BIAh2SHRs1NtCt6jcl8ZdNrMiczHjzYyP3TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZWZ+rzkZagMRcrwusl2kOa7Eb+lLpekZSvoSWWl+BlrtsrNq9YnKW18NnB7n5v7Z
	 sLTQFDSgn2ueaq5wbQqdRkyP3lAG8NUgZMsxn12qpJibHMfIwy3IHzQjj1HvEon1+o
	 mxwqdTdil7lrgvl6SFPYLS+o3Q/LAObmvsAAR4BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0301/1067] arm64: dts: mediatek: mt8192-asurada: Move PCIe DMA bounce buffer to host
Date: Tue, 21 Jul 2026 17:15:02 +0200
Message-ID: <20260721152431.331303647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7e5230581a1c76..738ea2100a25ab 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
@@ -261,6 +261,7 @@ flash@0 {
 &pcie {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pcie_pins>;
+	memory-region = <&wifi_restricted_dma_region>;
 
 	pcie0: pcie@0,0 {
 		device_type = "pci";
@@ -275,7 +276,6 @@ pcie0: pcie@0,0 {
 		wifi: wifi@0,0 {
 			reg = <0x10000 0 0 0 0x100000>,
 			      <0x10000 0 0x100000 0 0x100000>;
-			memory-region = <&wifi_restricted_dma_region>;
 		};
 	};
 };
-- 
2.53.0



