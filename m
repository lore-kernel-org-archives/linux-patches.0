Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E79519924D;
	Wed,  5 Feb 2025 14:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767060; cv=none; b=eJp3FoIjn4uFloP0xKH1fHT2ELk3+7I54P9Uph9H+sfTxuLHld6YJl/XT9Y7IEu6PhS9N3QDozLATcC7rN5VKsKQI35Vfuo9XRS+TvUPUZ1PBibYRKsZq380u6kM4ab+ZTAP6poxMF/ICKFc8KwGn5hyRMugJgYuxxVyixiiBMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767060; c=relaxed/simple;
	bh=J2BQ4DyKTLojt0K/+4FhGMqYb7Aaeh8lVnKPwLru0sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnOyHeh9oqmLAC6L0rN1gR3DxkUV0tTJDPrVhDuELXdItmZ3PBBwMrkqQSzHwhaoEAeerJm+OTL5S0Y2hhHEE0o2bDY1S4G5hRxVcrrxCBT1qWXbbJ04t7jkqmxy/CwnxEFAUS7dZXIhuu6dIZUtWHPAZBRuPyUwlI8Rk1v3WO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrTMTx8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrTMTx8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D868C4CED1;
	Wed,  5 Feb 2025 14:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767059;
	bh=J2BQ4DyKTLojt0K/+4FhGMqYb7Aaeh8lVnKPwLru0sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vrTMTx8KK8AV9q5JZ29uJvzeFTTZkd6UndZJc9+x4xRKCu2iD1Yy/eukDS69EuF6p
	 dLC1PR/bvPJ50AICNqpipM/a89vmVX1XsfXhc8PiNAigdT0x6DsL3Dv2LubYZhoA/g
	 gqubCF0rj0hkaVC4VwkORppeKNpUkATH3Q4T9eO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 351/623] arm64: dts: mediatek: mt8395-genio-1200-evk: Drop regulator-compatible property
Date: Wed,  5 Feb 2025 14:41:33 +0100
Message-ID: <20250205134509.654030029@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 5f16fb8205805..5950194c9ccb2 100644
--- a/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk.dts
@@ -835,7 +835,6 @@
 
 		regulators {
 			mt6315_6_vbuck1: vbuck1 {
-				regulator-compatible = "vbuck1";
 				regulator-name = "Vbcpu";
 				regulator-min-microvolt = <300000>;
 				regulator-max-microvolt = <1193750>;
@@ -852,7 +851,6 @@
 
 		regulators {
 			mt6315_7_vbuck1: vbuck1 {
-				regulator-compatible = "vbuck1";
 				regulator-name = "Vgpu";
 				regulator-min-microvolt = <546000>;
 				regulator-max-microvolt = <787000>;
-- 
2.39.5



