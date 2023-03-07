Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FAFBA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A12C433A0;
	Tue,  7 Mar 2023 17:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211990;
	bh=Y/q+L145BE+93JeqeN9PBSno8SHhBtY7FoLrqxecr58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxboxKVnCGx21mLSqs3Xzfhcosjrc/aFZHn9I36+i81ScexNVrwlm7CPOttzEl0xN
	 CR0b9v1G3jEfdC/m0mz86PjNTJKQcwpGZPPLIdRPmA6px0DItO/BPSFzH2nYCqHve+
	 aQIiSmPPA9d8I7DmJt5BhuPNI3kmxUDvLe/bEXAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/885] arm64: dts: mediatek: mt8195: Add power domain to U3PHY1 T-PHY
Date: Tue,  7 Mar 2023 17:49:08 +0100
Message-Id: <20230307170002.257023304@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit a9f6721a3c92764582ed12296292fda4a7f2dd25 ]

Assign power domain to the U3PHY1 T-PHY in otder to keep this PHY
alive after unused PD shutdown and to be able to completely cut
and restore power to it, for example, to save some power during
system suspend/sleep.

Fixes: 2b515194bf0c ("arm64: dts: mt8195: Add power domains controller")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221214131117.108008-2-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 6f5fa7ca49013..350d6c2ea622a 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -1410,6 +1410,7 @@ u3phy1: t-phy@11e30000 {
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges = <0 0 0x11e30000 0xe00>;
+			power-domains = <&spm MT8195_POWER_DOMAIN_SSUSB_PCIE_PHY>;
 			status = "disabled";
 
 			u2port1: usb-phy@0 {
-- 
2.39.2



