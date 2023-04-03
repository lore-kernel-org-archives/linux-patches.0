Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388426FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B182FC433EF;
	Mon,  3 Apr 2023 14:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533386;
	bh=Kp40yUVUP44W9wQSP/5+g3DBk10Mrzs5ZhzUG+Rqy2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUUU6/3xPsRMxlNnO4MXqzy7EYGeVx4UeKLQm+h9/WCDzn7MK/JJ47TOMf2Ce42bj
	 bCQ+f4CIEfgcEeENArcTdsazdZ4IZ1CK7IEnPDfwGE5orwcJF9q96LUTgsiP0IuCcb
	 REF4IWEzodbRlasBNuqGTgTdpyp2cSd7s2DL45hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 6.2 164/187] dt-bindings: mtd: jedec,spi-nor: Document CPOL/CPHA support
Date: Mon,  3 Apr 2023 16:10:09 +0200
Message-Id: <20230403140421.555678000@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit a56cde41340ac4049fa6edac9e6cfbcd2804074e upstream.

SPI EEPROMs typically support both SPI Mode 0 (CPOL=CPHA=0) and Mode 3
(CPOL=CPHA=1).  However, using the latter is currently flagged as an
error by "make dtbs_check", e.g.:

    arch/arm/boot/dts/r8a7791-koelsch.dtb: flash@0: Unevaluated properties are not allowed ('spi-cpha', 'spi-cpol' were unexpected)
	    From schema: Documentation/devicetree/bindings/mtd/jedec,spi-nor.yaml

Fix this by documenting support for CPOL=CPHA=1.

Fixes: 233363aba72ac638 ("spi/panel: dt-bindings: drop CPHA and CPOL from common properties")
Cc: stable@vger.kernel.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/afe470603028db9374930b0c57464b1f6d52bdd3.1676384304.git.geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/mtd/jedec,spi-nor.yaml |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/devicetree/bindings/mtd/jedec,spi-nor.yaml
+++ b/Documentation/devicetree/bindings/mtd/jedec,spi-nor.yaml
@@ -76,6 +76,13 @@ properties:
       If "broken-flash-reset" is present then having this property does not
       make any difference.
 
+  spi-cpol: true
+  spi-cpha: true
+
+dependencies:
+  spi-cpol: [ spi-cpha ]
+  spi-cpha: [ spi-cpol ]
+
 unevaluatedProperties: false
 
 examples:


