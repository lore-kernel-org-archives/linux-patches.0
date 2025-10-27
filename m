Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3F6328B7A;
	Mon, 27 Oct 2025 19:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593075; cv=none; b=JZb8I2jWpDMb09YafRWSm3BR8+Xu8I4OSTWLsLzFeBNx8VvKTzAVaVYrlZYOw7PLGzCLcObkQNQQhHxXLel+tI21SnawGGVzB+1tWfDLQhbeKUA5SD2OYA7gj6YfoHBAy1Ayuke0EWzuAk1Iek5JFFiJ9nmcA8MeLSpNuGTldbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593075; c=relaxed/simple;
	bh=k/j4CRNX090r+meiyzxe3P28GDftRQffEb7GU+4XKLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z72eL6LXbLbKBLnvEixZfYgLA9Yb1mwwxzYXJja2Ue1wV6ItNBfyI+3eIy1egRBZ3E/gGbKW20PkKsRPPVbdRayg+ItX4QWF6jCDTWT3ytQDYTHsI+sE3Y6j+zVjqQPff15er5M6p6t9E9GV98Y5N3V19CRsyYvWvTrC6G9Ms2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=myumvO95; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="myumvO95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4815DC4CEF1;
	Mon, 27 Oct 2025 19:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593074;
	bh=k/j4CRNX090r+meiyzxe3P28GDftRQffEb7GU+4XKLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=myumvO95dV3CYq9Z1BvICR93xRAxOHnU0nvYq04usbRpvywaCOSn8SMXj9aGrFIWH
	 7mI2WHPs2nMlnY7z/VxONuqlLsOHl9Wj4G8yL/wLcr2lgzJc5Ky0fwX15kK9nEf8W6
	 4jYV60gWb12/odrqKwV9xlim3g9hP+Q4vTDc5Xfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jun Li <jun.li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.12 110/117] dt-bindings: usb: dwc3-imx8mp: dma-range is required only for imx8mp
Date: Mon, 27 Oct 2025 19:37:16 +0100
Message-ID: <20251027183457.002999977@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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


