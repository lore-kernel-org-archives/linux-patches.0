Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690E619CD1D;
	Thu,  6 Jun 2024 14:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683444; cv=none; b=W7/WjlIsg2NmfQ5E3/LLoQKK+3si7oYrXc7vEH8dEZ4F3PQQa8AVqqiOeNkopqJdxk6R8kzdms7t0G5nL/MN0cTngWMHomsIrRP18kNbg5Jh779WzxBecmnx5NGksVIou4A0wdYdjtlJDJmAZi2vPYARtIDLH8LInJmOjiRDZ0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683444; c=relaxed/simple;
	bh=iqYEQf+Ab+GtWR1bCWcKS3uMQW/bbftkxoBxE3pePBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BYfjRbt0matWe8qw8euDd78ZN9JrTqQe4RVwVo4tQL4xRcfvYSMhnS7Sa3Ur5p0WNUJy8OYnrOIaPK9WrgAd5Q/EbywZO61c/TfFiNJVd3ck9koJVv6UG1vF/4NJqpUOSzOH/RDnB5FoQDUh34EO94O44ZpoduxpCyPrnoinBG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bwa+1Ie3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bwa+1Ie3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F259AC32782;
	Thu,  6 Jun 2024 14:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683444;
	bh=iqYEQf+Ab+GtWR1bCWcKS3uMQW/bbftkxoBxE3pePBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bwa+1Ie302fUYnG0xIRjJmkdvu4nQ5Bxkq4HTQZ6hfPBNAXflSVVKnKZ9h2L6goH2
	 Nnqz+15d1PaqonTXwTz/F6I/jzWZAL1TCBNfRPyg4I9I1OwM8z0CW1eRDahQvA0axr
	 EjVTpeoOArpooHgmGjBdlu2QchHkXBdoRbyRpdY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 306/473] dt-bindings: PCI: rcar-pci-host: Add missing IOMMU properties
Date: Thu,  6 Jun 2024 16:03:55 +0200
Message-ID: <20240606131710.055505549@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



