Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BEA1474AF;
	Fri,  6 Dec 2024 14:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496863; cv=none; b=fSfJ/+H9cgzwvmJ7iW3KHSrkWMrKm/tpiPjmxkmUJ91XKcY93bTEwKIhpfOPgzJJ/wTVj4o/rdzkkMh5dbHuGNzX4OwQZdM7zcog3Rrn7i+JhiypyE5p90Ym4Z3gf/s3TpZY9Aigs/Cij3yRVpLVCw9pD71DFyeWRXp0pZwe79o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496863; c=relaxed/simple;
	bh=P+l5s6FLFoyiNfPf7jYLR/NiSD0eXoyv6X6lb2j+87U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cq5LLGWiQxMZ/twTjXU5SmoWJ6A+EFXKsXjjYEDhFgRPcXHdxjuPjEaKaVONr0XbvH7VWXPzwQhEcZmMnOCu5PGi+JOY0/eXVc5NCf54GPfBOR1IOtKX/kDOVbvH7OD95KG4LeLHXRKMV/evfGKQYZTCg0TlsOwsi0yTTeWGKfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/HNSyr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/HNSyr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B548C4CED1;
	Fri,  6 Dec 2024 14:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496862;
	bh=P+l5s6FLFoyiNfPf7jYLR/NiSD0eXoyv6X6lb2j+87U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/HNSyr2iTDAN6qDBQjtWc8FfqJJ90s+EYJ3rzGhvWr/dWHx5cAyG1MqRJB0sMc6q
	 U8rEz2LllcRwkbaM3Dcwb+8FA6O07XhjxyvVUQ98BHvdmY3rRXGSqcEImRuJRHTH9u
	 HFDqNtmMiCuPQUapaKNSOChEVcLb1de635aSJLdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/676] arm64: dts: mt8183: kukui: Fix the address of eeprom at i2c4
Date: Fri,  6 Dec 2024 15:29:06 +0100
Message-ID: <20241206143658.315606022@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit edbde4923f208aa83abb48d4b2463299e5fc2586 ]

The address of eeprom should be 50.

Fixes: ff33d889567e ("arm64: dts: mt8183: Add kukui kodama board")
Fixes: d1eaf77f2c66 ("arm64: dts: mt8183: Add kukui kakadu board")
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240909-eeprom-v1-2-1ed2bc5064f4@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-kakadu.dtsi | 4 ++--
 arch/arm64/boot/dts/mediatek/mt8183-kukui-kodama.dtsi | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-kakadu.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-kakadu.dtsi
index 0d3c7b8162ff0..9eca1c80fe010 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-kakadu.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-kakadu.dtsi
@@ -105,9 +105,9 @@ &i2c4 {
 	clock-frequency = <400000>;
 	vbus-supply = <&mt6358_vcn18_reg>;
 
-	eeprom@54 {
+	eeprom@50 {
 		compatible = "atmel,24c32";
-		reg = <0x54>;
+		reg = <0x50>;
 		pagesize = <32>;
 		vcc-supply = <&mt6358_vcn18_reg>;
 	};
diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-kodama.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-kodama.dtsi
index e73113cb51f53..29216ebe4de84 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-kodama.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-kodama.dtsi
@@ -80,9 +80,9 @@ &i2c4 {
 	clock-frequency = <400000>;
 	vbus-supply = <&mt6358_vcn18_reg>;
 
-	eeprom@54 {
+	eeprom@50 {
 		compatible = "atmel,24c64";
-		reg = <0x54>;
+		reg = <0x50>;
 		pagesize = <32>;
 		vcc-supply = <&mt6358_vcn18_reg>;
 	};
-- 
2.43.0



