Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040761;
	b=xLleQngTXZHP9E4nwsB6NqStmChz9qrnCkxmWp0q2cUxUuvENeqFIJTfaaySIotNVzU0
	 7lUm+QF8Gl1KuCTEIUvpzoKCDxuf+ye6qTFq1C0aMeGY8+NbA4vM5EhkLt+JKdO57TgES
	 KpmbYFrPTx/fPu6ZXTPHx7OFBo4gc78RSGWqfaBPJO92SaDaL/2lth+0bp5h3rrjJg/2O
	 cQNX0vujRDg4xB1Dxl+W1D8/yjjdoitRy4saXGrkLmQu6LtNN7uw5R8G5btSSehE4rdb2
	 nQ9mSfPnKUh4GLSS3HD19/JUc4TY0DrrAFFaO6bTbrYDZuiiOG4NNCZFiDAUqwHt0eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P/XeS+rORjPNWLS7XFTdSXjPWnARmCKoRRLfSk7JYSg=;
	b=fh6q+NHkqvfE8isAgQAgOU1nzCxAURfchoHtihc5ZTgcYy7LeXIhzdd5K1FDP4WXpaVl
	 TUTPfwXQxwNKKmkt6Ah154oXJC1GzB9ro2Om+iHW3BMY+POXHlds9ypvONNAXBaB7ysF4
	 U+iawU9h7e6gqKLaJWNpQ+aSB5bSYHQ1+V/YQl5G7eeBLvz3D9uqjyqw6AiZkvjDWmNrt
	 /swWn1Q8MnwR7dDBzjvU0cJb/cdqaZV4uWVFEkGOwYb85jsBQEq31kYE+l0A8F5KUSgil
	 h1LnFHcLvOb3/UkH73SIuwDQ0+h2gCG4hkqGHi0Tainz7DV3joVZtxBGWcD6XqCtbWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGp6+MhD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA27606A31C;
	Wed, 18 Nov 2026 22:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGp6+MhD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960ED1F000C4;
	Wed, 18 Nov 2026 22:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040761;
	bh=P/XeS+rORjPNWLS7XFTdSXjPWnARmCKoRRLfSk7JYSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGp6+MhDaSZpWUNmjsSLeHG3Xgq4P9hb17rwRUsP70QDspjONEIQxBsDqYRSmm9Hd
	 574UfSk0YK4jXPbzIUvAGxrXLyVOyOynfwZAkZYrnYWpNBLSVBuAsB+udcBHf7mItY
	 D1KAdpHWf/w0rjo3IV9c9GDTEYN9LzyTGzx8STh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2571/3318] arm64: dts: rockchip: Rename rk3328 HDMI audio card
Date: Wed, 18 Nov 2026 15:53:13 +0100
Message-ID: <20261118150438.359229480@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Detlev Casanova <detlev.casanova@collabora.com>

[ Upstream commit daa0db717771d43c25d98c2798fa6a7b0252deb7 ]

Rename the card from "HDMI" to "RK3328 HDMI" so it identifies the SoC
in user-visible ALSA fields and no longer collides with the identical
"HDMI" string used by other Rockchip SoCs.

Fixes: 29e8976e604f1 ("arm64: dts: rockchip: Add RK3328 audio pipelines")
Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
Link: https://patch.msgid.link/20260910-fix-rockchip-hdmi-audio-names-v2-4-1396a6168e20@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index 82eb7c49e825e..5940171b6624e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -178,7 +178,7 @@ hdmi_sound: hdmi-sound {
 		compatible = "simple-audio-card";
 		simple-audio-card,format = "i2s";
 		simple-audio-card,mclk-fs = <128>;
-		simple-audio-card,name = "HDMI";
+		simple-audio-card,name = "RK3328 HDMI";
 		status = "disabled";
 
 		simple-audio-card,cpu {
-- 
2.53.0



