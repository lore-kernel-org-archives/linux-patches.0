Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061317;
	b=ZgjCLrp0dMmdXymewViUoT+NeIAf+Qd9qHUDvpYBMDQwSUs/s2ekYmEOQizyH8upK8WH
	 cmjzKKzuaWc31JO6Yg27VZGpS3yUxdpSWLymCH3dfOEZxtIwLx3mHAbz/QdDZcsmGTU1D
	 9j5/GNsjy2uBCHEL+vOTa4fkFhSN6jvSRm1ggShNj1knMtshuj89IM1BwHsu5PFYK0crJ
	 Y3m4M7DZbzYoJenH+HYt4fTZ/J5j6muFt+AsCQ+6uGvE0KFT4JJrM8GZ273tp/ISPpMiN
	 NHqAvy12wEgPRI2rWoJKzFJYR+fewCpIz9kNqzJsKE9N0UxM5SN5roJozr5+HqJ6+mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iznxoH3YLkr9W2TqEyUvf/kuerw7g+NrDmijjnG0KPE=;
	b=yxAwSoE1K2irrgnCahuS9sJDHsTExHBOYgLqrv1zpAIEWnjdU4AHyR+A6xfciMWpllzW
	 wqyON8inW7e80jjwjRBNGFRCKe9GZj9cct5uO7titi9bfph76bIUHJgY1kmpVjD+8VIvs
	 Zd5QFSs6u2bKSqFpIOk/owQrxueUhOIokTb89/PwH9PXVpkz8vD2HPNPsdQv0PJyeN1Jo
	 Yjr+eE1NMIO/OSmyDfuImYSgvyv/buoLNKnbidC9fdcNREoauJ9JL3n6i2yFgFEOO6NjQ
	 2TQwKdUk2jDWCZPPm7i7uvKdqgkyo6jeM6dJVMRTzEMLCtTWvNhDUx+9Enu0CQCxkjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c47ETyKN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A4A606A320;
	Thu, 19 Nov 2026 04:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c47ETyKN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5660B1F000C4;
	Thu, 19 Nov 2026 04:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061316;
	bh=iznxoH3YLkr9W2TqEyUvf/kuerw7g+NrDmijjnG0KPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c47ETyKNa7qAt1T3W7NF+Au43gqC1rkgyKZhWU8HkBy3mzGPbbLYgrHu7ar3ULsWe
	 YRp/Za6Y+Dry5XcZ0Ays9xB6Mjozx6EPWYaZN7eo4Nv8yQFXoeOIYvqZrD6FCPzVge
	 hf/9Hujj57ygm2CTBXElw2PqXIjg1NJhXplhoIe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaozhong Li <yaozhonguwl@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1467/1848] arm64: dts: rockchip: fix analog headphone output on rk3399-firefly
Date: Wed, 18 Nov 2026 15:58:25 +0100
Message-ID: <20261118150020.741534439@linuxfoundation.org>
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

From: Yaozhong Li <yaozhonguwl@gmail.com>

[ Upstream commit 23eab1a5e36099fd1269f8a18dc389e04dc19011 ]

The analog headphone jack on this board has never produced any sound
with a mainline kernel.

GPIO4_C5 has to be high for audio to reach the jack. The board file
muxes the pin to GPIO through the rt5640_hpcon pinctrl group and
references that group from the codec node, but nothing ever requests or
drives the line.

Describe it the way rk3399-roc-pc-plus.dts already does something similar,
as a simple-audio-amplifier auxiliary component, so that DAPM asserts the
GPIO while the headphone path is active.

Measured on a Firefly-RK3399 by toggling only this line while a 1 kHz
tone kept playing, with the playback PCM in state: RUNNING throughout:

  high -> audible, low -> silent, high -> audible

With this change the line is claimed and follows the audio path:

  pin 149 (gpio4-21): headphones-amp gpio4:149
  idle:    gpio-21 (|enable) out lo
  playing: gpio-21 (|enable) out hi

Fixes: 171582e00db1 ("arm64: dts: rockchip: add support for firefly-rk3399 board")
Assisted-by: LLM
Signed-off-by: Yaozhong Li <yaozhonguwl@gmail.com>
Link: https://patch.msgid.link/20260921063431.103-2-yaozhonguwl@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/rockchip/rk3399-firefly.dts | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
index 5725fa2df9fc7..07272ed3a7695 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
@@ -88,6 +88,15 @@ power {
 		};
 	};
 
+	/* GPIO that enables the headphone output path */
+	headphones_amp: headphones-amp {
+		compatible = "simple-audio-amplifier";
+		enable-gpios = <&gpio4 RK_PC5 GPIO_ACTIVE_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&rt5640_hpcon>;
+		sound-name-prefix = "Headphone Amp";
+	};
+
 	ir-receiver {
 		compatible = "gpio-ir-receiver";
 		gpios = <&gpio0 RK_PA6 GPIO_ACTIVE_LOW>;
@@ -124,8 +133,11 @@ rt5640-sound {
 		simple-audio-card,routing =
 			"Mic Jack", "MICBIAS1",
 			"IN1P", "Mic Jack",
-			"Headphone Jack", "HPOL",
-			"Headphone Jack", "HPOR";
+			"Headphone Amp INL", "HPOL",
+			"Headphone Amp INR", "HPOR",
+			"Headphone Jack", "Headphone Amp OUTL",
+			"Headphone Jack", "Headphone Amp OUTR";
+		simple-audio-card,aux-devs = <&headphones_amp>;
 
 		simple-audio-card,cpu {
 			sound-dai = <&i2s1>;
@@ -506,8 +518,6 @@ rt5640: rt5640@1c {
 		clock-names = "mclk";
 		realtek,in1-differential;
 		#sound-dai-cells = <0>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&rt5640_hpcon>;
 	};
 };
 
-- 
2.53.0



