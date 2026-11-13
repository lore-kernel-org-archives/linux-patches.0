Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590895;
	b=Gyn47gU0TYn5b5ak6pZy/d9t9PTdaU4UjBmbuLk7FuyKlvh6Ku8efc9MLcBWhcz+Xmvr
	 +doKL3gOMHWXBIpQqTJ58jIx7Q7rwGWhbWfQHSqywQZYV82o+0lwd9CwCiL04w32cOb0m
	 enGoMbYvJzehfXjuhiya/wlLh2vMzm11Xma53fxA7lKJ4nF/rb65gbdgt5I1UpFfVhkhF
	 4gZuLqZZwuSjK25G/AD25o9LF4B2O0OwqG+qd3mOuYJytyMjJmmmKnO5EAxCo3+RBu+v9
	 8904rty6UwLhd66lbTnK+KuXZ18zF6rvCsw4CpWpOpUjNt8kXTW2OJH80K3m83J9slg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i0DTZWFPQDIsb+XPpsqkiNT0kKurzAOySvGMfv56foA=;
	b=pW+lykXxQOe6xZwyqyYaYgG35QFkgfYPrA4CULSK2pM4DKSxdTsWlk850jLv8nwNzPZu
	 JCGqLR4xia+nDO/TSuyfKtDXcvmI9ujO76vaZmA7BIT5DUa6U+sS4mhvu2/hkr8LWaxC9
	 +rhAMIVguFUkW4SPFq6ntQ5r2WLygY1BDd9PSJ6YE1OBBBFMWKKAp+g/KxyPm+xMwvC/l
	 UyfhE1OnYX0PdbXZ0geo7QfNiNC/0DdxVar9OazOvseh5oM+Q2g6AhUsvkyR5bYxkSGO3
	 YNG6rVPM3UNOydaYjj0N6Ev8w7LvO6HT5438IcyhRMf5uaML/V8bv8t6hpHgUEQ9ZTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yWXZGlXp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A035607EE65;
	Fri, 13 Nov 2026 17:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yWXZGlXp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA60C1F000C5;
	Fri, 13 Nov 2026 17:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590895;
	bh=i0DTZWFPQDIsb+XPpsqkiNT0kKurzAOySvGMfv56foA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWXZGlXpcRRufZ3PPGS9XrrNhUqKZboWR8DSln67JvuDG3UNlFEo0qTFmUvRuWno9
	 DfO5MbfCnu5R0HadC0gEoEJw0lJfYbJTZQYDRy8lnQX6a0cfR68W3j1mPn05wLtNol
	 YptUTmHM4DleJ9lKIAfjDsI5utvL8PsCsvHpdGp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/670] mtd: rawnand: ndfc: add CONFIG_OF dependency
Date: Fri, 13 Nov 2026 10:44:10 -0500
Message-ID: <20261113153814.829243384@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 97f9e509d839f7e5b9a32105ae322e5223c86786 ]

When compile-testing on x86 without CONFIG_OF, the ndfc driver produces
a harmless warning:

drivers/mtd/nand/raw/ndfc.c: In function 'ndfc_probe':
include/linux/dev_printk.h:154:31: error: 'len' is used uninitialized [-Werror=uninitialized]
  154 |         dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt), ##__VA_ARGS__)
      |                               ^
drivers/mtd/nand/raw/ndfc.c:196:17: note: in expansion of macro 'dev_err'
  196 |                 dev_err(&ofdev->dev, "unable read reg property (%d)\n", len);

Limit compile-testing to configurations with CONFIG_OF to trivially
avoid this. The driver will still be built in allmodconfig and many
randconfig builds.

Fixes: 4f2692a5383e ("mtd: rawnand: ndfc: use ioread32be/iowrite32be and allow COMPILE_TEST")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index 0c39b4f346a69..91fae26a3d91d 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -72,6 +72,7 @@ config MTD_NAND_AU1550
 config MTD_NAND_NDFC
 	tristate "IBM/MCC 4xx NAND controller"
 	depends on 44x || COMPILE_TEST
+	depends on OF
 	select MTD_NAND_ECC_SW_HAMMING
 	select MTD_NAND_ECC_SW_HAMMING_SMC
 	help
-- 
2.53.0



