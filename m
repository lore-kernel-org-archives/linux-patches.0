Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAA133689F;
	Tue, 21 Jul 2026 17:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654008; cv=none; b=epb3UxLR3YEhenXq1dXNmIUdeO2a4yuw4EmMGOfrGBPmHHD1ZR/oVIOM6VoCNQ4nbbBxfKJ4138+d0Ji9poMMu/MYQwx2VmzDY24QFXwD7cmGTOf/qFpq1PlAQh7IkNVVgXWHwkkQPye1I/LeGRu1xKPX/KsrM7zerh/B1LLIFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654008; c=relaxed/simple;
	bh=f0/Yo7W1KVfB9E0QgHLatiDJ7rvpy59WeRUn4DDSTcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RumGif1/rXCz4zqedEFQlKTZ4xN/1OiRuguDbDkXyhI+MmktI3HK2pfJelMXh+8TN8Qi36T5H1FlqGxLaoJdYxHpAPUX/eJim0nzfaiLx+kDZYAQGSjrAIYg5mINP3hq3758QRdNL+N5liNGgDo+hPrV0A1Whdx+pMtxRdxpODY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bmO4zcOA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bmO4zcOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BE81F000E9;
	Tue, 21 Jul 2026 17:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654007;
	bh=YPDv/I415OBbQppYRGj2hoB5p9rbJhHqLC6HH4Sojr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bmO4zcOA0b5Bq2rjXDnpnasmJ7CQ1bAmHEFe5myL0NdJ2Vr/WS0D4Pnm1qiA4xGYT
	 49qR9ReyOrQXSgA7TvWpQxhzfrlzbBK2jRFtm86lhALc8sj7bxvJV0ZUilJEwdvFIe
	 qWxCuL3d2wpJHSHHlubV+fWx+CPbW1OZm5wgR/Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH 7.1 1542/2077] ARM: dts: stm32: stm32mp15x-mecio1-io: Fix GPIO names typo
Date: Tue, 21 Jul 2026 17:20:15 +0200
Message-ID: <20260721152629.145502468@linuxfoundation.org>
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

From: David Jander <david@protonic.nl>

commit b04ccecb714de913e360f0866c66f38e1606e89b upstream.

The reset pins for the LPOUT lines were incorrectly prefixed with "GPOUT"
instead of "LPOUT" in the gpio-line-names array. Fix these typos so the
pin names consistently match the LPOUT0-4 signals they belong to.

Fixes: 8267753c891c ("ARM: dts: stm32: Add MECIO1 and MECT1S board variants")
Co-developed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20260318105123.819807-5-o.rempel@pengutronix.de
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
@@ -185,14 +185,14 @@
 &gpioe {
 	gpio-line-names = "HPOUT0_RESETN", "HPOUT1", "HPOUT1_ALERTN", "",
 			  "", "", "HPOUT1_RESETN",
-			  "LPOUT0", "LPOUT0_ALERTN", "GPOUT0_RESETN",
-			  "LPOUT1", "LPOUT1_ALERTN", "GPOUT1_RESETN",
-			  "LPOUT2", "LPOUT2_ALERTN", "GPOUT2_RESETN";
+			  "LPOUT0", "LPOUT0_ALERTN", "LPOUT0_RESETN",
+			  "LPOUT1", "LPOUT1_ALERTN", "LPOUT1_RESETN",
+			  "LPOUT2", "LPOUT2_ALERTN", "LPOUT2_RESETN";
 };
 
 &gpiof {
-	gpio-line-names = "LPOUT3", "LPOUT3_ALERTN", "GPOUT3_RESETN",
-			  "LPOUT4", "LPOUT4_ALERTN", "GPOUT4_RESETN",
+	gpio-line-names = "LPOUT3", "LPOUT3_ALERTN", "LPOUT3_RESETN",
+			  "LPOUT4", "LPOUT4_ALERTN", "LPOUT4_RESETN",
 			  "", "",
 			  "", "", "", "",
 			  "", "", "", "";


