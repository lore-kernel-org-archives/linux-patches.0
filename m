Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BEE1BA860;
	Tue, 30 Jul 2024 15:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354944; cv=none; b=T2C7qabE213gdyjMEzyOENnuBNAD8KXz4hP+pljdfM7eaAeWvVpYkyI8IuWwNSjwe3d+u+zIyby4JKJnT8fs55udX+4hbNE8B30BQI4fVrRUvHTVbhoKyHwwjV1uayiI1XkDDifTJ5LBeQWKGrpecwSZpenKA/41TKV9q88xKSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354944; c=relaxed/simple;
	bh=J4JqU1wMzyPFNqJwUrP0ZiSSa31ZmMxdEiYj50JZ33Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWhLv8s3PPOznQ7DJKJ7RU2WpEAYXRtBB2ycKaSuzhiJZn5mRLKlHIxR1Bn5LnIxSJWbB3FR0+8LHObAgvMuyWYVsbIIk/hbIbLUe5elGKjKoK+tMuYjXyJ/8bqKimH19HqKmVjqaR8HBn30+clvOWZ+63LAY7mD4YK+LUA+h7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RonGP4O7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RonGP4O7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB98C32782;
	Tue, 30 Jul 2024 15:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354943;
	bh=J4JqU1wMzyPFNqJwUrP0ZiSSa31ZmMxdEiYj50JZ33Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RonGP4O7tIyvrcftVmhtVJQWRmqqBseNz64Nx2c0oDON4LpuEm8B4NGD56YzOzooq
	 P+PoQIJn0faZIo6sxC2KrxcDTsAYzJnubwc7B16tRAXTRKsG2Oj7UlcNTN3AadKu/y
	 7ImVWP/jhBlsfBdek9ohIm62rrUFY2kTRFEhJVhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/440] arm64: dts: rockchip: Add pinctrl for UART0 to rk3308-rock-pi-s
Date: Tue, 30 Jul 2024 17:44:33 +0200
Message-ID: <20240730151617.329579142@linuxfoundation.org>
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
index b9115c8828c72..a78e76c865e8e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
@@ -233,6 +233,8 @@ u2phy_otg: otg-port {
 };
 
 &uart0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart0_xfer>;
 	status = "okay";
 };
 
-- 
2.43.0



