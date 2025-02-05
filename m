Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169347BAEC;
	Wed,  5 Feb 2025 14:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766408; cv=none; b=DZV0M11RhpXp11jBkm/uPPSYeb1mefkGoQyFyFqX6SxxT+LMxLPPd+heRXuAyKc9SQZ8TdjdYu8UFAxkKbrpjvVdJEXx3R9A8hRVqsNiy4cgb8BsUS/v6KccP5B3sN7JtW5N+oKV3U4H5jzXcfgJ7pWZ+GNQujqq6caIpV5VgkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766408; c=relaxed/simple;
	bh=y2H8aBoe5tTni9d8KjOE6Q6xqz+XwdwlCJirPsyFdl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nd58PQtqfzURquWHRDHX/96JDfGp6qr0FWjpPYhWc5kZO6nZPhN/Gdeqt6QW8/SJ19oexGpwyD6WCTyYLOHTPzDo0Xra5lXwRZbzpXxBed+0E5a67YSpayBilR2ppmf+VPUXKDGyDgYooOIoNEvHwvP5c4rZD2nmbc7jjd3a+mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iikXuVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iikXuVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D81C4CEE2;
	Wed,  5 Feb 2025 14:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766407;
	bh=y2H8aBoe5tTni9d8KjOE6Q6xqz+XwdwlCJirPsyFdl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iikXuVuxgo2prYqTpcGALpBi0/DMXnxIRkbcX36waDzL7dSzxn/oLHfOKy9O42vH
	 dtacXYjvQhq31OxJLbI66hVrbp2IN5FJ/zEJxVFk23a4WLcKUYYX2P71tJORv2pMe7
	 yIoGdn3w39jbMm20gDgOm5sAKeFkQ5qPPJPJ5jf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 318/590] arm64: dts: mediatek: mt8195-cherry: Drop regulator-compatible property
Date: Wed,  5 Feb 2025 14:41:13 +0100
Message-ID: <20250205134507.441923977@linuxfoundation.org>
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

[ Upstream commit 4dbaa5d5def2c49e44efaa5e796c23d9b904be09 ]

The "regulator-compatible" property has been deprecated since 2012 in
commit 13511def87b9 ("regulator: deprecate regulator-compatible DT
property"), which is so old it's not even mentioned in the converted
regulator bindings YAML file. It should not have been used for new
submissions such as the MT6315.

Drop the "regulator-compatible" property from the board dts. The
property values are the same as the node name, so everything should
continue to work.

Fixes: 260c04d425eb ("arm64: dts: mediatek: cherry: Enable MT6315 regulators on SPMI bus")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241211052427.4178367-6-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
index 2c7b2223ee76b..5056e07399e23 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
@@ -1285,7 +1285,6 @@
 
 		regulators {
 			mt6315_6_vbuck1: vbuck1 {
-				regulator-compatible = "vbuck1";
 				regulator-name = "Vbcpu";
 				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
@@ -1303,7 +1302,6 @@
 
 		regulators {
 			mt6315_7_vbuck1: vbuck1 {
-				regulator-compatible = "vbuck1";
 				regulator-name = "Vgpu";
 				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
-- 
2.39.5



