Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F3D22A7FA;
	Thu, 12 Dec 2024 15:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019037; cv=none; b=djGmXNfl6F7/SOA99i4K2GNvpNWuU0ZisFNT55D8n73xrK0thd/hzBu1c35ernRRdIS5wnJqA2ke3v9oQBxVe+4antW2kyTPycDNAfj0r3XzXY2IwcT3XQhWZAQz/n8s438Fv3kV6h5f9Nd2mXCGOLvErov0KuUrRVIVSGbZ9gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019037; c=relaxed/simple;
	bh=dA25VX0qrZGDBBSdRQDD4692DI0QNtf6/yHoCiHiZRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXHXWmj73/wMoS63czwPlrGMSe3vIXmsKGyejvGsJym9YFVcpQ0BM9xsFRAq/owawaukLrFCZ9eEZlPfaVMryR2cRP49dmLWdNXzyM/tfseR8sji42rItdDZill0Xd6SzBSng9J7Ipoyqh9yGmFm3C0hpopboVbBxAglXy3d0gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cfc6Ceh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cfc6Ceh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2ACEC4CECE;
	Thu, 12 Dec 2024 15:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019037;
	bh=dA25VX0qrZGDBBSdRQDD4692DI0QNtf6/yHoCiHiZRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cfc6Ceh0rsFUWRASrTf9FJOZaV6mMzR7BYoIQbhQIMtNRgee7EPkH98kRHVtjaCxZ
	 2cTXHtGTt14eTdoQyoeGD8YJx3zWIwMT2tJ6uFeZOljmnnQydAvZvyaHJ3X+9ICEtS
	 836HUHRc5I72MDg4OtRQl1tl48tRn9CYVdLxwOxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/772] arm64: dts: mt8183: krane: Fix the address of eeprom at i2c4
Date: Thu, 12 Dec 2024 15:50:46 +0100
Message-ID: <20241212144354.115690209@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit e9c60c34948662b5d47573490ee538439b29e462 ]

The address of eeprom should be 50.

Fixes: cd894e274b74 ("arm64: dts: mt8183: Add krane-sku176 board")
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20240909-eeprom-v1-1-1ed2bc5064f4@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-krane.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-krane.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-krane.dtsi
index 181da69d18f46..b0469a95ddc43 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-krane.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-krane.dtsi
@@ -89,9 +89,9 @@ &i2c4 {
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
-- 
2.43.0



