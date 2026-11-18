Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015381;
	b=ZmapPgASjw2FH2nBP4xqoD0HpksU46/8lmvELfTlrYTKlGNo7cPfn1eB4Vg95ntXjP9t
	 RSQ5lk3sevwNLtMtxJf+iOZ4jVQs+m2pquyPMYr8QFT+dBwqORtQjuTotYHDKQqZ4PdRw
	 RZ0pfs+MOdj7OZtr49nkTO/MOcMAEPW+qjefM+4PF9SGHu85/QF4fp2SwR7SxhP5Efa/D
	 Q0GXvn5MDb3xBWdLIjOle56PbBMIkyieAWbcjkAmo3J0NoDDyO9rMSeyq3Ewb639ZlBzu
	 oz0n8ywXcF97+rFeAWF4RWlmXJ6JBeBnBwxjkVwJQEeRhMIATPZuvxYrr5igE76Av1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UEf9cH5uQo5apXo+YIPFhXio0BAvSCxVKqI1q1Srk8U=;
	b=IRThj5AFgd+2KwnrQH1/LMJUqhAHOyz474s7UlAyJCDK0+yFPsRHSOoBnhK6RwYXuzfG
	 NPnNMYEilMcogFYpo0V2ULxX2KuqvN88552w0d7iRoNLHG0HGJEp31EDYuRCZLp6sMCjh
	 yp8IyfkPZr6t2UilTAYA/4TsEPvD3e29ftoMTc2Zj6I6fFYIX9r8HkgSQVevuewhj7UC9
	 NavjsRXodunPqjAfAzs4JfuZ92poYujKJid240wK8F0p6L/lsr7iDH67lVqp69a5hlkZR
	 dxZifnmfGdCTF6bOVLKRSR0whapbAJ5lM3EP+XA7B3SsLWupAOQXR++DIlvz6KiU3HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1JkFZd5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB5E606A325;
	Wed, 18 Nov 2026 15:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1JkFZd5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07AC1F000C4;
	Wed, 18 Nov 2026 15:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015381;
	bh=UEf9cH5uQo5apXo+YIPFhXio0BAvSCxVKqI1q1Srk8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a1JkFZd5WK4MdY8KzmY4oVRo3Bs0ZKeay/ls1wjglZAqm42H3n7BDv+8sARCvlp/R
	 U6JdTQLghdLKT/dRfjrK9RFZwU9VZ/+9WMyDHn03tJr6v8W6c4Q3KfDiiZGeJwe+UQ
	 eQK7QY4MMjwKGUcjnzXaPaygVHXD22/59lGRf5gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0152/2651] arm64: dts: rockchip: Correct Device Orientation on Gameforce Ace
Date: Wed, 18 Nov 2026 15:23:12 +0100
Message-ID: <20261118150253.326574522@linuxfoundation.org>
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
index 230aac005e8f6..d43eb48152e8a 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
@@ -596,6 +596,7 @@ regulator-state-mem {
 &i2c3 {
 	status = "okay";
 
+	/* Touchscreen is rotated 90 degrees with 0,0 position near home button. */
 	touchscreen@14 {
 		compatible = "goodix,gt911";
 		reg = <0x14>;
@@ -605,10 +606,8 @@ touchscreen@14 {
 		pinctrl-0 = <&touch_int>, <&touch_rst>;
 		pinctrl-names = "default";
 		reset-gpios = <&gpio1 RK_PA7 GPIO_ACTIVE_HIGH>;
-		touchscreen-inverted-x;
 		touchscreen-size-x = <1080>;
 		touchscreen-size-y = <1920>;
-		touchscreen-swapped-x-y;
 	};
 };
 
@@ -641,11 +640,15 @@ channel@7 {
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



