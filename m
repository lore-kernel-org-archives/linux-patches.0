Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B881442E8;
	Fri,  6 Dec 2024 14:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496945; cv=none; b=C4PXv9u8NzVfd/CsmKTD7z2byMTKU+b+QN7Nl2eTU6ufSZsezCmZSgDbD7qNA2UYfrCeul6sDr/e7iJasYMsXD0VR6JnpI5jRnk59DLzc7iPaO+q8HmYx03PyrCkv1ne/6PcrQYu0fuO/QuTdxhcqj2krexOv/yLzZ+8k5W3lgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496945; c=relaxed/simple;
	bh=P+NDpbWbQ1ygmZ3bQc2Ha0IJldtgQ37nwi993IV8ja4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmhS4umTpEdXjlCnbcrm9OiJuKXGrNl/qGX8Ei5PYQ/vH9tmgwJl5lMX5IKN2TJGMzQhq2pKYstzvEDt8DAKMRDG5y2VbvqwJa9aQCaAy9LHa4v49Luk7ZTN3N6q/0Kw42CdLWJH+BBg7VQFI3hjanuwsuXgtHnM6zsGSDa81VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOQK/Rhr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOQK/Rhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C00C4CED1;
	Fri,  6 Dec 2024 14:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496944;
	bh=P+NDpbWbQ1ygmZ3bQc2Ha0IJldtgQ37nwi993IV8ja4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOQK/RhrsrJIW1/M/ry9tNiqwz7Cl0t+timbLzOMfF6TOvwKsqe+OYPx6AP80PI+x
	 FqOLWsh5AckWrxUNQxrTQu8+AMcBVHrwCmTv8pO5CYJ9DPI3mB7j6uYiVDbyqr5HpI
	 QY17JvWjDbVeQOH0JuDhEDd6aGE0/xjL2+Ju2Qt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/676] arm64: dts: mediatek: mt6358: fix dtbs_check error
Date: Fri,  6 Dec 2024 15:29:31 +0100
Message-ID: <20241206143659.289422853@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Macpaul Lin <macpaul.lin@mediatek.com>

[ Upstream commit 76ab2ae0ab9ebb2d70e6ee8a9f59911621192c37 ]

Fix DTBS check errors for 'mt6358codec' and 'mt6358regulator':

Error message is:
pmic: 'mt6358codec' and 'mt6358regulator' does not match any of the
regexes: 'pinctrl-[0-9]+'.
Rename these two device node to generic 'audio-codec' and 'regulators'.

Fixes: 9f8872221674 ("arm64: dts: mt6358: add PMIC MT6358 related nodes")
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Link: https://lore.kernel.org/r/20241029064647.13370-1-macpaul.lin@mediatek.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6358.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt6358.dtsi b/arch/arm64/boot/dts/mediatek/mt6358.dtsi
index 8c9b6f662e9bc..9a549069a483e 100644
--- a/arch/arm64/boot/dts/mediatek/mt6358.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6358.dtsi
@@ -17,12 +17,12 @@ pmic_adc: adc {
 			#io-channel-cells = <1>;
 		};
 
-		mt6358codec: mt6358codec {
+		mt6358codec: audio-codec {
 			compatible = "mediatek,mt6358-sound";
 			mediatek,dmic-mode = <0>; /* two-wires */
 		};
 
-		mt6358regulator: mt6358regulator {
+		mt6358regulator: regulators {
 			compatible = "mediatek,mt6358-regulator";
 
 			mt6358_vdram1_reg: buck_vdram1 {
-- 
2.43.0



