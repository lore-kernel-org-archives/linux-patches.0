Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DA322EE4D;
	Tue, 12 Nov 2024 10:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407954; cv=none; b=Ix0dMA5OgH+2mCLEPgKGomjJnU3ZHIHOZKKUr62jr0t3uNbCoL75VCDeauTgJFPOppgP+4BlkDKcX0iWrKMKzDggzaZEKJYYLjOmUTZBLvnjOT881PwwPQtfTqzsgWgpcSdCz6hs+v1yL95+CzeA96TLLr8N62ytSFgmotnWFrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407954; c=relaxed/simple;
	bh=vBTXFZasStnp8oMaJ3RH4Kf1xYD/G8xYge1d01WPv8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0/+czVJds9mEfr/56uXOpYROJqYWN1mMGVPOGGepJmC0aHRLi78Une+myrmun+XcfYxgmGWs7eygcx/H3goD067tZerokyN2MLvAD59avAIvlLyhE6pd/kBjHjkhsc7erETSHs2gLXYSexGytJFIdr+3/pEXVCkplkVai6kHW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eaUGjhyu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eaUGjhyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD395C4CECD;
	Tue, 12 Nov 2024 10:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407954;
	bh=vBTXFZasStnp8oMaJ3RH4Kf1xYD/G8xYge1d01WPv8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eaUGjhyutBZBrSHiPgJD81K+ze/FwXUB2l86xO6oTB1Q5RVWepMz0W8zkCrU6jZ7J
	 t7HZCbzQWvb487QnR4sbY96tWH3qhgTnXIHwp5jVuDcpxKplzugjWUuk0ZwJ6k25SG
	 okrGd5kcuOw4TMEBXA7xm2S49f/vyb8X4rfcB/u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bostandzhyan <jin@mediatomb.cc>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 015/184] arm64: dts: rockchip: Add DTS for FriendlyARM NanoPi R2S Plus
Date: Tue, 12 Nov 2024 11:19:33 +0100
Message-ID: <20241112101901.455449916@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Bostandzhyan <jin@mediatomb.cc>

[ Upstream commit b8c02878292200ebb5b4a8cfc9dbf227327908bd ]

The R2S Plus is basically an R2S with additional eMMC.

The eMMC configuration for the DTS has been extracted and copied from
rk3328-nanopi-r2.dts, v2017.09 branch from the friendlyarm/uboot-rockchip
repository.

Signed-off-by: Sergey Bostandzhyan <jin@mediatomb.cc>
Link: https://lore.kernel.org/r/20240814170048.23816-2-jin@mediatomb.cc
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: 1b670212ee3d ("arm64: dts: rockchip: Remove undocumented supports-emmc property")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/Makefile         |  1 +
 .../dts/rockchip/rk3328-nanopi-r2s-plus.dts   | 32 +++++++++++++++++++
 2 files changed, 33 insertions(+)
 create mode 100644 arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s-plus.dts

diff --git a/arch/arm64/boot/dts/rockchip/Makefile b/arch/arm64/boot/dts/rockchip/Makefile
index fda1b980eb4bc..36258dc8dafd5 100644
--- a/arch/arm64/boot/dts/rockchip/Makefile
+++ b/arch/arm64/boot/dts/rockchip/Makefile
@@ -20,6 +20,7 @@ dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3328-evb.dtb
 dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3328-nanopi-r2c.dtb
 dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3328-nanopi-r2c-plus.dtb
 dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3328-nanopi-r2s.dtb
+dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3328-nanopi-r2s-plus.dtb
 dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3328-orangepi-r1-plus.dtb
 dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3328-orangepi-r1-plus-lts.dtb
 dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3328-rock64.dtb
diff --git a/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s-plus.dts b/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s-plus.dts
new file mode 100644
index 0000000000000..cb81ba3f23ffd
--- /dev/null
+++ b/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s-plus.dts
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
+/*
+ * (C) Copyright 2018 FriendlyElec Computer Tech. Co., Ltd.
+ * (http://www.friendlyarm.com)
+ *
+ * (C) Copyright 2016 Rockchip Electronics Co., Ltd
+ */
+
+/dts-v1/;
+#include "rk3328-nanopi-r2s.dts"
+
+/ {
+	compatible = "friendlyarm,nanopi-r2s-plus", "rockchip,rk3328";
+	model = "FriendlyElec NanoPi R2S Plus";
+
+	aliases {
+		mmc1 = &emmc;
+	};
+};
+
+&emmc {
+	bus-width = <8>;
+	cap-mmc-highspeed;
+	disable-wp;
+	mmc-hs200-1_8v;
+	non-removable;
+	num-slots = <1>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&emmc_clk &emmc_cmd &emmc_bus8>;
+	supports-emmc;
+	status = "okay";
+};
-- 
2.43.0



