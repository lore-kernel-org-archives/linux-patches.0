Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E451D0492;
	Tue, 15 Oct 2024 11:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993328; cv=none; b=dijPsqpB2fATpil9y5+L8nag67SGZl1dyRxeTC7ieO7ujLqDBrH4Z0eOgVWRsvkyr8UJftL+EHHQ9lGpz0Y+mAT7aITiqea/WiFuufJ4ume4dnbqs8uYvtsc/D6GTjHbvATRaz0vBJEfRn0eohBrNznRoP215cepuDBRMvQBfDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993328; c=relaxed/simple;
	bh=+FsSCouhuSLr5l11VIhnHYf405X+U6isQHq6dU8dTkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJp8wZ8q5bk+TNEMI/tah7CYIPmSYzsWRwfoITyG3gp1qlcSxfqVci1IsXHQHOBvATipkD13ryoz9wh6gk/sI/iRmRfK1qz/OS8oqLqIAeH9cQqs5hVmaRFmHUjPbJu378y629u34yd5MJZyFn3ECYcBZ5Zz9+QCT/T+sfpAbmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqSaAMgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqSaAMgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9002C4CEC6;
	Tue, 15 Oct 2024 11:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993328;
	bh=+FsSCouhuSLr5l11VIhnHYf405X+U6isQHq6dU8dTkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqSaAMgukPSzbMuJBqXO/3vpZjciPgsMg3538O6rCHyL4NTYwnhDAQxI6Of2rWsAB
	 Umd5S2d968d+l0/5XN2blRilZtje3OToVe4d1/1vpu0mIzFkSd9enUp9FGZyfLTgS7
	 DyKdUjDRjEILGdFQlT+PXI+xkH9RzWE4cXCFoAVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 377/691] ieee802154: Fix build error
Date: Tue, 15 Oct 2024 13:25:25 +0200
Message-ID: <20241015112455.309036856@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



