Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF46211719;
	Thu, 12 Dec 2024 17:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023882; cv=none; b=L9yjBKbLyLEo1g2p1meldAIkkIn9Xw361XvCMbVbez3vyhYaegRuLpAX76W2aRONDKuXh4YFiUBZbmtxEOXxnhh7/nKvKXO9QVNs5TfCAkZhe5SoOmlREYB/osDQev+JWeRgyIbhnheN4/ix8xRYl7jXUIF8Jc/jlZWqMCoDqms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023882; c=relaxed/simple;
	bh=TfxLa6uE2eyubZ+gcvqABvVr9uaWegdrgylsUborHsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEtBlMjs9+bJRvZkBt2jkxCVe0hVxxqnrUAmb1O/ugGli+MuPF7OIoaPhN6zWaAoGucGaiOunA7OlGCuC7PigBH6w6UkJ/qe4u3ckVmcwVtsQvIV2n74NTd6sdTdS1oZAVCx6zf5AWwqws7ecMv17yWVPgJy5MH3+buEnVyrEko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRKOZCBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRKOZCBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E9CC4CECE;
	Thu, 12 Dec 2024 17:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023881;
	bh=TfxLa6uE2eyubZ+gcvqABvVr9uaWegdrgylsUborHsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRKOZCBByF8VYz74ynSRihS8w4RmvDw/mtKiWXAovuzqBnfdklOl1KDB+9MQusNEr
	 CiCa3FFPBqoTFh1TdprFXGzG1hhhsMsBD4ELxxOc08TLJrbyfqvipK6qDAbQGgjdzV
	 xHIjzthaSDftxRkgWPlgTHKLc1+9OsCuAyV6qU4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxin Yu <jiaxin.yu@mediatek.com>,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/459] ASoC: dt-bindings: mt6359: Update generic node name and dmic-mode
Date: Thu, 12 Dec 2024 15:57:31 +0100
Message-ID: <20241212144257.976016497@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Macpaul Lin <macpaul.lin@mediatek.com>

[ Upstream commit 4649cbd97fdae5069e9a71cd7669b62b90e03669 ]

Some fix and updates in the following items:
1. examples:
   Update generic node name to 'audio-codec' to comply with the
   coming change in 'mt6359.dtsi'. This change is necessary to fix the
   dtbs_check error:
   pmic: 'mt6359codec' does not match any of the regexes: 'pinctrl-[0-9]+'

2. mediatek,dmic-mode:
   After inspecting the .dts and .dtsi files using 'mt6359-codec', it was
   discovered that the definitions of 'two wires' and 'one wire' are
   inverted compared to the DT schema.
   For example, the following boards using MT6359 PMIC:
    - mt8192-asurada.dtsi
    - mt8195-cherry.dtsi
   These boards use the same definitions of 'dmic-mode' as other boards
   using MT6358 PMIC. The meaning of '0' or '1' has been noted as comments
   in the device trees.

   Upon examining the code in [1] and [2], it was confirmed that the
   definitions of 'dmic-mode' are consistent between "MT6359 PMIC" and
   "MT6358 PMIC". Therefore, the DT Schema should be correct as is.

References:
[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/sound/soc/codecs/mt6358.c#n1875
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/sound/soc/codecs/mt6359.c#L1515

Fixes: 539237d1c609 ("dt-bindings: mediatek: mt6359: add codec document")
Signed-off-by: Jiaxin Yu <jiaxin.yu@mediatek.com>
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20240930075451.14196-1-macpaul.lin@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/sound/mt6359.yaml | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/mt6359.yaml b/Documentation/devicetree/bindings/sound/mt6359.yaml
index a54f466f769d4..74330f54d6db4 100644
--- a/Documentation/devicetree/bindings/sound/mt6359.yaml
+++ b/Documentation/devicetree/bindings/sound/mt6359.yaml
@@ -23,8 +23,8 @@ properties:
       Indicates how many data pins are used to transmit two channels of PDM
       signal. 0 means two wires, 1 means one wire. Default value is 0.
     enum:
-      - 0 # one wire
-      - 1 # two wires
+      - 0 # two wires
+      - 1 # one wire
 
   mediatek,mic-type-0:
     $ref: /schemas/types.yaml#/definitions/uint32
@@ -53,9 +53,9 @@ additionalProperties: false
 
 examples:
   - |
-    mt6359codec: mt6359codec {
-      mediatek,dmic-mode = <0>;
-      mediatek,mic-type-0 = <2>;
+    mt6359codec: audio-codec {
+        mediatek,dmic-mode = <0>;
+        mediatek,mic-type-0 = <2>;
     };
 
 ...
-- 
2.43.0



