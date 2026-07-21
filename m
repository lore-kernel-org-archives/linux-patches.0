Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AD63B0AC6;
	Tue, 21 Jul 2026 20:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666740; cv=none; b=IJkKY4/puKz/2lkn6BGHKTwNsOheyiKTXSaXtLhXrhCdUnFGcSfK6WM/fJOPn+fZuQ1d1wLBBUDpID99lV58RVjizTqhXmPTG6WyE0lHJeWXfkLYS2QE1VpRDGcarCzS1+u7KVjCyN12gx5IZ9yKTmKIxTywJaQOD2z7iA7ixCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666740; c=relaxed/simple;
	bh=iBw6Stoya/topW7yYaZ7wWDq8+O54yX807RZgbOS4LA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hEhn+TN6D9jtMkqdNnihPz182NpdxmYYK+gTh3A/+i880/X1yjEfAEa4NAqBcorFP3mRYPbQI2BEEkrUhU0ioNfHviEeikKn660iyQ3K1moLa96mfYDGbvhhAqUGxLBofcJ5rG66ucwAoXCfmRtGV+hGOgABEaDt5wkPMnHZSWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+IF/seb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+IF/seb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA931F000E9;
	Tue, 21 Jul 2026 20:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666739;
	bh=VVKyzqh6UqELXcRqC1K/f+xym1dvGYjmWn1GIy0iIvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M+IF/seb8q+XjPr7G3wuJSnni2eX7UaUERQCmsGED4lHdbV1g5F9EHI1KHWYmX2TA
	 rRAxmOh8VCGBPVpZC182ZT6fqqkdw4/bo93uUmMDXMQa+F8PWnx5OZ/Ey8L8YXh/8L
	 PDuVieAeYJzleSb8d7DaTt1BXtG04Sj05ZiadX60=
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
Subject: [PATCH 6.6 0798/1266] dt-bindings: net: renesas,ether: Drop example "ethernet-phy-ieee802.3-c22" fallback
Date: Tue, 21 Jul 2026 17:20:35 +0200
Message-ID: <20260721152459.715646126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



