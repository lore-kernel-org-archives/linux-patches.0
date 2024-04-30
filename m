Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F007112C462;
	Tue, 30 Apr 2024 11:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475095; cv=none; b=GRI3VEbf1xfZ3ncYRF7j7cgvOjfkkN5oq9m/n6y/YmVP6osLXJv1K5afGmThRywcBTGt0U3sKPMUlJxQ9rRURgcbUX+TH+hgpBbsqOeWFsefHChVwoVOWr/LYi0p24urS2Ps2LzMTtXF85K/F/ZM6OO9gTwYZ/CsvK84ORA6bKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475095; c=relaxed/simple;
	bh=Q0YCzPw0DU8sVweO5NMjfsM0F17v8NQ8Fsjfv87XYuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=om5b/2nwkbxdagDGNPmiI1wEGT/um+ff6cvZJDhlorWXgFV4HAffSBLkWnMKjWCkcLnqgs/x2+EiR7TwdM+qlfOPxjibu0/XFBusTbf18KqiMUzFQbBYmdRa21AmObLP9EkhtGp9im2nRyek9mkpvukxfkKaLuFF+UpOXM/WvAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZKQhAuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZKQhAuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E77BC2BBFC;
	Tue, 30 Apr 2024 11:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475094;
	bh=Q0YCzPw0DU8sVweO5NMjfsM0F17v8NQ8Fsjfv87XYuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZKQhAucZCOmLWm61Xe8o/nvyKSgmI9tExQkDgfgdIOFFbDgWX4qs/hh0ya75PHG+
	 gFHxogkr2+wXgKp4poFUdmnYvq4zd1pHEtkAVJygMTsZemgdIBCMkx4qCVIWGC1bF9
	 6HXJ8BAtdL8Ns2UIEDQVkbyCLwNqOYMsBJNi40xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/138] arm64: dts: mediatek: mt7622: drop "reset-names" from thermal block
Date: Tue, 30 Apr 2024 12:39:26 +0200
Message-ID: <20240430103051.807157318@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 974520bd3d8fb..4454115ad8a0d 100644
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



