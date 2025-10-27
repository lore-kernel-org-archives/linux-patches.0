Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2123254AC;
	Mon, 27 Oct 2025 19:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593545; cv=none; b=ddx0uU16UX9iIgG2BihJsTlVYMPjV925pZGtL96+gA64Q3+yrYGYSHC8XqJPXLJzbS4t/u+LZz+DcMTY1C4YkQtw/4NMV+felM89b5SZVfQtHRU0D7gj+jmyts1nm0p7pEH3PmjhI17uZS11AdoPyI73liL2NQXas02jquQbhGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593545; c=relaxed/simple;
	bh=/7GtEpTQEF10ozwUPYOfbZHY3sTlnwlcj/W1gIdceqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRrc+n5aVEng6phxQ1oIYkf2gu/USFmC3pf5i57C6Ar3eqjesWfDKb9Ee/yhepbOSLqzRlCxStm3HEcDLqm4vPZx7EmGsz+klX/pYQoqrLy30e63etDZLj2GhvzPIsO+J8r71tA37t72FPAXDiBQvJnjifsAOzAisTQijsZfvrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEg1227U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEg1227U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C54C4CEF1;
	Mon, 27 Oct 2025 19:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593544;
	bh=/7GtEpTQEF10ozwUPYOfbZHY3sTlnwlcj/W1gIdceqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEg1227UdybvLz3xo1Xn6Ggc0/YXBtKKZE9pnn9XDR7H68V3RnqKJ7jrpC5seFXfz
	 2bbtVikzDb0oPhe+uUSt1pSTI+2BgCM6epq+7pdRCqTtTcgeSMrlOCyEeszOMHhBYe
	 yIPVST7DA/UEVdHhwTKA7JIZ/Z5922Bsc4hR/zw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jun Li <jun.li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.17 168/184] dt-bindings: usb: dwc3-imx8mp: dma-range is required only for imx8mp
Date: Mon, 27 Oct 2025 19:37:30 +0100
Message-ID: <20251027183519.449009007@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -89,13 +89,21 @@ required:
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


