Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4A1EC4;
	Thu, 13 Jun 2024 12:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282188; cv=none; b=uq8LKZ61nI47vFyGNgYvmN0cGbueCopI1JyDd7KO0d5APbfRNxCqVLiHDbqgh7KVuTrAh7bVDkLWqHfGqICuB0ZlH3dPsLDYRN/buwgIiry0ocs9IcUtKi1JdTn2jXNIQkyxcMMkHLfRGapvJclO0YeTVdj35YmD9UKJQ0om3NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282188; c=relaxed/simple;
	bh=9JfEQle6EIdJu7as1wNCwlZ5Fm8jSOGg4xSrfPLWLj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nvvwa/IOCASxIPEgRXQKxI9B+nllwvf3D1NQJO87Rr5DLQ10sybl/KKXWBQraIoTq+4a5bRa4ZdlI5lSqsC+fY/r/ETnSYmhQ4iXgsIeXsYOYRrX4eNRKHJXB0XwV9uOMgcmzs36oZ+9cUL6k9IA2+Dcp8u9yhn6UQI9TcQhhCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6ZYuory; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6ZYuory"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AAAC2BBFC;
	Thu, 13 Jun 2024 12:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282188;
	bh=9JfEQle6EIdJu7as1wNCwlZ5Fm8jSOGg4xSrfPLWLj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6ZYuory86VTCHnwRPd5Bgm4LYEkmCVDL8adGZpbWU8le5zCKP7nWuygPdhqkALSz
	 iEFulpo1eNz3L0+ScZOtmGrhp4FiYU7DAka022y2VrOL0V+IfpcZeiUakt5luJSa0N
	 HHQHbp6sI0/7XqAouRXCmNzg/yrtcr+YxPhssZM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 193/402] dt-bindings: PCI: rcar-pci-host: Add missing IOMMU properties
Date: Thu, 13 Jun 2024 13:32:30 +0200
Message-ID: <20240613113309.671997858@linuxfoundation.org>
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



