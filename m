Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591462;
	b=haKp0onT7OU93rR9iEtegrwXYtqMS40EuEHkTbpElIBktMarZQME4ItumsdOeObtC27G
	 kjrTTG4N0X7WISbolpZWXGwCV1kqX6RQtxTE/HDXVOzYLvX4JjsP0oJAhnkLtclkx4GxL
	 qIVgqXZi9V/t8r3r2tHaEsdbSsTvNAOlssnk9th9sID3hx8GgvYJrRbi9xHKuviQZ39EJ
	 rycs2PSKF3QRzYVz7IBZ3qnoq0Y08Ra6MIyLHm4NAfN7aaOi4GSnHiANd8BL1imMfP4TR
	 LXWhRqYu4vMkv+zm6yXnlT/axTtba5vI97JkpCzusTgooZZX8nbuh0VM9QenUhONf2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JkUz07Sz+fhIoQgEK2E6nEWY/W8cFGuYd1Cp9/BCE0U=;
	b=3wd1Rdq/DlGjg4k0tIUFrgJ8ejJnmnsHtqw0l3xnmOGVgH8WXOHGT1FoZQxRDOs1k5GG
	 KxhTyO5qRZYh65BPS6dekDPbsupk6zJT4Isd+4QeirJ3Z4xBi4hfCldLc/j4mdrO6vPIO
	 z6NFFwLs3O4v2sd3ddLFpqF6EQqZeaOwzJgwwlizSr7G9ymlM40d+zaJtzg2VJaX+Z+wf
	 tP4DuZte92s1n7rhBnBOYtAhewtsa75DTfSUoU+ZjVA6XFD/G+2xh0TJ7+7VhSOiH/6bG
	 JqDTM3XHyFhgwb9pv2fSk7tOM08LKYqlI/RY7OjR8NBunl5DZlH7sdUlDO2TNu1Jhig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uSRYTD0I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635F2607C371;
	Fri, 13 Nov 2026 17:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uSRYTD0I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104A31F000C4;
	Fri, 13 Nov 2026 17:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591462;
	bh=JkUz07Sz+fhIoQgEK2E6nEWY/W8cFGuYd1Cp9/BCE0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uSRYTD0IX4qqLjSYWrTgSqjVQz/FpRVsKEvP9hZ3PKDPoEz8QiWswkenDuqvA32id
	 41hsOdtxlQbbpE6ct5efiZXW+TOl3Cq04jdc6TDRdw5k5tgM/OM3MFfjImuaI3AnN+
	 s4Wb55RUlZpcBFBx8UMVN6YaIkC0o7zYXKn3LBys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 547/670] serial: sc16is7xx: add comments for lock requirements
Date: Fri, 13 Nov 2026 10:51:51 -0500
Message-ID: <20261113153830.425536852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 42405cb77fd35b5acc0e5a11d74eef68c2afa484 ]

Indicate why lock needs to be asserted when accessing
MSR register, as this is not immediately obvious when looking at this
register in the device datasheet.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://patch.msgid.link/20251027142957.1032073-15-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1c41d09dcd07 ("serial: sc16is7xx: declare MCR and IER as volatile registers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index bd38a2efd34ec..92869e56ce5d2 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -535,10 +535,10 @@ EXPORT_SYMBOL_GPL(sc16is762_devtype);
 static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
-	case SC16IS7XX_RHR_REG:
-	case SC16IS7XX_IIR_REG:
-	case SC16IS7XX_LSR_REG:
-	case SC16IS7XX_MSR_REG:
+	case SC16IS7XX_RHR_REG: /* Shared address space with THR & DLL */
+	case SC16IS7XX_IIR_REG: /* Shared address space with FCR & EFR */
+	case SC16IS7XX_LSR_REG: /* Shared address space with XON2 */
+	case SC16IS7XX_MSR_REG: /* Shared address space with TCR & XOFF1 */
 	case SC16IS7XX_SPR_REG: /* Shared address space with TLR & XOFF2 */
 	case SC16IS7XX_TXLVL_REG:
 	case SC16IS7XX_RXLVL_REG:
@@ -782,6 +782,7 @@ static void sc16is7xx_update_mlines(struct sc16is7xx_one *one)
 	unsigned long flags;
 	unsigned int status, changed;
 
+	/* Lock required as MSR address is shared with TCR and XOFF1. */
 	lockdep_assert_held_once(&one->lock);
 
 	status = sc16is7xx_get_hwmctrl(port);
-- 
2.53.0



