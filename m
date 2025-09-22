Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB2318C2C;
	Mon, 22 Sep 2025 19:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570445; cv=none; b=hU8lYCRBusQr7rWp39Shpe330QSlcPHTJMzDuE0/gGZQo+45u6EsZJdE68NDgcB9NZzSYJYqkTQ/y/obOR5sFTsrlSc+/+24nrVz6LFlqMtLIyJXYFz+weaydHW2pvNbI8qPhSV+WwfMpaDNlCWdIyqN/buD+7avBwtNyWq1kYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570445; c=relaxed/simple;
	bh=xcU71ppWI35/RRnXM/yvoEHsrJ8Rr+ZtfMJByqxFXs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcC3VeozUavPrJxKEHHKYJgM/aptuf1vMEoBYRBFaubPJnHY9OOoQF3LW8KPz1ARmkAnXmm7rC4Tq5xi28Mzz8VBlU9OAnKX8RqJ0SnB4OVLkQZz9wvVgwfNn3jCSfdG6QqnbGaBGjd46ILALJYwRQpNIAJmwmTamjqayzl1P8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUCoStzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUCoStzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98682C4CEF0;
	Mon, 22 Sep 2025 19:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570444;
	bh=xcU71ppWI35/RRnXM/yvoEHsrJ8Rr+ZtfMJByqxFXs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xUCoStzJpj4Y2hyjl+UMzjWkfDk+ohaqTZ3PuwqzbBI+W70WsZpllx6FuRW3ho4yj
	 NIGJhgVmdRk/Uxsz6FuUqORJTWNc335UFLbb0yxhQU+40bO5uQ+Su/dI4+MwGoxgvS
	 v/DIZAdJAoCFXtRR53kXZTxhzT2nNGr4G/1IXZfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 142/149] dt-bindings: serial: 8250: allow clock uartclk and reg for nxp,lpc1850-uart
Date: Mon, 22 Sep 2025 21:30:42 +0200
Message-ID: <20250922192416.447348691@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit d2db0d78154442fb89165edf8836bf2644c6c58d ]

Allow clock 'uartclk' and 'reg' for nxp,lpc1850-uart to align existed
driver and dts. It is really old platform. Keep the same restriction for
others.

Allow dmas and dma-names property, which allow maxItems 4 because very old
platform (arch/arm/boot/dts/nxp/lpc/lpc18xx.dtsi) use duplicate "tx", "rx",
"tx", "rx" as dma-names.

Fix below CHECK_DTB warnings:
  arch/arm/boot/dts/nxp/lpc/lpc4337-ciaa.dtb: serial@40081000 (nxp,lpc1850-uart): clock-names: ['uartclk', 'reg'] is too long

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Acked-by: "Rob Herring (Arm)" <robh@kernel.org>
Link: https://lore.kernel.org/r/20250602142745.942568-1-Frank.Li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 387d00028ccc ("dt-bindings: serial: 8250: move a constraint")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/serial/8250.yaml |   41 ++++++++++++++++++---
 1 file changed, 37 insertions(+), 4 deletions(-)

--- a/Documentation/devicetree/bindings/serial/8250.yaml
+++ b/Documentation/devicetree/bindings/serial/8250.yaml
@@ -49,6 +49,24 @@ allOf:
         - required: [ clock-frequency ]
         - required: [ clocks ]
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: nxp,lpc1850-uart
+    then:
+      properties:
+        clock-names:
+          items:
+            - const: uartclk
+            - const: reg
+    else:
+      properties:
+        clock-names:
+          items:
+            - const: core
+            - const: bus
+
 properties:
   compatible:
     oneOf:
@@ -142,9 +160,22 @@ properties:
 
   clock-names:
     minItems: 1
-    items:
-      - const: core
-      - const: bus
+    maxItems: 2
+    oneOf:
+      - items:
+          - const: core
+          - const: bus
+      - items:
+          - const: uartclk
+          - const: reg
+
+  dmas:
+    minItems: 1
+    maxItems: 4
+
+  dma-names:
+    minItems: 1
+    maxItems: 4
 
   resets:
     maxItems: 1
@@ -237,7 +268,9 @@ if:
   properties:
     compatible:
       contains:
-        const: spacemit,k1-uart
+        enum:
+          - spacemit,k1-uart
+          - nxp,lpc1850-uart
 then:
   required: [clock-names]
   properties:


