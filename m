Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025426;
	b=whkssmFk2IkvxF7CJxyq3N67bybXDd2Kut2UXknYfsOmGHWsvnjMp9Ww2ZoenV6P6f/u
	 DC4vDpYNhQJE/QFaV/bIguHqj5ggR9TvC0DjC0wRG6dP4Zet6HtqkYshhEi0LUKeqq5NA
	 zm9C2DlB4cfyi+xLKdi3s8pmNPnM/G8E/JVOBk5JVdw9SUc/ui0vvjPMRVDAuTDhSg67q
	 czl3EDCksZqtvroVEw9d8sy95/kHKQXagyrT5nBdn8dP8758ClC0CddSbqlfiEmMDRhI7
	 Xf7yAziFwIEhyL09R2TWpLjk20D34D5y3PE+U+hmrkUj3HE5kfEAdXrYuRW+158EN2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jhnn5npRd7zsDNGc4LfQsn/reDDxCo0HN2hrX0V29e4=;
	b=n5KEWvrIFY6tWSOvnUgC773QBheN0ceeBsZ04cz9wtToNBzspbjySCIkEQx40WFTBafN
	 FhaDLnZLrkyuFnM6MCAtCPg9BHnBWPJ+cLFxIWRtq8EnkEWCuHRezKsdUgU/wFpKow6XW
	 H5lAu8uuXgZmptJV9BEagCR+Vr4CmLGExUWMS1RdZyk8TKhKsMctvkAlyVjxgCwjhwem6
	 IUu2rC18FGxl1gHT8OA7SvJ9chVJIMaImbd8zTjGHULRePXblMkVftDn9fAjNVp25fEAM
	 ffgzZ7CM/pfSwGNwkQ8HZbB1cFnjCVlRZG5IEEo88A8P+hNWkpAScYfgkl7DQTi+ZTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hNaH6r4P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CFD606A31C;
	Wed, 18 Nov 2026 18:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hNaH6r4P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031D81F000C4;
	Wed, 18 Nov 2026 18:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025426;
	bh=jhnn5npRd7zsDNGc4LfQsn/reDDxCo0HN2hrX0V29e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hNaH6r4Pop//9FzZboEGZ3/yKdR5EzPlmJEekXQZxaPS1HSMhM9eKmhQKl7e7PK0a
	 Mx3wsrrxkvlH/tlKe0J+KmAVXkrj3Ew3cRXaak3nZmw7YyCSez/mZ1rtIVT6wp9uMt
	 WZ3I/cmiMEXbkry4w2VqNR/2jzVhYw268vHD67W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1076/2151] arm64: dts: rockchip: Rename rk3566 and rk3568 HDMI audio cards
Date: Wed, 18 Nov 2026 15:46:51 +0100
Message-ID: <20261118150201.474246920@linuxfoundation.org>
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
index 658097ed69714..b1d8e648497d4 100644
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
index d654f98460ec0..7984b1b808708 100644
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



