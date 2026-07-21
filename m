Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A3946C4AE;
	Tue, 21 Jul 2026 17:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656353; cv=none; b=dFBPs9TSJZ5kNGe4SzAY5gTOk3scY7RsYNSEbUX3TS/oEx7Ljz9ofD6aW4adzKff+D1ia+7B62+Rox11N2w1BLYp26/Cck6V0oSDOePQ/+NuQpouQhqPrTO7Jun+9xvs90BjJLYd8g23rEvoz0RxWgR/zaER7LwVlUhpQ4IGhPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656353; c=relaxed/simple;
	bh=J9l1VL6JXRge4KHln7G/A8g8p8ng//ZuUb1aEtHRWw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLrqtWNZ3gmRzNo+U9t/+Spp4D7e7wfGqDdfly0db/T0eceG8EG0mNcyYPMsDtspkzpzIBov84RfcG/PalLi70fmnW/4Yy+ZuhFkwhVF2xzK6Mn9m7iHvUS+BW6A9gylOV3mLJtfc4v8RVJK06xyQ0rPCO9/3LYKthCgPQeZ+FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlCnzFsM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlCnzFsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D491F000E9;
	Tue, 21 Jul 2026 17:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656352;
	bh=4E6lynj7cQb8i/rzZiUES2GYQDPj4PJtYFCXRwDjlhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TlCnzFsMchEy1CLShUvvvI0Tm0mGX8sFY5N0Z/1OyQ2HUH5OQ/KQKDrIAxHGqqiip
	 5a/6PdbdJaxOHM2/bQr3hbSi1Xl9D1McJrRcOJiT1QxeMm2kh8lsYJWDJq8HtA+ow4
	 5YdVTusHtOluxBIVZEbDaAik6oUNtnRFPBL1U9Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0355/1611] arm64: dts: imx8mp-kontron: Reduce EERAM SPI clock frequency
Date: Tue, 21 Jul 2026 17:07:51 +0200
Message-ID: <20260721152523.126717856@linuxfoundation.org>
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



