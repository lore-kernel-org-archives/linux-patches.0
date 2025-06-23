Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991CE222581;
	Mon, 23 Jun 2025 22:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716534; cv=none; b=XXxUZVl+OwMeKDeEo2b9Tj3pgHw0FjDFA9usk6P6fIUx5iA87aqtPsTarvvSSpVu+jtULFfZ32TFpf/yB0Sy6LvPF7XtM9Ud5A2B7N48IngWBm0Yd/67DX6CFar+MBecduVri+wBl1sSIyfH5SalPwUVyZTEQoFerZdoTyPvHDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716534; c=relaxed/simple;
	bh=WGAhFdqCWN+sQsz8Qm0O9cIf21Li5rm37mPmHPgVazI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qFweiMdbmmz7MvI1b+JDxAN27QCV5bj7dNUgoY/QDkPaj6QBD5Cuwhv4TunbijvT3B1GsLWSUP2w3je4nfleRdNBOzuTo6jiDoiJogFmi+VIhjR/+6QTn0zyRbsYgA3/aOZjvmotqDpA9KwdWwj4jWGWGu63L4G1ggh0N3m4P+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fE8lb+/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fE8lb+/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93E8C4CEEA;
	Mon, 23 Jun 2025 22:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716532;
	bh=WGAhFdqCWN+sQsz8Qm0O9cIf21Li5rm37mPmHPgVazI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fE8lb+/KMn3AmI8dw3tY+UG5ZzOsWthus1uW3aXndocmUsV5joXtkKw/XRKJimVD+
	 /s0sjzc8jck2ApsYxqwvY39jaxlJlnKfKMEmmmcimoiRNeX3Eu6Dcgp/opUPSzTw+m
	 pYkpu0/A8+42w3Nl2mkXhL/p0WFQ3XAJRg4j+FA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Andi Shyti <andi@smida.it>
Subject: [PATCH 6.15 559/592] dt-bindings: i2c: nvidia,tegra20-i2c: Specify the required properties
Date: Mon, 23 Jun 2025 15:08:37 +0200
Message-ID: <20250623130713.739252734@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -97,7 +97,10 @@ properties:
 
   resets:
     items:
-      - description: module reset
+      - description:
+          Module reset. This property is optional for controllers in Tegra194,
+          Tegra234 etc where an internal software reset is available as an
+          alternative.
 
   reset-names:
     items:
@@ -116,6 +119,13 @@ properties:
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
@@ -169,6 +179,18 @@ allOf:
       properties:
         power-domains: false
 
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


