Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779C03922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AA3C433EF;
	Wed,  7 Jun 2023 20:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171550;
	bh=VAAY/+MJFj1XrcKHKiMSRG7NQwjKRBVFLOzOLTJ3UcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1LfO6m3TUN9Js85/5OB8/OkSisTPVpMUBcCJePlBxELrWoORQQhKKA91a7CjN9fGf
	 AsiCt5MfNtU7AVRBToRxab7OK35sWrLQHWTd80tb72Lkt5D0FkzspAOGDIsW6yLnQo
	 AYWjblPIRx8fqteUiqly+IGvR955K7Nigu09Mu7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/159] ASoC: dt-bindings: Adjust #sound-dai-cells on TIs single-DAI codecs
Date: Wed,  7 Jun 2023 22:16:04 +0200
Message-ID: <20230607200905.684358218@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit efb2bfd7b3d210c479b9361c176d7426e5eb8663 ]

A bunch of TI's codecs have binding schemas which force #sound-dai-cells
to one despite those codecs only having a single DAI. Allow for bindings
with zero DAI cells and deprecate the former non-zero value.

Signed-off-by: Martin Povišer <povik+lin@cutebit.org
Link: https://lore.kernel.org/r/20230509153412.62847-1-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/sound/tas2562.yaml | 6 ++++--
 Documentation/devicetree/bindings/sound/tas2764.yaml | 6 ++++--
 Documentation/devicetree/bindings/sound/tas2770.yaml | 6 ++++--
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/tas2562.yaml b/Documentation/devicetree/bindings/sound/tas2562.yaml
index acd4bbe697315..4adaf92233c8e 100644
--- a/Documentation/devicetree/bindings/sound/tas2562.yaml
+++ b/Documentation/devicetree/bindings/sound/tas2562.yaml
@@ -52,7 +52,9 @@ properties:
     description: TDM TX current sense time slot.
 
   '#sound-dai-cells':
-    const: 1
+    # The codec has a single DAI, the #sound-dai-cells=<1>; case is left in for backward
+    # compatibility but is deprecated.
+    enum: [0, 1]
 
 required:
   - compatible
@@ -69,7 +71,7 @@ examples:
      codec: codec@4c {
        compatible = "ti,tas2562";
        reg = <0x4c>;
-       #sound-dai-cells = <1>;
+       #sound-dai-cells = <0>;
        interrupt-parent = <&gpio1>;
        interrupts = <14>;
        shutdown-gpios = <&gpio1 15 0>;
diff --git a/Documentation/devicetree/bindings/sound/tas2764.yaml b/Documentation/devicetree/bindings/sound/tas2764.yaml
index 5bf8c76ecda11..1ffe1a01668fe 100644
--- a/Documentation/devicetree/bindings/sound/tas2764.yaml
+++ b/Documentation/devicetree/bindings/sound/tas2764.yaml
@@ -46,7 +46,9 @@ properties:
     description: TDM TX voltage sense time slot.
 
   '#sound-dai-cells':
-    const: 1
+    # The codec has a single DAI, the #sound-dai-cells=<1>; case is left in for backward
+    # compatibility but is deprecated.
+    enum: [0, 1]
 
 required:
   - compatible
@@ -63,7 +65,7 @@ examples:
      codec: codec@38 {
        compatible = "ti,tas2764";
        reg = <0x38>;
-       #sound-dai-cells = <1>;
+       #sound-dai-cells = <0>;
        interrupt-parent = <&gpio1>;
        interrupts = <14>;
        reset-gpios = <&gpio1 15 0>;
diff --git a/Documentation/devicetree/bindings/sound/tas2770.yaml b/Documentation/devicetree/bindings/sound/tas2770.yaml
index 027bebf4e8cf5..aceba9ed813ef 100644
--- a/Documentation/devicetree/bindings/sound/tas2770.yaml
+++ b/Documentation/devicetree/bindings/sound/tas2770.yaml
@@ -54,7 +54,9 @@ properties:
       - 1 # Falling edge
 
   '#sound-dai-cells':
-    const: 1
+    # The codec has a single DAI, the #sound-dai-cells=<1>; case is left in for backward
+    # compatibility but is deprecated.
+    enum: [0, 1]
 
 required:
   - compatible
@@ -71,7 +73,7 @@ examples:
      codec: codec@41 {
        compatible = "ti,tas2770";
        reg = <0x41>;
-       #sound-dai-cells = <1>;
+       #sound-dai-cells = <0>;
        interrupt-parent = <&gpio1>;
        interrupts = <14>;
        reset-gpio = <&gpio1 15 0>;
-- 
2.39.2



