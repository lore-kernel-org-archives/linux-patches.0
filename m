Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA853FB1B;
	Mon, 23 Jun 2025 22:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716218; cv=none; b=Kn8AGmChzgfpl7WOVtx9Rlz8GqNiGi1wVjx7HBiWRiFfDwcBl+T6ZrH33AXBquOG6mLI1DWzluElpxwcT1fxa/jSIQ++TtVbtuWWoXS5oQJuiyykpiF3lM7MH4ZPTMulelb2ree/hGkRSGz5RaS4imd/KA8GPXnsANhFiy2LThU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716218; c=relaxed/simple;
	bh=CgyTfuQl2hmEWqShy78Fc8SU995ri327z/uZwPI8o2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t3UukMOA5FLaipV4+RZWDJd/RbbhozujGz2XvyYpbKS7nzX8ChT5ktKUZgj3VOVIHhthWlSa9yKZgR/O6T5R9X3f0Y2K5nmZVESQPv52wm9MUNShRTmv4lz0PhFpeeMPqV/32CuEVeiossV2DBqU95cLzCQ4t0ShS3tPv6gsQNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bs35Px8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bs35Px8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44610C4CEEA;
	Mon, 23 Jun 2025 22:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716218;
	bh=CgyTfuQl2hmEWqShy78Fc8SU995ri327z/uZwPI8o2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bs35Px8Kr0J4oii5GSWHBtj2wuC7OYi/13Ts6mAVNc7rxN44LGZgre+d3Ib33nsLh
	 ig+dJ3stIH7741+ZxoJHmVNDhksUH0BOfi8QjXsOZ660ODyi6jDRjsO7h3KInJa2L5
	 V6OgHaPbH3KU4Z2COgHpvtiVPfgYsuFQ11TD7pvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Andi Shyti <andi@smida.it>
Subject: [PATCH 6.6 270/290] dt-bindings: i2c: nvidia,tegra20-i2c: Specify the required properties
Date: Mon, 23 Jun 2025 15:08:51 +0200
Message-ID: <20250623130635.041165950@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil R <akhilrajeev@nvidia.com>

commit 903cc7096db22f889d48e2cee8840709ce04fdac upstream.

Specify the properties which are essential and which are not for the
Tegra I2C driver to function correctly. This was not added correctly when
the TXT binding was converted to yaml. All the existing DT nodes have
these properties already and hence this does not break the ABI.

dmas and dma-names which were specified as a must in the TXT binding
is now made optional since the driver can work in PIO mode if dmas are
missing.

Fixes: f10a9b722f80 ("dt-bindings: i2c: tegra: Convert to json-schema”)
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Cc: <stable@vger.kernel.org> # v5.17+
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Andi Shyti <andi@smida.it>
Link: https://lore.kernel.org/r/20250603153022.39434-1-akhilrajeev@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/i2c/nvidia,tegra20-i2c.yaml |   24 +++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/i2c/nvidia,tegra20-i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/nvidia,tegra20-i2c.yaml
@@ -103,7 +103,10 @@ properties:
 
   resets:
     items:
-      - description: module reset
+      - description:
+          Module reset. This property is optional for controllers in Tegra194,
+          Tegra234 etc where an internal software reset is available as an
+          alternative.
 
   reset-names:
     items:
@@ -119,6 +122,13 @@ properties:
       - const: rx
       - const: tx
 
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+
 allOf:
   - $ref: /schemas/i2c/i2c-controller.yaml
   - if:
@@ -172,6 +182,18 @@ allOf:
           items:
             - description: phandle to the VENC power domain
 
+  - if:
+      not:
+        properties:
+          compatible:
+            contains:
+              enum:
+                - nvidia,tegra194-i2c
+    then:
+      required:
+        - resets
+        - reset-names
+
 unevaluatedProperties: false
 
 examples:


