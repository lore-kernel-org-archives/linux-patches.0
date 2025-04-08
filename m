Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC25F268C78;
	Tue,  8 Apr 2025 11:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110543; cv=none; b=gXkJxtYI3e1qtwqIAlyum/nP+Tn7Bmjr0mVrYT6XPJo6ilYgM7JknpZVPxES8Y+tDYo4LUgrHKl8vcYCoqd7xboNsTDqgoRsSYS+KH8C6wEAgH8+uSq6nvqPzkHxTR2QDOc9/07uzzNy26kCtmnLlzia3GSe2CpeJinrVEWwDQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110543; c=relaxed/simple;
	bh=ITbPIwKic1Wqp9DmEeExYLkGgNlKE2rZ/OY+n5NmMbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfzzTdKJIXqSJk1bcEQ50M/uGjJOf6pcy6V5UKnLpYxzinOApg1Yvl3yc8fqT5LRR5nLahBbejy5PDQk9SBdupJfEhxnKNfhQ69ZAk4o7JTiyt99hjZ/wZIyKOJd1M4AjwUSl7McsL/ZxvCw7ARNDNOrkuf9Iedu1P7wU3GQshM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8s5v9v1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8s5v9v1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE86C4CEE5;
	Tue,  8 Apr 2025 11:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110543;
	bh=ITbPIwKic1Wqp9DmEeExYLkGgNlKE2rZ/OY+n5NmMbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8s5v9v15Rx5Jp0skQHJFXJFYqikYEO9qL3vRO3LceiRAUWpdyLZtZ3nOSeLtmpS8
	 COgG2mNnW2JZ9zHdjfftsBwZsk6zM5IO6bYUqCX/0KrgOZ20tEDELKp3iRxZ4skR3p
	 Wa1tQv8SDPniTtxdYmWUjpGHXfhDSPUkQNUpNfVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 103/731] arm64: dts: mediatek: mt6359: fix dtbs_check error for audio-codec
Date: Tue,  8 Apr 2025 12:40:00 +0200
Message-ID: <20250408104916.668060636@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Macpaul Lin <macpaul.lin@mediatek.com>

[ Upstream commit 76b35f59bbe66d3eda8a98021bc01f9200131f09 ]

This change fixes these dtbs_check errors for audio-codec:
1. pmic: 'mt6359codec' does not match any of the regexes: 'pinctrl-[0-9]+'
 - Replace device node name to generic 'audio-codec'
2. pmic: regulators: 'compatible' is a required property
 - Add 'mediatek,mt6359-codec' to compatible.

Fixes: 3b7d143be4b7 ("arm64: dts: mt6359: add PMIC MT6359 related nodes")
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250217113736.1867808-1-macpaul.lin@mediatek.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6359.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt6359.dtsi b/arch/arm64/boot/dts/mediatek/mt6359.dtsi
index 150ad84d5d2b3..7b10f9c59819a 100644
--- a/arch/arm64/boot/dts/mediatek/mt6359.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6359.dtsi
@@ -15,7 +15,8 @@
 			#io-channel-cells = <1>;
 		};
 
-		mt6359codec: mt6359codec {
+		mt6359codec: audio-codec {
+			compatible = "mediatek,mt6359-codec";
 		};
 
 		regulators {
-- 
2.39.5



