Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C131C1C5793;
	Tue,  8 Oct 2024 13:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392958; cv=none; b=uKRyjkE7xwhGhaoVe5KMFfYOBc5MUfJp0X85KC+/iUcWbhMsnyTLGtuXu3yThLD4DYO/YIIvDgrDn1n4UIGfcFmosCusAAkFEOtxt5BmKeyy88rekRhxWNzD0jzv4oqn3ffKxpA5FhFhTTjMZRG1z2iOyTS8kmpITe+s+bllG2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392958; c=relaxed/simple;
	bh=IqXJoz35b3W+PJILpSwC/UPM7K/1mGFNodYm8tQPpxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNyrPli/fIDdc/sMvCiY5T81H2FICAiCaokY/tqp4/rstjzGaY1PcD9dE82G0gmFfk35lhAVkXtcdQaAS1umUBu6JKJ0OjapidXhyQS2/vMOMaqYZQ2DpbjmxegS9Wlc8wMNzRuhHxItNGowvJFyivlCqzNbg68Wv6eS6uUguuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3zgraC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3zgraC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB580C4CECC;
	Tue,  8 Oct 2024 13:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392958;
	bh=IqXJoz35b3W+PJILpSwC/UPM7K/1mGFNodYm8tQPpxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3zgraC9ckYuxWMMHlivpqtEgS/bU+90+LPSx35nD9uSp5ZXDkNTbeHG1/STs9ILe
	 3rqfgd6QyBR3iZoCoQVPXpP1hLCTlTC0hKfRHGZTAS1+/8EkB5WBkBt5a2zcBNgSrr
	 HCM8nKrJlyc4pOF9AYrOpaNuD/QJjXevDmFbs8nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/386] ieee802154: Fix build error
Date: Tue,  8 Oct 2024 14:04:16 +0200
Message-ID: <20241008115629.765697491@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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



