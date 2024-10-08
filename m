Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B7D192594;
	Tue,  8 Oct 2024 12:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391133; cv=none; b=JdInL8beaOUGbgwaDQBCjr2R806FunT0xw2NNqeWv9f18mb/H/XcT2F8EAgurRTou4KMP5ZN5KXsu+105Gv8uFTmH+JFh6VvqkS4zXDn2g9U6jF3mUwtjwPti1BWCpTY37NULeXEAkC75D72wTN5TidRRkIZY3D5CncdzPF2RJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391133; c=relaxed/simple;
	bh=ag10vNeAeQACFZWN75cyj3ltLXAxjZfY0dPeXQgqnWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/kMkcL93m06PyIHFTBxTMhOxHPdj2H8BEMF8y1HyaQcGzBqcvtzjQVReZdPLudimY72XgL7pS+FoZJB+LvjvTz8FhqprJMjpDXR5rjYmdl/jdK1TRhqNcHnXILjuPvtzQFANGAYWTvdzaVvZ9mKesKoG2TN4/X0a+4Dae7pIl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/D2weYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/D2weYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6003FC4CECC;
	Tue,  8 Oct 2024 12:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391132;
	bh=ag10vNeAeQACFZWN75cyj3ltLXAxjZfY0dPeXQgqnWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/D2weYShwJYL5KfWlwbQ3D7CqKZGIsVtyLrE2tmPLWmxjVPp7zZ/ptvO/rTbED4E
	 ro7JXeHGfo89McKGC549tjGLtRIJ013FQ8SpjFc6t4gTZCPqVPgPxZfiOspUgptoEn
	 70ugOq5xuenfhJ3MHC0MGVd5U4S6tbdkGgbjIwuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 018/558] ieee802154: Fix build error
Date: Tue,  8 Oct 2024 14:00:48 +0200
Message-ID: <20241008115702.940000368@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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



