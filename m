Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3362D29C2;
	Tue, 15 Jul 2025 13:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586973; cv=none; b=Vw768/mRT1W0oCVqXXLBydGo+dtDx2jeFmCzaRL36/hMxGonvCKaEsZjEfJnK4LikaBCWwQoDzj/bsLHfvpUmC/WdtQgok71RztUny38dEJIBEu1I1+oDaXwV4MB0gtrOIX97YkxoW+ApL5EHe8Eh1QG8W+dIq513cm2QIk7nkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586973; c=relaxed/simple;
	bh=hKg/aZabzfj8RR9wrRNhBokydPYxIUNTkmNEXvbS9sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsK1dcc5mhEqR/N61kNjSuWBl4/cCOkIRLrK1JMKXSBKvooooErlEGTElFf+5LkCzSn71zVpKnruA94NKiRodgmmOEinNh1gMYzpK8ekSoQbUThSoBwJbaZGS2TD7Ny3k8xVB7FYneXxm7KPIjdjJw+sa4YZmYAMbIKqNAYBH5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6ShzhA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6ShzhA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FACFC4CEE3;
	Tue, 15 Jul 2025 13:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586973;
	bh=hKg/aZabzfj8RR9wrRNhBokydPYxIUNTkmNEXvbS9sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6ShzhA+bO0FsxlqlyKsbzaywrqxOUuXpORyvnjwF62CLT6QyZXqid72XuwTVaetj
	 UbpmGRJpS3DPSK31sORm9dvPccs6pZHG8eyFz3Lw3ZO2b4zkubgfk4HkHzMbBg9TTa
	 wD6RBgprHAxE9F2nmd+CwQPX6pPV55AlcKwQ9n68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Julien Massot <julien.massot@collabora.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.15 117/192] dt-bindings: clock: mediatek: Add #reset-cells property for MT8188
Date: Tue, 15 Jul 2025 15:13:32 +0200
Message-ID: <20250715130819.583914581@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

From: Julien Massot <julien.massot@collabora.com>

commit a42b4dcc4f9f309a23e6de5ae57a680b9fd2ea10 upstream.

The '#reset-cells' property is permitted for some of the MT8188
clock controllers, but not listed as a valid property.

Fixes: 9a5cd59640ac ("dt-bindings: clock: mediatek: Add SMI LARBs reset for MT8188")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Julien Massot <julien.massot@collabora.com>
Link: https://lore.kernel.org/r/20250516-dtb-check-mt8188-v2-1-fb60bef1b8e1@collabora.com
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../devicetree/bindings/clock/mediatek,mt8188-clock.yaml       | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/mediatek,mt8188-clock.yaml b/Documentation/devicetree/bindings/clock/mediatek,mt8188-clock.yaml
index 2985c8c717d7..5403242545ab 100644
--- a/Documentation/devicetree/bindings/clock/mediatek,mt8188-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/mediatek,mt8188-clock.yaml
@@ -52,6 +52,9 @@ properties:
   '#clock-cells':
     const: 1
 
+  '#reset-cells':
+    const: 1
+
 required:
   - compatible
   - reg
-- 
2.50.1



