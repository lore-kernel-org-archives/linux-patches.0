Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFA4376;
	Wed,  5 Feb 2025 14:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766450; cv=none; b=uD+RR82n8i/6QNnpxSDLfK5e++hkgu2m+2GqNVYrdemlmYWPLeHUiOWb/bXe/avYOjVWerccEbvWqUepjiwACR9OkLluU8cIP/vlFo/7h1m9JyBeKy7aSRZw+cUZaZUVqpJ5B1iZXdffSzqNeTbdGSkwpGLGPvGjtsJT//jCQOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766450; c=relaxed/simple;
	bh=IDfAhc554bopSO+tG8H/olMVQXLJdghfFfJQBr2qqrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVS1aaSNr7fmimh3Lo/Q5Gu/+A6ZJ+aPAl5B49AMLip38oRHV6LDIlEBN8d8y1umOoLZN8jgdyOJLRx9ghnTvus+zYMy5mR4+e9O83QrSNSbeDZmIIO6GuEpzylMSf3AFPK6PKfJrmNZ7o8v4X1VYQTb5UOiJlOjmVUsdx+L4ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgVlxSL7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgVlxSL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8B3C4CED1;
	Wed,  5 Feb 2025 14:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766450;
	bh=IDfAhc554bopSO+tG8H/olMVQXLJdghfFfJQBr2qqrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgVlxSL7RynkVhEG6UxS9qrhkyKcfnwtUGdestnwQSSqMv7EGih8uM2i/0Ix2hy4P
	 qVcPjoqAUfp/1SMmp8QlpprQI+ojLlTGfOYVL67Yn5UH7CjkVEazhTlTZAxxJuuCwg
	 ZusLFAFnsuxLuMk5GCYrtzGIBkeeoMisgGp0AhCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 321/590] arm64: dts: mediatek: mt8395-genio-1200-evk: Drop regulator-compatible property
Date: Wed,  5 Feb 2025 14:41:16 +0100
Message-ID: <20250205134507.555359925@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit b99bf07c2c8b3c85c1935ddca2a73bc686f8d847 ]

The "regulator-compatible" property has been deprecated since 2012 in
commit 13511def87b9 ("regulator: deprecate regulator-compatible DT
property"), which is so old it's not even mentioned in the converted
regulator bindings YAML file. It should not have been used for new
submissions such as the MT6315.

Drop the "regulator-compatible" property from the board dts. The
property values are the same as the node name, so everything should
continue to work.

Fixes: f2b543a191b6 ("arm64: dts: mediatek: add device-tree for Genio 1200 EVK board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241211052427.4178367-9-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk.dts b/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk.dts
index b4b48eb93f3c5..6f34b06a0359a 100644
--- a/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk.dts
@@ -820,7 +820,6 @@
 
 		regulators {
 			mt6315_6_vbuck1: vbuck1 {
-				regulator-compatible = "vbuck1";
 				regulator-name = "Vbcpu";
 				regulator-min-microvolt = <300000>;
 				regulator-max-microvolt = <1193750>;
@@ -837,7 +836,6 @@
 
 		regulators {
 			mt6315_7_vbuck1: vbuck1 {
-				regulator-compatible = "vbuck1";
 				regulator-name = "Vgpu";
 				regulator-min-microvolt = <300000>;
 				regulator-max-microvolt = <1193750>;
-- 
2.39.5



