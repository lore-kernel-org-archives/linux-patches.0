Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87AF1A76A5;
	Mon, 14 Oct 2024 15:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918659; cv=none; b=cg7mrccPU98Xw7nTyrRtW1h0vSbfqBENZy1nTzIBCzZQahcMvPav3JlhrUSaEIJRb61locQZ9AtqKiiobWEdgZgeoqUvpy7JntpceGIG+qIjo0phsLc5mDt5GmT5OFbKPDX9rgeavjQsHAC2Pafxmb0cdhg5VmcZ8oNIoUyrUCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918659; c=relaxed/simple;
	bh=8ZapBsKeR01TVej8YoI9BpfwDfaEiYXz8Y9Q2i+gZH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AX/hfWFlQSDa5ye/8I3axGRyTWlPW91YQi6ldOT7D+XpsMcp8iIH/8HZZhLbUGki+1aEEdCz0PXiXn9FsGoFlOhjFBcBCXd7Nf2EkSYzR+x9lt2aJUhTGij+y32B6z+LKJt8euxNvjwmQ24rjaOPqToJQltPUDLWAo5BinSF9QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=es9Kbqhb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="es9Kbqhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F08FC4CEC3;
	Mon, 14 Oct 2024 15:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918659;
	bh=8ZapBsKeR01TVej8YoI9BpfwDfaEiYXz8Y9Q2i+gZH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=es9KbqhbVyTcQ/gSou4CBftylxu1jDNB0Ohhok+wuh8kM+Il+Csy0lc/gnICO90j8
	 Bw/V8ILGp06EVQ8vTTBXk9Cavet1y1Y/nzdgx7cGi9KeQ+JKybmpAoBQaPtd5WwinE
	 CBB/s3gmKkVHzIwAM0CSodmdlYPu5uEzoOoCniy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 385/798] ieee802154: Fix build error
Date: Mon, 14 Oct 2024 16:15:39 +0200
Message-ID: <20241014141233.075355413@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit addf89774e48c992316449ffab4f29c2309ebefb ]

If REGMAP_SPI is m and IEEE802154_MCR20A is y,

	mcr20a.c:(.text+0x3ed6c5b): undefined reference to `__devm_regmap_init_spi'
	ld: mcr20a.c:(.text+0x3ed6cb5): undefined reference to `__devm_regmap_init_spi'

Select REGMAP_SPI for IEEE802154_MCR20A to fix it.

Fixes: 8c6ad9cc5157 ("ieee802154: Add NXP MCR20A IEEE 802.15.4 transceiver driver")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/20240909131740.1296608-1-ruanjinjie@huawei.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ieee802154/Kconfig b/drivers/net/ieee802154/Kconfig
index 95da876c56138..1075e24b11def 100644
--- a/drivers/net/ieee802154/Kconfig
+++ b/drivers/net/ieee802154/Kconfig
@@ -101,6 +101,7 @@ config IEEE802154_CA8210_DEBUGFS
 
 config IEEE802154_MCR20A
 	tristate "MCR20A transceiver driver"
+	select REGMAP_SPI
 	depends on IEEE802154_DRIVERS && MAC802154
 	depends on SPI
 	help
-- 
2.43.0



