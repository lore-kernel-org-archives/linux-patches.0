Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5750E1EE001;
	Tue,  3 Dec 2024 15:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240495; cv=none; b=f1ZOBZ2I9pZ8rsJTBezm4XEWjI+0G7qReXWdksMDtiNGSrYicGDtw3I4zUwd7LjxJfWg/BwkPR6F9fTtx9eqlCdKO8dT9l7KrBU29m6qfMSED9tUXQJC4i00TqYtIwU3lO2YmkL4shEloQh0gkKUltRH8uOu0xOwSSYECH1M80Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240495; c=relaxed/simple;
	bh=GhKfncx4Pec4f0ZH/x8W5OLPMvoA93SrbcnD6yfQzXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+y91JrJCS63FpZuXHFIOmlAkY+wTVARyJ294JrXVIY2BFpQGBozejF1rSFSJtwUBaoXi1UFCLs65l+rHIjThsAS6gbrbWiJ9JqtGyPddZXNHU1QKrnFs+bsxm6FmzOI9CX0oyd1JrhBpJ+PFmR1h3gaK8DHa0QZlFYhAva1cj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=waYlPoQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="waYlPoQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9969C4CED6;
	Tue,  3 Dec 2024 15:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240495;
	bh=GhKfncx4Pec4f0ZH/x8W5OLPMvoA93SrbcnD6yfQzXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=waYlPoQ5vhBPgRGFf5R0Xt0zXAI/2Y+S4FOzPm0AR5dqgCxS/D7s+Sym/4chry4J9
	 2HO/+YOp480TN+gFei4eabr2Vs/xnBllnJ+UoHgN61S7jy1zZUaQM4c488TUxtWj7D
	 wFDp+Sgyfs+PCHaEJ/28Q0cK7KpKrbORRu/s8Wmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 153/826] dt-bindings: cache: qcom,llcc: Fix X1E80100 reg entries
Date: Tue,  3 Dec 2024 15:38:00 +0100
Message-ID: <20241203144749.711482447@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit f9759e2b57049f9c4ea8d7254ba6afcf6eb10cd6 ]

Document the missing Broadcast_AND region for x1e80100.

Fixes: e9ceb595c2d3 ("dt-bindings: cache: qcom,llcc: Add X1E80100 compatible")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410181235.L7MF7z48-lkp@intel.com/
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241018-qcom-llcc-bindings-reg-ranges-fix-v1-1-88693cb7723b@linaro.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/cache/qcom,llcc.yaml  | 36 +++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/cache/qcom,llcc.yaml b/Documentation/devicetree/bindings/cache/qcom,llcc.yaml
index 68ea5f70b75f0..ee7edc6f60e2b 100644
--- a/Documentation/devicetree/bindings/cache/qcom,llcc.yaml
+++ b/Documentation/devicetree/bindings/cache/qcom,llcc.yaml
@@ -39,11 +39,11 @@ properties:
 
   reg:
     minItems: 2
-    maxItems: 9
+    maxItems: 10
 
   reg-names:
     minItems: 2
-    maxItems: 9
+    maxItems: 10
 
   interrupts:
     maxItems: 1
@@ -134,6 +134,36 @@ allOf:
               - qcom,qdu1000-llcc
               - qcom,sc8180x-llcc
               - qcom,sc8280xp-llcc
+    then:
+      properties:
+        reg:
+          items:
+            - description: LLCC0 base register region
+            - description: LLCC1 base register region
+            - description: LLCC2 base register region
+            - description: LLCC3 base register region
+            - description: LLCC4 base register region
+            - description: LLCC5 base register region
+            - description: LLCC6 base register region
+            - description: LLCC7 base register region
+            - description: LLCC broadcast base register region
+        reg-names:
+          items:
+            - const: llcc0_base
+            - const: llcc1_base
+            - const: llcc2_base
+            - const: llcc3_base
+            - const: llcc4_base
+            - const: llcc5_base
+            - const: llcc6_base
+            - const: llcc7_base
+            - const: llcc_broadcast_base
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
               - qcom,x1e80100-llcc
     then:
       properties:
@@ -148,6 +178,7 @@ allOf:
             - description: LLCC6 base register region
             - description: LLCC7 base register region
             - description: LLCC broadcast base register region
+            - description: LLCC broadcast AND register region
         reg-names:
           items:
             - const: llcc0_base
@@ -159,6 +190,7 @@ allOf:
             - const: llcc6_base
             - const: llcc7_base
             - const: llcc_broadcast_base
+            - const: llcc_broadcast_and_base
 
   - if:
       properties:
-- 
2.43.0



