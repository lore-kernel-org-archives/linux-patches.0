Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4B9350A10;
	Wed,  3 Dec 2025 16:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778627; cv=none; b=GnQesBgEjlixIgRH1xkUayXaaTRDqSY1bAmU6W5e3wQgbbNALh3S4JhP0xonU2pLeukclHIqfLpD2ODb6AAcNMsGmwvXulwj704nsuMBWb0QfOdCn8peWf0wWp8JK3gkRsC+7y+EHa5z8YGXHqvSoRMC6hvTlIyKyI7CT05+E3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778627; c=relaxed/simple;
	bh=T1dCzu44r8nOh11hadW7IzyTXlW7UkPscWJASk5mkcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHpeIP/r06NucHR3wgJ4E9QoXO+oNSKoGRg/dMqMTpOnLg0WkG/Il4i/bFZnYzLTB6UaIAWNgKy3+p4oa1clXXGGe8zfO0oyq3QoWYEq3ysugpA4Tzvb6rK31UpzLgw5e2n3pUyTuhH36PoR1X36pNUq4awXURId7VlmB1jqEbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ul3mHpMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ul3mHpMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F43C4CEF5;
	Wed,  3 Dec 2025 16:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778627;
	bh=T1dCzu44r8nOh11hadW7IzyTXlW7UkPscWJASk5mkcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ul3mHpMupH2G17Vs16G22ayAa9D+wsO9X7eu0YJnJCkMWAzIYGVILsMckStrWDgTy
	 l/itK4u3IpPKhyJVoG1IFj1IwmwSe9FwDspu8XbbYOtUBg1tWJ+sVFAC5EYewapntx
	 BCBWFmgG+6QklKUnqpdPgfi9QX+9mooICW9bFLCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jun Li <jun.li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/568] dt-bindings: usb: dwc3-imx8mp: dma-range is required only for imx8mp
Date: Wed,  3 Dec 2025 16:20:13 +0100
Message-ID: <20251203152441.072514228@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit 268eb6fb908bc82ce479e4dba9a2cad11f536c9c ]

Only i.MX8MP need dma-range property to let USB controller work properly.
Remove dma-range from required list and add limitation for imx8mp.

Fixes: d2a704e29711 ("dt-bindings: usb: dwc3-imx8mp: add imx8mp dwc3 glue bindings")
Cc: stable <stable@kernel.org>
Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/usb/fsl,imx8mp-dwc3.yaml |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/usb/fsl,imx8mp-dwc3.yaml
+++ b/Documentation/devicetree/bindings/usb/fsl,imx8mp-dwc3.yaml
@@ -82,12 +82,20 @@ required:
   - reg
   - "#address-cells"
   - "#size-cells"
-  - dma-ranges
   - ranges
   - clocks
   - clock-names
   - interrupts
 
+allOf:
+  - if:
+      properties:
+        compatible:
+          const: fsl,imx8mp-dwc3
+    then:
+      required:
+        - dma-ranges
+
 additionalProperties: false
 
 examples:


