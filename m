Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBC01F76B6;
	Tue,  3 Dec 2024 15:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238051; cv=none; b=hgzjWUdqukNp2/858JP4JLQq2BFKftq1IngNJ3Ngdh/JPBLMzKy8UanlWW01eb1VtpDb8nSni+7OdtfQKjCaEjvxJL9lnqnuTUEthJlvypO9dUnbkmJFMmgLe2bF36y9hCKZbykwptjoKDYtVjHVJLbSdtKEfRVsNLyN1I80yag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238051; c=relaxed/simple;
	bh=R+Gc4pkOrE7Qdq2M5Z0s9ymWKgGIzJzXMumBfnamojw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BD1pJL0wTUnc9C3EGZfaHNGW2kuOl4CPEV3i6nMA9e/D51DLsXbBQ90kHkQAK6I0mt/ZCyNTjvfy3fqzXYTkOF1wdFg2+ow+hPedJorZdU4tgl9gdTsf87BMoKpVsEhExXsBYXl/iz1bExRAu5ntQSn0vLa8r9pQ7lqqt1DfJpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APgEm5OC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APgEm5OC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAF8C4CED6;
	Tue,  3 Dec 2024 15:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238051;
	bh=R+Gc4pkOrE7Qdq2M5Z0s9ymWKgGIzJzXMumBfnamojw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APgEm5OCbcJ6LeMkHjF/jiUC9slX1lMn+CCxCUiHJsJ2+jHBVw4Q8Epo5vfAd6iqB
	 A23a8i/4biFtVvAlQF/AD0uqdWg0v1w4V7XTMLRJ5JIaqToq85Iz6OD0q+6/V1jmeF
	 M6J4OhegSW6Cv56PuCrw8s2dkA9C6At8e10N57RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Sun <pablo.sun@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 146/817] arm64: dts: mediatek: mt8188: Fix wrong clock provider in MFG1 power domain
Date: Tue,  3 Dec 2024 15:35:18 +0100
Message-ID: <20241203144001.426727890@linuxfoundation.org>
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
index 29d012d28edb1..041a85e1d9b55 100644
--- a/arch/arm64/boot/dts/mediatek/mt8188.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8188.dtsi
@@ -508,9 +508,9 @@ mfg0: power-domain@MT8188_POWER_DOMAIN_MFG0 {
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



