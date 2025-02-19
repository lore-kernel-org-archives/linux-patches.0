Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714611BD9DE;
	Wed, 19 Feb 2025 09:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956357; cv=none; b=hfdmQvMwVXnZJ8oLp8n8UVfUcEtldiLYM7Fs3JyLNRn+cNfXH3yOwgVpoMK+PQWuwukMN+DsGPx8Rm2sQMNyEkuXGf3HEGfNNpOKmN0GPPGuPzV1zzYJ88kdSz2G539Zp/U6HayFzPXCqDTMioTQl01vRJvUuvfMTCtaE4D9J1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956357; c=relaxed/simple;
	bh=9G/lf/6Ko5wQzkYWv24L2x3YNTm1WwUuML2/upA2Efw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djnu4w7CGfT082gqOaq4T4nPjiJz66dyA1gOZ542vuRlR+p+8+joY6l6pKb8XxIdsNg4u4CkujHActcBhWxJdIk4t3n5I2iadFWngJastboSIOQYa952M+SmIq00Kcw0/0w2wHm5skU4uugo2Zqk40balNABSm+cW14eXw8jWNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wEqKxy3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wEqKxy3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C69C4CED1;
	Wed, 19 Feb 2025 09:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956357;
	bh=9G/lf/6Ko5wQzkYWv24L2x3YNTm1WwUuML2/upA2Efw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wEqKxy3ETy1mjfwr1USvJLzf0tZFpRtk91xXc4rjyduhyhZuP+Lz1KbWwxlHaq/sx
	 TbLoB5LP53EW6oL37baav6CPfE5Wg0oG6T+fZnPVvAvo0+QZmr1c99SXfUNpDgzMuJ
	 OTLbLp2WSYriJvacTOqdnKq6YvZwZuHx59fhAPi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/578] arm64: dts: mediatek: mt8183-kukui-jacuzzi: Drop pp3300_panel voltage settings
Date: Wed, 19 Feb 2025 09:22:36 +0100
Message-ID: <20250219082658.956476387@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



