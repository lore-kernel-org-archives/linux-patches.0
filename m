Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29558399013;
	Tue, 21 Jul 2026 18:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657093; cv=none; b=FBqEmoABm0f+BWwbqmCvtKRa9GiUmxTZUmJl0AKhdrVXbePA4QRFhU0f9AWQcrApmHhxnA1RpYXfq269m6s0bwbEM6yTBGuXMGqKlF7XCJJL55N1n9GQuKjCg9nGJHO1IRfs5paSDjJHzYA6zW4b3gER0OJfkdVNQBPG/Roxknk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657093; c=relaxed/simple;
	bh=7XlhDSSF+re73WZ8RlK4mFMoiRPLz22KAayC40iLC/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8hUVDh4Q46oMMWKmWUEKkZdBviskP8+6TDMhzrZw9liqkcByWBhcQ2gAtIpandPeF2qz5TRSmB8jgUnT2T6PjyfAFi8LuO6NDFLYzDbXp6c0SRYh6AoRWqg7e3Cw0hOZSGepY+HoqpL06wg1fM/ob0oM6OS324Ch/hPtNdqkLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BX+VBktL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BX+VBktL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5181F00A3A;
	Tue, 21 Jul 2026 18:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657092;
	bh=asr4yteCyHDh+C6PGisGH6ohtXRLSONTBXuels9BnSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BX+VBktLCG2TqLR6wAB+2B4R58Tv55372af3+iTs5HvyH91+iCvkVK4EH/VZLxrH3
	 jBeD5+v2r1GcHKpcwpuYuixZkDJmyra9fJM0mh+9UsM+A0OoMDVSRYryw5MvMyqTCI
	 eT+8sFs8wPbZHMq4fSq6ODMkR1lCX2rnctKIe3b8=
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
Subject: [PATCH 6.18 0633/1611] dt-bindings: dma: nvidia,tegra186-gpc-dma: Make reset optional
Date: Tue, 21 Jul 2026 17:12:29 +0200
Message-ID: <20260721152529.626898301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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



