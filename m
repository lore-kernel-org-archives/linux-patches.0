Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023087;
	b=09ru8Vsv/bKEB4TPy4PH/+61nfDywNBKPXCwp2A2wfO2G+FOkR7gcuJvhBYazxCZz0Zo
	 miV1rDyh2/vy+Hi+v85HMkBAgFCA+sSK1DZaFLl9UTi06aZqqsX6+fpSHc4wwOqNARbmf
	 7k6SbzZnUaNPVVcZfHDhvs/pbsrdQhsKRyZamwUuReks8aO1quWmt7iS8e45FlxHPmcSI
	 CRwl61Si2J88fmXHZTnO1k1nR5sOmKBbqsYDZoyxD9Kf/HPAzRksjsbMl9UWm46q08sz9
	 c+wi5m7U+p1GKjUq21GFjWhchcQdABGN1vjoOpKSj/TotjcCuBYMsqPCH5QqzbaEfPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Md2IEg0LNCO6dUqhy3Q0b6yqFOcWQYmCaLpRMM1xKDc=;
	b=tzWYQqOB1iaMyhWQooZr+g6byS/IBLHt1h9ltsng0Xw1HFk16V7Zv6peIH5C625bc1Cm
	 lP225pfno0BlxUk7NBGo/ARU2livMnKuLmeX2zmY3bf33C06aIB5Bu7Gpz6a2CH8PRuZ2
	 7LqTmAwrQuzcLe2Kk1lKuunIhkkjk71BrkChDVm4h0NMmCMU2m9bcgWez5fkt+cvF9Fnl
	 pYnMb3QKtzPKPj1WAzLLMiodDe9Yf2Oj/uGZ4CufofDavshlXQ+gEldRR2HUUKULBt5OV
	 tnbxD2F9MuYEy+jcAbPUFI2YnHJVOigUMYP2DifRkuGBGNHINhTnNqrzUeB0wzmfN9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TNdoDTxe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7251B606A31C;
	Wed, 18 Nov 2026 17:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TNdoDTxe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52881F000C4;
	Wed, 18 Nov 2026 17:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023087;
	bh=Md2IEg0LNCO6dUqhy3Q0b6yqFOcWQYmCaLpRMM1xKDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TNdoDTxeZ6a2v6xHbj0xN/oVnd2JFcm7/uqDkPkcVgka6u+3UjJmh45b2EzaKCvls
	 oXxSIA9pg0cMuZepLmc83Rl1e4eJh73gbTG55DGeSJjimLEQ2dlpa5QCpoDh7pxjmq
	 OTcoCZiqMuj7SA1fyZjk+InGabsVuluPjLnEZfNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0193/2151] arm64: dts: rockchip: Correct Device Orientation on Gameforce Ace
Date: Wed, 18 Nov 2026 15:32:08 +0100
Message-ID: <20261118150128.809414485@linuxfoundation.org>
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

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit 0d170ee38e7a943248082cdb4b3e40b45a96e2f6 ]

The display, touchscreen, and IMU are currently not oriented
consistently. The touchscreen is 90 degrees offset and the IMU is using
the default mount matrix which is 180 degrees offset.

Fix the touchscreen alignment and add a mount matrix for the IMU. When
the device is held vertically relative to the display hardware, the
touchscreen 0,0 position is in the top left corner of the display
(next to the home button), and the IMU reads the correct orientation.

Fixes: 4e946c447a04 ("arm64: dts: rockchip: Add GameForce Ace")
Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Link: https://patch.msgid.link/20260828205331.78185-1-macroalpha82@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts b/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
index afac54ba58318..8628d941d80dd 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
@@ -556,6 +556,7 @@ regulator-state-mem {
 &i2c3 {
 	status = "okay";
 
+	/* Touchscreen is rotated 90 degrees with 0,0 position near home button. */
 	touchscreen@14 {
 		compatible = "goodix,gt911";
 		reg = <0x14>;
@@ -565,10 +566,8 @@ touchscreen@14 {
 		pinctrl-0 = <&touch_int>, <&touch_rst>;
 		pinctrl-names = "default";
 		reset-gpios = <&gpio1 RK_PA7 GPIO_ACTIVE_HIGH>;
-		touchscreen-inverted-x;
 		touchscreen-size-x = <1080>;
 		touchscreen-size-y = <1920>;
-		touchscreen-swapped-x-y;
 	};
 };
 
@@ -600,11 +599,15 @@ channel@7 {
 		};
 	};
 
+	/* IMU oriented relative to panel, which is rotated 90 degrees. */
 	imu@68 {
 		compatible = "invensense,mpu6880";
 		reg = <0x68>;
 		interrupt-parent = <&gpio0>;
 		interrupts = <RK_PD3 IRQ_TYPE_EDGE_RISING>;
+		mount-matrix = "-1", "0", "0",
+			       "0", "-1", "0",
+			       "0", "0", "1";
 	};
 };
 
-- 
2.53.0



