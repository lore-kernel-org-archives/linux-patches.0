Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36872494FE;
	Wed, 25 Feb 2026 01:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983687; cv=none; b=UeGmabj4Ygl/mv+wEK5BgiQa1lbv/RB7Legg95CwDgTddOZwjYboF2OonZprB2lcwy8iIgTiMK2xn+0/AZ/2wTN4YLhsdQNv0fgwPZbDzaidVIw8pY233kVGqwoF9zk6MhVamDyxe8gzx1EYxU85Rg5Oy5Yk5FJiy6uKK8nG620=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983687; c=relaxed/simple;
	bh=qadBpM6U4A5mH8tJEM03axnXHHX+A5lmTHZHrWw3lDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmRQ4OTV0GbDXJQk/a6LgGtOOHfzGKQqbD5U6T9T+yEF8Ezy03nSLGK8+zwknIRCBKSiF4HihzCZDrtD+UecXiP47hvKuY5k6vYyzgh4aCtx6YZEXk+1aXWZNlFh3/9rbUoFX4spHZgDJ9vxEW+wmImf5AidHyStRt8Axp7e5JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xI0VPshQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xI0VPshQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDBCC116D0;
	Wed, 25 Feb 2026 01:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983686;
	bh=qadBpM6U4A5mH8tJEM03axnXHHX+A5lmTHZHrWw3lDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xI0VPshQ0u8rodPs/27d37mCDHWaLjBnvKuTThJx8WmIEE3c8n6o/a5KbhWWUlWJc
	 Js1Wo/vNnfRDB8RKqF9mSPMGf/Jqk5EDny9UtjeZUi/hXBN6+KH1t+nydKifZv03P7
	 934F6WqJ3LIr/bcmVMuUJSKuxIIude9J6X8LhPHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.19 770/781] dt-bindings: phy: qcom-edp: Add missing clock for X Elite
Date: Tue, 24 Feb 2026 17:24:39 -0800
Message-ID: <20260225012418.602263317@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@linaro.org>

commit 6b99eeacf6abb1ff2d6463c84e490343f39cf11a upstream.

On X Elite platform, the eDP PHY uses one more clock called ref.

The current X Elite devices supported upstream work fine without this
clock, because the boot firmware leaves this clock enabled. But we should
not rely on that. Also, even though this change breaks the ABI, it is
needed in order to make the driver disables this clock along with the
other ones, for a proper bring-down of the entire PHY.

So attach the this ref clock to the PHY.

Cc: stable@vger.kernel.org # v6.10
Fixes: 5d5607861350 ("dt-bindings: phy: qcom-edp: Add X1E80100 PHY compatibles")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://patch.msgid.link/20251224-phy-qcom-edp-add-missing-refclk-v5-1-3f45d349b5ac@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/phy/qcom,edp-phy.yaml |   28 +++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/phy/qcom,edp-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,edp-phy.yaml
@@ -37,12 +37,15 @@ properties:
       - description: PLL register block
 
   clocks:
-    maxItems: 2
+    minItems: 2
+    maxItems: 3
 
   clock-names:
+    minItems: 2
     items:
       - const: aux
       - const: cfg_ahb
+      - const: ref
 
   "#clock-cells":
     const: 1
@@ -64,6 +67,29 @@ required:
   - "#clock-cells"
   - "#phy-cells"
 
+allOf:
+  - if:
+      properties:
+        compatible:
+          enum:
+            - qcom,x1e80100-dp-phy
+    then:
+      properties:
+        clocks:
+          minItems: 3
+          maxItems: 3
+        clock-names:
+          minItems: 3
+          maxItems: 3
+    else:
+      properties:
+        clocks:
+          minItems: 2
+          maxItems: 2
+        clock-names:
+          minItems: 2
+          maxItems: 2
+
 additionalProperties: false
 
 examples:


