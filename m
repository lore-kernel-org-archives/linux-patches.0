Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA1B12C462;
	Tue, 30 Apr 2024 11:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475181; cv=none; b=ls3Aqin6svSQzowMrYA73WBwJRouD6Lx6CVPn/HmtOZn2e01+H3dUajjoO+flFs7XfPk2qWfuu/Gz70E7HPgiPwR7NITVC1V2XowQxaktdGIAKH/QY449znkZWwnRADi79x6YNLEshwXo1WRvDVSNtCfVBv8tI/o2GF6vDhllzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475181; c=relaxed/simple;
	bh=XqsdULsb7PNe1wEa/VJRciHq5nCt6qcjq9lTYFMPnWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eE+dSMHRiTpPu6GhxDsNeERghnOnFes+i/QBrpNskQSOUKuEFnAahsjDDdpK1FE7AkUK48LeDWsth9IWv5T4Tlqgf9ATVG8EiXyscjMFOtaE/q3aW4tmrTvqcc5+ysgkQa3+9ABb4GjB6EYz3TaGRDT5Z6qsz8BMBdd+JmXHNHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Di5TNzFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Di5TNzFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C626C2BBFC;
	Tue, 30 Apr 2024 11:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475181;
	bh=XqsdULsb7PNe1wEa/VJRciHq5nCt6qcjq9lTYFMPnWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Di5TNzFaiqbvPeOp/9fjKrWMaPeEh1VSgEMAJyc+RPFAyioXILLnMxbhQiF4+fMHa
	 M/TwwsI3WJQaZwp+sENfA03YDZG/YHeqxGuYiZaGkkxsenhDD+9VEjeBJ4z5vsIMEp
	 wVvtejYHIShv2Q7W+EjUBuvHAF9kHxkcImvCJGtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/186] arm64: dts: mediatek: mt8195-cherry: Update min voltage constraint for MT6315
Date: Tue, 30 Apr 2024 12:37:51 +0200
Message-ID: <20240430103058.578381393@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit e9a6b8b5c61350535c7eb5ea9b2dde0d5745bd1b ]

Update the minimum voltage from 300000 uV to 400000 uV so it matches
the MT6315 datasheet.

Also update the minimum voltage for Vgpu regulator from 625000 uV to
400000 uV because the requested voltage could be lower than the minimum
voltage on the GPU OPP table when the MTK Smart Voltage Scaling (SVS)
driver is enabled.

Fixes: 260c04d425eb ("arm64: dts: mediatek: cherry: Enable MT6315 regulators on SPMI bus")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240315111621.2263159-3-treapking@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
index 663c9f414b611..b78f408110bf7 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
@@ -1205,7 +1205,7 @@
 			mt6315_6_vbuck1: vbuck1 {
 				regulator-compatible = "vbuck1";
 				regulator-name = "Vbcpu";
-				regulator-min-microvolt = <300000>;
+				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
 				regulator-enable-ramp-delay = <256>;
 				regulator-ramp-delay = <6250>;
@@ -1223,7 +1223,7 @@
 			mt6315_7_vbuck1: vbuck1 {
 				regulator-compatible = "vbuck1";
 				regulator-name = "Vgpu";
-				regulator-min-microvolt = <625000>;
+				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
 				regulator-enable-ramp-delay = <256>;
 				regulator-ramp-delay = <6250>;
-- 
2.43.0



