Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFE133FE;
	Tue,  3 Dec 2024 15:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238060; cv=none; b=sLFvdNGzp3OczzcV9nAd3GP6zR7Usy8dM72DLOzCYbxWfrNd+KBq7wVLKLmFPaU909Szf/aKrxEZbopP0rDTHlTUUjzlskFw18cSl0PXqi1AnXliSw+R2QMmhFv4+YGnH0bT3eOUNqD3HYcso8MfpCadfWTgU0trbgZ6+Ejsblo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238060; c=relaxed/simple;
	bh=602GjF4QMEs4JP18sHlYPEt+QLHPQ8Wh5XG1c/OE9Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qW+w7ePPK+fJmE8tf0UB+etrD2cCgBzeC+ddZezv2x9iUzpf3q+epsXvEpIVlV0lQYuxfIQMiwXzM/Xsq4XMpPZ8kZ3vJi6P/Q/hD0NAqOikx70VH+TKNMk4CgPyjhXxpeINORxW2qc5944W1eu0eLhh9aN5Rbs2gjTm5zYICTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JyRdmffg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JyRdmffg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE45C4CECF;
	Tue,  3 Dec 2024 15:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238060;
	bh=602GjF4QMEs4JP18sHlYPEt+QLHPQ8Wh5XG1c/OE9Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JyRdmffgMSfB9WRNNFx+ByGDxP/ViXtuBK/44LtJb++llaSDJiyd6fCWew28a8jpq
	 3QSJrnmR5fPnafFumiLZwr/ld7/Wf2DtOnREVn2nkTsojlt+TceGXlNHb6HO6IP3fS
	 bzmCpZ7Z45QZ+IJIalz21ZGY6849esbqYSGIDjoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 149/817] arm64: dts: mt8195: Fix dtbs_check error for infracfg_ao node
Date: Tue,  3 Dec 2024 15:35:21 +0100
Message-ID: <20241203144001.544232883@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 30903d468e99f..e56b23995c7bf 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -487,7 +487,7 @@ topckgen: syscon@10000000 {
 		};
 
 		infracfg_ao: syscon@10001000 {
-			compatible = "mediatek,mt8195-infracfg_ao", "syscon", "simple-mfd";
+			compatible = "mediatek,mt8195-infracfg_ao", "syscon";
 			reg = <0 0x10001000 0 0x1000>;
 			#clock-cells = <1>;
 			#reset-cells = <1>;
-- 
2.43.0



