Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E5E1BA872;
	Tue, 30 Jul 2024 15:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354937; cv=none; b=TtV4nJUBjyBsW68OT27aw7KOF2nRzn+isYbSt6HkKh8Bh9JoTDNPZEdo6yc4l4PT5u5E2ImffDBRRCSctNMNTAToC2RZKymOeX4p4m3+kn3T+cTaHe9jbWzjF2vRTqHVnL8fWiSQeClXf9L9gPwGP51K6HSc2HhtJb8xdNElwos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354937; c=relaxed/simple;
	bh=CWxg65K4eu+nyeTuO71zadU6xED+xoCdHtU7PYdz5B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UT1aJhdPyylw3+/xLwKzgxgJJjy1LlSZ9LIW1Y6gx8jFKhygvtuvoHv6WCZ+aLrtk/ZwRU2MmiNSwIZ/cGwMr8Mp9HUHx7tS0MhVHWfnWkAm3FSQpfxcLJjYuN67Xf4X4gcwVCSKHKJC/6mo8HjX7mkcHueXFNBfueqftxoHb94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WqwsW4a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WqwsW4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209B4C4AF0A;
	Tue, 30 Jul 2024 15:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354937;
	bh=CWxg65K4eu+nyeTuO71zadU6xED+xoCdHtU7PYdz5B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2WqwsW4a/XI/SYWBfWeGcdZjzyg3zHk+zztTbYa3WkDq9LfROGtjMcGAcsoUA0UW7
	 dKesFuzWua/dWkH2UWz1XGGjk2qEduZktGfTVLMt7ERks+1F/ZVkTAV5C5HvRJeu2A
	 0R6yePtL/U0JlFWgf0TSn3CaMQKYeMArcrZdjp2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/440] arm64: dts: rockchip: Add sdmmc related properties on rk3308-rock-pi-s
Date: Tue, 30 Jul 2024 17:44:32 +0200
Message-ID: <20240730151617.289919881@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit fc0daeccc384233eadfa9d5ddbd00159653c6bdc ]

Add cap-mmc-highspeed to allow use of high speed MMC mode using an eMMC
to uSD board. Use disable-wp to signal that no physical write-protect
line is present. Also add vcc_io used for card and IO line power as
vmmc-supply.

Fixes: 2e04c25b1320 ("arm64: dts: rockchip: add ROCK Pi S DTS support")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240521211029.1236094-5-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
index edc8d2e3980d0..b9115c8828c72 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
@@ -211,7 +211,10 @@ &sdio {
 };
 
 &sdmmc {
+	cap-mmc-highspeed;
 	cap-sd-highspeed;
+	disable-wp;
+	vmmc-supply = <&vcc_io>;
 	status = "okay";
 };
 
-- 
2.43.0



