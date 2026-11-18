Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025421;
	b=uahp4pXsErAto4ov/C7LJnvgnJafu13h9/iJopo5JKE1lPU1QYsHlRPJzdeUA4ZFTMR9
	 /88EwxcPVGYdoy5/OWVuEqclSOfAz0TwVwqoHvaKOMxs/o+43dRs3bLQK3ZB1Ut622HBs
	 /gEcTuvqFz/Lklk1lOBWIjhtilMd/VRi6cPhsHq8qnhSSiZ5+PCcxj2YIkNRyUnbPidkZ
	 grkqq93Rmjm2jj4uaN6HzKsmXmhUI6CEf1Kn2fvuTcfgS/iXBwZ9X853Mt1HzJmrSfP5t
	 DVOd/Ok6u8rbXtZ5jqTFBbL7/FWsdbVwZBIKZJO+TZEfck+3/sSr747be8MuwZigobQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ITLxOPFHXBhipYoNZopHSM3k05guaZzeQe711wOzMUs=;
	b=qucR/urbcu80j13ZsXpWY/PObLdvSzZ2AVZZfvAN01U0FOk1SC/egBIQox2ZLZqK5CNU
	 ffTkZ40OP7UotUAru6sqL0hOIzIVdr6uIe+WoQUdojzBcudraBbSGX2xXQhk+i8GFt6Lt
	 rPnqy+bVgMUcswR0y0QuOlv+hGuKffcOsZU/ybLQhiwPYsctQN/ZRtdPCMc86hVoHv8d7
	 UlLHefHpGb1s/4c9nsZ869sd4xoN185zqFtRJ7Srp2+3JRBvHZZG/zQlV8NhiUmZwdccU
	 sGNWpNG2w6BRrP1i0iDjx7ajp2cROBcYpSIAszg48SBWjjupPwUvl1B2Q5GkkxgW8nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q2oIcdwD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15643606A31C;
	Wed, 18 Nov 2026 18:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q2oIcdwD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681481F000C4;
	Wed, 18 Nov 2026 18:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025420;
	bh=ITLxOPFHXBhipYoNZopHSM3k05guaZzeQe711wOzMUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q2oIcdwDYtPHQPJk1+WAT0u1MDCcV+IKWO7Mc1d6oHS6JdOJIOxtidT2U6eZQdPKw
	 Kyhqe6zzjGM7/1nyeXqCSg3mlqE0DxKr1DkMbooXJIodgRppixnA9dGx39Zp9DflA4
	 k+K3GLRoVu+GYZfAulD4SbhDqvRvTewiP5Lm/ioY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1074/2151] arm64: dts: rockchip: Rename rk3328 HDMI audio card
Date: Wed, 18 Nov 2026 15:46:49 +0100
Message-ID: <20261118150201.404235194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



