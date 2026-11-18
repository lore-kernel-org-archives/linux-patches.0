Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061297;
	b=jS8vLI1XHiDRYVBy3toTcFayFqAmzOkXGdRXJosNn7RmqEy2M2CohoaMlJNo2Su9sIXY
	 6SJRI+QahH0Yk9o5wRWl6Zr4FEjfyXWM4Bb3s0SA4k57bwCujQepkT2b/Famcu7wzolLw
	 4xb1Rsn4Ur8rwAjPJchWTpGl817ab7oirctbAPc48xmgYPGn/qDQjPWBYhJv5GveJTSc3
	 qYKShI6jBtzbKjpnoj5w7pE3UTvEVxu9GlbUW9rIK5V1hPahN33Rw3bVwx6NIgXqpg21x
	 6EpqIa5fm0xNP+HRAseBjqWt3C9mafLDN5u9mvbD9XgDeM6QoXfnYCqrvvS0yrvKiGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oNZr1OOJyG3M/NGPlCNA8rl8pQflLsyADbcf7a4qhGo=;
	b=YWoAVE20pwr6Sx6Mmr8dwt5RT9pLnaV6WrIvwLooVaoITHivUHV5xwitiiaWGCWGWNhk
	 NsMesf2/+/chUG8YJXGsjRHguUvkITotco7aQho+c9xnKpTZ+iPZLsuAqfN3TZiOxWQlQ
	 /LXUW7RAH+0ZGoZEs0dthxjWOXSnEjakB/WPS51neIpnb2gsvfNayNE8ZnZl3PhU5kT1c
	 VKj7QGoeFU85kRPeuvUc/vNWhLdeYn+GqJumQRaEn6O889gdi83hxHTBzZckSVL0sTrAX
	 lg69fAUhr43o3OLZQWUn/jYzKVNp5rG3LS/gU7TfCFB9bc8IGtBXaLQ8tiuV17ds+eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uzAqzw+Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465A1606A325;
	Thu, 19 Nov 2026 04:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uzAqzw+Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09E11F000C4;
	Thu, 19 Nov 2026 04:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061297;
	bh=oNZr1OOJyG3M/NGPlCNA8rl8pQflLsyADbcf7a4qhGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uzAqzw+Z+oBTZXKBK9FzvD1SCrD2M8I7yl8mS6pFUFTcs4wzDQWqJDmBcLe5qhkId
	 avTqvdLOem1/3xJJ7c9PpF0WBJV6HHpiJGxFCJjtlyGTJUNmLvAJkNDSubEGvVGoAM
	 0/dWjOLjXytn2MInHjSUthyRX/C1SWSJKK0/Er1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1465/1848] arm64: dts: rockchip: Rename rk3328 HDMI audio card
Date: Wed, 18 Nov 2026 15:58:23 +0100
Message-ID: <20261118150020.665739804@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 28c861ac20f74..e4c4f413d1ebb 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -194,7 +194,7 @@ hdmi_sound: hdmi-sound {
 		compatible = "simple-audio-card";
 		simple-audio-card,format = "i2s";
 		simple-audio-card,mclk-fs = <128>;
-		simple-audio-card,name = "HDMI";
+		simple-audio-card,name = "RK3328 HDMI";
 		status = "disabled";
 
 		simple-audio-card,cpu {
-- 
2.53.0



