Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C310846A5F8;
	Tue, 21 Jul 2026 15:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649282; cv=none; b=egok5kpiuiEKhuwZW6fkqtpMN2C3gY3NJlvuEZf2k0uI1bH00VpTU90pzT5ePx4VukFdB8KsuX+T6jwpG5p4bOgn/TKlp2J0FEcA2s4bkz0tekESBn/lCdhkysyj3IzLvOWzPHSNZItrM+prOYzKFs9WeWYRUKz10NlGMBCkqDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649282; c=relaxed/simple;
	bh=hsKfWiGXfl+hh8B1N8OzjG0x7q0TLDXlcNO/VHJUmvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIySAxRi4u/nvlTm9J9mwkS3gmqfn6biSALnU9F6Z71LX1Yf5nBY6BKxj0HvqoKz+mlum9DNiZBDTzfIb+R/MibM2VMMajOS/1hCXDFP2u5Txq0ncLrBEWtzEKL573+SBsPagj2TOXf9W3zmbAlZN1FAxuxYNjxlJ2yEFqci9wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXYoWmsw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXYoWmsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F2C1F000E9;
	Tue, 21 Jul 2026 15:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649281;
	bh=WQgskmDlf+dxe11DFwdo9x4QsKSYtkBUa8U7sDRg10w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VXYoWmswXTzdcSVja4Xc8mWUW7d/jZPvk+tWCk733hK2HoQIW/Df3BibrxLhnPnXW
	 xU0wuMWVX9VvRDO2eUZrQt9C3A+B0+NP6m7nGqWh/Q7wB6LMghWq8iGBIfV/Y0U2TP
	 0uy4rHnf0ZQz+2CWDL0b2er4nqIX0cV6sM2LKf4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0502/2077] arm64: dts: imx8mp-kontron: Reduce EERAM SPI clock frequency
Date: Tue, 21 Jul 2026 17:02:55 +0200
Message-ID: <20260721152604.654840480@linuxfoundation.org>
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

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit 95f5bc1632ab8f243e517357b5da0dd28d1c6c92 ]

There is an onboard level shifter for the SPI signals that causes
additional propagation delay and renders the SPI transmission
unreliable at 20 MHz. Reduce the clock frequency to a safe value.

Fixes: 946ab10e3f40 ("arm64: dts: Add support for Kontron OSM-S i.MX8MP SoM and BL carrier board")
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-kontron-bl-osm-s.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-kontron-bl-osm-s.dts b/arch/arm64/boot/dts/freescale/imx8mp-kontron-bl-osm-s.dts
index 0924ac50fd2dbc..75ae4664278214 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-kontron-bl-osm-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-kontron-bl-osm-s.dts
@@ -63,7 +63,7 @@ &ecspi2 {
 	eeram@0 {
 		compatible = "microchip,48l640";
 		reg = <0>;
-		spi-max-frequency = <20000000>;
+		spi-max-frequency = <16000000>;
 	};
 };
 
-- 
2.53.0



