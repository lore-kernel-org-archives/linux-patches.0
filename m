Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9103E49C4;
	Tue, 21 Jul 2026 19:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660413; cv=none; b=Ps6GK3rc7KDYZ4p0XD+BwxurwFY8QTZWWOCfnhsu7v9c0NdZp96HUgJMQqNZvxCZ9swd4z2Mk9/HPwze/gme/CPhRmYe6DaObKoQC/AW5pI5/3KYWw1VKjO/XPKWIHGlpE1ixqVS2o6sI6OZws9VDBFdJC7KfKA/nlHTvM/fnso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660413; c=relaxed/simple;
	bh=pkrgLKQ1SZxlZFBDqO84E1N9BkSx3/h++5zepXQnwBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqINa7DuIa5IfjS5QXfIOFH/z2eeEJEUq4lZVtksnycFz5EHv9pvtisx4luZXrctLh/SmuyFPpUp9K6t6rjyoBZOx3DGxM5uj7Stbag40RBPr8u18kY0dMX/HKr2x+urbAD7a+u2Vm5rSsgrZhoa9LP+neOVQvAPRV7d5vzeNtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdQiG0E2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdQiG0E2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D401F000E9;
	Tue, 21 Jul 2026 19:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660412;
	bh=DZHmbTszUMpzHuPrlXNzn41kluJsLiOnZnKi7WQVsqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xdQiG0E2o6CojkjstG5LGA7sWUdABgTz9OgI4B5M6zI19CkACotaHofL06pWrA+Oc
	 dbcIksj0xYks3b1fu+Rwbfb5UMhCao3hOV6BwOTLoMpJSXaLs3fWcg0kipAiu1uyvO
	 G+4tWhxzVRHqFCCMn1qYpZXCG21CaDLKTdFZsiq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Thierry Reding <treding@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0926/2077] dt-bindings: dma: nvidia,tegra186-gpc-dma: Make reset optional
Date: Tue, 21 Jul 2026 17:09:59 +0200
Message-ID: <20260721152614.653582298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit cc6049bd3fa8501ee27042df469a19ed69cf406d ]

On Tegra264, GPCDMA reset control is not exposed to Linux and is handled
by the boot firmware.

Although reset was not exposed in Tegra234 as well, the firmware supported
a dummy reset which just returns success on reset without doing an actual
reset. This is also not supported in Tegra264 BPMP. Therefore mark 'reset'
and 'reset-names' properties as required only for devices prior to
Tegra264.

This also necessitates that the Tegra264 compatible be standalone and
cannot have the fallback compatible of Tegra186. Since there is no
functional impact, we keep reset as required for Tegra234 to avoid
breaking the ABI.

Fixes: bb8c97571db5 ("dt-bindings: dma: Add Tegra264 compatible string")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Acked-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260331102303.33181-2-akhilrajeev@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/dma/nvidia,tegra186-gpc-dma.yaml | 23 +++++++++++++------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/nvidia,tegra186-gpc-dma.yaml b/Documentation/devicetree/bindings/dma/nvidia,tegra186-gpc-dma.yaml
index 0dabe9bbb219ba..64f1e9d9896df3 100644
--- a/Documentation/devicetree/bindings/dma/nvidia,tegra186-gpc-dma.yaml
+++ b/Documentation/devicetree/bindings/dma/nvidia,tegra186-gpc-dma.yaml
@@ -15,16 +15,14 @@ maintainers:
   - Jon Hunter <jonathanh@nvidia.com>
   - Rajesh Gumasta <rgumasta@nvidia.com>
 
-allOf:
-  - $ref: dma-controller.yaml#
-
 properties:
   compatible:
     oneOf:
-      - const: nvidia,tegra186-gpcdma
+      - enum:
+          - nvidia,tegra264-gpcdma
+          - nvidia,tegra186-gpcdma
       - items:
           - enum:
-              - nvidia,tegra264-gpcdma
               - nvidia,tegra234-gpcdma
               - nvidia,tegra194-gpcdma
           - const: nvidia,tegra186-gpcdma
@@ -60,12 +58,23 @@ required:
   - compatible
   - reg
   - interrupts
-  - resets
-  - reset-names
   - "#dma-cells"
   - iommus
   - dma-channel-mask
 
+allOf:
+  - $ref: dma-controller.yaml#
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - nvidia,tegra186-gpcdma
+    then:
+      required:
+        - resets
+        - reset-names
+
 additionalProperties: false
 
 examples:
-- 
2.53.0



