Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A0E1E048E;
	Wed,  6 Nov 2024 13:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899014; cv=none; b=SFcFEQQugByNttGSSzcnVMDQ6OnOP4m0IGgSWuWIgwzI/TUYJNxYKmpTd0u4h4o0Evi7Z5ykucZVP4LZsCSgtZAh/Jc3GPFnkfmkiwTmJiXiH4TL8BksuyziskcGJDX/3Co4wX+mW8/UVAx1p1IlSmg+TDjNJM4VUNQrZi3Cz5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899014; c=relaxed/simple;
	bh=hmg5OH+r8+/o/WqmnW9RiJl/t3zzWtlb3sVXbdH5n4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZijVdT4neGpGdCAUNZCYFa8suqYRUCRYGFY3oC9v32b8Q8nyKw5WjD9lGSi4N0kD0D22oDPdNoUeR9NA8aq2iddZ6WycZr85gbyH7SZIDVIUKTVU5ftTyIq7bQUD8SL2hLhOSjUu9qtpvvmPfAAB4u9dV7laH3/rAJv0aGa+BkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbUGLsBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbUGLsBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9E0C4CECD;
	Wed,  6 Nov 2024 13:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899014;
	bh=hmg5OH+r8+/o/WqmnW9RiJl/t3zzWtlb3sVXbdH5n4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbUGLsBNb6QLDa5EyjDomYwmpVtb9HZ4ySyU54PmkWS+lnN0J79cHj4w9HI0N9qKY
	 v15pBdQiNNFWRRdoWwdiZYbGIkFTtj1/MI0BX1yVD39n2x1n27nw3iB9gbhoggtOyx
	 PaGNkubysLASs+hcu7+DjJJunh63MxvHyGGZ/D5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Falkowski <m.falkowski@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 433/462] dt-bindings: gpu: Convert Samsung Image Rotator to dt-schema
Date: Wed,  6 Nov 2024 13:05:26 +0100
Message-ID: <20241106120342.202714021@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Falkowski <m.falkowski@samsung.com>

[ Upstream commit 6e3ffcd592060403ee2d956c9b1704775898db79 ]

Convert Samsung Image Rotator to newer dt-schema format.

Signed-off-by: Maciej Falkowski <m.falkowski@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: 338c4d3902fe ("igb: Disable threaded IRQ for igb_msix_other")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/gpu/samsung-rotator.txt          | 28 -----------
 .../bindings/gpu/samsung-rotator.yaml         | 48 +++++++++++++++++++
 2 files changed, 48 insertions(+), 28 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/gpu/samsung-rotator.txt
 create mode 100644 Documentation/devicetree/bindings/gpu/samsung-rotator.yaml

diff --git a/Documentation/devicetree/bindings/gpu/samsung-rotator.txt b/Documentation/devicetree/bindings/gpu/samsung-rotator.txt
deleted file mode 100644
index 3aca2578da0bd..0000000000000
--- a/Documentation/devicetree/bindings/gpu/samsung-rotator.txt
+++ /dev/null
@@ -1,28 +0,0 @@
-* Samsung Image Rotator
-
-Required properties:
-  - compatible : value should be one of the following:
-	* "samsung,s5pv210-rotator" for Rotator IP in S5PV210
-	* "samsung,exynos4210-rotator" for Rotator IP in Exynos4210
-	* "samsung,exynos4212-rotator" for Rotator IP in Exynos4212/4412
-	* "samsung,exynos5250-rotator" for Rotator IP in Exynos5250
-
-  - reg : Physical base address of the IP registers and length of memory
-	  mapped region.
-
-  - interrupts : Interrupt specifier for rotator interrupt, according to format
-		 specific to interrupt parent.
-
-  - clocks : Clock specifier for rotator clock, according to generic clock
-	     bindings. (See Documentation/devicetree/bindings/clock/exynos*.txt)
-
-  - clock-names : Names of clocks. For exynos rotator, it should be "rotator".
-
-Example:
-	rotator@12810000 {
-		compatible = "samsung,exynos4210-rotator";
-		reg = <0x12810000 0x1000>;
-		interrupts = <0 83 0>;
-		clocks = <&clock 278>;
-		clock-names = "rotator";
-	};
diff --git a/Documentation/devicetree/bindings/gpu/samsung-rotator.yaml b/Documentation/devicetree/bindings/gpu/samsung-rotator.yaml
new file mode 100644
index 0000000000000..45ce562435fa7
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpu/samsung-rotator.yaml
@@ -0,0 +1,48 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/gpu/samsung-rotator.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Samsung SoC Image Rotator
+
+maintainers:
+  - Inki Dae <inki.dae@samsung.com>
+
+properties:
+  compatible:
+    enum:
+      - "samsung,s5pv210-rotator"
+      - "samsung,exynos4210-rotator"
+      - "samsung,exynos4212-rotator"
+      - "samsung,exynos5250-rotator"
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+    - const: rotator
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+
+examples:
+  - |
+    rotator@12810000 {
+        compatible = "samsung,exynos4210-rotator";
+        reg = <0x12810000 0x1000>;
+        interrupts = <0 83 0>;
+        clocks = <&clock 278>;
+        clock-names = "rotator";
+    };
+
-- 
2.43.0



