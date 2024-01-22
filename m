Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AC764AA7;
	Tue, 23 Jan 2024 01:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975041; cv=none; b=AQTVAgAgISy18tYl8u56FG6L8YomU8JbXRXdW8UYT0Jejmtvfyq8+IfWl3MrZlLukrz2mTyoIG09KoVCF0DEjmoH+I7LyUKE2P0jD1VYQ1whnMwuzxVGmHErlMs5AaFkgn6pSom8fzj6N7Z4KgnG0w0oO3ES1TkOqPL0NZa3bW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975041; c=relaxed/simple;
	bh=OZRHMFFn5fqDOuDGytNI52TjZk22rvOOJQM/CFNOXSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cw0uGvkzEG5QU/brbbCm6U7UtTU4Syw3E65nUInlIsIzwI0DovFSj6Jep5BcpBY+LBb8RwAftTd849GqeejUnmcMb672K5DKf9S7VK1ZkeeNVivBawJ8WJm1ckb00COyfAmLzBGHsk5/6c/GmOaO8HHooISC+6vuSsr44tapZqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+sZWQGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+sZWQGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9927BC43394;
	Tue, 23 Jan 2024 01:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975041;
	bh=OZRHMFFn5fqDOuDGytNI52TjZk22rvOOJQM/CFNOXSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+sZWQGfIIYuB5U8oyHCrjQT8k/pKMSrKhF4llg3IuDgjNRgeb91Q27dhDugim3v/
	 cLw6Z+frz4jVYKVl7Ze6aH4VDI4Ua/vNRflF+4ttsUqmuKs8i25h+ZhhEnZaRwxVo1
	 ZgvBIkQTH+dZK0+5waHC7eVcE2wA8MGvMFs1zmdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Ning <zhangn1985@outlook.com>,
	Andy Yan <andyshrk@163.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 209/583] arm64: dts: rockchip: Fix led pinctrl of lubancat 1
Date: Mon, 22 Jan 2024 15:54:20 -0800
Message-ID: <20240122235818.402045259@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andyshrk@163.com>

[ Upstream commit 8586a5d217ef7bfeee24943c600a8a7890d6f477 ]

According to the schematics, the gpio control sys_led is GPIO0_C5.

Fixes: 8d94da58de53 ("arm64: dts: rockchip: Add EmbedFire LubanCat 1")
Reported-by: Zhang Ning <zhangn1985@outlook.com>
Closes: https://lore.kernel.org/linux-rockchip/OS0P286MB06412D049D8BF7B063D41350CD95A@OS0P286MB0641.JPNP286.PROD.OUTLOOK.COM/T/#u
Signed-off-by: Andy Yan <andyshrk@163.com>
Link: https://lore.kernel.org/r/20231225005055.3102743-1-andyshrk@163.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts b/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
index 1c6d83b47cd2..6ecdf5d28339 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
@@ -455,7 +455,7 @@ &pcie2x1 {
 &pinctrl {
 	leds {
 		sys_led_pin: sys-status-led-pin {
-			rockchip,pins = <0 RK_PC7 RK_FUNC_GPIO &pcfg_pull_none>;
+			rockchip,pins = <0 RK_PC5 RK_FUNC_GPIO &pcfg_pull_none>;
 		};
 	};
 
-- 
2.43.0



