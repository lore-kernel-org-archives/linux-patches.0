Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B86A2585
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81948C433D2;
	Mon, 12 Dec 2022 13:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670850783;
	bh=gJTDziNBG3S2B64bwHnchA39yNEuc6c3h0DbT86GhBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2XhlM/CmHZnV/od/y6puxlvpsiBtVk87v0Jp3I+vgMz9IVHGsg9TDU9w4CkC/gsFS
	 ztUwga1II4+uKtAjhgAqLVyFWIfE1ftNMQ3X3ad/4XKu6upay4sR2CZypRpi7Nnp4L
	 burqF9tNmtHtxYmz+qk+a0M8UYrYiAhAJ+U9/5lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/106] arm64: dts: rockchip: keep I2S1 disabled for GPIO function on ROCK Pi 4 series
Date: Mon, 12 Dec 2022 14:09:11 +0100
Message-Id: <20221212130925.242809208@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: FUKAUMI Naoki <naoki@radxa.com>

[ Upstream commit 849c19d14940b87332d5d59c7fc581d73f2099fd ]

I2S1 pins are exposed on 40-pin header on Radxa ROCK Pi 4 series.
their default function is GPIO, so I2S1 need to be disabled.

Signed-off-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://lore.kernel.org/r/20220924112812.1219-1-naoki@radxa.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
index f121203081b9..64df64339119 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
@@ -448,7 +448,6 @@
 &i2s1 {
 	rockchip,playback-channels = <2>;
 	rockchip,capture-channels = <2>;
-	status = "okay";
 };
 
 &i2s2 {
-- 
2.35.1



