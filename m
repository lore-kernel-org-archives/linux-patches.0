Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DF01FA177;
	Tue,  3 Dec 2024 15:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240444; cv=none; b=iIbANF31ud12GU3i/H8UXh4fDG4Y8xBr6ydS0jnyaLbUo9Bh0CjSFJR/Yl+7H/h2Fe/fLfqJpIYEDNgn9+nokEYtv2e2msqemp88FgRbkaVTpatNXiPQHEtv4iK1OpR4d9HCpgEY3z+nbk/STKbvBE2yaW/QTysGuuPSeKsf374=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240444; c=relaxed/simple;
	bh=CldCs3RCHtMaLnUddvtvab+Zy2zaW6W3ICWf6dugsj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgu6a67ZimaMjft0FY6aB/rgPUXtCvUkbMhNkk8yJJflY417VG8x2QcK8usFx13Hpc+LB2YfxjVCSinTvvJcpMYzFwUIvcvQGOdfAc8zg+Wf6/h7mfclZDL+BGyh1S9Al/sOW+H5AlexfmIHjSeOJHfSDamBvrEWuvrUHgCxkF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psd/ZLfb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psd/ZLfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43066C4CECF;
	Tue,  3 Dec 2024 15:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240444;
	bh=CldCs3RCHtMaLnUddvtvab+Zy2zaW6W3ICWf6dugsj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psd/ZLfbeXWxSFWMsFe+xTaKXMD/OSEizubP2ywie9ZBNdK2WudIAVgJTlvLowYF5
	 N3eDOGR6Y0N39ZVUNGHqxkUMbcsuyAtgUAp82EtvXcmkSefnrF4GCYtFUHLNGtzjvq
	 oaez7vh63WmV3qm0rDId8do8DRwRJEJe/KWKljqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Sun <pablo.sun@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/826] arm64: dts: mediatek: mt8188: Fix wrong clock provider in MFG1 power domain
Date: Tue,  3 Dec 2024 15:37:12 +0100
Message-ID: <20241203144747.838665958@linuxfoundation.org>
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

From: Pablo Sun <pablo.sun@mediatek.com>

[ Upstream commit 4007651c25553b10dbc6e7bff6b7abd2863c1702 ]

The clock index "CLK_APMIXED_MFGPLL" belongs to the "apmixedsys" provider,
so fix the index.

In addition, add a "mfg1" label so following commits could set
domain-supply for MFG1 power domain.

Fixes: eaf73e4224a3 ("arm64: dts: mediatek: mt8188: Add support for SoC power domains")
Signed-off-by: Pablo Sun <pablo.sun@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241002022138.29241-2-pablo.sun@mediatek.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8188.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8188.dtsi b/arch/arm64/boot/dts/mediatek/mt8188.dtsi
index cd27966d2e3c0..02a5bb4dbd1f8 100644
--- a/arch/arm64/boot/dts/mediatek/mt8188.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8188.dtsi
@@ -956,9 +956,9 @@ mfg0: power-domain@MT8188_POWER_DOMAIN_MFG0 {
 					#size-cells = <0>;
 					#power-domain-cells = <1>;
 
-					power-domain@MT8188_POWER_DOMAIN_MFG1 {
+					mfg1: power-domain@MT8188_POWER_DOMAIN_MFG1 {
 						reg = <MT8188_POWER_DOMAIN_MFG1>;
-						clocks = <&topckgen CLK_APMIXED_MFGPLL>,
+						clocks = <&apmixedsys CLK_APMIXED_MFGPLL>,
 							 <&topckgen CLK_TOP_MFG_CORE_TMP>;
 						clock-names = "mfg", "alt";
 						mediatek,infracfg = <&infracfg_ao>;
-- 
2.43.0



