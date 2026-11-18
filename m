Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030831;
	b=yGqS0KXbGPmKXXuXmzcNGxa3j2R4k3hbCAy7kQMdoFNKRxob0bS+vZ71w9ASdgoeDEBH
	 tlzlz9EYx3xIC5gsYhh8XzNUqkWRaYoQBoFizn+cJB3vYcpRrsoQ35t7hDGPw7rzgkX3g
	 0Z4Tewufu365rNsav7tv/nU/ydDMvY6O2WLMKTevsLr/9Rjgo9sjP3CbkcUSMXDxsZ70m
	 loV7X5zoqhUQAiHWiFw/vv1VFyn/41R0UxiC0Uh69jKSMa9N1dekKLGarAwO1SWAlDZjJ
	 JSkBRYOk19H0RDiF2lWkvPMwBEHYVmIqVqnhTjVbKBxzNxoi+lAMKRZNYlgKHx4MgKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vv5ftJ5dFpxTemJySg7dR9X/Px+6uQFGtzM2+yUC8no=;
	b=Oqp71fbNR+MxuyYhMo2sr2m++oqRnmGFRXDpwQ4XJ210pIIvxkufoGsoknstzwxTuW93
	 o616Jh6alUsU6UCs/OkNVxDPwXsUmWw/SeKBiqJaD8lVSOHAC6/QSown26q3Q1MLi6YQZ
	 oaKjPV0Sf6jPvWdvsXsUuCqXtHxY6QPVnT3RiAkJYanCub2yb/pDadkWzVhmHPXKFWNmE
	 R3WCydpjxpWkd4KTXW2k+WPjGEEi0LGSnCdsqQTPYBeEjW9egrb5+VPOhyPmG0ng75a56
	 FW2aXoFx99i+ih87QJjiB416sYtOESVFZxojKtTSqggLIiQ1B6hskH7vhuKBXVvsopg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YD5FyWsA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9A8606A92E;
	Wed, 18 Nov 2026 19:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YD5FyWsA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C839F1F000C5;
	Wed, 18 Nov 2026 19:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030831;
	bh=vv5ftJ5dFpxTemJySg7dR9X/Px+6uQFGtzM2+yUC8no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YD5FyWsAEmFP/dn/qV+FELuLr9X8iUBD4SIC2kl1EqrNDdMGfXOqkjy7hKTWY0Kpo
	 jGUtPJeJFDc5qT1KzzO5mz65HQJ6ZjKmdBwcSOSRffsxqQN6CnuG3/mdny9qJk9k6F
	 IQmNWODmOBRmhXK25Edc+zvNgpV/xEqeGii6vk/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0845/1756] arm64: dts: rockchip: Rename rk3328 HDMI audio card
Date: Wed, 18 Nov 2026 15:49:32 +0100
Message-ID: <20261118150043.061511836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d16a13d6442f8..a6db5ce407970 100644
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



