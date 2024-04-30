Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32EB8801;
	Tue, 30 Apr 2024 11:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476172; cv=none; b=GAEEff2yAFVs431RJ8lyb47mXWPAe3urISm2B6GwhWiAJlZSGQxuFOrcMzPRa8xhpLPM7vvpYkcJYmOitb1NOb51vitv2J6DclafNNSx14ACEANBqxdwCtkHFozIGc0sGiRmm+FtHPziySc22f7KUyZy5ii56lFYizHIzTvBvFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476172; c=relaxed/simple;
	bh=GEuMQ4FZg4c78sOf76K7OwnQIIKTUg2f0wnn/8USN8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uSxnBsekA56fVeavXpuE6TRLqGAWHa87QQdCHiVX3sFsSulg+w0XA4n+vVtoED6syIMplq/bcpMQS9G1i5bYHYmuDvtN1h+r2RoNWsmvPeGsZz9kOqWu+Y8mjy2Fe/OnXLG9nJULbuZYpItGc3cskr/z+JHlbFiVZD6kkVLkcww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jiPr8dZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jiPr8dZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673F0C4AF1C;
	Tue, 30 Apr 2024 11:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476171;
	bh=GEuMQ4FZg4c78sOf76K7OwnQIIKTUg2f0wnn/8USN8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jiPr8dZTO3rCLvUKejGZIPnNIpkCGWMWHN9QVNQFku+cgVdzMLqKTdAJBTY564zjn
	 f4mecxpZPt20iH5cBQK0GppJa0euJJwmIw2CmHXKmJTWLUeFhgrg3G3GGWdeIz89f5
	 gSRgyQ9vVNhYFnNxg4/JiW2DqlvLY3mybJMZzkPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/107] arm64: dts: mediatek: mt7622: drop "reset-names" from thermal block
Date: Tue, 30 Apr 2024 12:40:17 +0200
Message-ID: <20240430103046.339464033@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit ecb5b0034f5bcc35003b4b965cf50c6e98316e79 ]

Binding doesn't specify "reset-names" property and Linux driver also
doesn't use it.

Fix following validation error:
arch/arm64/boot/dts/mediatek/mt7622-rfb1.dtb: thermal@1100b000: Unevaluated properties are not allowed ('reset-names' was unexpected)
        from schema $id: http://devicetree.org/schemas/thermal/mediatek,thermal.yaml#

Fixes: ae457b7679c4 ("arm64: dts: mt7622: add SoC and peripheral related device nodes")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240317221050.18595-5-zajec5@gmail.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index aa4593af576c7..122ff44a092e5 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -507,7 +507,6 @@
 			 <&pericfg CLK_PERI_AUXADC_PD>;
 		clock-names = "therm", "auxadc";
 		resets = <&pericfg MT7622_PERI_THERM_SW_RST>;
-		reset-names = "therm";
 		mediatek,auxadc = <&auxadc>;
 		mediatek,apmixedsys = <&apmixedsys>;
 		nvmem-cells = <&thermal_calibration>;
-- 
2.43.0



