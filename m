Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82D01FC0E0;
	Tue,  3 Dec 2024 15:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240532; cv=none; b=hTgjppjmbvuDVR9zPSvL0rxRntCyVaGyL+rSfMY7paSAxh/EcFtaRe0m+MfMXT+oh0qRllgb0w/zMgqupXdfhDdNBjC1ItKQczAggTaPuz+RR1FEX0Qet5T1ppMTVAmPjPZMyXQKRZWMLs7Q33jitwDEB0CrSZzyCyfSKJxqB7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240532; c=relaxed/simple;
	bh=aSBnH9Nnr9OWIa1/KrN3T/1M7ZkGlT5+w9e89sn+9Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8BbASh6o8fn4Vm1un6MNkgq8uPQ5IWgQxJl5xqYySuPpveoeRht2e0wbtI8wGEtxmUsXC9Zv9iNbztr2lV05vQVxOxowXd93hCNUk8HLMYx9PxDWT6KrOhEqwkS22mijf+qw2Ql/5eoKcUzB2TBOFNHUaF+HA/d2rv1LDcsuHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRs6w9I7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRs6w9I7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504F8C4CECF;
	Tue,  3 Dec 2024 15:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240532;
	bh=aSBnH9Nnr9OWIa1/KrN3T/1M7ZkGlT5+w9e89sn+9Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRs6w9I7pWEgHhn7wMoh3Fl3Udgp78zn7ZZ7uoR/gOLquOPJIWAzuAJW0Rybm3jEj
	 4N9n+hoaKdEj9FebyME9fhkCnmxu9sE7PSbCHM1q2vkGTJkJnDmUi8GshDTtxiTrU2
	 zWBkap7a1X00hNpOSMy0fsgMzlWkzLyctd30BVes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 163/826] arm64: dts: mediatek: mt8183-kukui-jacuzzi: Add supplies for fixed regulators
Date: Tue,  3 Dec 2024 15:38:10 +0100
Message-ID: <20241203144750.096587565@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit aaecb1da58a72bfbd2c35d4aadc43caa02f11862 ]

When the fixed regulators for the LCD panel and DP bridge were added,
their supplies were not modeled in. These, except for the 1.0V supply,
are just load switches, and need and have a supply.

Add the supplies for each of the fixed regulators.

Fixes: cabc71b08eb5 ("arm64: dts: mt8183: Add kukui-jacuzzi-damu board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20241030070224.1006331-4-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
index ac7ec0676e147..49e053b932e76 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
@@ -20,6 +20,7 @@ pp1000_mipibrdg: pp1000-mipibrdg {
 		regulator-boot-on;
 
 		gpio = <&pio 54 GPIO_ACTIVE_HIGH>;
+		vin-supply = <&pp1800_alw>;
 	};
 
 	pp1800_mipibrdg: pp1800-mipibrdg {
@@ -32,6 +33,7 @@ pp1800_mipibrdg: pp1800-mipibrdg {
 		regulator-boot-on;
 
 		gpio = <&pio 36 GPIO_ACTIVE_HIGH>;
+		vin-supply = <&pp1800_alw>;
 	};
 
 	pp3300_panel: pp3300-panel {
@@ -46,6 +48,7 @@ pp3300_panel: pp3300-panel {
 		regulator-boot-on;
 
 		gpio = <&pio 35 GPIO_ACTIVE_HIGH>;
+		vin-supply = <&pp3300_alw>;
 	};
 
 	pp3300_mipibrdg: pp3300-mipibrdg {
@@ -58,6 +61,7 @@ pp3300_mipibrdg: pp3300-mipibrdg {
 		regulator-boot-on;
 
 		gpio = <&pio 37 GPIO_ACTIVE_HIGH>;
+		vin-supply = <&pp3300_alw>;
 	};
 
 	volume_buttons: volume-buttons {
-- 
2.43.0



