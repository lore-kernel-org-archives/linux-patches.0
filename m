Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71C93F660F;
	Mon, 20 Apr 2026 13:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691554; cv=none; b=Hmb46V3cJ2F8hqCMcpZaEhj5Fu8Q7siilYgxcTnmP49ORoRcFPNZswnPehRO/KBRBdUXVhW/7FT0Q6eZZ3gV9IUR81XCwYwPPHXAfHFDRiVvxhWJxvw31NptK/FqDnUUpbP0VrUXNBhNSqxt/grAsTvH+2V/e2RoFZzIOhWlirA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691554; c=relaxed/simple;
	bh=wqssYkH7wHaSK4ZujMsdTPYU7wNv3OKuWpGpkDZUxoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7VaIdmJsLYVF9k/N8uY85Lwc7uF19GEXWBCMNOv2ZoRByeP6vh4FY/cscQxdHW0tW0k0vya/jLKowR5Rl9cokX//VJSclryK6/z2kixy1dsGPQVcI/ZYI5IbrcvzC6Y8rYmNBR/dWo59HSttB4IRjkazJ9ztvYgn2DxbbjAY9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RuodTQwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RuodTQwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654A6C2BCB9;
	Mon, 20 Apr 2026 13:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691554;
	bh=wqssYkH7wHaSK4ZujMsdTPYU7wNv3OKuWpGpkDZUxoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RuodTQwBk2ujQrrxOQgXBU2Jse3oOIWcIixuHeftwkx2rhEnzLP3MJ/NJiUxRd9Et
	 AgtfegnkE1HfGOxw7v+A8FhoPFDN2ag8GhW/g/hViIg3APupWM/NpelHO+TVAsxFuL
	 bicxbzrSzjIfObZBI/5XUW4FTaPiRnTCcmBhxtjWx65k0tNPtliOq3I0P2VnPwk+JN
	 de+ymWYLk3uDr2OWc1ZegtMUoX8LENc9+WZa1YoqlZ23g0MsTbfTrtsRtTDj/eXYCA
	 mFx6DCz/2tOPIXD4sI+xqjT0kPrXi09EfgGsIvAE2hZg4+l/ffvxqqd+Y7CnHAhfKQ
	 scBkY3zuGIH4w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mihai Sain <mihai.sain@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	varshini.rajendran@microchip.com,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ARM: dts: microchip: sam9x7: fix gpio-lines count for pioB
Date: Mon, 20 Apr 2026 09:18:11 -0400
Message-ID: <20260420132314.1023554-97-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Mihai Sain <mihai.sain@microchip.com>

[ Upstream commit 907150bbe566e23714a25d7bcb910f236c3c44c0 ]

The pioB controller on the SAM9X7 SoC actually supports 27 GPIO lines.
The previous value of 26 was incorrect, leading to the last pin being
unavailable for use by the GPIO subsystem.
Update the #gpio-lines property to reflect
the correct hardware specification.

Fixes: 41af45af8bc3 ("ARM: dts: at91: sam9x7: add device tree for SoC")
Signed-off-by: Mihai Sain <mihai.sain@microchip.com>
Link: https://lore.kernel.org/r/20260209090735.2016-1-mihai.sain@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 arch/arm/boot/dts/microchip/sam9x7.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/microchip/sam9x7.dtsi b/arch/arm/boot/dts/microchip/sam9x7.dtsi
index 46dacbbd201dd..d242d7a934d0f 100644
--- a/arch/arm/boot/dts/microchip/sam9x7.dtsi
+++ b/arch/arm/boot/dts/microchip/sam9x7.dtsi
@@ -1226,7 +1226,7 @@ pioB: gpio@fffff600 {
 				interrupt-controller;
 				#gpio-cells = <2>;
 				gpio-controller;
-				#gpio-lines = <26>;
+				#gpio-lines = <27>;
 				clocks = <&pmc PMC_TYPE_PERIPHERAL 3>;
 			};
 
-- 
2.53.0

