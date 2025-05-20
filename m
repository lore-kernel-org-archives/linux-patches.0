Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E58624C077;
	Tue, 20 May 2025 14:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750457; cv=none; b=PihoLnwLloE3qeo911xTsIv4Q5hCZEQWQeLeWj5NrsTK3g7JbSa//DPCqgsklk4iAC/M33xw1hKTfc3yrr7/CFmRmKiVfNtcS2X4qe6PsbutUeS/zXzKi9AxBEYwU4RYxU931IpkLRFS8KZJybAlga5eMAh3TziRoZq0sjCXpRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750457; c=relaxed/simple;
	bh=TwjmdUuWXarLyZvJ5eSSO4LeWW6//UFLjXzY0wpQfi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJ5krO++yinD8VnBCxz1EGhb7yKAkY93iQeJvuH/TMdR/ICFhWvjaQMX/kxGu+3pmCe7MigZsqPh2W7r40Rlyr6J/PMDATMZAvjLZYQsbyHpCmmS0h1l/IMmrDfARfg+i6dtp7HTYBOYnGrIQvFLagm//xT+7hSTqzg7fCHwm7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b821RwOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b821RwOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B6EC4CEEA;
	Tue, 20 May 2025 14:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750457;
	bh=TwjmdUuWXarLyZvJ5eSSO4LeWW6//UFLjXzY0wpQfi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b821RwOtw0ZtPy3PUAD/x/fTJumECmAiFAHUeyGgLVa77/RdgAdXmVpZ36NtAzThU
	 bemNiQkOpCz6tuafQZJUXyGOPfVTsjR3/L2fidLeAa/XnM2YdogjIUg8AxKPqHPoVM
	 h+lfzs3FJDS1y3KYfo1TR99M3mwhv0uXC8wSit4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 007/145] arm64: dts: rockchip: fix Sige5 RTC interrupt pin
Date: Tue, 20 May 2025 15:49:37 +0200
Message-ID: <20250520125810.835791359@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit 4bf593be2e462623c4c34c7e3b604eb3f8f9de45 ]

Someone made a typo when they added the RTC to the Sige5 DTS, which
resulted in it using interrupts from GPIO0 B0 instead of GPIO0 A0. The
pinctrl entry for it wasn't typoed though, curiously enough.

The Sige5 v1.1 schematic was used to verify that GPIO0 A0 is the correct
pin for the RTC wakeup interrupt, so let's change it to that.

Fixes: 40f742b07ab2 ("arm64: dts: rockchip: Add rk3576-armsom-sige5 board")
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Link: https://lore.kernel.org/r/20250429-sige5-rtc-oopsie-v1-1-8686767d0f1f@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3576-armsom-sige5.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3576-armsom-sige5.dts b/arch/arm64/boot/dts/rockchip/rk3576-armsom-sige5.dts
index a9b9db31d2a3e..bab66b688e011 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576-armsom-sige5.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3576-armsom-sige5.dts
@@ -578,7 +578,7 @@
 		reg = <0x51>;
 		clock-output-names = "hym8563";
 		interrupt-parent = <&gpio0>;
-		interrupts = <RK_PB0 IRQ_TYPE_LEVEL_LOW>;
+		interrupts = <RK_PA0 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&hym8563_int>;
 		wakeup-source;
-- 
2.39.5



