Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025432;
	b=QjBtNzXkGFdw5gAlIZLrYi8Sy819jmKotskV0ALKQLwetfJIaydsVeI04Vxui3KrYWO5
	 3om7fHBvG6WbKdzRz+B+UEtzMgjAdRvF5fucLyxubryHQKOdg9xctcNMlKkCgXGqCBBPL
	 hXRGNqQyOf6h0LOoVgAzvGTNcfOzl4lFG7hcV2/9fxTQ0ZYZxFVOsEW10elTpVA2/wzzq
	 1UAkDKSkiazqqFsBPqGcAq3XcbgCxyNzFxIzEt0MkrI4APUbwGhK9oY09brgfDeoG2fOP
	 0k9J64lV37pRU0MjGJgU5NfPM/3Tf9s3D3XcwGHL+Md/SfaPJbBbmwsJWjxTQ9C8cUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PhQVgZuXug4dK3TmVJ4aWYvxEKkTBhsi6PGfS1ylPoI=;
	b=ltoWdcRZddOLYmJqNE8njTT+IT6riku3FdT+b7+nj821GX+ol2YgRzxVZbBW4ucyYMbi
	 /IzLDoTKxEjDncpcW+WzZzREgIz2Cj6pMojBiIhtdMNwiWhyyv7ILQgqosRGFat0tu+BX
	 RAw24G83EBxAUSZbb/lensr9OB1dEnZi002VEKmp3JRdcUA4KGlfVlEBOwf4T9+7Mh+1Y
	 thoPj2++hjzrhLo2abxBqN22V+vWwEP6LJF07ar9kw912/h76V5NkzaoMlVJfXBGgjeS4
	 QU4UZJ3IJEegs+lG4k9zMZhqF6lzSPw/9T9RW1Wd3UiyfXRuCknRoFTSLh3+3yC512A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ciq983xL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D389606A325;
	Wed, 18 Nov 2026 18:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ciq983xL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756F91F000C4;
	Wed, 18 Nov 2026 18:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025432;
	bh=PhQVgZuXug4dK3TmVJ4aWYvxEKkTBhsi6PGfS1ylPoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ciq983xLiCRvIU0niIPESEKOR7cNVxx8HebUsvzQm52/7GwU6hGg3lHT0goN4wWiV
	 xVrRIIXNZdvD9KsbFhfLZV0rbl4NiyvKa0oxSw+ZentjE7jjHk5qyTzgSRSKi14IC2
	 Jk4Mre2nCx2vUPo5THqlxv1MN6Rh4WWfhAkvhOvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1078/2151] arm64: dts: rockchip: Rename rk3588 HDMI audio cards
Date: Wed, 18 Nov 2026 15:46:53 +0100
Message-ID: <20261118150201.546911977@linuxfoundation.org>
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
index a031f42c558ed..e93e6170ae618 100644
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



