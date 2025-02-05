Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F981DE2A5;
	Wed,  5 Feb 2025 14:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767171; cv=none; b=vFCo5F8u1aQkaxBmZIRuKlIV7EUVZ+YC0Hke+ZJDSMXsRyiDkFOKJpiOD8AGr3r+k4QGSd2yB3aULM77s/GEcP9/8VaiXeZc6HabVZUYaUcAHWQzAkGJpE/L7m3Y88o0KCYzauXub15G/9CFq2w+k1ZBerQ1xi3Y1bVNWSFkY+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767171; c=relaxed/simple;
	bh=XO2ouYuDBZ6ACk4B4mBCFUeSyaeFhREGj+0NykhbzGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfxU0f5qKtF044mkS6QbDGjzRZ91ue9mHbk1ZXwOw1wI9ynB+rL4cz1x3B2LZ7L3KdynhtfRmoZRfUdUh7zpRIhjX44wNcTIETYPtVMY2vl0gNqbGSQgIb3uecAA6jl+tZ+zmfGc+C4PQYyhav8/BP1jEM75ut83Nb5s4FBJE+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPyH6N/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPyH6N/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9C5C4CEE2;
	Wed,  5 Feb 2025 14:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767171;
	bh=XO2ouYuDBZ6ACk4B4mBCFUeSyaeFhREGj+0NykhbzGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPyH6N/MwRnwMdlw83b2rx4qBAQZe14KtyO7m0+bBBqdcs6uM1Rv7s/51UU2H5Gyp
	 5YV1MGZxyhI2QbChM8Ko2LyjmcOnrt7XUgLsAiKpgdzN8KI8JI9LYQbj2OyFWU78HO
	 u3a32TuBsSOsJjYZQBQVInnk6gtF9hB1T8Hx8rDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 366/623] arm64: dts: mediatek: mt8183-kukui-jacuzzi: Drop pp3300_panel voltage settings
Date: Wed,  5 Feb 2025 14:41:48 +0100
Message-ID: <20250205134510.222517851@linuxfoundation.org>
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

[ Upstream commit 0b5b1c881a909f17c05ef4b1ccb421e077f6e466 ]

The pp3300_panel fixed regulator is just a load switch. It does not have
any regulating capabilities. Thus having voltage constraints on it is
wrong.

Remove the voltage constraints.

Fixes: cabc71b08eb5 ("arm64: dts: mt8183: Add kukui-jacuzzi-damu board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20241030070224.1006331-2-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
index 49e053b932e76..80888bd4ad823 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
@@ -39,8 +39,6 @@
 	pp3300_panel: pp3300-panel {
 		compatible = "regulator-fixed";
 		regulator-name = "pp3300_panel";
-		regulator-min-microvolt = <3300000>;
-		regulator-max-microvolt = <3300000>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pp3300_panel_pins>;
 
-- 
2.39.5



