Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017038;
	b=H4ZWYH84hqCh9ZUNRppPedOhiRRdfQEPjgTj5zkc/9tTO1bFQaLskicHsLiHsqwr40B8
	 c/JIHBWBsAzfsyZWJoc88DQEpBaYRzISayVqh7+lYGkCNVWSRt0OzGKR2MORHJ1a3aeeo
	 +cauBeSkFqlYho1tTi4YIP2fZZGq7SejZe3SVv9D9F/9mrJR0R8yOKJFQMrbNfo1SgLdF
	 ooFYsU+PV3452lsu3i6ynYweVEWJI4DCnvwTWVk3vEnCngEARw4AKEODfslQtrOujXoSM
	 ELf23a18WG/+c5Egh9ca1s2r+8E3U6vVCBLOxh8Czdx6LoskDNly3zGZbZgRoET51Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BJA1m9lPEBwv0cmPkpCgK7uEtsk0e010sJdHgP0dKug=;
	b=ZATr5I7gT3XbErKquVQ+5nLxDPuhE97G1boWlhmShZue7GCh1N3EhthbMhts1UA0viHw
	 3kkc7EdTSWfYHeGhZEy3wUgkZhEN3q3+STncIm/TGQ9fAKlZaCmMdR+EadAAjh/qu1I6r
	 BrL+JgE3a4L8txIC9qo1Oq4glsfCl1drlSjZK+2zJ+fow/LZ3bweD5y31iVTJ9Nf3vkeq
	 zuKZ14lhcubNdMr/bQ+uG9tkYYOP4ScgF+Dkx5EmpmcGO7lsu9NcNmvlxWrwYV/T7x6BQ
	 5m5us25ne80tckzBC4H/Asa1LhOugYBeYN8RNevpLH+h/y73r1GbUCd8RQ9htTkBK5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQQSTTKw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB467606A32A;
	Wed, 18 Nov 2026 15:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQQSTTKw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312F81F000C4;
	Wed, 18 Nov 2026 15:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017038;
	bh=BJA1m9lPEBwv0cmPkpCgK7uEtsk0e010sJdHgP0dKug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQQSTTKwU8U2rKYTA4OaQGMsk1WeOz3K5h2RJBMwf3IdI1OZhy+KMUQ5XmcKbks70
	 0bU89qd8xgkw9nCIuEfgtU02SmV8RCZTgp/bZgqaDQ1geldbhvG3bUxfeh6DwFefef
	 51kgHHQzT5oYbOzYIrRm7peddW8O2yp9YiFsN6b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Stefan Wahren <wahrenst@gmx.net>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0735/2651] dt-bindings: phy: ti,tcan104x-can: Fix property constrains
Date: Wed, 18 Nov 2026 15:32:55 +0100
Message-ID: <20261118150314.331859067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit c7f2322431cb6d108b18fb4154606b49e2bc50f7 ]

Microchip ATA6561 is compatible to TI TCAN1042, so the same property
constrains should apply. But they use a strict scalar enum match, which
makes Microchip ATA6561 fallthrough. So add a "contains" to cover also all
compatibles ones.

Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/linux-devicetree/20260902133525.E22DE1F000E9@smtp.kernel.org/
Fixes: 05ace63d0bcf ("dt-bindings: phy: ti,tcan104x-can: Document NXP TJA105X/1048")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20260907150420.18787-2-wahrenst@gmx.net
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/phy/ti,tcan104x-can.yaml         | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml b/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
index 9f5c37ca6496a..0cf5fa21106b6 100644
--- a/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
+++ b/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
@@ -71,10 +71,11 @@ allOf:
   - if:
       properties:
         compatible:
-          enum:
-            - nxp,tjr1443
-            - ti,tcan1042
-            - ti,tcan1043
+          contains:
+            enum:
+              - nxp,tjr1443
+              - ti,tcan1042
+              - ti,tcan1043
     then:
       properties:
         '#phy-cells':
-- 
2.53.0



