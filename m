Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055734;
	b=0+a6VLGc59xC7YVHvotGqJlykNk3LVbDDF/86zl1MJYAY8UHx13C8BDxU7TJCcYWCMZX
	 CuYmsm/Mita3e7CfSsXBcK0HcQqAyjcpGJHdMALJpmZeOF5tuWknVRcs3xYin+uMI47l7
	 Dg25/pq0o0SpQVs+vmf99eUuxJUOQgTP1R3z8v6kiAE/KYfB8/U1S9QFJVK8hcts5+Qe6
	 ue16caYAO4sNZmT6h413eOmIk1np5jHDzhujL1I9JOXUe1bQGQ+QcJWmeWXw0LYZz8EcR
	 eIuuWopUfEFYJzCmWe3URwyJXGB4TtVaAlWfAjQ9LI9pfElp8yn7qHVjS3GnRTtdtOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OxwKLBM10UvzWD2HztMeHXYhiwSvLyW8yq4JlPUj22I=;
	b=bBytjBRJtuoGQydrKfIpw2x34tj1dJOw74GNEzZ2Gzzssw+MSkmkVpyMtKIyzYS3moNT
	 57Mr6jr5bFq+y1OzDz0bpJtBFclqhyYmrxOJJSIcWv5iqtDU1VPcZa1NUMwVPK9EluNgI
	 t9zEG7AW2hHl5sS6/UqEe/7iQizSzaJEpY8CXD3BittdfW6OOFWS8QxGkQD5lMqLDqTHK
	 4+MEmpFo3OQ25iEKvVtgeXocM/Bus4+EM5XB/7q7rXpTEThi47JQLDTlVO6IZzAeIncDF
	 XsBh2O1xhiI97ZQY8ccsv3ChFamsm5lfMZpJTJIEzSbuQSmJjWtXe00NTxn5j7qtzjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EK2FYKz6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB8A606A320;
	Thu, 19 Nov 2026 02:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EK2FYKz6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D3C1F000C4;
	Thu, 19 Nov 2026 02:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055734;
	bh=OxwKLBM10UvzWD2HztMeHXYhiwSvLyW8yq4JlPUj22I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EK2FYKz6OExhvzzOl0dk/Q8ld7BddkeDrAXvAE6E+N15RS7DZnXNnAMasXVYsx1XY
	 Y1nzfB+rECPZEbzbvXO4lJJFZ1OAPDHR47mzH+Fv3Fhtgko/RvaC4NsrAAR6vntbiT
	 a/nYTx/NsQq/Aik1dZ8scwW/MdTwX1ZgsoosKQSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaozhong Li <yaozhonguwl@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1738/2214] arm64: dts: rockchip: fix analog headphone output on rk3399-firefly
Date: Wed, 18 Nov 2026 15:56:54 +0100
Message-ID: <20261118150121.184891419@linuxfoundation.org>
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
index f81ce3240342c..6df072b5fe4ac 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
@@ -95,6 +95,15 @@ power {
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
@@ -131,8 +140,11 @@ rt5640-sound {
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
@@ -541,8 +553,6 @@ rt5640: rt5640@1c {
 		clock-names = "mclk";
 		realtek,in1-differential;
 		#sound-dai-cells = <0>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&rt5640_hpcon>;
 	};
 };
 
-- 
2.53.0



