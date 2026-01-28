Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCCE302163;
	Wed, 28 Jan 2026 15:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615614; cv=none; b=CBQkm5vkFQAXpYsuORMj8cr9Knpe4mOKZ2bLjfx7Ox3WWx50iu7aFSoXgyTdJs/ISfD1xumbXQ7H0lVdFt+2ZKJjSk7cljam/MR8kwoPzQ+8mwlycUpQYkioPM9Svp7/oiwKSesR7rJQXzq5c4rrfrBsQHAzsqKiDJGsWjc5h98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615614; c=relaxed/simple;
	bh=Qq0RMLMns4WYyURVM/i8DXDEmI6LKpASt9q8akZyQLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u57uMsX/jhJCrk14WkOi1plvU4qvy9srkv3CwmtpoKxjvP3nEz8RCy45rNxjxPgNXeqiY4M5R39R4vInjSobuDSm8fn1Z8juwXlF81+3EQPbrl4vLfaegug4YQq+x6t/pHkk7kuzm5g6i3BM95DGxmRvxMBSst9Yc2guh/Vqy+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x40bO31H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x40bO31H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A690CC4CEF1;
	Wed, 28 Jan 2026 15:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615614;
	bh=Qq0RMLMns4WYyURVM/i8DXDEmI6LKpASt9q8akZyQLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x40bO31Hw9l9u2zjQJQDt/DJ5qmEZAH6bt01ni9NQYdgKuje8xuQBG/si4J5yqJzJ
	 fx8Kzws6eHcQpKEadeFW8BKh7h7oD2052v67phHHqCAyK1PVnAAopSPfkSPqt+z00O
	 YOgZFDcMy2cbbDd9s9jsRzi9IKCaLoNUx0FGYmB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Prasath Gujulan Elango <hari.prasathge@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Subject: [PATCH 6.18 060/227] ARM: dts: microchip: sama7d65: fix the ranges property for flx9
Date: Wed, 28 Jan 2026 16:21:45 +0100
Message-ID: <20260128145346.500556569@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Hari Prasath Gujulan Elango <hari.prasathge@microchip.com>

commit aabc977aa472ccf756372ae594d890022c19c9c8 upstream.

Update the ranges property for the flexcom9 as per the datasheet and
align with the reg property.

Fixes: b51e4aea3ecf ("ARM: dts: microchip: sama7d65: Add FLEXCOMs to sama7d65 SoC")
Cc: stable@vger.kernel.org # 6.16+
Signed-off-by: Hari Prasath Gujulan Elango <hari.prasathge@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20260102170135.70717-2-nicolas.ferre@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/microchip/sama7d65.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/microchip/sama7d65.dtsi b/arch/arm/boot/dts/microchip/sama7d65.dtsi
index cd2cf9a6f40b..5f3a7b178aa7 100644
--- a/arch/arm/boot/dts/microchip/sama7d65.dtsi
+++ b/arch/arm/boot/dts/microchip/sama7d65.dtsi
@@ -676,7 +676,7 @@ i2c8: i2c@600 {
 		flx9: flexcom@e2820000 {
 			compatible = "microchip,sama7d65-flexcom", "atmel,sama5d2-flexcom";
 			reg = <0xe2820000 0x200>;
-			ranges = <0x0 0xe281c000 0x800>;
+			ranges = <0x0 0xe2820000 0x800>;
 			clocks = <&pmc PMC_TYPE_PERIPHERAL 43>;
 			#address-cells = <1>;
 			#size-cells = <1>;
-- 
2.52.0



