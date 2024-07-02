Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5381A1BE863;
	Tue,  2 Jul 2024 17:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940623; cv=none; b=W9JwXRRmcTyinfOrsA7GTLAUehURiJm5n7D3M8lowyr541TPovBJGqzQsE855jT4bTUnl8XIJ2u4ns/L+oLs/xWtiobr2nxRsgPWIt4jpsTsLkbt0K9yU2k8Xp4DsrUxVZ4vqV43PHdF3wjQhcIZZX8xhjI535puimJSkn5IrUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940623; c=relaxed/simple;
	bh=GRWCGHfGcLqgJNHYMjlJ8XTDwfFoDY5XDT436N3d4Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WthEjVCPGoEBLRd3LeRH3ddzpIeXT3nAyV5UFLG/zvyy+FiNYaisC9B3U32GYQSEK3kvVu/0IIPIYysdzNrakbH+/CSrBAVk2vQ78O6hRIFELmHD/WEuzU1WPMU4+dhK+2jE0MmuyVo8t0oy7ZTG5/Pyevq4CEzO0Ux4UqZUW4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfhzdFQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfhzdFQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85F1C116B1;
	Tue,  2 Jul 2024 17:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940623;
	bh=GRWCGHfGcLqgJNHYMjlJ8XTDwfFoDY5XDT436N3d4Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfhzdFQk8dZGsf4et55RL4kwnE5x09Ex2J92u14D5RFgrt7oIhuGit7h1l9AGPiIa
	 gECPLSyx9fy7KJNg/7M0alGBZK3TCclhdDqlhUnV04iB6t+A2NPSaacEJYBuY7eRiy
	 AMqKCddbrbHWfMU/c9lTd5YmRjGjpO2WVdNrMul0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 210/222] Revert "arm64: dts: rockchip: remove redundant cd-gpios from rk3588 sdmmc nodes"
Date: Tue,  2 Jul 2024 19:04:08 +0200
Message-ID: <20240702170252.013473845@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUKAUMI Naoki <naoki@radxa.com>

[ Upstream commit b56aed4a613e2d2cb3bfe05fd222dbf480f6b5d8 ]

This reverts commit d859ad305ed19d9a77d8c8ecd22459b73da36ba6.

Inserting and removing microSD card is not detected since above commit.
Reverting it fixes this problem.

This is probably the same thing as 5 years ago on rk3399
https://lore.kernel.org/all/0608599d485117a9d99f5fb274fbb1b55f6ba9f7.1547466003.git.robin.murphy@arm.com/

So we'll go back to cd-gpios for now.

this patch is tested on Radxa ROCK 5A and 5B.

Fixes: d859ad305ed1 ("arm64: dts: rockchip: remove redundant cd-gpios from rk3588 sdmmc nodes")
Signed-off-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://lore.kernel.org/r/20240613001757.1350-1-naoki@radxa.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-plus.dts | 1 +
 arch/arm64/boot/dts/rockchip/rk3588-quartzpro64.dts     | 1 +
 arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts         | 1 +
 arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts        | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-plus.dts b/arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-plus.dts
index 1a604429fb266..e74871491ef56 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-plus.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-plus.dts
@@ -444,6 +444,7 @@
 &sdmmc {
 	bus-width = <4>;
 	cap-sd-highspeed;
+	cd-gpios = <&gpio0 RK_PA4 GPIO_ACTIVE_LOW>;
 	disable-wp;
 	max-frequency = <150000000>;
 	no-sdio;
diff --git a/arch/arm64/boot/dts/rockchip/rk3588-quartzpro64.dts b/arch/arm64/boot/dts/rockchip/rk3588-quartzpro64.dts
index 22bbfbe729c11..b6628889b707e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-quartzpro64.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588-quartzpro64.dts
@@ -429,6 +429,7 @@
 &sdmmc {
 	bus-width = <4>;
 	cap-sd-highspeed;
+	cd-gpios = <&gpio0 RK_PA4 GPIO_ACTIVE_LOW>;
 	disable-wp;
 	max-frequency = <150000000>;
 	no-sdio;
diff --git a/arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts b/arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts
index 1fe8b2a0ed75e..9b7bf6cec8bd1 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts
@@ -378,6 +378,7 @@
 	bus-width = <4>;
 	cap-mmc-highspeed;
 	cap-sd-highspeed;
+	cd-gpios = <&gpio0 RK_PA4 GPIO_ACTIVE_LOW>;
 	disable-wp;
 	sd-uhs-sdr104;
 	vmmc-supply = <&vcc_3v3_s3>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts b/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
index 00afb90d4eb10..2002fd0221fa3 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
@@ -366,6 +366,7 @@
 	bus-width = <4>;
 	cap-mmc-highspeed;
 	cap-sd-highspeed;
+	cd-gpios = <&gpio0 RK_PA4 GPIO_ACTIVE_LOW>;
 	disable-wp;
 	max-frequency = <150000000>;
 	no-sdio;
-- 
2.43.0



