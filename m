Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C6C17CA12;
	Mon, 10 Mar 2025 17:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629015; cv=none; b=ptnYwx4MjD79mlMnfKcU05LLCtZ0e7qXpBp1xCGvisA0QishBjUk744sIF1aQ/+H11SJ9Sto+J3qd4k+/ksF8FDBKFn0PBg1PWxELtNKDub7CIJZ/Tr8V2zOwyA4rYT4+Tdt+vqGINTL+dwFtMFVTNEM1Zs/wL16d1p+2r2GL6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629015; c=relaxed/simple;
	bh=8hYjsnP6nW1B0qw4MH78juifMHu97/sbnkNFfgc94Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHQzGAlWwZCiFcmc4D5zkKc2jciAWqW6HpAl9yHMAHqEZkPFYe3IJNXK2ZOIt8/OATykAuNQyBDdJ/dkuaLAsoGN2pmsI3JaBNVGkqZSkOhLE0G4iDVIaftusgKIDYEglBnL+syKe/Wl10QEiQwAxIIhVePnDg6JPdNfjnlg0R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgNnceCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgNnceCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EE1C4CEED;
	Mon, 10 Mar 2025 17:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629015;
	bh=8hYjsnP6nW1B0qw4MH78juifMHu97/sbnkNFfgc94Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgNnceCFeE0qF15PKdKTxx7tcfcvpxJ4uYaneG60Xu7kd7k1ZY+1sItUpUZh0xKjY
	 nZRoGlgaampbk4aPaooNgx45cJGNmXZE2rGSfDlpPZdaeFsBrwyVmpyNPN9HadTVAf
	 JKfZH/GY4Es9Uar+JI8PcBnjJjbix0JCMnjZZ/aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/620] arm64: dts: mediatek: mt8183-kukui-jacuzzi: Drop pp3300_panel voltage settings
Date: Mon, 10 Mar 2025 17:59:22 +0100
Message-ID: <20250310170550.183189712@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f19bf2834b390..3fa491dc52021 100644
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



