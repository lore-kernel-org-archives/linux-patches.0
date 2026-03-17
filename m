Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B2C346797;
	Tue, 17 Mar 2026 17:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766805; cv=none; b=dA+GLjik3fEiAW1ckAqhF5wWcY5e/Hf5Z81+z269t+tnU5bSw+5pABEgchmzy78xRhlmJgaxEd1TGM+KsUpcsxziuwbUheISnad9PVJ+6cE0sXJIulq0N2WIMkHfcIhRCFW990yh9v+Qw7dJ2eJ7IOZ3mIfJLNn13j3lxuZd034=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766805; c=relaxed/simple;
	bh=SFCTu99rM1UzNCRisFts/dasUZvrRzVrQYepDl2exYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZpqpKAdV52nN4hCJrqOTikZeZBgsm/LDbQy47lFyLX1T0lRuShu8HOJXL5m24J/W9tULYVrJpqOx23fN4N3Acd5ZQkVVmtwfSVC7IJ8Wj2egH/O5t6iveaNUMgirzcgcIURhYKgjesVAgsMGLVl0XUaxVz7Gmq+MUWiDEBe/3wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sXd7se/x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sXd7se/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FA0C4CEF7;
	Tue, 17 Mar 2026 17:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766805;
	bh=SFCTu99rM1UzNCRisFts/dasUZvrRzVrQYepDl2exYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXd7se/xeYHMMxU3hoY9RuqBlijSaCWFimJWmRYZdFHFxpbIX3bijUoNLEHIDTgkk
	 OYwJqiZ6a9nx+4eqAE6z4KW20N6biXLxHfE64KVwrIbGtWeuRRtxn1GTkro3h8xo6k
	 hYjDVb97Py8qgoYpHKnv+VTUNDnJgxshekWum+Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.19 325/378] dt-bindings: display: msm: Fix reg ranges and clocks on Glymur
Date: Tue, 17 Mar 2026 17:34:42 +0100
Message-ID: <20260317163018.946125353@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

commit 7403e87c138475a74e5176176778f391d847f42d upstream.

The Glymur platform has four DisplayPort controllers. The hardware
supports four streams (MST) per controller. However, on Glymur the first
three controllers only have two streams wired to the display subsystem,
while the fourth controller operates in single-stream mode.

Add a dedicated clause for the Glymur compatible to require the register
ranges for all four stream blocks, while allowing either one pixel clock
(for the single-stream controller) or two pixel clocks (for the remaining
controllers).

Update the Glymur MDSS schema example by adding the missing p2, p3,
mst2link and mst3link register blocks. Without these, the bindings
validation fails. Also replace the made-up register addresses with the
actual addresses from the first controller to match the SoC devicetree
description.

Cc: stable@vger.kernel.org # v6.19
Fixes: 8f63bf908213 ("dt-bindings: display: msm: Document the Glymur DiplayPort controller")
Fixes: 1aee577bbc60 ("dt-bindings: display: msm: Document the Glymur Mobile Display SubSystem")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/708518/
Link: https://lore.kernel.org/r/20260303-glymur-fix-dp-bindings-reg-clocks-v4-1-1ebd9c7c2cee@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../bindings/display/msm/dp-controller.yaml   | 21 ++++++++++++++++++-
 .../display/msm/qcom,glymur-mdss.yaml         | 16 ++++++++------
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/display/msm/dp-controller.yaml b/Documentation/devicetree/bindings/display/msm/dp-controller.yaml
index ebda78db87a6..02ddfaab5f56 100644
--- a/Documentation/devicetree/bindings/display/msm/dp-controller.yaml
+++ b/Documentation/devicetree/bindings/display/msm/dp-controller.yaml
@@ -253,7 +253,6 @@ allOf:
             enum:
               # these platforms support 2 streams MST on some interfaces,
               # others are SST only
-              - qcom,glymur-dp
               - qcom,sc8280xp-dp
               - qcom,x1e80100-dp
     then:
@@ -310,6 +309,26 @@ allOf:
           minItems: 6
           maxItems: 8
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              # these platforms support 2 streams MST on some interfaces,
+              # others are SST only, but all controllers have 4 ports
+              - qcom,glymur-dp
+    then:
+      properties:
+        reg:
+          minItems: 9
+          maxItems: 9
+        clocks:
+          minItems: 5
+          maxItems: 6
+        clocks-names:
+          minItems: 5
+          maxItems: 6
+
 unevaluatedProperties: false
 
 examples:
diff --git a/Documentation/devicetree/bindings/display/msm/qcom,glymur-mdss.yaml b/Documentation/devicetree/bindings/display/msm/qcom,glymur-mdss.yaml
index 2329ed96e6cb..64dde43373ac 100644
--- a/Documentation/devicetree/bindings/display/msm/qcom,glymur-mdss.yaml
+++ b/Documentation/devicetree/bindings/display/msm/qcom,glymur-mdss.yaml
@@ -176,13 +176,17 @@ examples:
                 };
             };
 
-            displayport-controller@ae90000 {
+            displayport-controller@af54000 {
                 compatible = "qcom,glymur-dp";
-                reg = <0xae90000 0x200>,
-                      <0xae90200 0x200>,
-                      <0xae90400 0x600>,
-                      <0xae91000 0x400>,
-                      <0xae91400 0x400>;
+                reg = <0xaf54000 0x200>,
+                      <0xaf54200 0x200>,
+                      <0xaf55000 0xc00>,
+                      <0xaf56000 0x400>,
+                      <0xaf57000 0x400>,
+                      <0xaf58000 0x400>,
+                      <0xaf59000 0x400>,
+                      <0xaf5a000 0x600>,
+                      <0xaf5b000 0x600>;
 
                 interrupt-parent = <&mdss>;
                 interrupts = <12>;
-- 
2.53.0



