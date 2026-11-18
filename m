Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018561;
	b=HPIRH7UsN+LqKkC0gXs9IWefU9oN5qPfjq7959Q9gb77AJjn+ICIKaNkur2JIxGiZXQn
	 ALo/2q89UdsOWs3b+rIeGG3HVS/G5lTEvVBi5LJv8VguU3rAiNbqNaIkO8UuwYBh7m83e
	 ljmSbJm+RNJcVLLj2FDreP3vAKWkBMbCsFtUxHZ06Zk7Lanviaw6GT9QfjMmhd6d96PAb
	 CgOraqLs9ueSChMnFZg/pA8oFS0vv3dVOz5wjCWt0BIdj7c1nukDAYYa4lYSvLDyXUDuA
	 q+OmpLEFL2xTFP8jtO33pXAyq7O1RLi8hW8AucegZhhnBpz+GvdlhTBwIZfaYrMhZEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d2AuoMYwhAMUgZnr/tX9NA0NcZrzs+oQFSeszvBkU+U=;
	b=KbPE4SgTaS9ZgJdNwuT+1Yc0/oNVZIuEs9vxmkLl5GzVfagleRTqdNCzMij+jLvTz63n
	 i/Ah5JX3Bbhq6ytdj8V/GKbwAGkrNrHqT3Ywh50nXj8gojb8OkSviXc4RBEYre6a2K96i
	 F0U1eEWiH6qnGW5iSKR6I8KRdyIkx93o7YkirOP6EPujOH2trUT3/zjPJ03aD//keCwU1
	 ZzlUBYzJqPhFhjuojQwVcOedh1uP4/mm/bDeBBZXGh9dyMtMM9jcoeVXKBl5Tm2J42Uj5
	 fH74P+2JWg6+oHRUkmH2jZNvG+5bgkAbExVAGqHN/nnKTyIzp4haliFI3qUrcJXMCqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UG9JoA9q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56521606A325;
	Wed, 18 Nov 2026 16:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UG9JoA9q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8B41F000C5;
	Wed, 18 Nov 2026 16:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018561;
	bh=d2AuoMYwhAMUgZnr/tX9NA0NcZrzs+oQFSeszvBkU+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UG9JoA9qPf+S58y8LCxAlLe3E6Mf/eNWu9VXsnAk/XPM1w8eFBx5FuJ0H0/js88jc
	 H9HfdLFmeSLG5lnodDm4cnHYlhaAdVakOWN6EOQVQu93n7LLSf+nyEEbTikGp2e/GW
	 yBQOPzkRWgO8kbKOlYHU/6VDFRszc9GnIGlT7WYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1284/2651] arm64: dts: rockchip: Rename rk3328 HDMI audio card
Date: Wed, 18 Nov 2026 15:42:04 +0100
Message-ID: <20261118150334.163331337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 03b7c43137506..26c9f4558ed9c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -207,7 +207,7 @@ hdmi_sound: hdmi-sound {
 		compatible = "simple-audio-card";
 		simple-audio-card,format = "i2s";
 		simple-audio-card,mclk-fs = <128>;
-		simple-audio-card,name = "HDMI";
+		simple-audio-card,name = "RK3328 HDMI";
 		status = "disabled";
 
 		simple-audio-card,cpu {
-- 
2.53.0



