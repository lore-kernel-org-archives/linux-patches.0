Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822951EE02F;
	Tue, 30 Sep 2025 15:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244541; cv=none; b=RmzwUB8EybyRV/99bDywPPkCWQbSy5zidyDciVyGK8gDPbwav4mmQiHaPR9/jPD61Dsm4JbH8Q2UKbjVOIAqAYHy2ImHBD42SHGmuoruI83HcjqvVpE7MjlsIEKd5LBVKrUzBcLeQxDdDUdlOk/Ms18B0LndifZWIpWWWSS8WEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244541; c=relaxed/simple;
	bh=40DngJyD2tU/RUeGE8XcAssTtLNQyMf2K2z5WM4WBkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8YuXNwBBXHlTiYEubHl+F00RyzZhMdffR6wkEgLa6v40dm/aBNW9Zwy/fQJXnBZmtx5jy8tZ9UQRNz+Q7v5OU/33DoqRd5dTf4Ut5GnfxNqo2OrKDceB99NzHtl463nTlq0VC83oKe/dHFnNwSuIfuJ4jkxessp905N28Dh/O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvTD4Y2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvTD4Y2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68B9C113D0;
	Tue, 30 Sep 2025 15:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244541;
	bh=40DngJyD2tU/RUeGE8XcAssTtLNQyMf2K2z5WM4WBkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvTD4Y2yoW1YmCcNklRSuZwHOfMs6UMdp/AEdf7Gcn0Ng0Y+r33fVjfArlvfoaHQz
	 /RlnTEefxvr5sx/+8LoUB1NnwVmjrPllVxic5kKnqCalT+aZg2exiZOYaAGIqZzf/D
	 dVDoAO4wY8UWscx5Fa15+A8/ncjZ63utprKqb2/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Hon <honyuenkwun@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 038/143] arm64: dts: rockchip: Fix the headphone detection on the orangepi 5
Date: Tue, 30 Sep 2025 16:46:02 +0200
Message-ID: <20250930143832.758612322@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jimmy Hon <honyuenkwun@gmail.com>

[ Upstream commit 0f860eef417df93eb0ae70bbfa8d26cb7e29244d ]

The logic of the headphone detect pin seems to be inverted, with this
change headphones actually output sound when plugged in.

Does not need workaround of using pin-switches to enable output.

Verified by checking /sys/kernel/debug/gpio.

Fixes: ae46756faff8 ("arm64: dts: rockchip: analog audio on Orange Pi 5")
Signed-off-by: Jimmy Hon <honyuenkwun@gmail.com>
Link: https://lore.kernel.org/r/20250904030150.986042-1-honyuenkwun@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dtsi b/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dtsi
index 4fedc50cce8c8..11940c77f2bd0 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dtsi
@@ -42,9 +42,8 @@
 		simple-audio-card,bitclock-master = <&masterdai>;
 		simple-audio-card,format = "i2s";
 		simple-audio-card,frame-master = <&masterdai>;
-		simple-audio-card,hp-det-gpios = <&gpio1 RK_PD5 GPIO_ACTIVE_LOW>;
+		simple-audio-card,hp-det-gpios = <&gpio1 RK_PD5 GPIO_ACTIVE_HIGH>;
 		simple-audio-card,mclk-fs = <256>;
-		simple-audio-card,pin-switches = "Headphones";
 		simple-audio-card,routing =
 			"Headphones", "LOUT1",
 			"Headphones", "ROUT1",
-- 
2.51.0



