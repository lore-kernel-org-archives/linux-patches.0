Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88D33B994F;
	Tue, 21 Jul 2026 21:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669684; cv=none; b=Xf8FXvzrP1IfnxWMgqXG5XxcexuiZAZzBgYAJhKPMr/gXAgCHnHXerQCQtAPVguMDAccpHcdDlABvhm8/UCk9XZKJuruh+xVvYxsoZ78N/EVZXHNb01TH1VmPQM2WEnE5YugXpzv/bIvEtaAsIK9tUSqdg8oUD05uQzDpYzWUKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669684; c=relaxed/simple;
	bh=eDnzYG6L3iSHtQVdcs/sNpoZgletepH1xc0LvqSKlDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s5FN4K9W8YhIsuS/RwQ7Vb4qk/Fli2H9huVu2bgQCCHaRGshiDDN12fYblZ/xJXEJNkqKJxUnRoQiGA74dnloxcDTLR2odpiwFAJOyzONVrKQ5zvM9KZdti6R3/uB0vWX1969PSJG4iBXIpZ4JUhtGyYe2gzHY0x1J6EkmtHXhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxLJufTx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxLJufTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9B61F000E9;
	Tue, 21 Jul 2026 21:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669682;
	bh=d2O1rA5G0fvSLAzw33XGdXQZYGhjTbqqyEjmGjc/CAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZxLJufTxPnstJDXwywIaVSlz/7TfOkLUpoUglRddLqFkhg2ALvggnxqD7YsEzVKvI
	 Bh31XYkrZFIOnns9BP7UlBW5w/hFuRdsNND/j5PHNkvAAaakwV8vjeunLvWCsYWWL2
	 L1Pab2twv8cgR7GcHjvb9I/9HWodYrUzx+v66x+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Conor Dooley <conor.dooley@microchip.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0646/1067] dt-bindings: net: renesas,ether: Drop example "ethernet-phy-ieee802.3-c22" fallback
Date: Tue, 21 Jul 2026 17:20:47 +0200
Message-ID: <20260721152439.044130620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 14eb1d2c03b38ce3427f299967f7a4d97ebff4c2 ]

Fix the Micrel PHY in the example which shouldn't have the
fallback "ethernet-phy-ieee802.3-c22" compatible:

Documentation/devicetree/bindings/net/renesas,ether.example.dtb: ethernet-phy@1 \
  (ethernet-phy-id0022.1537): compatible: ['ethernet-phy-id0022.1537', 'ethernet-phy-ieee802.3-c22'] is too long
        from schema $id: http://devicetree.org/schemas/net/micrel.yaml

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Fixes: 37a2fce09001 ("dt-bindings: sh_eth convert bindings to json-schema")
Link: https://patch.msgid.link/20260624150250.131966-2-robh@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/net/renesas,ether.yaml | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/renesas,ether.yaml b/Documentation/devicetree/bindings/net/renesas,ether.yaml
index 06b38c9bc6ec38..f1b0b03df83843 100644
--- a/Documentation/devicetree/bindings/net/renesas,ether.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,ether.yaml
@@ -119,8 +119,7 @@ examples:
         #size-cells = <0>;
 
         phy1: ethernet-phy@1 {
-            compatible = "ethernet-phy-id0022.1537",
-                         "ethernet-phy-ieee802.3-c22";
+            compatible = "ethernet-phy-id0022.1537";
             reg = <1>;
             interrupt-parent = <&irqc0>;
             interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
-- 
2.53.0



