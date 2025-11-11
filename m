Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C872346FA2;
	Tue, 11 Nov 2025 01:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824254; cv=none; b=S3KKpoV59KO2/KqE31nV0ndVsO9z1qCRmxRwi0nIfrj4Ar9exdfl7uH7O2+jM5NMnJFl1C2cn/ARwMRNddleliyKIUz/qKrFJGPhkIc/018Yi+zTv97sCel2tBHdRPtMqjDYhipTAUOdbi7G6lqDWaRL78TRLErPUzHB+MWavAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824254; c=relaxed/simple;
	bh=YmA6U8ooSspXArdv0g5X8BnzATDhFagMYQo+jT4xFMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjirfs7hz1XR8mR9Eq/lvKCfObl46SeHM5Vz1JLDJptIR9SU8DpowIb6OyddW/J3JGzcXmhhsputpv1uqRCjJo/f9RqHQIIDN5a3jMwKcjFIexkRPZ+vdIS6FaTJiUiW8EqWof7tlpLPjjxCP7epcDRs8Z+Y3qDbAroHgkcSmvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0W82CpCX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0W82CpCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080CEC16AAE;
	Tue, 11 Nov 2025 01:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824254;
	bh=YmA6U8ooSspXArdv0g5X8BnzATDhFagMYQo+jT4xFMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0W82CpCXM2NExe6oNt+bPWolIigBj6Z8lGMFnbFwLxRZWEmW9RBGF5EnKlrjNPlMJ
	 CdovTXLnpC3/pJzYW/BtCPh8OLijTYCzncqRaxtTVSN/phlmBmh06AoPt5sojO8JnO
	 O8OoisHlnbECUcQEz/OJDfYAxo5y+doutIMVlNtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhang <quic_jiezh@quicinc.com>,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 471/849] dt-bindings: display/msm/gmu: Update Adreno 623 bindings
Date: Tue, 11 Nov 2025 09:40:41 +0900
Message-ID: <20251111004547.835770582@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Zhang <quic_jiezh@quicinc.com>

[ Upstream commit c2cc1e60c1afff4f23c22561b57a5d5157dde20d ]

Update Adreno 623's dt-binding to remove smmu_clk which is not required
for this GMU.

Signed-off-by: Jie Zhang <quic_jiezh@quicinc.com>
Signed-off-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/672455/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/display/msm/gmu.yaml  | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/Documentation/devicetree/bindings/display/msm/gmu.yaml b/Documentation/devicetree/bindings/display/msm/gmu.yaml
index 4392aa7a4ffe2..afc1879357440 100644
--- a/Documentation/devicetree/bindings/display/msm/gmu.yaml
+++ b/Documentation/devicetree/bindings/display/msm/gmu.yaml
@@ -124,6 +124,40 @@ allOf:
           contains:
             enum:
               - qcom,adreno-gmu-623.0
+    then:
+      properties:
+        reg:
+          items:
+            - description: Core GMU registers
+            - description: Resource controller registers
+            - description: GMU PDC registers
+        reg-names:
+          items:
+            - const: gmu
+            - const: rscc
+            - const: gmu_pdc
+        clocks:
+          items:
+            - description: GMU clock
+            - description: GPU CX clock
+            - description: GPU AXI clock
+            - description: GPU MEMNOC clock
+            - description: GPU AHB clock
+            - description: GPU HUB CX clock
+        clock-names:
+          items:
+            - const: gmu
+            - const: cxo
+            - const: axi
+            - const: memnoc
+            - const: ahb
+            - const: hub
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
               - qcom,adreno-gmu-635.0
               - qcom,adreno-gmu-660.1
               - qcom,adreno-gmu-663.0
-- 
2.51.0



