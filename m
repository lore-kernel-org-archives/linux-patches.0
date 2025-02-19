Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C861DE2CE;
	Wed, 19 Feb 2025 09:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956383; cv=none; b=H4ydUYH1tTYTMw04uEcylkvytf7In+gyEMBHqa1664k7WO+0P/7/ZLfiSCqvTDFbIySZWL2sIFwOMIIPDEvj3Fx6njYLlwHqune2slfalgg6I8STIBEyXLyVphC7lT2lSCHgkxqrNXHJXbXJqp9eCt8/+cKSzM1Hjd7RKlOGVss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956383; c=relaxed/simple;
	bh=oBANmfEI9w3uR9pJ8Q392T8Pxae4BPpEMxn2PdkhRho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCJ/o3TrpIbSd2EGUUbeRgywJZdjkPkTRTC+F/4H10DN+x/WDeGTLUZoTTw16+ZFAC/T3LYPh07TPBZ/G1Uz45nskiQsCT8+OWJMVhpnMG5pLO12CjJKEfpWuSt2Bh8WOyuxuIdPpsGaIyJbfSt0gjr4XOE0DZO622YbYf0QBQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iREDuSGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iREDuSGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37C1C4CED1;
	Wed, 19 Feb 2025 09:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956383;
	bh=oBANmfEI9w3uR9pJ8Q392T8Pxae4BPpEMxn2PdkhRho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iREDuSGvA+AjJm+zob87p/ry70RGtaOXHCdh0cjPoko4xOBLws6acAugaDULizSJL
	 5ZHaEjaYqBQNmX8L0Xko5zUzQ218K9IZE/S2yXtVCQrSSd6mgArR3to8AzPDrQ3at3
	 JuPXFwGTlzS5N6mThR5r8azEy7BXRgQzObtoIX9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/578] arm64: dts: mediatek: mt8192-asurada: Drop regulator-compatible property
Date: Wed, 19 Feb 2025 09:22:27 +0100
Message-ID: <20250219082658.608137496@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit d1fb968551c8688652b8b817bb081fdc9c25cd48 ]

The "regulator-compatible" property has been deprecated since 2012 in
commit 13511def87b9 ("regulator: deprecate regulator-compatible DT
property"), which is so old it's not even mentioned in the converted
regulator bindings YAML file. It should not have been used for new
submissions such as the MT6315.

Drop the "regulator-compatible" property from the board dts. The
property values are the same as the node name, so everything should
continue to work.

Fixes: 3183cb62b033 ("arm64: dts: mediatek: asurada: Add SPMI regulators")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241211052427.4178367-5-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi b/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
index 0814ed6a7272d..7e5230581a1c7 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
@@ -901,7 +901,6 @@
 
 		regulators {
 			mt6315_6_vbuck1: vbuck1 {
-				regulator-compatible = "vbuck1";
 				regulator-name = "Vbcpu";
 				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
@@ -911,7 +910,6 @@
 			};
 
 			mt6315_6_vbuck3: vbuck3 {
-				regulator-compatible = "vbuck3";
 				regulator-name = "Vlcpu";
 				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
@@ -928,7 +926,6 @@
 
 		regulators {
 			mt6315_7_vbuck1: vbuck1 {
-				regulator-compatible = "vbuck1";
 				regulator-name = "Vgpu";
 				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <800000>;
-- 
2.39.5



