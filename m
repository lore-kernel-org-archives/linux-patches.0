Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024414;
	b=LU0b2mKZkK14rJTeemI2nb5X32dAf9ffcwqknAnsTeALhNQAtSV5Wmi3sVePYt6XghdT
	 6/xLdGThUprFJwX5vIAjTgOSZpgXPHY3D5xM/urJ31DOPZap3Tm48+/j47n4C9Lv8p3nY
	 wJvXgedT+Bm75KbSx9DpaFxHo6F5Pkvzis6oL1xqIxH4Yz3A5X+kvVdccJYvRWvFrE26e
	 4Pv3A32Gb39ef4KWgs2CEHBnjm6njvV2+Vgu1rkbc7/qBmG5qeEEMY+Xqa4YT2sOTueYl
	 VeM1HoFhPTsqlmzhKqvk6BTjtQXbMPLs5Zc4Y6THGCJOXTtvJGfB5rQ0ws7STDfCkbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cCC0rAVVo+Z5nVT5iW8VCHVpHJ7NBEmqo1knqH2/76A=;
	b=lWsah7yzD2YHKab3rmoOO1bBZxLSHJRmQPsnEEDfSXRuiNwXenTHfWsn8x1N0rwTDxYN
	 PyMB5FJIo68lt37F5ikG/0VMMqmQ8Vh26DznpYrg6LHxlSIQQ8/EK/xFmutEyvCvRDOKh
	 J6xcNo/dQLkPHUzcHn2T+ROoCrPeWWC3jKiAGmdQo0mpybIkLQBkypsBwG5uMtYTqAI+N
	 x2dfIY8xGK5G6mJaN8lw9Ygj6AWI2gBEaFCN9cLBtQ5shZpr2tcURHLFzD0JhugOJnKsm
	 8TKfZAY1T+Ft/OJ5TODzhk1XrIqw+znNUaP6cMOKc+KCuHZ76BbZbCAwCQLwtjTXkiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gIa5XaAZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736FD606A32A;
	Wed, 18 Nov 2026 17:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gIa5XaAZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A4F1F000C4;
	Wed, 18 Nov 2026 17:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024414;
	bh=cCC0rAVVo+Z5nVT5iW8VCHVpHJ7NBEmqo1knqH2/76A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gIa5XaAZSGN0PxCjFYi69sEwf9QUjUccpyRgOiqqLdHkNnZBXzHQE/XSFnnKwAKtp
	 1YTXFYvzbLrdsBQ5h9pMl6SEzgBv8CxgmLnIp1nrCs/u4KpqBYb2OpnHdUtUpXE/GN
	 pxWU17vtkqWEgcgsDYFWAAH7AUzaInzh6ckDMBPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0717/2151] dt-bindings: arm: mediatek: Fix MT6779 audsys compatible
Date: Wed, 18 Nov 2026 15:40:52 +0100
Message-ID: <20261118150148.001068468@linuxfoundation.org>
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
index f3a761cbd0fd4..6d060beb2a17b 100644
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



