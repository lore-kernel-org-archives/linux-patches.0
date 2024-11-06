Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A671F8933;
	Wed,  6 Nov 2024 13:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898263; cv=none; b=qRMuaycQjcfGnzwq9dAohiRBXB7B5oNEJ6ORL3l/87GIUjLUOzPI0mF0RW1XqLzdR/EK8bG5ECPsFR8LmLoBMFVJBZblImUOJCFG5/lnz/1QuHl/uxxLcycJ6PbVl03oRnbAGhcjYGLu8vfOnpCthHZztJW71RMiHZeW2lZBJps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898263; c=relaxed/simple;
	bh=MC0qkEvnYK8aR3K2vexzhtHFWUhei6FqfVNRNCdhex8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLzHgcqplcF4Qq4nhzW74+i/giTDZjIpwhaXZ832HaW/1uEXaB6gC5Nb6Z/KDhhOhcC9NrqKH5v+jw/DM2zF+PzqJF+bcQiMhjpGpnfZ0s4hVZwe7SAuaIkpPyteHXE5bAxB06xmw5RM3nWCo6h8G/YKFjGfif0r370ro6zDm1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tblcaEsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tblcaEsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10084C4CECD;
	Wed,  6 Nov 2024 13:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898263;
	bh=MC0qkEvnYK8aR3K2vexzhtHFWUhei6FqfVNRNCdhex8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tblcaEsD7Ooiqk/iMtomuuE4TVq32dXzucjLtvxWJvASTVHc88VfRHvrfuxYdu3lH
	 Uo5Fg3fCp5hIwT4Bni8rjyV9V1HL26jcT6GBMUJt/AUZI//hgGnK6/CGEJR298s9o4
	 GSjZqivkYTMyWe5+8WvUZ/GdKB7XMisEohby9zHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 178/462] ieee802154: Fix build error
Date: Wed,  6 Nov 2024 13:01:11 +0100
Message-ID: <20241106120335.915120766@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c92a62dbf3982..6d1c83fe3e976 100644
--- a/drivers/net/ieee802154/Kconfig
+++ b/drivers/net/ieee802154/Kconfig
@@ -108,6 +108,7 @@ config IEEE802154_CA8210_DEBUGFS
 
 config IEEE802154_MCR20A
 	tristate "MCR20A transceiver driver"
+	select REGMAP_SPI
 	depends on IEEE802154_DRIVERS && MAC802154
 	depends on SPI
 	---help---
-- 
2.43.0



