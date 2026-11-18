Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032501;
	b=XXlc+I/qOVYlYD3Jm0rBKqPWbXE8jB3BDM9s2ycKZJC0/htXPmO6koNnwqVZ+pXq90s4
	 6gHdGXc2T02xRVH099zZkQELNcqXBXGdGYnQ3Mrz99WtF2S39+zcWxyG2S/D6I9i+K8GB
	 gwXAEmW3F9x6D6lQJexbo/UDkT4UzDbR9idFFuC7kyGjj76NLPbrMYOMTBHhOGT5xGTCi
	 gTydoPkfy2it3p36oZpGBsdQhKLmwMhpMoh/Em0u7CiSJMj0CDCv55EsvRREf9iCsJPl+
	 AoSvjZyS+wBzDIsnDjLkDICf5aMdoDtCnGAshy+y73hctRgNZqSdbvPaPRYUaQbnHzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Suv7gVz6SH6D8ITpSKmLrDSwXzkf7afHMlsRyt0QGOk=;
	b=5Kl31NOdd0NE42JsK+cT9MYAZeBPi9Q9hmrel6QvKTUJHNvlNgKbFo2V8/GHmmY5I713
	 +aFHcQvjw26Jxd2BlkIiOpQkgwAoiELJn7LQEWJwbbiTbY2I7hDHLPpItes/GEfYG+2EN
	 bpevNxMy8DwFQ7IRMxw5vaa3LcVcAdrDipf1TbAy8BQL6jZ5uDHSwUR1C48o8M5o9elGM
	 wF0wPHKHxW/keoYm4RYBUquFUCnfXJbnNct6kys2VqOQXxzeKPeIQJBzqYPGOcyTBLElY
	 OCdRm4QiA22OWm/8wLkamcbhMnLXBBuz2Wekd7FmrYDrhC9OfJE3ioKihIRylFKsLzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="H3m3//WR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FAB606A867;
	Wed, 18 Nov 2026 20:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H3m3//WR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA611F000C4;
	Wed, 18 Nov 2026 20:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032500;
	bh=Suv7gVz6SH6D8ITpSKmLrDSwXzkf7afHMlsRyt0QGOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H3m3//WRdUsNzPCd46fUQ6g5UuDMpQhsG9fGJK7iswD54wLwJBkQA6leADD1evcCq
	 Cj5b/EasvSg7uMYXnyzQ1XILcEUGT5s6qh2dI3dpo74hLlKyYmKiVavmpCG8Ru1ZCC
	 Y/p6/MP1XcDII7qSGRNH0p9NUy2uc66atafJsw6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1434/1756] dt-bindings: clock: mediatek: Add MT8516 fallbacks
Date: Wed, 18 Nov 2026 15:59:21 +0100
Message-ID: <20261118150106.265889609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index db5f48e4dd157..61a57f80c942e 100644
--- a/Documentation/devicetree/bindings/clock/mediatek,apmixedsys.yaml
+++ b/Documentation/devicetree/bindings/clock/mediatek,apmixedsys.yaml
@@ -25,7 +25,6 @@ properties:
           - mediatek,mt7988-apmixedsys
           - mediatek,mt8135-apmixedsys
           - mediatek,mt8173-apmixedsys
-          - mediatek,mt8516-apmixedsys
       - items:
           - const: mediatek,mt7623-apmixedsys
           - const: mediatek,mt2701-apmixedsys
@@ -40,6 +39,7 @@ properties:
               - mediatek,mt7629-apmixedsys
               - mediatek,mt8167-apmixedsys
               - mediatek,mt8183-apmixedsys
+              - mediatek,mt8516-apmixedsys
           - const: syscon
 
   reg:
diff --git a/Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml b/Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml
index bdf3b55bd56fd..c54225259260b 100644
--- a/Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml
+++ b/Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml
@@ -22,7 +22,6 @@ properties:
           - mediatek,mt7622-topckgen
           - mediatek,mt8135-topckgen
           - mediatek,mt8173-topckgen
-          - mediatek,mt8516-topckgen
       - items:
           - const: mediatek,mt7623-topckgen
           - const: mediatek,mt2701-topckgen
@@ -41,6 +40,7 @@ properties:
               - mediatek,mt7988-topckgen
               - mediatek,mt8167-topckgen
               - mediatek,mt8183-topckgen
+              - mediatek,mt8516-topckgen
           - const: syscon
 
   reg:
-- 
2.53.0



