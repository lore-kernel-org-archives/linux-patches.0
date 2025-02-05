Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071B01519AA;
	Wed,  5 Feb 2025 14:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765024; cv=none; b=Vfl7sc8vq6m8YExiGYs90LLqWm2Grvp6f0jXwACYjSZBIKAMkzZV0WCCO5Jlofp6ZFVe6kQtNFlHKP02psSmwYNCX3vqMuTtRcy/mrjfpmxsSCAvAB6PBMZVdloP0dUK4wH3gdDGEisnmS0SYkuiFF5XSsj6+z5bregwET09QKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765024; c=relaxed/simple;
	bh=1TeOGlnJxfnvH2gPArZM8uAIA+j2Ywnw7QSpgQ7GOsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMwY+TsrVuPSpI+vmobio5FMsSgvv5o5Mf5JkXMPD0sYSZu+Xlyp/1UyKauFZ8Yusr9/sPcY+zSKvJUtOlUbaUhKQgOGrByVs5RPo1/JGobCAO+LiOwooV1ZRQNVP9Cu2CuMgsgyNux6C5caqSO0DZ9k60qb03FMvqT4Fzk8Ckk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13WZ7KNB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13WZ7KNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5E5C4CED1;
	Wed,  5 Feb 2025 14:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765023;
	bh=1TeOGlnJxfnvH2gPArZM8uAIA+j2Ywnw7QSpgQ7GOsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13WZ7KNBeWZ/z+4YGQmcwGSTG+tjIijH3qmwWIC+Hxp68QOz+f+gpZY8T1GgmXEVR
	 Dec+f5UB+BLXr3p536rwFRVTaZ1AliQBYRxGEx45CKIcUfZMImC1onkCroT0w8uE3C
	 GiJq9s8UzHvmAtv8/ENn15a/CefHW7+vlcYBWVlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 225/393] arm64: dts: mediatek: mt8183-kukui-jacuzzi: Drop pp3300_panel voltage settings
Date: Wed,  5 Feb 2025 14:42:24 +0100
Message-ID: <20250205134428.914536394@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 629c4b7ecbc62..8e0575f8c1b27 100644
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



