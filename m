Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270C62C08AB;
	Fri, 23 Jan 2026 18:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192444; cv=none; b=HR/fC3i0FDymxIMFW+bOEdQ1fbwj3rrQ7Y8BWRC9H2h5QQ5LMKWj868Tqgerbd7z9kPQx3SzJqh/CJS1RkZegBXfvUGF+rghPSdRzmSw8nNygd4XEI55ePCon29kbM/EF4mk/n9eec2EL88D5EEexKKOwKngbNZwiQaN6aTPr1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192444; c=relaxed/simple;
	bh=uyJGViFNnTrqV/0+XtxMOgU872S4kW0SndMvdMXhrTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+pr/vAetQ0zty3xzlGpi6BS0C/fHDD0dndYm1rgRroRtkN3sCopSmYH016ikORfRo9rhKvtT6Yr+amQg5U25h+bBsYWsOkLW4FFBS0TyhB7/sib6SUyT5Ym1smp1ayix6BHvOtb58pr7WFBSdpM2vOBAABSEYD3FHmkqTJ1ZcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AqYXFY7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AqYXFY7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B9CC19423;
	Fri, 23 Jan 2026 18:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769192443;
	bh=uyJGViFNnTrqV/0+XtxMOgU872S4kW0SndMvdMXhrTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqYXFY7Lu9Z3VoFW5V3fFHKvdCsk2zlSyMopwDXK6fs7YVGZ+C55jXidB3Eb0qs34
	 2CobhJ31jc/zTPtc/05aZ08tnxruHSDMa6SUUsgXO2G9BhnCUnbB8ElOHnlTtneuix
	 IhEo8X0PQl4wMUCI5pdR6n2Ih29mxBAm8QTM6uY9vqqEpKyS5uDDXSU65NaST3sP1a
	 0QrtqpuhyA2qtoMa58EL/1rl9yIN1ykKs351uOuOoNUsBePMwBoUWnvRtkPLTU34gT
	 M0reACU+270c0zZfHeOHn6flkVAk/FMZsvzbHiVJkD4R8Tbv2REQFHvVbkmpMx/8Mr
	 0+SiRojKuKyhw==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jishnu Prakash <jishnu.prakash@oss.qualcomm.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 07/10] dt-bindings: spmi: split out common QCOM SPMI PMIC arbiter properties
Date: Fri, 23 Jan 2026 10:20:35 -0800
Message-ID: <20260123182039.224314-8-sboyd@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260123182039.224314-1-sboyd@kernel.org>
References: <20260123182039.224314-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jishnu Prakash <jishnu.prakash@oss.qualcomm.com>

Split out the common SPMI PMIC arbiter properties for QCOM devices into a
separate file so that it can be included as a reference for devices
using them. This will be needed for the upcoming PMIC v8 arbiter
support patch, as the v8 arbiter also uses these common properties.

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Jishnu Prakash <jishnu.prakash@oss.qualcomm.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 .../spmi/qcom,spmi-pmic-arb-common.yaml       | 35 +++++++++++++++++++
 .../bindings/spmi/qcom,spmi-pmic-arb.yaml     | 17 +--------
 .../spmi/qcom,x1e80100-spmi-pmic-arb.yaml     | 21 +++--------
 3 files changed, 40 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb-common.yaml

diff --git a/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb-common.yaml b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb-common.yaml
new file mode 100644
index 000000000000..8c38ed145e74
--- /dev/null
+++ b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb-common.yaml
@@ -0,0 +1,35 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/spmi/qcom,spmi-pmic-arb-common.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm Technologies, Inc. SPMI Controller (common)
+
+maintainers:
+  - David Collins <david.collins@oss.qualcomm.com>
+
+description: |
+  This defines some common properties used to define Qualcomm SPMI controllers
+  for PMIC arbiter.
+
+properties:
+  qcom,ee:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    minimum: 0
+    maximum: 5
+    description:
+      indicates the active Execution Environment identifier
+
+  qcom,channel:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    minimum: 0
+    maximum: 5
+    description:
+      which of the PMIC Arb provided channels to use for accesses
+
+required:
+  - qcom,ee
+  - qcom,channel
+
+additionalProperties: true
diff --git a/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.yaml b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.yaml
index 51daf1b847a9..d0c683dd5284 100644
--- a/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.yaml
+++ b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.yaml
@@ -19,6 +19,7 @@ description: |
 
 allOf:
   - $ref: spmi.yaml
+  - $ref: qcom,spmi-pmic-arb-common.yaml
 
 properties:
   compatible:
@@ -71,20 +72,6 @@ properties:
 
   '#size-cells': true
 
-  qcom,ee:
-    $ref: /schemas/types.yaml#/definitions/uint32
-    minimum: 0
-    maximum: 5
-    description: >
-      indicates the active Execution Environment identifier
-
-  qcom,channel:
-    $ref: /schemas/types.yaml#/definitions/uint32
-    minimum: 0
-    maximum: 5
-    description: >
-      which of the PMIC Arb provided channels to use for accesses
-
   qcom,bus-id:
     $ref: /schemas/types.yaml#/definitions/uint32
     minimum: 0
@@ -97,8 +84,6 @@ properties:
 required:
   - compatible
   - reg-names
-  - qcom,ee
-  - qcom,channel
 
 unevaluatedProperties: false
 
diff --git a/Documentation/devicetree/bindings/spmi/qcom,x1e80100-spmi-pmic-arb.yaml b/Documentation/devicetree/bindings/spmi/qcom,x1e80100-spmi-pmic-arb.yaml
index 7c3cc20a80d6..08369fdd2161 100644
--- a/Documentation/devicetree/bindings/spmi/qcom,x1e80100-spmi-pmic-arb.yaml
+++ b/Documentation/devicetree/bindings/spmi/qcom,x1e80100-spmi-pmic-arb.yaml
@@ -17,6 +17,9 @@ description: |
   The PMIC Arbiter can also act as an interrupt controller, providing interrupts
   to slave devices.
 
+allOf:
+  - $ref: qcom,spmi-pmic-arb-common.yaml
+
 properties:
   compatible:
     oneOf:
@@ -45,20 +48,6 @@ properties:
   '#size-cells':
     const: 2
 
-  qcom,ee:
-    $ref: /schemas/types.yaml#/definitions/uint32
-    minimum: 0
-    maximum: 5
-    description: >
-      indicates the active Execution Environment identifier
-
-  qcom,channel:
-    $ref: /schemas/types.yaml#/definitions/uint32
-    minimum: 0
-    maximum: 5
-    description: >
-      which of the PMIC Arb provided channels to use for accesses
-
 patternProperties:
   "^spmi@[a-f0-9]+$":
     type: object
@@ -96,10 +85,8 @@ patternProperties:
 required:
   - compatible
   - reg-names
-  - qcom,ee
-  - qcom,channel
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
   - |
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

