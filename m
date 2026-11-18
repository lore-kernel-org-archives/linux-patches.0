Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032523;
	b=2K4K/wZ3j5xkO7oZcxsGwOZXXTKy/PEInQqBmHWheZ226QtNSnY6bK7VyXPwEWGWfgp5
	 9F2HYY3kLuKeJERD2v3Fu/6oyyWWzfBtw74xOcDu68CCdCdRaOzNYPrZ+D9INrxF7Y0Qu
	 egggKstSl+BUH62xDrNtCiPtqiWl2AlhfdMqXatkWXkiCLd2gi1TJWDgJp+uqCUyknx1Y
	 5bwxqsnQV6HaYkJDLpBMZFwzL6wb9DvX8w694rzX63tP3Z4h4O10XH2zQKSmGiUf4nm6N
	 8U+eSvFuiv/owGm3oo/tmMUNzXRuGL+/AOttbLc2NRkhLHJAqYINJQN/uwTLW2AkZ5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FI47YugF1w5L7VzibUPpTP6oihQUYrsuWg+KldGonVk=;
	b=0l9gVOg3XkYcdDsW/9KzBdpf8zOiv/uQOhhWlLOgod0oLhAP/49eOyjtTgobTBCAkWtt
	 3vdg7/JpLINEiQ6Ly3hV45FiGhoXGBjW67XClcK/oCr1j84DwSXOsl4k7e7H3vh6IE72e
	 FffRmHK6vkcBm16dz6DuCWDK2gZYpiXtUkZaGJe57aVesff6WJEGKDyuYTHkRF5Dj5D6s
	 kPxV6q9SkTuteOR5sLHougBm67wzHxqqIAjdszcVqn0AFquHYkSOfijaJC6og9ooyBudH
	 XDDyVPgB36EGhrTNCNhbOILliuuWGlfMNjLqhts4F6gZuX+qkf/faCuOgPsjnP+zLaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c0cRsWGH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA277606A320;
	Wed, 18 Nov 2026 20:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c0cRsWGH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5A11F000C4;
	Wed, 18 Nov 2026 20:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032523;
	bh=FI47YugF1w5L7VzibUPpTP6oihQUYrsuWg+KldGonVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0cRsWGHWtwIp4eEc220xYGkdp2PlCZTe2PqaGNYDGGVYVFXgbm1oYZg25wkFlbJ6
	 ZQodM6O3FpN1cVh0xOTdcM3uHugCEBseFSaRnRHeQsUYReVERWhWmubT/XZDZeKUcM
	 p8IImPgPVZmmtAbg9PzgK3tk1Zn60Mjf95zw3lOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1442/1756] net: phy: move realtek PHY driver to its own subdirectory
Date: Wed, 18 Nov 2026 15:59:29 +0100
Message-ID: <20261118150106.543958620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 1416a9b2ba710d31954131c06d46f298e340aa2c ]

In preparation of adding a source file with hwmon support, move the
Realtek PHY driver to its own subdirectory and rename realtek.c to
realtek_main.c.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/c566551b-c915-4e34-9b33-129a6ddd6e4c@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 20c0c6773624 ("net: phy: realtek: restore RTL8211F RGMII delays on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/Kconfig                               | 5 +----
 drivers/net/phy/Makefile                              | 2 +-
 drivers/net/phy/realtek/Kconfig                       | 5 +++++
 drivers/net/phy/realtek/Makefile                      | 3 +++
 drivers/net/phy/{realtek.c => realtek/realtek_main.c} | 0
 5 files changed, 10 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/phy/realtek/Kconfig
 create mode 100644 drivers/net/phy/realtek/Makefile
 rename drivers/net/phy/{realtek.c => realtek/realtek_main.c} (100%)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 4e78a4d8fd2a7..f7e21a2761b8f 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -343,10 +343,7 @@ config QSEMI_PHY
 	help
 	  Currently supports the qs6612
 
-config REALTEK_PHY
-	tristate "Realtek PHYs"
-	help
-	  Supports the Realtek 821x PHY.
+source "drivers/net/phy/realtek/Kconfig"
 
 config RENESAS_PHY
 	tristate "Renesas PHYs"
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index e6145153e837f..a38b01f74db7e 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -94,7 +94,7 @@ obj-$(CONFIG_NXP_CBTX_PHY)	+= nxp-cbtx.o
 obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
 obj-y				+= qcom/
 obj-$(CONFIG_QSEMI_PHY)		+= qsemi.o
-obj-$(CONFIG_REALTEK_PHY)	+= realtek.o
+obj-$(CONFIG_REALTEK_PHY)	+= realtek/
 obj-$(CONFIG_RENESAS_PHY)	+= uPD60620.o
 obj-$(CONFIG_ROCKCHIP_PHY)	+= rockchip.o
 obj-$(CONFIG_SMSC_PHY)		+= smsc.o
diff --git a/drivers/net/phy/realtek/Kconfig b/drivers/net/phy/realtek/Kconfig
new file mode 100644
index 0000000000000..5b9e6e6db834b
--- /dev/null
+++ b/drivers/net/phy/realtek/Kconfig
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config REALTEK_PHY
+	tristate "Realtek PHYs"
+	help
+	  Currently supports RTL821x/RTL822x and fast ethernet PHYs
diff --git a/drivers/net/phy/realtek/Makefile b/drivers/net/phy/realtek/Makefile
new file mode 100644
index 0000000000000..996a80642431e
--- /dev/null
+++ b/drivers/net/phy/realtek/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+realtek-y			+= realtek_main.o
+obj-$(CONFIG_REALTEK_PHY)	+= realtek.o
diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek/realtek_main.c
similarity index 100%
rename from drivers/net/phy/realtek.c
rename to drivers/net/phy/realtek/realtek_main.c
-- 
2.53.0



