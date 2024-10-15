Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CAB1DFD8;
	Tue, 15 Oct 2024 13:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997787; cv=none; b=qmJFDaT8w6LptEqoDAtHHKzz4eh4BjlnebJgcwKyrymbLFVukcqFm3k5izioOWaB4wjvcCFdOlY2FB6e9IMi+/Mmv6InuP9kZu5zqHipZ01kapFNFLn+1jK7sygAhLdlDAFgTgOd5x3393i6K7/L4u8cVxs9OWQl85PSPnQihS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997787; c=relaxed/simple;
	bh=rl+4+oI1vJFF+ZE7e/jWBdrZN4bD1Alc6zqirAHFhO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ynpr0epvx2t1KahPAuWwnPFpb4K9tJhUrUv7YibFe1HUdragw/WzzJI79WFn9R63ml/xL9FNB9v4MhIlAXhWwF+AbkiomzSIOX1VXnrx/hct10Uks8w816e/NXmjMxNpUUQFxuZ15L9xKBOF5uqgnfoCZrBoGGVQdYMmPeZa1Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogpOtNAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogpOtNAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75D0C4CEC6;
	Tue, 15 Oct 2024 13:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997787;
	bh=rl+4+oI1vJFF+ZE7e/jWBdrZN4bD1Alc6zqirAHFhO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogpOtNApLn9rgloLn0nkbMwS0IXN2O1Kq4fKNPlFlh/ebLxnt7jmN2wwm+ZWWXScY
	 GE9JN5kSnGfiSkST74LXDuC1M09IKlM9LsXJTmrKhWfDF06NchdWnBfh/dvLmUhRvj
	 322Hw2/waRvEsuFeFGwQ/PEQw7z4pX/DsiL+VVT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 269/518] ieee802154: Fix build error
Date: Tue, 15 Oct 2024 14:42:53 +0200
Message-ID: <20241015123927.376571908@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0f7c6dc2ed154..26f393a0507c1 100644
--- a/drivers/net/ieee802154/Kconfig
+++ b/drivers/net/ieee802154/Kconfig
@@ -108,6 +108,7 @@ config IEEE802154_CA8210_DEBUGFS
 
 config IEEE802154_MCR20A
 	tristate "MCR20A transceiver driver"
+	select REGMAP_SPI
 	depends on IEEE802154_DRIVERS && MAC802154
 	depends on SPI
 	help
-- 
2.43.0



