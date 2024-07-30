Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A32187FF6;
	Tue, 30 Jul 2024 16:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355479; cv=none; b=ldihNIsTYcjOzHV/k1Gg1TncVE1/Zh8Pz3PyB5AP2XIGnlwIRCdwxGVZ+wkvIXQRHypm7i2bvhskh7IUTFGf+tE2ajZVTk1Ok2DBsKabUIjp8wmLbEqIx5oZshAs8UkObljstMveamFY/0HBId8WP+uXQj/qb1VV+hiP09eoUrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355479; c=relaxed/simple;
	bh=frVpXnU3YNP6lwrMP2O/jjSaBvgBLkzKiaI1tBN47ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xnk1HfpXV0DzHsmZRxqi08Jc0U/qGcA1siQF0FezrlIPbsrTzSU8twyiljZ6Q44QorPZXdbpS7rHBj6SzrHF6W/DmwwVSV38CzAa5IeucEU0zWSVknidI9UykbZg1qvfXjWm21bo1HPRFHNtna+/721EWVFZTqAd7EbfC7WXGlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WijdtRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WijdtRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BF1C4AF0F;
	Tue, 30 Jul 2024 16:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355479;
	bh=frVpXnU3YNP6lwrMP2O/jjSaBvgBLkzKiaI1tBN47ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2WijdtRaJoNzPHM4IGKiTBOpgdFOSTz4NORilgdmazSINw8JE6rNQTY3IPZJwMLsJ
	 guYLuc7n32gqjciibD2qgwfW7233nyknl/C5iLjybCmz+ws5SfUNk6B4uEGzE6WN42
	 mBRrTtXq0bzV0yfVMST2JWfsbBVItOMJDUNaUXrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 059/809] arm64: dts: rockchip: Add pinctrl for UART0 to rk3308-rock-pi-s
Date: Tue, 30 Jul 2024 17:38:55 +0200
Message-ID: <20240730151726.975559723@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 7affb86ef62581e3475ce3e0a7640da1f2ee29f8 ]

UAR0 CTS/RTS is not wired to any pin and is not used for the default
serial console use of UART0 on ROCK Pi S.

Override the SoC defined pinctrl props to limit configuration of the
two xfer pins wired to one of the GPIO pin headers.

Fixes: 2e04c25b1320 ("arm64: dts: rockchip: add ROCK Pi S DTS support")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240521211029.1236094-6-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
index 8ea9849064032..d4cf6026241c4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
@@ -294,6 +294,8 @@ u2phy_otg: otg-port {
 };
 
 &uart0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart0_xfer>;
 	status = "okay";
 };
 
-- 
2.43.0



