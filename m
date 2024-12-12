Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B69922541B;
	Thu, 12 Dec 2024 15:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019131; cv=none; b=J0OJku68Hnj2OyzYvrC8eoehDHUrV7P0uhBlvaa6Z7V17+8mIdIXYiSYAAumeR9FfVuVL0uMM2UzrnWTixZqIILzmCEwvkwfrrB7Vtv3z7SOlH/bEsIE166oqDcudPbgbM8kJ5UN8NHXY8nfL/i0HMYABpAfSpGkiwVlHq0zrA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019131; c=relaxed/simple;
	bh=43TND/t5/HRDoU6UfOXZz8qmsH278+06rPJyp70m/HY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXz3fhvQ2c1BtcRHZhLBu8yajiBELBp6XwBgjd7FLTuJE9AwhdqUIrPyfJ/w/RxsXwL/r+C7e3Il11HKOUypoKbYfjayBEoySXCISW/tn2zLisIURrJ3AcU7Syr19NCdKCwiwOk5769MHjQry+GyMe2AC4dMdfhbTZOz7At5ItI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/+nNGRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/+nNGRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FCAC4CECE;
	Thu, 12 Dec 2024 15:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019131;
	bh=43TND/t5/HRDoU6UfOXZz8qmsH278+06rPJyp70m/HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/+nNGRdIPz4xvNX0zKs8JQ81H8/5EimTYDnYqfuui3u1v/43hyR3KPLVNzewcxfS
	 o0FwXFr9XABXwTaLpzRPXznxjju5ryFfNKUFnbzeFcxzVVTH/xSk/gsN5v9PR06rky
	 PzUFx3pl2aRWN9JAVS2ynCPmbXVtbQga/HgenS7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/772] arm64: dts: mt8195: Fix dtbs_check error for infracfg_ao node
Date: Thu, 12 Dec 2024 15:50:41 +0100
Message-ID: <20241212144353.900004357@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Macpaul Lin <macpaul.lin@mediatek.com>

[ Upstream commit c14ab45f5d458073248ddc62d31045d5d616806f ]

The infracfg_ao node in mt8195.dtsi was causing a dtbs_check error.
The error message was:

syscon@10001000: compatible: ['mediatek,mt8195-infracfg_ao', 'syscon',
                 'simple-mfd'] is too long

To resolve this, remove 'simple-mfd' from the 'compatible' property of the
infracfg_ao node.

Fixes: 37f2582883be ("arm64: dts: Add mediatek SoC mt8195 and evaluation board")
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241002051620.2050-1-macpaul.lin@mediatek.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index bdf002e9cece1..aa8fbaf15e629 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -332,7 +332,7 @@ topckgen: syscon@10000000 {
 		};
 
 		infracfg_ao: syscon@10001000 {
-			compatible = "mediatek,mt8195-infracfg_ao", "syscon", "simple-mfd";
+			compatible = "mediatek,mt8195-infracfg_ao", "syscon";
 			reg = <0 0x10001000 0 0x1000>;
 			#clock-cells = <1>;
 			#reset-cells = <1>;
-- 
2.43.0



