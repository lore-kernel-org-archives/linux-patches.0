Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEFD2F4A14;
	Mon, 27 Oct 2025 19:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592725; cv=none; b=ZiWZdkRbQ/JTu/A9jDn5CrGiG7pFAOUVCJGu+HlKAHYi2OZxNP2nNx+2dOBKwI0+OHCD0HkE2uqmdDXkvq7uxEWaJvuQAwWlFRnL7ZHKc6DiFWhoN8jMmTZccq0EHu/IgP7HlmAWA9I4a7ri4cob29oWYwgc6QnmOAOsHP8gfss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592725; c=relaxed/simple;
	bh=ys6Fwt6P3woWA9Dpi5WVs1s9ZH4xtA5ngEOPdOLDpV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uv7RMKfTBwDyRMn4O1p4MZpMHFHEMWRsbTt1oaMxeV3NHYgbp66g14nJuh247PSQ15o5X9hqxWgzL/Yg7V9bBKZrj8rTs4p4OiIOUBN0lIBhrV70ADHxgvlywkhjRDL8YV4bKlerHtGb4drUdTeyY+ENYFo5l55Z1cquOy2eppQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BKL/+WlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKL/+WlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF826C4CEF1;
	Mon, 27 Oct 2025 19:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592725;
	bh=ys6Fwt6P3woWA9Dpi5WVs1s9ZH4xtA5ngEOPdOLDpV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKL/+WlQerMjQ26+j7VosnzdTsYcwJdtXFHO48qD2bdsr300FXGMsuIalLPtZ7YpZ
	 IWPQhc/hZYf08v+j7GbjvL4sVLifyCaqYd4alN0MyhtmvLX3FEBsM1JnCjJfEzWohF
	 w64IgXCRogNe/gNB2Ua7xaaqjXuQunV1Rzx0NoS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jun Li <jun.li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.6 73/84] dt-bindings: usb: dwc3-imx8mp: dma-range is required only for imx8mp
Date: Mon, 27 Oct 2025 19:37:02 +0100
Message-ID: <20251027183440.752903600@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 268eb6fb908bc82ce479e4dba9a2cad11f536c9c upstream.

Only i.MX8MP need dma-range property to let USB controller work properly.
Remove dma-range from required list and add limitation for imx8mp.

Fixes: d2a704e29711 ("dt-bindings: usb: dwc3-imx8mp: add imx8mp dwc3 glue bindings")
Cc: stable <stable@kernel.org>
Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/usb/fsl,imx8mp-dwc3.yaml |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/usb/fsl,imx8mp-dwc3.yaml
+++ b/Documentation/devicetree/bindings/usb/fsl,imx8mp-dwc3.yaml
@@ -85,13 +85,21 @@ required:
   - reg
   - "#address-cells"
   - "#size-cells"
-  - dma-ranges
   - ranges
   - clocks
   - clock-names
   - interrupts
   - power-domains
 
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


