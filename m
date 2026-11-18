Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030842;
	b=r/v9eUwTKO3DT+qaOXT0U+YLEQujWRk+7V2SZLSXcn1Z4FrKqwyhz27Sw2xh15R6/eur
	 vrCMI6sGkQ0pZTN9eIVKY+V5fmIRtXJMTtgbAOYJtnBC18N2jlZbxypE5kbO7WL/D18/s
	 4SUEemy0rXIznHNcEzL+dT2hAs+pbcnowsRAECwGSW9AtKnksFdWaaLSekmIdhr1/2UA5
	 l6YxHvq09P0MoxJB7T8jocbwBa2ydaE610AsGDw8CNmNQppuS/8CD4F3vErjf+a18D5i8
	 UeD+txdCqQYveAhOJVv2QYReTLsF7hGhfZ9d39/8Mg2hkwCOUfHu55h8et2JOeLCyfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dOmaTIB+EwtXMPZ5W++R3NtYCclxpXOVU9somcWnNaE=;
	b=p39J1sRqBAF6Uv8aShgbmpVkawjrB/7g9LwCwAvAZBhZhMyc+b3ksPbJ6b7KJgyMa9vk
	 RaIDFh2zpKqvWLXJ4oHtfvqiUWp7/1ZHJupp19BYSagbrDPGqeuh0bJyS1oTBwxZE6ceY
	 Yre33drbAkmNIM+GKB3b7FEe6BF3wpsm8QeOYXPbdOzxQ70ZxWOojcjWV3b3NGuO9wNEE
	 FDEqkZ9Aggf1biK6DEId+juAb1Rr/qFa7klsfJywsgezdr6EUa3fmBYI3b6HR9C4bJs9c
	 4/T0Mi/IcXZaoIxs9wwAFSQ7gntTW+/tVUPAupEU5JQ4RMDfH6wKZL7DIQmzJ7oYcBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=asn09MTH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986A0606D344;
	Wed, 18 Nov 2026 19:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=asn09MTH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAC11F000C4;
	Wed, 18 Nov 2026 19:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030842;
	bh=dOmaTIB+EwtXMPZ5W++R3NtYCclxpXOVU9somcWnNaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=asn09MTH7oHCCCc2NIFF/BKaEjVGtZanCsRVE40Rb2yVmgv1sin8rZvlXT5ytUg4e
	 qikfdHA3flR55h5c3Q4DlsP3uOlqJPWKxKbtGfLt79ZENCfOUkFTBA8gFEuncedALn
	 fZMLjXm23Y3tlN184oWhS1Mmt825iIQ24zkvxCPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0849/1756] arm64: dts: rockchip: Rename rk3566 and rk3568 HDMI audio cards
Date: Wed, 18 Nov 2026 15:49:36 +0100
Message-ID: <20261118150043.197971761@linuxfoundation.org>
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

[ Upstream commit 8043ed0f40fe2b49df1c2c25409ab6bd3f88e806 ]

Move the HDMI audio card name for RK3566 and RK3568 to their
corresponding dtsi files so the name can be set to match the SoC
in user-visible ALSA fields and no longer collides with the identical
"HDMI" string used by other Rockchip SoCs.

Fixes: 697ee8546e241 ("arm64: dts: rockchip: Add HDMI audio nodes to rk356x")
Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
Link: https://patch.msgid.link/20260910-fix-rockchip-hdmi-audio-names-v2-6-1396a6168e20@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-base.dtsi | 4 ++++
 arch/arm64/boot/dts/rockchip/rk3568.dtsi      | 4 ++++
 arch/arm64/boot/dts/rockchip/rk356x-base.dtsi | 1 -
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-base.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-base.dtsi
index e56e0b6ba9411..3c365a1188d7b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-base.dtsi
@@ -6,6 +6,10 @@ / {
 	compatible = "rockchip,rk3566";
 };
 
+&hdmi_sound {
+	simple-audio-card,name = "RK3566 HDMI";
+};
+
 &pipegrf {
 	compatible = "rockchip,rk3566-pipe-grf", "syscon";
 };
diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
index c43c8dee7a0e5..1b527d8c3b8ce 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
@@ -378,6 +378,10 @@ &gpu {
 	operating-points-v2 = <&gpu_opp_table>;
 };
 
+&hdmi_sound {
+	simple-audio-card,name = "RK3568 HDMI";
+};
+
 &pipegrf {
 	compatible = "rockchip,rk3568-pipe-grf", "syscon";
 };
diff --git a/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi b/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
index c30e5737b44d5..6e764edab4985 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
@@ -146,7 +146,6 @@ scmi_clk: protocol@14 {
 
 	hdmi_sound: hdmi-sound {
 		compatible = "simple-audio-card";
-		simple-audio-card,name = "HDMI";
 		simple-audio-card,format = "i2s";
 		simple-audio-card,mclk-fs = <256>;
 		status = "disabled";
-- 
2.53.0



