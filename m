Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018566;
	b=HiI96KcGBR6wPD56y7YoDjMh8nyLNe7+7K5z1LfxO4r78Vv9gVR+1v9JmcObW8gjjqnw
	 QLkyx1qrQRa3FNUwiKvZ02N3XaJkt10a5ffqC5tovaZv5wcfNSBqaWucgispckjgYUPzn
	 b5doQ0/o69X5ZmcG+H41+flJDnmTXLDJ23QbzdPtjOGF890perdcW6yjvalBv8byCnVsi
	 I7KVMR9Gh14HhZ+88zZkh1K7OhiJoMoopqVg8KxhnvpAOW6Piu96IBREBOI/qsyXvpWN2
	 fZhZqV6V2E5/u8EezZ135J/OatVSPn7E/MqaFdEt1Z1Kq4ry9LIZaCiXGg8acTX4ZmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5TAUw2Ug7qUPyx5woOkxRRpxxYW0741xq6rDeKRrSKI=;
	b=moMzZnGXUlWFeTZEQyu3Ekaxq67XzXe4udxmVKoKxWn9dqVW33ZvWiocxEpOXzM9Ngdh
	 yGe4uyoo6BHNYTeFp644pkQJMnxqS2vsH8ol8WK82afrqaLuMd0z+Q26M+sikN6f5jcKd
	 R5KDuvV07Ys8EB60B9svgsiKELWPWsu2XupNoBZNR/GMyGg4CBJZBHsEH2PE4JpBwNewy
	 EsY/oUIG30Y3JJhlDn239pAQHCscKqUdW40CC7Z2CQTcc+8/BjflbJXWFO/UglWtPmMuU
	 TSi+76IaWtzM3IIGI4+h301PRvfGztQWvrbvk+KOEi1H1nJqUlzj80AnP3L0Rnqjmbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=csefJlXz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7989606A31C;
	Wed, 18 Nov 2026 16:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=csefJlXz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EAB1F000C4;
	Wed, 18 Nov 2026 16:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018566;
	bh=5TAUw2Ug7qUPyx5woOkxRRpxxYW0741xq6rDeKRrSKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=csefJlXzBo69LB3DpULyB0B5GGLfLL1G61Iayi+aJR+EW188fpGuKgyIgvAjYrIW9
	 FWZ3joCWWfrr9gwyYyWi7hzcikDlcgbmk6jy00S8HRnz3Wxd0OowchrJovE2I2y9W6
	 o7crX7eLg/d7M8h0mNXDtebQA8rHTX3qGGaDbx4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1286/2651] arm64: dts: rockchip: Rename rk3566 and rk3568 HDMI audio cards
Date: Wed, 18 Nov 2026 15:42:06 +0100
Message-ID: <20261118150334.237403247@linuxfoundation.org>
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
index 3bc653f027f1f..2f42bf26fd9bf 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
@@ -382,6 +382,10 @@ &gpu {
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
index a5832895bd392..1a4562df20ee5 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
@@ -150,7 +150,6 @@ scmi_clk: protocol@14 {
 
 	hdmi_sound: hdmi-sound {
 		compatible = "simple-audio-card";
-		simple-audio-card,name = "HDMI";
 		simple-audio-card,format = "i2s";
 		simple-audio-card,mclk-fs = <256>;
 		status = "disabled";
-- 
2.53.0



