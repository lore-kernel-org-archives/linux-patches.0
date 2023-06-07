Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76D83AE5C
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FFAC433D2;
	Wed,  7 Jun 2023 20:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169773;
	bh=CBrdSp2n2kHs/ug4HkD2TUoKIySAJZQWTvqqglXS1rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhmwsn+j3ILh6mv3KGxk4DBFhTst8taKkxd4Nw7KMmFBpoduDT/lR6FcX9A7GSs5+
	 a9TiVzhk+Go3fdsKnWKtZU6/HU42RFQaBxe9URssps42wnm78wNM1QMI1PvkeIdvYn
	 Hddj584Jd6H6oyD0e7KiX66stFznzZ27YRqRU8hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Marek Vasut <marex@denx.de>
Subject: [PATCH 6.3 209/286] dt-bindings: usb: snps,dwc3: Fix "snps,hsphy_interface" type
Date: Wed,  7 Jun 2023 22:15:08 +0200
Message-ID: <20230607200930.079298652@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

commit 7b32040f6d7f885ffc09a6df7c17992d56d2eab8 upstream.

The "snps,hsphy_interface" is string, not u8. Fix the type.

Fixes: 389d77658801 ("dt-bindings: usb: Convert DWC USB3 bindings to DT schema")
Cc: stable <stable@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20230515172456.179049-1-marex@denx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/usb/snps,dwc3.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/usb/snps,dwc3.yaml
+++ b/Documentation/devicetree/bindings/usb/snps,dwc3.yaml
@@ -270,7 +270,7 @@ properties:
     description:
       High-Speed PHY interface selection between UTMI+ and ULPI when the
       DWC_USB3_HSPHY_INTERFACE has value 3.
-    $ref: /schemas/types.yaml#/definitions/uint8
+    $ref: /schemas/types.yaml#/definitions/string
     enum: [utmi, ulpi]
 
   snps,quirk-frame-length-adjustment:


