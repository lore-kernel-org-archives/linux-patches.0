Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85088801;
	Tue, 30 Apr 2024 11:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475777; cv=none; b=S+NfZ8Y5J3du2iaAbBteLOf2EAwzZTQH9tz/X84EQIaC+1YY+f7oVowkvjgoAhLPoeU23PC5IV8QHAdF4fQ5Qf1ovy50pHm8F6t4ZraWhBdXCMej3KFKZz6LJqji2FgAlY6OEAxNaVGdVHSUrpIhy29u+z9sJBdiqajKWYBnoXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475777; c=relaxed/simple;
	bh=E+n2M29YgJFCgxEf0il+JIMO3yi93WBL2Ry1+coo1Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=miBqZi9gXo936bPRonaYB4bcxbRhXsNOiX26yk/te2DHTFKfiH/fMgQODQGanEoDpjemlActwNSUkXD/1Q7SQzL/5G0/IfgBCpM7mrV3gefsDH4jr4tdYwmdmXmQs63pyidRtPY6zVFHpdxXCZuJWP5RvRc+TbvP63hNtzU4M+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w50WLuA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w50WLuA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175FFC2BBFC;
	Tue, 30 Apr 2024 11:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475777;
	bh=E+n2M29YgJFCgxEf0il+JIMO3yi93WBL2Ry1+coo1Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w50WLuA+3bFQ5bgXZwtd1vS20Le9kxEMEjpjhNDk1o0BPO88C8QtPomMe3fk1qyko
	 Rx7lSC70BjRaPjiZyVvrN08OJsoAVpOp55YfdKQ9cm6DJOuV8RD5YHYClnwKJEi9vZ
	 84enDnJwWCSRZgyVdXeuAUACFoRZ7y8je3J61lAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 15/80] arm64: dts: mediatek: mt7622: drop "reset-names" from thermal block
Date: Tue, 30 Apr 2024 12:39:47 +0200
Message-ID: <20240430103043.862080347@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7a54af96e1d90..5f21f1e95d095 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -505,7 +505,6 @@
 			 <&pericfg CLK_PERI_AUXADC_PD>;
 		clock-names = "therm", "auxadc";
 		resets = <&pericfg MT7622_PERI_THERM_SW_RST>;
-		reset-names = "therm";
 		mediatek,auxadc = <&auxadc>;
 		mediatek,apmixedsys = <&apmixedsys>;
 		nvmem-cells = <&thermal_calibration>;
-- 
2.43.0



