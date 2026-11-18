Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027485;
	b=BTXGfsIHHCgCpPrp+0eDpU32beMq14SlKDLscgkhFSZNRUQsdCfFJj9kj/m7+o9aY7sn
	 Ne+FSLhhtxVoC8QlIXlfPCkt8PTnSx8ea7+s0H/G+gGXT7ampBTUcod75hkkZEsugrnMy
	 f0wLkIY0fklFb+JymZztA+I7yHnjuaaTMhTGyYuPSin/Nvrp4axVbRfT34h79qv9phYGj
	 MpT30xyFi48ZSaqzkv+D6txoja5TznZgFKOgXsoB9vQTYRH8tuoW5o73v7wq/ezXDArSL
	 2Z9h0UQBfd4Q7dCUCV/AscBMz+92Qby3ZVwLJpctNW24+rosGZbENPTqOzRr8NamdyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mh9a0twK6uMMISXEmH4Pr3pztB2zUEpaJmLE+OhME8Y=;
	b=VJgizMizHorslOlOUI551dnLbEVjIzUncyKjNLzT45+ZxQ4aJY5/xsDu0P6cF+qAt4gP
	 UsWPYyhQhIG//sTHuXC5IHXlRZT94u+oKJPv7UyhWw4Tn04XjpjJEzerbUCfjwrLaMM1Z
	 IH8nt5LOxdwrkXs0jzGhJe5q7uOV8LZEKSIpMOpP78gEMSxu+/il6OcxcIttVV7qsN+Sd
	 keZW9VEtT75tI4cePOjkMYzjI5UY/iKe25k9/JPbC33m1S/7lI3dnyoFfPQ0hS/5cU1lI
	 O/IaiA7ibrMJ0n7kdw2REipz2uJk1akoYgzv4ypYV1ItA8fqAv3rj0Jtpvp6f+MHgoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LcAuOjDJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA0A60A2607;
	Wed, 18 Nov 2026 18:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LcAuOjDJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174031F000C4;
	Wed, 18 Nov 2026 18:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027484;
	bh=Mh9a0twK6uMMISXEmH4Pr3pztB2zUEpaJmLE+OhME8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcAuOjDJ+6jFmpqI5nsg+9SeQEShIoo6vs606cuULFBBvSEElEaUjqhn+VKkC+cvc
	 hBQXkVeWqhF+bSDHXYX/vZz58HzqGXjfWibfSTqADByxeTXGP8vSd7b3EskD4q4RPG
	 yXWdw3iShOGCSGgIqow3KnJLo4xwl8Iw1nbV5t3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1806/2151] dt-bindings: clock: mediatek: Add MT8516 fallbacks
Date: Wed, 18 Nov 2026 15:59:01 +0100
Message-ID: <20261118150227.592989831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 1d48ecb48e2ab9dd2564e735a1c1b29a5eeeb599 ]

MT8516 topckgen and apmixedsys nodes use the common syscon fallback
form. Add the MT8516 compatibles to the branches that allow the
syscon fallback.

Fixes: cd9fdd06b0e8 ("dt-bindings: arm: mediatek: topckgen: Convert to DT schema")
Fixes: 16a146735df3 ("dt-bindings: arm: mediatek: apmixedsys: Convert to DT schema")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260921232807.3137010-1-robh@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/clock/mediatek,apmixedsys.yaml          | 2 +-
 Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/mediatek,apmixedsys.yaml b/Documentation/devicetree/bindings/clock/mediatek,apmixedsys.yaml
index 591a9e862c7d4..438723d253207 100644
--- a/Documentation/devicetree/bindings/clock/mediatek,apmixedsys.yaml
+++ b/Documentation/devicetree/bindings/clock/mediatek,apmixedsys.yaml
@@ -26,7 +26,6 @@ properties:
           - mediatek,mt7988-apmixedsys
           - mediatek,mt8135-apmixedsys
           - mediatek,mt8173-apmixedsys
-          - mediatek,mt8516-apmixedsys
       - items:
           - const: mediatek,mt7623-apmixedsys
           - const: mediatek,mt2701-apmixedsys
@@ -42,6 +41,7 @@ properties:
               - mediatek,mt7629-apmixedsys
               - mediatek,mt8167-apmixedsys
               - mediatek,mt8183-apmixedsys
+              - mediatek,mt8516-apmixedsys
           - const: syscon
 
   reg:
diff --git a/Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml b/Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml
index c080fb0a16181..6594d491e215b 100644
--- a/Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml
+++ b/Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml
@@ -23,7 +23,6 @@ properties:
           - mediatek,mt7622-topckgen
           - mediatek,mt8135-topckgen
           - mediatek,mt8173-topckgen
-          - mediatek,mt8516-topckgen
       - items:
           - const: mediatek,mt7623-topckgen
           - const: mediatek,mt2701-topckgen
@@ -43,6 +42,7 @@ properties:
               - mediatek,mt7988-topckgen
               - mediatek,mt8167-topckgen
               - mediatek,mt8183-topckgen
+              - mediatek,mt8516-topckgen
           - const: syscon
 
   reg:
-- 
2.53.0



