Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050258;
	b=ng4V9WRRiF8TUkri48z0BHMtNuVir0I5ruuNsLThL8RS44BzzvOjgYSoh9WBlMkEhz3i
	 qnX66fNUnwpAMIRY7qH/3fglaRmoNRGbLpaSAoDv6G8zb7YclZQSwo50/v+zENYDTNe7C
	 XH9spNroiE+4L4UFfZxFXEz2rSxzKEMnzZhpHbi6AjDZ+bLbHRKO0SeCX0zUKc973aObA
	 /U9BAc53l6BjHI84B6h0CDUboDfTL6XbR3jl0zRbM3UGiVYVH076LtpPL3DT/JMZotxX+
	 9d4ZJg3h4zXX3UbL6zt6yGLHQn91q2DW6lRIjqUY6JEIC6lBPkuYFq/juD2xQyMp/LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=luZHKY3wVrMOadfLPRIXY8feD8m4yp7etE4HDsdKJxY=;
	b=ffrtDYuIEAvHPkVfJRdLvuTSASR9jJLiO3UuUZmzIByeNVyiX7qy7vLPAaIrZa3is3Iv
	 l8HFYJ28pTt5Ih9doWVbVd3gjsmjhoP4XpOdp2Qsp9FJWv8atTn4AIlIkEknhwTc2Y/M0
	 tEjmBkm+vK1TQZzz+7Nb+ascWfs9tTxDyhrM22TWwyv/Wnm71hlHxcme/mDshY+SqHqRy
	 fmBS/8hOYoooFuCJ8AwmSyOpDEygVs2Sg+nCMq1ub1/JnfUbB4gqy/GAZv9FwW+K7DIU3
	 yCZTok2wK3QlPQKpFJOGYMi4+WveZk64FdoE9SELxTjr1AtgLoMdk0Y5+0gz+NoopdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z6eliwCf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49575606A325;
	Thu, 19 Nov 2026 01:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z6eliwCf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8171F000C4;
	Thu, 19 Nov 2026 01:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050258;
	bh=luZHKY3wVrMOadfLPRIXY8feD8m4yp7etE4HDsdKJxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6eliwCfHQV5FJheBOx2KDG3YSZ/Im2LvSV2Y5tzlXG37Xa2qou59lg1Lkh8ssH1L
	 FgcjrsugILH/8BqPfzG8PoiGJHONL5qjqrGfEhvQKibl3+K7iQ5pBFw2Nwbthtd9Vn
	 V1CmEUUpWFbcjgAx8FaPa75CDCWPyn8n04UuGpz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2644/2857] dt-bindings: clock: mediatek: Add MT8516 fallbacks
Date: Wed, 18 Nov 2026 16:01:18 +0100
Message-ID: <20261118150336.787586982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 731bfe0408c20..79d719d9f8dd2 100644
--- a/Documentation/devicetree/bindings/clock/mediatek,apmixedsys.yaml
+++ b/Documentation/devicetree/bindings/clock/mediatek,apmixedsys.yaml
@@ -23,7 +23,6 @@ properties:
           - mediatek,mt7986-apmixedsys
           - mediatek,mt8135-apmixedsys
           - mediatek,mt8173-apmixedsys
-          - mediatek,mt8516-apmixedsys
       - items:
           - const: mediatek,mt7623-apmixedsys
           - const: mediatek,mt2701-apmixedsys
@@ -38,6 +37,7 @@ properties:
               - mediatek,mt7629-apmixedsys
               - mediatek,mt8167-apmixedsys
               - mediatek,mt8183-apmixedsys
+              - mediatek,mt8516-apmixedsys
           - const: syscon
 
   reg:
diff --git a/Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml b/Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml
index 81531b5b0db79..2ef5012939cc1 100644
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
@@ -38,6 +37,7 @@ properties:
               - mediatek,mt7986-topckgen
               - mediatek,mt8167-topckgen
               - mediatek,mt8183-topckgen
+              - mediatek,mt8516-topckgen
           - const: syscon
 
   reg:
-- 
2.53.0



