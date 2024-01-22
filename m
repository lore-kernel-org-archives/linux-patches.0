Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0197D5025C;
	Tue, 23 Jan 2024 01:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974730; cv=none; b=F9kKW/I27V5JjpI2//iuWNc3IJEouRZTGBCaHuyAGdtbb8lXLzz66iCIExyZIuXnDrCJcUbj8KofN2JF6XLlzpuceqQv2+eWTGYzSBnfSdISbIf/5Klq/f/MbcQ2mzYsNKjCs+FV0F97+qQNT/DGpoYFE8Bgb7Soygpjbaz5ntI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974730; c=relaxed/simple;
	bh=3RTrgN9O11QvHrkXdfqxysCuIb5x/f+/MUednQLFsWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYrNfRthDRw2yX9cGVkFuFF1GI3rT2wFXd/6Kg/PrDKHnRkbnCYcBbvzzDCyfXPFm1zmCjHu0JgRvYLTxb9G3Ms9L9T8xz3W6V15EKDoQCoEx/mYGL2pB0jjg3yuSggzAYHUlZpranNgKkKAzpidfrm+1aCHv8fQuMt5VVD+o6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8jc9FCP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8jc9FCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8A8C43399;
	Tue, 23 Jan 2024 01:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974729;
	bh=3RTrgN9O11QvHrkXdfqxysCuIb5x/f+/MUednQLFsWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8jc9FCPizbW920umkdqepasJVssQwJJxpeg1mk7iBEPIU4tl36GdwE7kxTCv28c2
	 3hG25zB5pZcr9PzKZG/YFc3jwbw3f5/wEmFiFVUpBYkq+86CIf01oWkB/GwRxsI1Ql
	 QElB0Wg69u8feQyNr8uQOIRxCa6MoSulIHmInyUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moudy Ho <moudy.ho@mediatek.com>,
	Rob Herring <robh@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 146/583] dt-bindings: media: mediatek: mdp3: correct RDMA and WROT node with generic names
Date: Mon, 22 Jan 2024 15:53:17 -0800
Message-ID: <20240122235816.559246688@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moudy Ho <moudy.ho@mediatek.com>

[ Upstream commit f5f185bf7c42f6ca885202fefc40fc871d08a722 ]

The DMA-related nodes RDMA/WROT in MDP3 should be changed to generic names.
In addition, fix improper space indent in example.

Fixes: 4ad7b39623ab ("media: dt-binding: mediatek: add bindings for MediaTek MDP3 components")
Signed-off-by: Moudy Ho <moudy.ho@mediatek.com>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/media/mediatek,mdp3-rdma.yaml    | 29 +++++++++++--------
 .../bindings/media/mediatek,mdp3-wrot.yaml    | 23 +++++++++------
 2 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/mediatek,mdp3-rdma.yaml b/Documentation/devicetree/bindings/media/mediatek,mdp3-rdma.yaml
index 7032c7e15039..3e128733ef53 100644
--- a/Documentation/devicetree/bindings/media/mediatek,mdp3-rdma.yaml
+++ b/Documentation/devicetree/bindings/media/mediatek,mdp3-rdma.yaml
@@ -61,6 +61,9 @@ properties:
       - description: used for 1st data pipe from RDMA
       - description: used for 2nd data pipe from RDMA
 
+  '#dma-cells':
+    const: 1
+
 required:
   - compatible
   - reg
@@ -70,6 +73,7 @@ required:
   - clocks
   - iommus
   - mboxes
+  - '#dma-cells'
 
 additionalProperties: false
 
@@ -80,16 +84,17 @@ examples:
     #include <dt-bindings/power/mt8183-power.h>
     #include <dt-bindings/memory/mt8183-larb-port.h>
 
