Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC191DA60C;
	Tue,  8 Oct 2024 12:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389512; cv=none; b=htnPif/KRG07c9ovF7M9Q+3oPmuOBxpwcqsyQmzXkNnoj6w2eQ147r5PZCmjNbsWq3OX8zv9bhRzKenu86BMeR5G7WzvAIdF7zX/wJqxSVPkyfeDsgyWSEBtK1wC7hPd3V9uEBJXWrio0zMGmsVrL8dG4xb6QPaLYvk+jADY5MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389512; c=relaxed/simple;
	bh=AlY2eLlx1DCNC+XpP6L7Yh7y9eaAp1vXOPuO6Zl1zBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWc846aXcQYMpXZMWpisJhucKsvPRxqwF9m4RxLMcV4wk3JINg8270FA1DVjbvmM5xj12D+qRdqNOEwbfAe9cTzn8bKc6G9w2YAEw7BbzrqOoyZ8j4B3H2GQgANW5qUVKIc5wav10D9be6/bJ8N1F5OHXmYT5Qzda+OULZ/q5x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G44cDD0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G44cDD0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C58EC4CEC7;
	Tue,  8 Oct 2024 12:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389511;
	bh=AlY2eLlx1DCNC+XpP6L7Yh7y9eaAp1vXOPuO6Zl1zBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G44cDD0+zmA1grugn5M8Pt+bT3VQlVwMJrRtt+3EWEVaKiH3f3w80stOGRA2GumRL
	 uK7MU4kWhN6HgGbmsfQM3yq2XAUEbZRi0r54L16Sb174MCZYF4VTkvXJvzVv8s14VJ
	 UCPU7/ng+dUXKqk2ic4xqlPXgHXCsRCI7K7cc65U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 016/482] ieee802154: Fix build error
Date: Tue,  8 Oct 2024 14:01:19 +0200
Message-ID: <20241008115648.937802051@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



