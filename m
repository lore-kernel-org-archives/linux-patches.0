Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105AA19CCEC;
	Tue, 22 Jul 2025 14:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192868; cv=none; b=sGOaiW/rzKP6qWC30u9jBY4xG28PyMPQTmHhp/dYIlY/eK/QKzIfOYkDPCgO289211LfPwCLed3CF2w/VJwReygzaC6I1Ij8Hxm5wachkwrQn7YFL9rINXH+as10yw0cFCmZEEHvNJEUFxo+ysBrCzwnQXvxtsC6CATv9koOq2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192868; c=relaxed/simple;
	bh=kRqYDGvsherRfBFnSvJPERkdvpC/VWkBVBzprUmLZCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZU4zMmPiQXv4Ex6N/811NsVeAFVuXnuHK3qVl9pS/QeS9cewY31X7HZgZDltGci7rVnrozZu0hs/dpGf+C407zZOVsOOardHzlzi8Q0hJNjKmXavydBYrAEeCcrf4Ea3Fuo48sL3+PS/sD7JSKs4F2aLsETa0IjHDKml3k/2ftA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2+Ai+Qu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2+Ai+Qu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4B5C4CEEB;
	Tue, 22 Jul 2025 14:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192867;
	bh=kRqYDGvsherRfBFnSvJPERkdvpC/VWkBVBzprUmLZCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2+Ai+Qu93jSA7iRn+lPT52QFUk+Oau4gZhbGk/aDj0JUx9lzNYe7OK1s3DC+t8BY
	 FAxFAXVkZAoh6DyCYzTgeKDHReUl88oN6xWD5549J5mCy4okZbLt46x+99JB7HpTeh
	 ntrAarpZPHc1e9YZG6HuRma0ecgWA8VEBwr26PBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andyshrk@163.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/158] arm64: dts: rockchip: Add cd-gpios for sdcard detect on Cool Pi CM5
Date: Tue, 22 Jul 2025 15:44:26 +0200
Message-ID: <20250722134343.835759308@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andyshrk@163.com>

[ Upstream commit e625e284172d235be5cd906a98c6c91c365bb9b1 ]

cd-gpios is used for sdcard detects for sdmmc.

Fixes: 791c154c3982 ("arm64: dts: rockchip: Add support for rk3588 based board Cool Pi CM5 EVB")
Signed-off-by: Andy Yan <andyshrk@163.com>
Link: https://lore.kernel.org/r/20250524064223.5741-1-andyshrk@163.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5.dtsi
index fde8b228f2c7c..5825141d20076 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5.dtsi
@@ -317,6 +317,7 @@
 	bus-width = <4>;
 	cap-mmc-highspeed;
 	cap-sd-highspeed;
+	cd-gpios = <&gpio0 RK_PA4 GPIO_ACTIVE_LOW>;
 	disable-wp;
 	max-frequency = <150000000>;
 	no-sdio;
-- 
2.39.5



