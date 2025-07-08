Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B488A7E9;
	Tue,  8 Jul 2025 16:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993336; cv=none; b=cByk0oplN6+hFbNTr8AtttdTrb1hNP6wHzZkrO/wMCiFeR6Ip0Q2PVJ2YTjP0/E3soT3EK7ZiegR6odu7LvN0vbgN9o0vhQhgnMxTz/H9qOd1F0ufxI+4YGOpArcN9wVCEFEUwn48oK+PFw6Y/HpxLFiIQ9mrq1sWqGDjPnn1mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993336; c=relaxed/simple;
	bh=gn+Rt5vx75GDARGNGw/wWu7diSCeu/gDP/08706rKjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQMeoiGGK3f+8stOfz46FCzmxYacfDiprYt55CWbwUakArGGmlmID8Jg5/WmFcdvFsPK9cYMIuOAQ1Lu6J1a/a4JAQvFGkgsRBq5dAUDTldlOs9Xxkzpb/ut+iJf+UFkPACefhCX5XYIIOlROMbnJWUmUc8oQ2x6zVNfcKvP+Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wp+xrxS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wp+xrxS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A09C4CEED;
	Tue,  8 Jul 2025 16:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993336;
	bh=gn+Rt5vx75GDARGNGw/wWu7diSCeu/gDP/08706rKjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wp+xrxS6mOzs6WUtHmxTWI4HVQSJM5VJK+SjIm1o+P2qjQwt6j1U1X7PqgJ+Vrue2
	 nI0VU4il4+6yInwNG2/jwQKlkp7VUMwrkJJgfXeHCEGlqAc7+3b5k3OOCnILxfv2G7
	 y+po7tlQe0Ry8p8uJoZ6MPuFUkgw6JsBf4rrqdAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Chen Wang <unicorn_wang@outlook.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.15 008/178] dt-bindings: net: sophgo,sg2044-dwmac: Drop status from the example
Date: Tue,  8 Jul 2025 18:20:45 +0200
Message-ID: <20250708162236.771055425@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit f030713e5abf67d0a88864c8855f809c763af954 upstream.

Examples should be complete and should not have a 'status' property,
especially a disabled one because this disables the dt_binding_check of
the example against the schema.  Dropping 'status' property shows
missing other properties - phy-mode and phy-handle.

Fixes: 114508a89ddc ("dt-bindings: net: Add support for Sophgo SG2044 dwmac")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Reviewed-by: Chen Wang <unicorn_wang@outlook.com>
Link: https://patch.msgid.link/20250701063621.23808-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/net/sophgo,sg2044-dwmac.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/sophgo,sg2044-dwmac.yaml b/Documentation/devicetree/bindings/net/sophgo,sg2044-dwmac.yaml
index 4dd2dc9c678b..8afbd9ebd73f 100644
--- a/Documentation/devicetree/bindings/net/sophgo,sg2044-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/sophgo,sg2044-dwmac.yaml
@@ -80,6 +80,8 @@ examples:
       interrupt-parent = <&intc>;
       interrupts = <296 IRQ_TYPE_LEVEL_HIGH>;
       interrupt-names = "macirq";
+      phy-handle = <&phy0>;
+      phy-mode = "rgmii-id";
       resets = <&rst 30>;
       reset-names = "stmmaceth";
       snps,multicast-filter-bins = <0>;
@@ -91,7 +93,6 @@ examples:
       snps,mtl-rx-config = <&gmac0_mtl_rx_setup>;
       snps,mtl-tx-config = <&gmac0_mtl_tx_setup>;
       snps,axi-config = <&gmac0_stmmac_axi_setup>;
-      status = "disabled";
 
       gmac0_mtl_rx_setup: rx-queues-config {
         snps,rx-queues-to-use = <8>;
-- 
2.50.0



