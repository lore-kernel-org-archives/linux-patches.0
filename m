Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018572;
	b=ma04e1VMX4pa10fKOcCpKO3qIHMNnG7Sl5hTIX+Gi1fWALWRdQc4xnV+SasyH8wDfqYM
	 X878/jAwvDB9eTb/C2qpd3IxKfbTIsfnNNSpPGUWlf1cczgxEoK5u6Hr+wezl5nkfPkJ4
	 aBQz6wp0bbtstPR+UIc2PwEv+FRb5gZjDAIAghbR9mvVsFlP35K3d+KqvNtRwWN4EelJj
	 CbE52Wr+mRAdIoQtmnoJx4uKu7AoUqploccSYvoQoAcVYpjRgH4CYiobidwck1PTgs2vJ
	 0JF+lnawmkq6eKwgWf+ldpQscjE0CS59jzGSsK3ZW/d09mch1Vit5tvbLwwT8LuiscA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DUZKLeLaWxkobJpjCZtEBHpL7xU881OaxnG4WwTObE8=;
	b=m3vR939uHqzKjQ1gTWre4q0ey6OIh/CsxYB95nmuj8euonqwwzOaevGruTXsqyVFh/9R
	 qSlv4BcWe3MnHL609XAffXA1tdSZM9RbcmtKJurzFO+31V09kIm+kqDyRrsbbYW/+8D66
	 rPrm7NE8WpNErHm7niU2Zj8umLN/teNUSL6Wcn51V1ug//tJD+zjNfqrQfB/szc/cR3I/
	 0yRdQmeG/zQpVmMIQ5kZxDZc+cPyL1ui60kms6txT2fWlr9EUuqfk5Gzv4ZO0T8oTQnk3
	 f0xDFBv4OkA56r/Vdvo3Jm3dtXoY8cutV5Y5yMsLcJ98/79DjPo+DI2gz/hfGUaX5Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnuKko+3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E81606A330;
	Wed, 18 Nov 2026 16:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnuKko+3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD1F1F000CC;
	Wed, 18 Nov 2026 16:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018572;
	bh=DUZKLeLaWxkobJpjCZtEBHpL7xU881OaxnG4WwTObE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnuKko+3UAAZUOs88jfhKguDlArOQ5A94B1pLPLahGpfQACSUGR/tRFY27SfI3AI9
	 HcKK65fz6ERWHS5u0kmARWtWWVmb5u+Jx0maJBJQ4wafxqGQLVcr6gtzPTQRj9XT4X
	 qQ5t3pTegmj1pHuZRM6ovoRQ9KclIawKPS1zVzcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1288/2651] arm64: dts: rockchip: Rename rk3588 HDMI audio cards
Date: Wed, 18 Nov 2026 15:42:08 +0100
Message-ID: <20261118150334.310906738@linuxfoundation.org>
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

[ Upstream commit d1b7c3228041f4b3ad888abe6a31f6494279e979 ]

Rename the two cards from "hdmi0"/"hdmi1" to "RK3588 HDMI0"/"RK3588
HDMI1" so they identify the SoC in user-visible ALSA fields and match
the naming scheme used across the rest of the Rockchip family.

Fixes: b8c6c136971c0 ("arm64: dts: rockchip: Add HDMI audio outputs for rk3588")
Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
Link: https://patch.msgid.link/20260910-fix-rockchip-hdmi-audio-names-v2-8-1396a6168e20@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi  | 2 +-
 arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
index 376ad04e07869..7892e18a7835a 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
@@ -376,7 +376,7 @@ hdmi0_sound: hdmi0-sound {
 		compatible = "simple-audio-card";
 		simple-audio-card,format = "i2s";
 		simple-audio-card,mclk-fs = <128>;
-		simple-audio-card,name = "hdmi0";
+		simple-audio-card,name = "RK3588 HDMI0";
 		status = "disabled";
 
 		simple-audio-card,codec {
diff --git a/arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi
index b251bb129cdbf..2bcf30d8a338d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi
@@ -11,7 +11,7 @@ hdmi1_sound: hdmi1-sound {
 		compatible = "simple-audio-card";
 		simple-audio-card,format = "i2s";
 		simple-audio-card,mclk-fs = <128>;
-		simple-audio-card,name = "hdmi1";
+		simple-audio-card,name = "RK3588 HDMI1";
 		status = "disabled";
 
 		simple-audio-card,codec {
-- 
2.53.0



