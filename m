Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721782054EF;
	Thu, 12 Dec 2024 16:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022149; cv=none; b=OMHGRakr8M0teiS8QGlXBZ85hGsi5oOS826oOpREk003agXypTkr71Tic5HkMl6pApkH5NoTdCwbO+T0FU6FhHkZBnW4QUQzLn++EClt7cFdx/HzpaLZNPVioV5wFwIpKrZtOea7o2z3wcS4qWujAYKZ33GAThyDbrA3HvplhFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022149; c=relaxed/simple;
	bh=Uk2AS9IQb2QKhKVsERXTeKIFoFHgv5kU0mzhYVc6948=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMmbl5GcQeUVhGHJgm4rEacvqdyNCl59eZ5N9bx3xq0XD+hJWzyWnRjsZB+ua6BXf46aWCLKVlshSOZ9xd4wG9M0BE/PeUEmdzS0jAYz9LwomUyFjyhRke/rrcnbYREipjmol/jXKXwNKjgB4tJtJl8iBx1gbB4Vz2lqpP2mpo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SILjXTnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SILjXTnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C15C4CECE;
	Thu, 12 Dec 2024 16:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022149;
	bh=Uk2AS9IQb2QKhKVsERXTeKIFoFHgv5kU0mzhYVc6948=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SILjXTnK+B+X6hEqEnwn+fL7ZC/kZMeR87vjsy/YHwGFzuhrxztpgMaAKZTE5u6jc
	 OsqIlSaihnXjXR0m/w+2Li8wR7365xmWT2TM2XQN8lUXA+OoLPEzTES5xo3bzaWdFO
	 Af0mh+SDPgaeTrp91aBLr4jJOoiA5Scw6ml6NLOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxin Yu <jiaxin.yu@mediatek.com>,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/565] ASoC: dt-bindings: mt6359: Update generic node name and dmic-mode
Date: Thu, 12 Dec 2024 15:55:57 +0100
Message-ID: <20241212144317.879676949@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