-    mdp3_rdma0: mdp3-rdma0@14001000 {
-      compatible = "mediatek,mt8183-mdp3-rdma";
-      reg = <0x14001000 0x1000>;
-      mediatek,gce-client-reg = <&gce SUBSYS_1400XXXX 0x1000 0x1000>;
-      mediatek,gce-events = <CMDQ_EVENT_MDP_RDMA0_SOF>,
-                            <CMDQ_EVENT_MDP_RDMA0_EOF>;
-      power-domains = <&spm MT8183_POWER_DOMAIN_DISP>;
-      clocks = <&mmsys CLK_MM_MDP_RDMA0>,
-               <&mmsys CLK_MM_MDP_RSZ1>;
-      iommus = <&iommu>;
-      mboxes = <&gce 20 CMDQ_THR_PRIO_LOWEST>,
-               <&gce 21 CMDQ_THR_PRIO_LOWEST>;
+    dma-controller@14001000 {
+        compatible = "mediatek,mt8183-mdp3-rdma";
+        reg = <0x14001000 0x1000>;
+        mediatek,gce-client-reg = <&gce SUBSYS_1400XXXX 0x1000 0x1000>;
+        mediatek,gce-events = <CMDQ_EVENT_MDP_RDMA0_SOF>,
+                              <CMDQ_EVENT_MDP_RDMA0_EOF>;
+        power-domains = <&spm MT8183_POWER_DOMAIN_DISP>;
+        clocks = <&mmsys CLK_MM_MDP_RDMA0>,
+                 <&mmsys CLK_MM_MDP_RSZ1>;
+        iommus = <&iommu>;
+        mboxes = <&gce 20 CMDQ_THR_PRIO_LOWEST>,
+                 <&gce 21 CMDQ_THR_PRIO_LOWEST>;
+        #dma-cells = <1>;
     };
diff --git a/Documentation/devicetree/bindings/media/mediatek,mdp3-wrot.yaml b/Documentation/devicetree/bindings/media/mediatek,mdp3-wrot.yaml
index 0baa77198fa2..64ea98aa0592 100644
--- a/Documentation/devicetree/bindings/media/mediatek,mdp3-wrot.yaml
+++ b/Documentation/devicetree/bindings/media/mediatek,mdp3-wrot.yaml
@@ -50,6 +50,9 @@ properties:
   iommus:
     maxItems: 1
 
+  '#dma-cells':
+    const: 1
+
 required:
   - compatible
   - reg
@@ -58,6 +61,7 @@ required:
   - power-domains
   - clocks
   - iommus
+  - '#dma-cells'
 
 additionalProperties: false
 
@@ -68,13 +72,14 @@ examples:
     #include <dt-bindings/power/mt8183-power.h>
     #include <dt-bindings/memory/mt8183-larb-port.h>
 
-    mdp3_wrot0: mdp3-wrot0@14005000 {
-      compatible = "mediatek,mt8183-mdp3-wrot";
-      reg = <0x14005000 0x1000>;
-      mediatek,gce-client-reg = <&gce SUBSYS_1400XXXX 0x5000 0x1000>;
-      mediatek,gce-events = <CMDQ_EVENT_MDP_WROT0_SOF>,
-                            <CMDQ_EVENT_MDP_WROT0_EOF>;
-      power-domains = <&spm MT8183_POWER_DOMAIN_DISP>;
-      clocks = <&mmsys CLK_MM_MDP_WROT0>;
-      iommus = <&iommu>;
+    dma-controller@14005000 {
+        compatible = "mediatek,mt8183-mdp3-wrot";
+        reg = <0x14005000 0x1000>;
+        mediatek,gce-client-reg = <&gce SUBSYS_1400XXXX 0x5000 0x1000>;
+        mediatek,gce-events = <CMDQ_EVENT_MDP_WROT0_SOF>,
+                              <CMDQ_EVENT_MDP_WROT0_EOF>;
+        power-domains = <&spm MT8183_POWER_DOMAIN_DISP>;
+        clocks = <&mmsys CLK_MM_MDP_WROT0>;
+        iommus = <&iommu>;
+        #dma-cells = <1>;
     };
-- 
2.43.0



