Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590762;
	b=zf4FFjUntE7h82keUehvZMifqmmhtmopbJxcyFQwbOX2WCcn+wg/+bVde1sECjbGhib5
	 deW4jCagQtJg+0pXK6DjncQD8v2Cf9Q5CayQgzJCcxOrZYfZJLOnD1A2b0c38DOoD3fgA
	 RFWfxQMEeDQXTAbmYnk9bCxtAx/s0F8gFeJUdU53UPhLFXNTcdgoVAx9cnb/+7cKTmKZT
	 w0QACFXaueycdzuVvq1waOgKfMxnQbMMJAYEfhC7G7ci9mr/Z4PE2cbh8mWJ69Myk10rS
	 M2ycu8+erYKRbp9VQnJ5te9Ecg9r43qT3UypCjb3gtVCuzVgYScFwVcNK895+2pirsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w4+/CLSMS+hcIXKwCXDaG5Ef78UWUFYkRQO1saS5t6A=;
	b=UpUgi062DPdPL4FZxp3Ak2gXckJdPBnvHzYvZKFmy8qrj78eLbYlk768v31BoJd7A9UV
	 Bd6Ys4u0yqrepySRG14ihZKuhds217I1X//awOwJ6n17BbyGHwEHloGILwdonpKG4Q6jk
	 ykRI6YcxkYcnqdOoWby4KyBfx0q0Mi7UaqT0sjzOdc8OTalQYkvvgsmwg/af8L5WJcBjb
	 U32qtEOVyXHi0rnM+PXBmZyuI+RyDysi/XWB6sPAANZeh1OrBOHXekQxtJGxsb/ObKoWI
	 FBEDHkgngt1meTUBorwCRf0K1GyieOsSp7vpXFmshWHaU+VqgwtQTo+vvczy/3WjX6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sfPoH0ap;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D454607C35D;
	Fri, 13 Nov 2026 17:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sfPoH0ap
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC811F000C5;
	Fri, 13 Nov 2026 17:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590762;
	bh=w4+/CLSMS+hcIXKwCXDaG5Ef78UWUFYkRQO1saS5t6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfPoH0apIFbetC+nCxNXH6JcJ/54K01Mf+mrPWgIWx5CXJRWcwngr/BCMmHkJFjj5
	 lU8WIBJxcX7x/LO3dxCDfl89KNjd/w8/N6LUzRo9rTVHTRrrCfcpFzucOuB8HR8JkD
	 KMGeW7ERpJUWVvfX1b1aH70mZMOr/txRomMOGcBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 662/686] dt-bindings: clock: ma35d1: Add missing WDT/WWDT parent clocks
Date: Fri, 13 Nov 2026 10:53:15 -0500
Message-ID: <20261113153844.147081793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 8c7453cb0b01bee47ec2f902a9ac1872d3b77f3d ]

The WDT and WWDT muxes have PCLK3/4096 and PCLK4/4096 among their
possible parents, but these fixed factor clocks are currently not
defined, even though they are needed to properly describe the clock
tree. Add them to the bindings.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260930-perso-ma35d1-upstream-clk-v6-4-48937ee6c9bb@bootlin.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Stable-dep-of: 1dc3871ce7ec ("clk: nuvoton: ma35d1: Add missing WDT/WWDT parent clocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/nuvoton,ma35d1-clk.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/dt-bindings/clock/nuvoton,ma35d1-clk.h b/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
index 2d6a44a7e55c4..764d837d6162a 100644
--- a/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
+++ b/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
@@ -248,5 +248,7 @@
 #define ADC_GATE	233
 #define EADC_DIV	234
 #define EADC_GATE	235
+#define PCLK3_DIV4096	236
+#define PCLK4_DIV4096	237
 
 #endif /* __DT_BINDINGS_CLOCK_NUVOTON_MA35D1_CLK_H */
-- 
2.53.0



