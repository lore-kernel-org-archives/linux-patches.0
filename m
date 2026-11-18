Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055725;
	b=CrcYmEjowaYisE6t489xmwUp+fMgl4otJFMXJ2HN874W5jfT0lctj9jOKSYDZGYkqYgS
	 OlCySnrd1Xs14un9W0e8/yq//Gs1y7IXZzxkMbQ5hqqMQprRdni9ZaE4eI0mhR/wYdm3W
	 D2ObFu/5QnJMubS46rHpkh+oFRc7U3nFmqm3PvddMVTx/ve97YI0uQh7YdF7INiXf0Lte
	 9+6RdZOXYFksjAINjyodHsTGtIkig7Dw6RHuf9yoY9dnzNXjyNSqj1Kg1hQ9+69m3kdmW
	 8mNwywmCJtLYEtJneO6zCLGE1Eu5IGUea7M6N0vGwlCeu+yixNtCBrWbeWCFB42Y3cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qu49KhDD8S5rRdW9809vypc5PTYscYaw1Fqwu3ZVUAI=;
	b=qCtCIudFeHqOV8t9i2Fz9d6jijTNlpcaWqzyYSn2UFauzG2xBmVE1mwGXmB/q9y/ufQA
	 9PXnnw30VOxOcH1hZw1jo0H7KngDhRKRnajfjMDeZjX3g2shjUsk57XRldC6eIChAfAbE
	 f6w7sXZ5mJ3fdNd9L+bU3N5VZgWM/vm6niStmavkAVk8092JV0L94J0zQik2o6gL219sX
	 CEFXfFqt4nLIWFp/2YQ5WefJ44zPElzoDk+Q6bvW01JLXvHIXX6Pbk9vAFtEWTrjVjvMc
	 KW96LYhC2+eaVpCB51BHD2186eK9GY/MLw8sw1ixpYUlpJwq+IpaAt/JgSmo/5JQwUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jadg8/Ej";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8AC606A320;
	Thu, 19 Nov 2026 02:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jadg8/Ej
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4AB1F000C4;
	Thu, 19 Nov 2026 02:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055725;
	bh=Qu49KhDD8S5rRdW9809vypc5PTYscYaw1Fqwu3ZVUAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jadg8/EjqQA1R3QB2FcZO8PqHzmpn3Mab2U2rb0q8h1FVkAM49ooKUzXq0ulGb7st
	 Gqksyy1PZnM6w87Mc76FDHGq7/PDxdWPHr4U024jlCwe6aN71N9CuctVhZzd6eGErE
	 kGHzSaeJtRjc4FXVGLz5BFWSVueZPoq9xBZbCuY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1735/2214] arm64: dts: rockchip: Rename rk3328 HDMI audio card
Date: Wed, 18 Nov 2026 15:56:51 +0100
Message-ID: <20261118150121.080349142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 93ef90315cda6..e1fdfb047cee6 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -176,7 +176,7 @@ hdmi_sound: hdmi-sound {
 		compatible = "simple-audio-card";
 		simple-audio-card,format = "i2s";
 		simple-audio-card,mclk-fs = <128>;
-		simple-audio-card,name = "HDMI";
+		simple-audio-card,name = "RK3328 HDMI";
 		status = "disabled";
 
 		simple-audio-card,cpu {
-- 
2.53.0



