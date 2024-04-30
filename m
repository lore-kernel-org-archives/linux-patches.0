Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88AB12D746;
	Tue, 30 Apr 2024 11:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476393; cv=none; b=JgawBPWkdyjBwSJbvtFGSoGZMgV4FuBiKgHez4AYPKKlfyilZgnYu3Al3ay1XmJH6XgMxWEqOKn7EqQef87HyMmsmBc3ME81TxL+ox3vM7BXlBb7rPkmWQhKaC05QGPDzasV2lvIUtdnGMgILt2WEfuf+K0X0jFJ37krBq/TaTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476393; c=relaxed/simple;
	bh=Tu09Zo2+mOD03P0gpO5yQmLwG4EizAr8MnI5FOvTGOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T61jiLJOYrtHMwZkQD9m/v6ckbCnztTvnZ3cj6EAZ569cx4AHGZXDqL6nOgLnv1mgvoy0zkR691buFM6ew+iW8IKc0h0SQq7tkplazLbHbZmzN9AoXApXykNk+gGNDD2GmNJP/QgtRQjEbf23hdJXUCoeTsCb4+VVtn7raGdk38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXxyvPqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXxyvPqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB32CC2BBFC;
	Tue, 30 Apr 2024 11:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476393;
	bh=Tu09Zo2+mOD03P0gpO5yQmLwG4EizAr8MnI5FOvTGOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXxyvPqoETSxWGfBBTkeNTJIMa3fMW2qVsJqQyX9P+5keInmNhY6DvjQEEvnJ8FCU
	 zUi0ippui01w8mDqmHXHXb4/70UGoPj9IugGEYq6lhu51PPsbiKnVFeRok73KjV5V0
	 A35u14yZwCXex3lYgJ3SEdi8OAexexXqOmvyMCbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/110] arm64: dts: mediatek: mt7622: drop "reset-names" from thermal block
Date: Tue, 30 Apr 2024 12:39:48 +0200
Message-ID: <20240430103048.138772542@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5b7be71afa5c1..f8a32006885bb 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -512,7 +512,6 @@
 			 <&pericfg CLK_PERI_AUXADC_PD>;
 		clock-names = "therm", "auxadc";
 		resets = <&pericfg MT7622_PERI_THERM_SW_RST>;
-		reset-names = "therm";
 		mediatek,auxadc = <&auxadc>;
 		mediatek,apmixedsys = <&apmixedsys>;
 		nvmem-cells = <&thermal_calibration>;
-- 
2.43.0



