Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042152;
	b=aS9XPNFCpVvuXNVadjzJeSLPSPJoO6T3iPVlMe46RdFAom0+FV7KuU+CBaYqGqiZBFO1
	 Ffeg6PuitlG1sdohmr4P0yN4P9MsdQwXNo2US+pezjmC8l4ue/GYFeWxdrTJvoLejPEHT
	 hHGd5M7S3YcXv5v9/K/D5hpo/6qcaFzodyEdD7s8XwfksBPRkv2y9TRV6auqiNozLDWdc
	 PXxlyUNIOAGN0GV4fvFqTZ7CVmWLcYdGcbOUk7txhz2ft8dK50czrIEa1DS1TRO2y1u8V
	 jVIgqWCLlWNYpjixCMREY38IyJHvYF21t5vFZ5Z/1NKgxZlLOiCrEIYuqRkW5DspZvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9lUU/Bo71MKW0Uf0LsVaj3Jlk2D0eAvRJarTQZNhuu4=;
	b=HXgSoA9wna3/CiO7gBtHqIdf3cwKw3Jd7AfExKRbnS2dP4p5uwIYTcdhSdVz7BAr68vI
	 lvfZpRH3VSq8WYpd1Y0CbGp2Rdg3BgiDXVEYxEYr/97s3hjmy5mEOWssodREorEklX9DV
	 I8NnfmmDg5WkpEKhTmBA4f/EMWxzoM5NrqdUeROkFVJx/PRrll82fIprWVXDZx7U8BbQ7
	 xwjt1dG3cefVMfFXldN9VnrAiYvnNG2PjZpH4q+FoowVTnyudZhmaFdgpgVbfN2UtPmPx
	 1wj5LfVulb0JNg1SIMQN/+q9KxBs1xSenTMAacbXgzfwcA13phF9n/0+yOCESKEwK4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jozuxbs/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AFB606A320;
	Wed, 18 Nov 2026 22:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jozuxbs/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A2E1F000C5;
	Wed, 18 Nov 2026 22:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042152;
	bh=9lUU/Bo71MKW0Uf0LsVaj3Jlk2D0eAvRJarTQZNhuu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jozuxbs/9K4GQ3Yetxo7y1bxkY0eEFAbGqW81Dg7h/qJ7cYY5Uf59/LTIo1kGX8n6
	 Xjzs1M7AwkoDyNp7r0m8U+po4ODBiEyAucrfLIOeDQeop0QFS57/y357pL03n18ny6
	 dR8XAzDEOifSpuZ6iVja2AWRWEQVYxORuFTAL3O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3066/3318] dt-bindings: clock: mediatek: Add MT8516 fallbacks
Date: Wed, 18 Nov 2026 16:01:28 +0100
Message-ID: <20261118150452.101260086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 372c1d744bc27..8a0e19705a541 100644
--- a/Documentation/devicetree/bindings/clock/mediatek,apmixedsys.yaml
+++ b/Documentation/devicetree/bindings/clock/mediatek,apmixedsys.yaml
@@ -24,7 +24,6 @@ properties:
           - mediatek,mt7986-apmixedsys
           - mediatek,mt8135-apmixedsys
           - mediatek,mt8173-apmixedsys
-          - mediatek,mt8516-apmixedsys
       - items:
           - const: mediatek,mt7623-apmixedsys
           - const: mediatek,mt2701-apmixedsys
@@ -39,6 +38,7 @@ properties:
               - mediatek,mt7629-apmixedsys
               - mediatek,mt8167-apmixedsys
               - mediatek,mt8183-apmixedsys
+              - mediatek,mt8516-apmixedsys
           - const: syscon
 
   reg:
diff --git a/Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml b/Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml
index 6d087ded7437a..2dd00adec3c97 100644
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
@@ -39,6 +38,7 @@ properties:
               - mediatek,mt7986-topckgen
               - mediatek,mt8167-topckgen
               - mediatek,mt8183-topckgen
+              - mediatek,mt8516-topckgen
           - const: syscon
 
   reg:
-- 
2.53.0



