Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE98D47255D;
	Tue, 21 Jul 2026 19:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663450; cv=none; b=YlRbZzVVbw2mel4lmaaIp5Wg6gVlq/OuqRq3vly5joafKp2S6v0J7YAw3bxW0QpYV2rB150suUIb0rgsoZwyOb4R0p1nDM94tfGyu7pXayDmOTWzTJl50B6vpiJ9YI/c1682n5FsOTdsUpoMMGHok/VaYKLxiH6jZSCRDYBR3Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663450; c=relaxed/simple;
	bh=MAphk9G50NWkf7QZOR0VSQEUPwquhVyAkvDBE7/g5ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3GT8Hrdz919kYCzoHPekr3UWTdplhAGkrFddfRfSX44WEgrt+E93vBhlAz67eshSzaLntvBuys/CtW4qjObzKIGLnW4dvCGxhFggOmEXsF81e0CKEZ5cggKKZZlw3SwVAQSpOrR7zeH0TvIyiSm++SQWnuPbaTdANcRpFAykGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yr6NsTZ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yr6NsTZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBFD1F00A3A;
	Tue, 21 Jul 2026 19:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663448;
	bh=kixjTtHSZLo3chwgt/5HnqX0jhW3qbtNcZ0WZWje4oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yr6NsTZ+z4PX+espak1LetdlP4ew6f3K53NLFnlZl2X6VOE3FYNtiMI0vbV+HzRn6
	 4FBQvPfppQSU09hXuhN8m/am+3D2k5oQageNp7axN+mjZUcjn61C5QDEQ59GJxz7Wg
	 x+y+tBr1bl0lasVQZZKMouy4DaUG1C03ENmzvbi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH 6.12 0825/1276] ARM: dts: stm32: stm32mp15x-mecio1-io: Fix expander gpio line typo
Date: Tue, 21 Jul 2026 17:21:08 +0200
Message-ID: <20260721152504.525717791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Jander <david@protonic.nl>

commit dfb93c4acce8ad9c4f573128b2cf7ddb936e0de7 upstream.

Fix a copy-paste error in the GPIO line names for the TCA6416 expander
(gpio@20).

The common mecio1-io include file was originally defined using the
mecio1r1 (Revision 1) hardware layout, but incorrectly labeled pin 13
as "HSIN9_BIAS" instead of the actual "HSIN7_BIAS" present in the
schematics.

Fixes: 8267753c891c ("ARM: dts: stm32: Add MECIO1 and MECT1S board variants")
Co-developed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20260318105123.819807-7-o.rempel@pengutronix.de
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi b/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
index 69a502ec36d4..1808289f8193 100644
--- a/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
@@ -186,7 +186,7 @@ gpio0: gpio@20 {
 		#gpio-cells = <2>;
 		gpio-line-names = "HSIN0_BIAS", "HSIN1_BIAS", "HSIN2_BIAS", "HSIN3_BIAS",
 				  "", "", "HSIN_VREF0_LVL", "HSIN_VREF1_LVL",
-				  "HSIN4_BIAS", "HSIN5_BIAS", "HSIN6_BIAS", "HSIN9_BIAS",
+				  "HSIN4_BIAS", "HSIN5_BIAS", "HSIN6_BIAS", "HSIN7_BIAS",
 				  "", "", "", "";
 	};
 
-- 
2.55.0



