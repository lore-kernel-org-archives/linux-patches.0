Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029010;
	b=CFlOgLhO3OvaZlcUQDeOML4xULKkf3dMrK/SJDlRDfBZTuDVr15yyH/vUS9N9NJnGPbz
	 Rh36tJ4EevGrgl11Srqnt4v7rSkB2wlVsn3W6cxzixvg8zR4zMBeoWtLQ2JcXy4nmmI1q
	 Z4cUc5zLw20kmSAmRL7Z/TEBb6zLYihVbyKPtplC+ArrzLvpXj1BP10IDL3TLjoXg/KQg
	 MKrnBivKtzrMwY5iDhwD7W+LLyrI1/8xN0dVDd5eGe3piEOEY2wZHhXQBCaapfRIcbg3m
	 2eOh0aQ4/Ns+YCzKgLNyil8vBybAW11RNamDhCSa4acoM9dKVHGUEMEdIvn4SapADew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N2cODnNY4qipwqGtcf/WtmZnuKAQr2tKgXSMXd+7NvE=;
	b=Ta2GgpUJqoBVcpLhW0JiaSrYEuf0AfQlegtTTL+y7ktzrbaxZO1tLVGdjY7mirWckEQU
	 ul8S3w6hhiZ8yVasOe8wXo0SkdPcdKa0byL5phuDzpN+d97wMQnilEaR1vopN8+IPxrgA
	 pzrWi4P7BAY6CsjQyzvtqEoVODahW5TwWrK018b1euN7e7S50VpHxjKfhIyKUHgRgiuaK
	 CuTOSbc0pUyuDytOwwdJpIbsit8NOVAO8Rhy/oj3C0iaMLl5lNey5gwEg0b7h6lqMNnoe
	 rMqsfjSh63A+1p4wMUH6A5TS6S+0Pzmg/S789R7jaCHvfeyYnPzsPzt53tlZhrQDzXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u987THPb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D08606A332;
	Wed, 18 Nov 2026 19:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u987THPb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E808D1F000C5;
	Wed, 18 Nov 2026 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029010;
	bh=N2cODnNY4qipwqGtcf/WtmZnuKAQr2tKgXSMXd+7NvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u987THPbnv6cZ+6y9g89F7w7EUgAF2sY3jhcqDikJmUX49v95dOOHs7RMCA83mGxH
	 cFs7P0+E/awQuRO1PJhxvvY2Jy5YNTlliceiaMhHz9qkmBXKk8DB6B0JNDFDTZ21xG
	 1KGjOPjAa48tMpp5B6I0VetMZK4OYFtYspw++NHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0197/1756] arm64: dts: rockchip: Correct Device Orientation on Gameforce Ace
Date: Wed, 18 Nov 2026 15:38:44 +0100
Message-ID: <20261118150016.230997661@linuxfoundation.org>
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
index b9a17108e1acd..b658e4892424b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
@@ -519,6 +519,7 @@ regulator-state-mem {
 &i2c3 {
 	status = "okay";
 
+	/* Touchscreen is rotated 90 degrees with 0,0 position near home button. */
 	touchscreen@14 {
 		compatible = "goodix,gt911";
 		reg = <0x14>;
@@ -528,10 +529,8 @@ touchscreen@14 {
 		pinctrl-0 = <&touch_int>, <&touch_rst>;
 		pinctrl-names = "default";
 		reset-gpios = <&gpio1 RK_PA7 GPIO_ACTIVE_HIGH>;
-		touchscreen-inverted-x;
 		touchscreen-size-x = <1080>;
 		touchscreen-size-y = <1920>;
-		touchscreen-swapped-x-y;
 	};
 };
 
@@ -563,11 +562,15 @@ channel@7 {
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



