Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B17635C1A6;
	Tue, 21 Jul 2026 19:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663063; cv=none; b=o7feSvle4fP+jT7JYXO4wpDH+7F9IzWIS3Btu9LhNIm8am6uk/MaKe6UXRXmcg+O43KOu/16ZHPHQGGJJ/j40h8bfp2oVvPMS8dX9k0OGhX5EqXsiHrYmuLib0lpIL8Xd8bIJHbAYnDmtU5If7I6T1EUWuG/Gt7rFAL9Egfo9Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663063; c=relaxed/simple;
	bh=XgszwkB3LGPDHRdEXSCiTx41KR0azitij3HOU29lrrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cP1I1Lg1Pt4KSyvY9cdm4FfkP5JA5EdZcD0D2iD6fmCpMnzu49WKPDrri2x/ooE0UjOM+ouTPqjEDPs2tcZuGLKdSdLP3QIjwbScw7gOmId/RKDVvBNR3y/jv84xIxrU67/lvHLZpaSx8i7wxIPNxyHbSPug5QYEIYIbWUSL/UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0YcCjQC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0YcCjQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04201F000E9;
	Tue, 21 Jul 2026 19:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663062;
	bh=rDcat2zXkIbh9MGbGRLs9AG75DnHmapo9v/ALIyoJWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x0YcCjQCdwTXQzktZ88S1Vl2DIgC6KjI/f3uo6M3skK4TF318ZnrL6DifZsmgbzDI
	 3DVzvdJcZcaJzCDg0Ba6YM2Akt1DT4hTJI3bzA3fWcKMtBFnM4CXuzLwQf7mA87h5u
	 nsaruvlqz8VvqTIRU4/MEKrM6UfOmv9rSqMFtYa8=
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
Subject: [PATCH 6.12 0680/1276] dt-bindings: net: renesas,ether: Drop example "ethernet-phy-ieee802.3-c22" fallback
Date: Tue, 21 Jul 2026 17:18:43 +0200
Message-ID: <20260721152501.314697172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 29355ab98569da..fa1a9579f8c991 100644
--- a/Documentation/devicetree/bindings/net/renesas,ether.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,ether.yaml
@@ -118,8 +118,7 @@ examples:
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



