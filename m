Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E63441D;
	Thu, 13 Jun 2024 12:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282185; cv=none; b=g5J/TnDFeRaJ+J1YDhaU477ZW3bpFV8XJI6qzXNGFFe95Sf3zdoMJs2yIdm4s5hpg136A9wOY6gGULZXDJoVfvNo2oUtAOS/o5/9kiODcbXsRb9E7bzrG+kirYm39VBR20Lg0tdo0rv2d2JQ2frOq0lX4fezZB1IhPZ+c/qVMxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282185; c=relaxed/simple;
	bh=KRXI8/6S66S6mI+zK4kKDnC6bjUyERE/hgeYzCcTZ8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wkchg+XnEiDYfNCRsM0s/tk9ucVmG+VPXdGK3tTcV3QYcUHO5PuEOpuXKuIzzfKdWThTok5AeL78Ec/CEODFIQbvYQcfiyDU7L0MMbgKA79lOb5/FQe4KS1L99hyo4JonYSqPNJOw/IjCoWm6mUa6nEd/cSM6PMvmaRQIKN4eoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywUbiv2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywUbiv2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC55C2BBFC;
	Thu, 13 Jun 2024 12:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282185;
	bh=KRXI8/6S66S6mI+zK4kKDnC6bjUyERE/hgeYzCcTZ8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywUbiv2ZIBMoYgu2iEZo6vJBkbrTsHGqSSxN3njek7yH0YHptHny25L/zKr15cWVH
	 AObsRcDtTsKEzLZ1rICTuvaPaXgmh2WzSrGJ2+TxU0naw0IMrPWSTdxob4yLnrRefD
	 IyUPPc3lvuV6wVSnXSHEQu3tekHx5mtFs34P2pJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 192/402] dt-bindings: PCI: rcar-pci-host: Add optional regulators
Date: Thu, 13 Jun 2024 13:32:29 +0200
Message-ID: <20240613113309.633587389@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit b952f96a57e6fb4528c1d6be19e941c3322f9905 ]

Support regulators found on the KingFisher board for miniPCIe (1.5 and
3.3v). For completeness, describe a 12v regulator while we are here.

Link: https://lore.kernel.org/linux-pci/20231105092908.3792-2-wsa+renesas@sang-engineering.com
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Stable-dep-of: 78d212851f0e ("dt-bindings: PCI: rcar-pci-host: Add missing IOMMU properties")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/pci/rcar-pci-host.yaml        | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/pci/rcar-pci-host.yaml b/Documentation/devicetree/bindings/pci/rcar-pci-host.yaml
index 8fdfbc763d704..b6a7cb32f61e5 100644
--- a/Documentation/devicetree/bindings/pci/rcar-pci-host.yaml
+++ b/Documentation/devicetree/bindings/pci/rcar-pci-host.yaml
@@ -68,6 +68,15 @@ properties:
   phy-names:
     const: pcie
 
+  vpcie1v5-supply:
+    description: The 1.5v regulator to use for PCIe.
+
+  vpcie3v3-supply:
+    description: The 3.3v regulator to use for PCIe.
+
+  vpcie12v-supply:
+    description: The 12v regulator to use for PCIe.
+
 required:
   - compatible
   - reg
@@ -121,5 +130,7 @@ examples:
              clock-names = "pcie", "pcie_bus";
              power-domains = <&sysc R8A7791_PD_ALWAYS_ON>;
              resets = <&cpg 319>;
+             vpcie3v3-supply = <&pcie_3v3>;
+             vpcie12v-supply = <&pcie_12v>;
          };
     };
-- 
2.43.0



