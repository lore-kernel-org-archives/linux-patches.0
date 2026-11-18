Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017264;
	b=HA8ngLU0f1p77byvrIJXOc2rom7IcuIzGdu0yjXRsFRg9C9PPJdNaU173SUuREyAV27n
	 Gpygr+mHyEfnIMO2dbX21m7W1pf547bn5iH9jR1EqFnHwTlxZRXL1h5SGVCj8ZQmBoeSI
	 LWztOq2PXO7dFWtGV661GRyMUrgRmQ5Ib5KUfnaBoujp8hFu+oAGBeiNLu5EQPvGZX1H2
	 Bmgk3jcXn1abAmbGUswfFsEdzF3/Gy6wEif68bObFj44U53R4ADywUKkYP6XeU3eSYTy8
	 qoy1sH40kYSZ89iyA35veUKIHzbH5LXZcW0FnFkw+aunn9O+S3hVJ3fu3U/Y3oMSexQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6tLVyPwAC6hcZZ9AVYL96fLuY89d4HQa1ll4pXxyQfo=;
	b=reWo/QFHl/IO+qafVCOkRXBayDnm0wUjrbCW0ehaM5ga0KqSdttU/n2wPsexNBdDN0iH
	 JxKz1zPv5p6N10p20TrX+1s5LuyOaaz+bX08zz9kC6dDVaYApdTlVz/xq4yRRzn666DAZ
	 sIn2qj9RXVNdmzXxQ0I3xFa/IRBTsVifV5cpmeI4KRuLYQoV/+JO8huDNg2pmgH/axCDw
	 new3pya2fYjlcXayvtViyIC6GlzvZ83e28bqhwzqKlwcWFlyEyQZUhzai76tnrhzzXJ5y
	 1cbNCB9Jp+Nc+fbSOm3zvLIVhYeyy5vdWQsLKKjP6SgqzliWLh0llB9QcTRBHb4xuFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qhJbrQn9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A427606A31C;
	Wed, 18 Nov 2026 15:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qhJbrQn9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896631F000C4;
	Wed, 18 Nov 2026 15:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017264;
	bh=6tLVyPwAC6hcZZ9AVYL96fLuY89d4HQa1ll4pXxyQfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qhJbrQn97vCgI7g6gl37jGMhJu4KBnTgmnT4rlvywWKbYvz7lGqBUwnTfRDAcZIXN
	 Cz4z9qxpyqSORs6A0CgWSGm9Ab8LQy+68EV24dWYT25Mml0DDneut+HCL88IVTok4u
	 CZ889PG4PmoEyC2xqG9j09/uBasN11oDHIwUV+bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0820/2651] dt-bindings: arm: mediatek: Fix MT6779 audsys compatible
Date: Wed, 18 Nov 2026 15:34:20 +0100
Message-ID: <20261118150317.414690237@linuxfoundation.org>
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

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 034b3b1ce25a62222920e2bb3b6a0c7ef160b108 ]

The correct name for the MediaTek MT6779 audsys compatible is
"mediatek,mt6779-audio", not "mediatek,mt6779-audsys". The original .txt
binding was correct.

Fixes: e97c618234d9 ("dt-bindings: arm: mediatek: convert audsys and mt2701-afe-pcm to yaml")
Assisted-by: LLM
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260921232819.3137721-1-robh@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/arm/mediatek/mediatek,audsys.yaml       | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,audsys.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,audsys.yaml
index 9aa39b002361d..5ede7d277488c 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,audsys.yaml
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,audsys.yaml
@@ -19,7 +19,7 @@ properties:
           - enum:
               - mediatek,mt2701-audsys
               - mediatek,mt6765-audsys
-              - mediatek,mt6779-audsys
+              - mediatek,mt6779-audio
               - mediatek,mt7622-audsys
               - mediatek,mt8167-audsys
               - mediatek,mt8173-audsys
-- 
2.53.0



