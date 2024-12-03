Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8084033FE;
	Tue,  3 Dec 2024 15:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238114; cv=none; b=A2o0376GqmHvIkxmhxgQK4BLFE3Q/Yf+zchIAvBSxR1N8bggT/drZZgfvi2rXPCbUgj0vila3oXVBTa8fZ8r330A4sD4hh/uXOox+CkEQ/znZ+8c38NpkRQwoYtuOsqupF8if/nsHhukQEAhzOUMw+YVDd4QHtIw5fPLocv+m+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238114; c=relaxed/simple;
	bh=/cIo/kEPF/v0imRnRrVFSLF54/2hjdQpINf9XYN2EiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2a6fI+QMILaNHQk8tjkfqEwz/kCtNxUzTre37ARn3RTQzU+ftAgDa25/4wJ9O8mHlwAlz31hhKaxQNn6YvFSpgIu0MJW0kiAbHtDPy9HBvOu9oouiPXxteBbWqvyPOkrELtXkJ5iHvw930JPchFKnMAKjyoqSZ2cIC9kUTAQbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x27QNxyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x27QNxyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EC7C4CECF;
	Tue,  3 Dec 2024 15:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238114;
	bh=/cIo/kEPF/v0imRnRrVFSLF54/2hjdQpINf9XYN2EiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x27QNxyL3fh8nb60N5Od24UWxEUbXmyJjOZkrI15T/yObQ80w8OdU0EeTPibMBtI7
	 Z6UgqEOse64QogA/QynYDoSlw9cekO5rvpFiCtdXrfSfMiKdjLHV1TrRclW+VBCke9
	 fgEXCRiWttdDERDdeVeKVa3VJNDC2PefbjRc2JL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 165/817] arm64: dts: mt8183: kukui: Fix the address of eeprom at i2c4
Date: Tue,  3 Dec 2024 15:35:37 +0100
Message-ID: <20241203144002.168998962@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index bfb9e42c8acaa..ff02f63bac29b 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-kakadu.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-kakadu.dtsi
@@ -92,9 +92,9 @@ &i2c4 {
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
index 5c1bf6a1e4758..da6e767b4ceed 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-kodama.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-kodama.dtsi
@@ -79,9 +79,9 @@ &i2c4 {
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



