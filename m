Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7538E198E92;
	Thu,  6 Jun 2024 14:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683487; cv=none; b=D+oppB0kzgrQbvLHPkY3RropEp9mJObsS7M150qcmUj0FEj0FeWX4nYMSvWTNoByaYBOOjihYXcbij2veBVzOcJvOPAZ3XlOTkqD17fC/CCRFivvrjNJWnVeDuZDzYDVAyc8WCd/hty6Owo35VQ5tqfNjA7nVu/7KLGs+IeH++U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683487; c=relaxed/simple;
	bh=Sq94q6P8gBvvcoB97pK1zx6kjRzHarVVECgfGUemAAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gLtnyoN9NswUwvYhRpbXMb0vETMdvTvsj1UIm5WChyGxuyQ8cxIfU/NU2nD4k9jbmi8cYQ/g0CpomT16koCtEzioc/Ty0tPKLX98c/FM48ULlD1gXc77cOHMt3V5BvJXTkco96PysLCfSevEmTdOVhNp0Xr5BKoMx6yuxTrLS5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvDx7JKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvDx7JKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B31C2BD10;
	Thu,  6 Jun 2024 14:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683487;
	bh=Sq94q6P8gBvvcoB97pK1zx6kjRzHarVVECgfGUemAAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvDx7JKSoFy2w5/5ZOGO3IE09yslum8b3f4tetJKhY8GbW2CebG+aQkVR9C2vKfzj
	 xo/L3kox+f7S+S+cfPMYboU+QcXjkKBn1rmM9ZRsl/8JMILh1Yx9Yykx5toWnIa6uM
	 jkMdvikjh92tnQksWgs4bRYfYQ11u2s0+8pk0YjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 430/744] dt-bindings: PCI: rcar-pci-host: Add missing IOMMU properties
Date: Thu,  6 Jun 2024 16:01:42 +0200
Message-ID: <20240606131746.261067221@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 78d212851f0e56b7d7083c4d5014aa7fa8b77e20 ]

make dtbs_check:

    arch/arm64/boot/dts/renesas/r8a77951-salvator-xs.dtb: pcie@fe000000: Unevaluated properties are not allowed ('iommu-map', 'iommu-map-mask' were unexpected)
	    from schema $id: http://devicetree.org/schemas/pci/rcar-pci-host.yaml#

Fix this by adding the missing IOMMU-related properties.

[kwilczynski: added missing Fixes: tag]
Fixes: 0d69ce3c2c63 ("dt-bindings: PCI: rcar-pci-host: Convert bindings to json-schema")
Link: https://lore.kernel.org/linux-pci/babc878a93cb6461a5d39331f8ecfa654dfda921.1706802597.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/pci/rcar-pci-host.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/pci/rcar-pci-host.yaml b/Documentation/devicetree/bindings/pci/rcar-pci-host.yaml
index b6a7cb32f61e5..835b6db00c279 100644
--- a/Documentation/devicetree/bindings/pci/rcar-pci-host.yaml
+++ b/Documentation/devicetree/bindings/pci/rcar-pci-host.yaml
@@ -77,6 +77,9 @@ properties:
   vpcie12v-supply:
     description: The 12v regulator to use for PCIe.
 
+  iommu-map: true
+  iommu-map-mask: true
+
 required:
   - compatible
   - reg
-- 
2.43.0



