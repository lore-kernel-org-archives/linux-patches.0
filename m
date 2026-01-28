Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A13302163;
	Wed, 28 Jan 2026 15:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615618; cv=none; b=Emicr9nuEI0kbvesYV2txRFO/PICAbLHnQZKDvysJvsQyPA8OYoqyPh8bLBXwtAoJ6z61UxNURoAlhCbIDev5eMd37mhKV1w/nOGUcOAjAwpA3r0qamHE8dwrBaac2NaiLqYCh0n7ECURqStoCRLPVTOMSxLhLosdWC4x7H6vrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615618; c=relaxed/simple;
	bh=rg4cJ0T50QnJrWyS1odKGehib9RIziJHO5Db0zFCAJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g35+Mpn35Sw1un5hE3Sas8NzgvdgdFwcnUo5FcVYIwYdNv5C3Io2JjD7aRDUYTNZ/q88rv324kmcgRyAo0Ou9rCDw5l/WX/6zkz4Aks3tl7AqrEBWbi0iX75K+pOitxpL507hUkyVIn0QvvtOpFkLJuz4C9yaOmAug8DQUJJwhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yod+IxFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yod+IxFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C07C4CEF1;
	Wed, 28 Jan 2026 15:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615618;
	bh=rg4cJ0T50QnJrWyS1odKGehib9RIziJHO5Db0zFCAJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yod+IxFbn30ZsP+C1pgYgTGW5UkgihuKg4d79Q3zLc54fbR6u5sOC//Gjg8gIJXas
	 LERfmMMhmqra0RjCbSytCNAN2eEb/Wnn0K3/ScUmB2V9ZlvOWldHRKaJ4MrPyWbvXK
	 9JjSC/Su3miI/WgZo/aPW0RyEKB+s6dVuDyP+X/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Subject: [PATCH 6.18 061/227] ARM: dts: microchip: sama7d65: fix size-cells property for i2c3
Date: Wed, 28 Jan 2026 16:21:46 +0100
Message-ID: <20260128145346.537316585@linuxfoundation.org>
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

From: Nicolas Ferre <nicolas.ferre@microchip.com>

commit 94ad504e67cd3be94fa1b2fed0cb87da0d8f9396 upstream.

Fix the #size-cells property for i2c3 node and remove the dtbs_check
error telling that "#size-cells: 0 was expected" from schema
atmel,at91sam-i2c.yaml and i2c-controller.yaml.

Fixes: b51e4aea3ecf ("ARM: dts: microchip: sama7d65: Add FLEXCOMs to sama7d65 SoC")
Cc: stable@vger.kernel.org # 6.16+
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20260102170135.70717-3-nicolas.ferre@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/microchip/sama7d65.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/microchip/sama7d65.dtsi b/arch/arm/boot/dts/microchip/sama7d65.dtsi
index 5f3a7b178aa7..868045c650a7 100644
--- a/arch/arm/boot/dts/microchip/sama7d65.dtsi
+++ b/arch/arm/boot/dts/microchip/sama7d65.dtsi
@@ -527,7 +527,7 @@ i2c3: i2c@600 {
 				interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&pmc PMC_TYPE_PERIPHERAL 37>;
 				#address-cells = <1>;
-				#size-cells = <1>;
+				#size-cells = <0>;
 				dmas = <&dma0 AT91_XDMAC_DT_PERID(12)>,
 				       <&dma0 AT91_XDMAC_DT_PERID(11)>;
 				dma-names = "tx", "rx";
-- 
2.52.0



