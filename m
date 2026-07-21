Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF3C37B40C;
	Tue, 21 Jul 2026 17:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653465; cv=none; b=HreyNUmDznM+Zf0kUx3Id/3ETkZcot5zznnx+18zIhzqSWYTyCUmAtM5JOVuS3pa7anEo4TLA3JsSLT0s8MDiaB7y1RRMPryCqsHEXX9Vy67wnBJi09nJLxRC9iRijsP6AJ96hlXBqsq23pn7Nwx6KcWGqcnOnyMZMZopKsplaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653465; c=relaxed/simple;
	bh=YXxxqOMKCG2DLLSA7Q9vH4JbWiYsOz1Ue6mf7aHMUoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YUO50j93QY0mprbTDWucQ9KLy+Sn6Uw1deTUC6YWWG3iqnro7VppTxy9asXa+H8geOBGx4ppj43cAaOVHYNoXhrS06E8h0Hbg4s5OefmOJoOHoI3fXiDgebY70SMpPDmxF1PtErFejG2VzmoofyG/6jtzxanT8/vznQ/kLAqavU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0nKshep4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nKshep4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471FF1F000E9;
	Tue, 21 Jul 2026 17:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653464;
	bh=26jHIWo5e/+iAdgpj4DsQ1L1AVr6BfZx1WeKuNoKwAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0nKshep4xUuy37FZv0RigoDItVu0VXBYjpm1c1Jqe8ElImXsWTiP8veazebWphvd/
	 fh9ZlGM1XUC2GvX2m0f8AZUvfpAL2mQMOgeblUhbeq905aH3RYhWQP/MEe53CzHO6R
	 GX7q1m1G6bTggYhycDyVWGF/h2Ynj8/58Kj0mmaY=
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
Subject: [PATCH 7.1 1293/2077] dt-bindings: net: renesas,ether: Drop example "ethernet-phy-ieee802.3-c22" fallback
Date: Tue, 21 Jul 2026 17:16:06 +0200
Message-ID: <20260721152623.319307054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



