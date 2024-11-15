Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E72645;
	Fri, 15 Nov 2024 06:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652766; cv=none; b=fFxL6P2Obkkq+3KDGsx5cj0IIx/b2bzDkKb1chVxDbsr7xf/2a+VbsHT0/six83fyh2G9IKpK7aSwDshFtwjm5CukBInBtn0XPgEJZh7uenKbRFoFTqbu3EiZafCeYSe8A/f3y5JkJlIZT+HSQTl2AQ7tufaLxgtm9Dd35AaR8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652766; c=relaxed/simple;
	bh=9wNd+bYYu/gaoEEjIxebGds5iKjQDZHfyIh9VLVnxOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJfAIsQKMHNyAE8dYQVfFfC3TUJzVZsJxmH/nn4u0wcxJukHu7t9nhbKtOEwWd8GPr6o0+zcHeK6sQPVnPnmwmFuSlTb4mG5erRfJ1ds8MLs73IDrGEpQl2TFNiy2udTDO+veB11T2jqSCOde3pbaOpsJLy63CIvkmz4PYPiTg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyZouBek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyZouBek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF45C4CECF;
	Fri, 15 Nov 2024 06:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652765;
	bh=9wNd+bYYu/gaoEEjIxebGds5iKjQDZHfyIh9VLVnxOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyZouBekGfuKqzYBRJlna07nOQgOni+rrzoen7bvojcDYpz8MMONFfBwNx15CsLf1
	 ZQZeJmAVyxAOOI6BYPD+D3dis85qv2Lsw7fVQ9RMpv76CeSiOPLr30t8rZjHtUuurV
	 Ugbh+u/giV4fwxxy4y9jpAk+l+iggF4V3u4B/Cn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/52] arm64: dts: rockchip: Fix rt5651 compatible value on rk3399-sapphire-excavator
Date: Fri, 15 Nov 2024 07:37:14 +0100
Message-ID: <20241115063722.902019418@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 577b5761679da90e691acc939ebbe7879fff5f31 ]

There are no DT bindings and driver support for a "rockchip,rt5651"
codec.  Replace "rockchip,rt5651" by "realtek,rt5651", which matches the
"simple-audio-card,name" property in the "rt5651-sound" node.

Fixes: 0a3c78e251b3a266 ("arm64: dts: rockchip: Add support for rk3399 excavator main board")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/abc6c89811b3911785601d6d590483eacb145102.1727358193.git.geert+renesas@glider.be
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts b/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts
index b14d83919f14c..dacb1331ae9cd 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts
@@ -123,7 +123,7 @@
 	status = "okay";
 
 	rt5651: rt5651@1a {
-		compatible = "rockchip,rt5651";
+		compatible = "realtek,rt5651";
 		reg = <0x1a>;
 		clocks = <&cru SCLK_I2S_8CH_OUT>;
 		clock-names = "mclk";
-- 
2.43.0



