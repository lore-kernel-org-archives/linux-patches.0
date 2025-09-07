Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BD44315A;
	Sun,  7 Sep 2025 20:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277628; cv=none; b=Cmaag+oygAhv4VKJpMwqD4xqcEbh8OsDpcYNOKarYN7+IE17Ffp61tNljdv2jef7yytIVNnbJbCu31Sz0qkAKUhL++9i1gU7I0MsKJdNpd9V3gUvOhk1HGucf+N7DN+J9DIL20dwY7kPe8IPS5SHMvJqv4sHG1ksXeZwvcTi2ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277628; c=relaxed/simple;
	bh=nKv7B4R20dIFycsvGzhoX4rZI2rXTmhvFKSXzc20Sgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0zTbhOIU5z2yqeQnNTNTZMVLA1Pb07uKZa1A/9UlvGKv1vDelqd4lbWfzhpS9xkGxpO0CP0N64yA1rOnYgiFdMVB9nUJvN365ObXB3r7wNfGGUNIyJyyburnKVUmA+z99dIEo68oXUBN5KCaZLojV13/+9Reg4etH/qTp7nCPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=icgqi5Ox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="icgqi5Ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509B7C4CEF0;
	Sun,  7 Sep 2025 20:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277628;
	bh=nKv7B4R20dIFycsvGzhoX4rZI2rXTmhvFKSXzc20Sgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=icgqi5OxBEu749WkR2d5qyfDAlUEo+T+r/1Z1RUBIsll5/+fc/DpkZ8kpxqwLuVFx
	 PwjAwOd38vyTnH4wc/WC1wVr+ga53JUcR6pIAUlEHlO0WtWO6W3cFDOZRmTwq4y+Tc
	 zCqZwgcCpmFJJz5UjPeX5KS3bL7WgD+ozSt5qBYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Wanner <Ryan.Wanner@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 029/183] ARM: dts: microchip: sama7d65: Force SDMMC Legacy mode
Date: Sun,  7 Sep 2025 21:57:36 +0200
Message-ID: <20250907195616.469953749@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Wanner <Ryan.Wanner@microchip.com>

[ Upstream commit 217efb440933bf97a78ef328b211d8a39f4ff171 ]

The SDMMC in this IP currently only supports legacy mode
due to a hardware quirk, setting the flags to reflect the limitation.

Fixes: deaa14ab6b06 ("ARM: dts: microchip: add support for sama7d65_curiosity board")
Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20250819170528.126010-1-Ryan.Wanner@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts b/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts
index 53a657cf4efba..dfe1f0616a810 100644
--- a/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts
+++ b/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts
@@ -352,6 +352,8 @@ &rtt {
 
 &sdmmc1 {
 	bus-width = <4>;
+	no-1-8-v;
+	sdhci-caps-mask = <0x0 0x00200000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_sdmmc1_default>;
 	status = "okay";
-- 
2.50.1



