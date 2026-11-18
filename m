Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030093;
	b=D3S3a8YNQhwYxKN0CiG6YOUFrwll/zsK/SgFlldzdinkSaskqowmZx2/UgZjV2UQFp/w
	 G+yn2uTZwWOf2+Xj6YjTMZMiZVYK050lODeZOXFpsM9bFn79roLO+oYPlE1dwP6qpKaMD
	 RAhD+SMhi3+8XRzzfi3CtivKgH7ZcV+Cfg9FjEz/mJcQIVH92iOC6pts4O0/CjQY/iY2x
	 RoENxfaPOU6TCAn2QIVf1ocXbmZz5zu57FJ1eISKmpN84PurKhV0g+FJB9+VvThn3YGjh
	 Sok11rb4QVi5uFSbCzALgyiRPBZ1Rv80D+mOkhYasoHGEAC+wx735Tbxp23sMZj8fyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P2cfdcbhkwUOf6r08PHeIN8tFpKpa0sqPCkkGo1MNoc=;
	b=Gb7q7TIRcfHOC7UpFf0gB0xGB+9nxQP93UDvWERwRMLNahUnT/DQ57CgD063yzAbDIsy
	 G9Lt5HsWH/4Gi2JqDVQT6V8kBAsRrWOF8RrHKKLwCQ1ELdOMzK6bZZIS52kUWEc38wy1/
	 NGwBmcF/ctp9c1khjcpcsMoM+XLaWcb9Y5EFmDkPQI6XBIaBIy+F5h7ihz/lg6CkvwuB5
	 QEMtgEPm6gdSdZ76BLZ8EzaXQ9rYfKZN7QzIcPPafKVeO9ytXnqnyDGmdxuxuv+nfQ9lS
	 S5eKlW+7JJ/97GhpPegjb0Cw14YbKxVMBc8uiL1rCciVyJYzeDxmz7P9fN0njJNkpVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rpMk9eZg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F66260A5BEB;
	Wed, 18 Nov 2026 19:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rpMk9eZg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5EB1F000C4;
	Wed, 18 Nov 2026 19:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030093;
	bh=P2cfdcbhkwUOf6r08PHeIN8tFpKpa0sqPCkkGo1MNoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rpMk9eZgL0uzBA30vfz81/Kjgtm/I+zprMvC33xPsuWof5V1ULE6Te+wPL9EERR7M
	 9GIHzTwaDwH1hieY0tdljUsSVamv/hG3uFJOnGvum9+joTi0WVAacTmNYC0jtcohwB
	 lvqsa0isFPMPBpPBuFUdGpY2k+A4k2moWEwvijjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0582/1756] dt-bindings: arm: mediatek: Fix MT6779 audsys compatible
Date: Wed, 18 Nov 2026 15:45:09 +0100
Message-ID: <20261118150032.203344544@linuxfoundation.org>
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
index 45d4a6620041b..c2d263475c363 100644
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



