Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C311F759C;
	Tue,  3 Dec 2024 15:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240526; cv=none; b=M9tQSPkq99dJdTb6E8oIuBtYLnbow7lcPHd730Xv7Hxg+DaUJ29Kl+TyB+U+DPs16G6enuhqaZ1U4TXfuFuoUgjZJnL2YoSmilnlBi3+EAZdbuDRwMmTP1j+s1YKlztOr7Np6D8g2EXHfP3WhCHGlifE6yjeTPMXmBVBSPzc74o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240526; c=relaxed/simple;
	bh=9GcOpSBledmV/KdMnBQjFnw/X+uO4oX3hZx+T9mFNJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHfFIyXg92QgRv+BDuuA+cM+fyzovWxtjx/SUceZbffCg8leaG0sHIH8S2betT9PP9KNsSVseV6/V5fCPQ92xnxVb2QI08Dplz4g6QfDQ3LO6hMDzYjfqUkRWIlsu4HVxakJN0VnWKbmA7f4SfJyTHjK2hDj8CCgScyAxc9w4fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FY/HzzzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FY/HzzzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E77C4CECF;
	Tue,  3 Dec 2024 15:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240526;
	bh=9GcOpSBledmV/KdMnBQjFnw/X+uO4oX3hZx+T9mFNJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FY/HzzzI8yxgqTPYt+pb6fFStuhxBav7eejHLK8qChg77FvbO1hoYjdaILaAmNNEc
	 CHNu80mk1QfoCZ+TRcfTmAHvSkHS4cizgOqzi+4XdEYcXDTNCLYOgucHu9TRFJo+RZ
	 29R0LoOuuQcU36isOVA5rT3ZOaZtloihpKQ5qtbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/826] arm64: dts: mediatek: mt6358: fix dtbs_check error
Date: Tue,  3 Dec 2024 15:38:08 +0100
Message-ID: <20241203144750.020269339@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 641d452fbc083..e23672a2eea4a 100644
--- a/arch/arm64/boot/dts/mediatek/mt6358.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6358.dtsi
@@ -15,12 +15,12 @@ pmic_adc: adc {
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



