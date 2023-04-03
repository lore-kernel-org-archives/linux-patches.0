Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550606FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38A3C433EF;
	Mon,  3 Apr 2023 14:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532975;
	bh=kbp3TjlYwASYYj6cKqXDVCvKSQYIEc5krvyhh7Q2Mzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IW50f3BF3h4LkwubzE+x/OJfI37jP8dd+Zo4EcdZe416i+4RtrVbWCVKV6h//GcuL
	 ice6EsgCF0UPXRRSGPni8gs/Ud1rg6OGhhwBqfBOAbIGdI0rSN7Kl+sb6xjSdrvD7Q
	 sRvVXjaHnu5QYFkM/x1KPu2mIgaiJso4lv3nUgXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 6.1 158/181] dt-bindings: mtd: jedec,spi-nor: Document CPOL/CPHA support
Date: Mon,  3 Apr 2023 16:09:53 +0200
Message-Id: <20230403140420.217121062@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
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
@@ -84,6 +84,13 @@ patternProperties:
   "^otp(-[0-9]+)?$":
     type: object
 
+  spi-cpol: true
+  spi-cpha: true
+
+dependencies:
+  spi-cpol: [ spi-cpha ]
+  spi-cpha: [ spi-cpol ]
+
 unevaluatedProperties: false
 
 examples:


