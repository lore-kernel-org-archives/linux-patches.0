Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA862D7D42;
	Wed, 25 Feb 2026 06:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002786; cv=none; b=qLRf+CGcFX41JL/s+bY1pvz92xpdJsZHTQYDbPYr6oWcsVgYdpZveWoeSezgO1wvf4649oitip2dmw9wDzB6oyoghX3yNSxyEDY4oXwVdLaWrvKrnZzCfnNJ3lwer1MQGWM9QSm18V4Af/w/zB10N52omv8YcVQbL+Azs3jTa9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002786; c=relaxed/simple;
	bh=b5yZrUyqV9aZ2b1PYYSl59z3Z/0RZKqi6kg+LWbmYco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLiAOgYA10ENlun6H0RsoffCHokAydibJEVz6XF06ta/dqoC62hk8Lj2ryEdqhOBNt1D0IKAGUBUwkz5WeRnl4/uVqsAh5GOqg2s07jWDLR3NUIfVs+MunQGx1tWP+lbJviV9qn2wbpslfwotcYNx79Ee8fHACT29HoJUmJz++s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9gkdknK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9gkdknK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4B1C116D0;
	Wed, 25 Feb 2026 06:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002786;
	bh=b5yZrUyqV9aZ2b1PYYSl59z3Z/0RZKqi6kg+LWbmYco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w9gkdknKURBW6m02alpZBRvNoRIak/JCUxfHjWCx7TuYISRvJ+J+WKUXYC+kf5uf0
	 RMgQxEnJlF1UUc3TYr6lIa0BZNqIsH/wb5pxctHoOccewzhCFU1P2g0zGXoxphaQ8m
	 CiauolwVKOE4oc3uwDqLPecsh7q1WIbS2dtJWgBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 627/641] dt-bindings: phy: qcom-edp: Add missing clock for X Elite
Date: Tue, 24 Feb 2026 17:25:53 -0800
Message-ID: <20260225012403.697756697@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


