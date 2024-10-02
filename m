Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C261D0DD9;
	Wed,  2 Oct 2024 13:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876310; cv=none; b=qvU2EPS6r7+JyHWBMiIOwTSVZRCujmzmHq7moQYHn6JLhl3ekvtwED3LAerbFMVvM0alG/oyOBG8gTlS6nqGKTwbeW1vpBoVgrSHKX+VGEHVe0dfxNR1/3F404sR2tKGiHOO6GiZnMoY4xR4T1kx6sb/W/N8nfJZ70g+PONEJLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876310; c=relaxed/simple;
	bh=Il6sS4VH778JVQmPH3AiLdR0JlARSM8xyGWQIkoKhhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oLxWZRXrsLBYpXkXmn3Y4rZooWv21M7o0jb+a/DX7oXd+ehr87eyIP5DQD3CGqwHBixLvsF4ysH+QX/cYuL/bc240SE39AJIuAN+c67/hG6FJzQA5T9rHKfijJWQpDPqUjyECnx+tM7+msgO5oGR3EHVUkaNijbwX7WGPFvD4fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RP4NurZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RP4NurZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9D1C4CEC5;
	Wed,  2 Oct 2024 13:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876310;
	bh=Il6sS4VH778JVQmPH3AiLdR0JlARSM8xyGWQIkoKhhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RP4NurZHXVJZpOZ4Aw/8UzOS+aICkTqoJvpf3ygvnLGFf+8qd6sed/9jqsQQoZo8q
	 rk2JxoP0LB6WOeev7uhfubllMv2v5K3CQ6slfymsy5Y1CvpbBr0CRGaGJMqh4wWyem
	 PQywmsZPI02XcuBkN8zosJS/2h3Xw/AS4u/9N2eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 401/695] dt-bindings: PCI: layerscape-pci: Replace fsl,lx2160a-pcie with fsl,lx2160ar2-pcie
Date: Wed,  2 Oct 2024 14:56:39 +0200
Message-ID: <20241002125838.464053338@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



