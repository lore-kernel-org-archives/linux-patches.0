Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EF346DFF5;
	Tue, 21 Jul 2026 18:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657900; cv=none; b=gwqJdRhaI4P4+eRbq1ZWfLikxQZUUm0XnhmbKO/UZJM7DTjQoyrq6m8KM0mlosn2SfUoGiVGYDKN+eBtnGlcOTN5CxvSN2I4RoGm7buZLks6wdvNqBdM0bTeSQ9aPBOgRVTEKLoNWV0W57kCY4BF4rEmYF8gDud6gGmcflERlSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657900; c=relaxed/simple;
	bh=tzyyY3sV3177B0Fb8SIuh4bHIY9TyqsoMOn73LMc71w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T1+/mmd/D1nKUUfqeYuIFw05Fu/pMs9SUx5Gzs+GLqKMvE6V4ff8m0VKNPBJ6XfcMkJpobPgV9Jo2YDbeYn1vv+89F8Fww10fyy/BFDaizSDkZeguFFA3Ep8dmd7e1BmNwohL/pPiIsxaO0DfMPGKyw/J2r1cB732/tOQGSIGZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlBMEfW6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlBMEfW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D581F000E9;
	Tue, 21 Jul 2026 18:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657899;
	bh=JX67YCfgvzfsqCPPkFsrVi9Gy3LSZw4JpKUPj1b9zxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZlBMEfW6cj9cP6LyS+jdXdXUrOQ5qSOfBv8saw67TBV+oAGbQK4w+60RVfV+KLiaz
	 SwDd0PfIdbRVT+zlMK8SwoKf20mUj5gunX2fFQepWT7L1MH073hIZ2Ew5E6xVdeKJf
	 iFsvAQheZzEYhplheZN+emx+jnngjKJvNhDD6wS4=
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
Subject: [PATCH 6.18 0941/1611] dt-bindings: net: renesas,ether: Drop example "ethernet-phy-ieee802.3-c22" fallback
Date: Tue, 21 Jul 2026 17:17:37 +0200
Message-ID: <20260721152536.551952105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f0a52f47f95a0d..dd7187f12a6757 100644
--- a/Documentation/devicetree/bindings/net/renesas,ether.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,ether.yaml
@@ -121,8 +121,7 @@ examples:
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



