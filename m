Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EB51D0B94;
	Wed,  2 Oct 2024 14:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878297; cv=none; b=nqxWR/hYmn6qW+omBW1IiSKFUid17fpxzV4ZseiX/Ux6byrprSUsj3f5TPqJg4JmzSPGUnD+Ofva3omEfpHr2ePA7q23rAeh+NHDnCfamRv6B6nrVEsSkqtYKglB/sr1BAafI+wdk5V9uT8JgF0ljs8mMxUGkAkk/6Trsj+o0Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878297; c=relaxed/simple;
	bh=BE9nzc/ReFYIib1RqDZjaVKvqrfgMkS9GOPHiKuzQgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PMTw39szyGdZ+XhHt8n1zYDt+oUSfqUtggKM92m4Nji9c2sY+RgAgjciRxtsnISJUlCy6Ljd3apML1lSdyWlbOmlI15pFNGNrk067a5GV1E8vGDDz+z6yuqPs97nWwamZeCeF2fQhEx2dkC3RqTxmZeDoEVKchfiR7y2yoNKQXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQn0g0cJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQn0g0cJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E60DC4CEC2;
	Wed,  2 Oct 2024 14:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878296;
	bh=BE9nzc/ReFYIib1RqDZjaVKvqrfgMkS9GOPHiKuzQgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQn0g0cJX05qnht9M52AcpuzMeUzX0DYFC1JZ4KofzgFfsCV5+xriqD/sJN5qj9lm
	 dZz67fHQqUpQFpgtn2S+lUM/Kj+ZUEiN3QcHiPqXEJ4odJ5u/96OGk4CiqftR67pzY
	 s1hrF4ao6FgRLakf5aGd0zhnOIe2H4hWG+le7Lws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 364/634] dt-bindings: PCI: layerscape-pci: Replace fsl,lx2160a-pcie with fsl,lx2160ar2-pcie
Date: Wed,  2 Oct 2024 14:57:44 +0200
Message-ID: <20241002125825.463812305@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 1a1bf58897d20fc38b454dfecd2771e142d36966 ]

The fsl,lx2160a-pcie compatible is used for mobivel according to the
Documentation/devicetree/bindings/pci/layerscape-pcie-gen4.txt file.

Whereas the fsl,layerscape-pcie is used for DesignWare PCIe controller binding.

So change it to fsl,lx2160ar2-pcie and allow a fall back to fsl,ls2088a-pcie.

While at it, sort compatible string.

Fixes: 24cd7ecb3886 ("dt-bindings: PCI: layerscape-pci: Convert to YAML format")
Link: https://lore.kernel.org/linux-pci/20240826-2160r2-v1-1-106340d538d6@nxp.com
Signed-off-by: Frank Li <Frank.Li@nxp.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/pci/fsl,layerscape-pcie.yaml     | 26 ++++++++++---------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/fsl,layerscape-pcie.yaml b/Documentation/devicetree/bindings/pci/fsl,layerscape-pcie.yaml
index 793986c5af7ff..daeab5c0758d1 100644
--- a/Documentation/devicetree/bindings/pci/fsl,layerscape-pcie.yaml
+++ b/Documentation/devicetree/bindings/pci/fsl,layerscape-pcie.yaml
@@ -22,18 +22,20 @@ description:
 
 properties:
   compatible:
-    enum:
-      - fsl,ls1021a-pcie
-      - fsl,ls2080a-pcie
-      - fsl,ls2085a-pcie
-      - fsl,ls2088a-pcie
-      - fsl,ls1088a-pcie
-      - fsl,ls1046a-pcie
-      - fsl,ls1043a-pcie
-      - fsl,ls1012a-pcie
-      - fsl,ls1028a-pcie
-      - fsl,lx2160a-pcie
-
+    oneOf:
+      - enum:
+          - fsl,ls1012a-pcie
+          - fsl,ls1021a-pcie
+          - fsl,ls1028a-pcie
+          - fsl,ls1043a-pcie
+          - fsl,ls1046a-pcie
+          - fsl,ls1088a-pcie
+          - fsl,ls2080a-pcie
+          - fsl,ls2085a-pcie
+          - fsl,ls2088a-pcie
+      - items:
+          - const: fsl,lx2160ar2-pcie
+          - const: fsl,ls2088a-pcie
   reg:
     maxItems: 2
 
-- 
2.43.0



