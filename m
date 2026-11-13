Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590065;
	b=xN/yzvel7dYrUzD2G9wM/0b5yCmBd7J8nL6psnv09InyGdePx8eTuoNMKEK45mKy0hUu
	 YSnzjSkNHpkG4nSNO0bHI3/XD/+EL9+THtMn+uDbiOoWktshJ09ccXAYC9ZsuQqhf7xKU
	 9tNeI+SkpZEld8BfC8NIfJl92zbCSgdbkNxhZ7BTn98Wn0ONgMsWvK0jINasiYobpxX5b
	 Dlf+nXxBc4csUKPYJ0HAekDAGUKZtDKh3OTgonPNAKxgV627jFL0awAxvOaUZEMmVkzh4
	 qGkWRVzluFKJeQnEA88AaOrvuXmQvRaJZSVrN53Yspf0DyvcKVIJ84Z1juX6HOA4AKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oz8m6H6ZCX7ulKsN+QUJ5JcmKzHQNzgr/Z55VrQFl24=;
	b=CKV4O077mI4NOSGJN1SskPkaf01ucfBJan99+pBy9NjDUTcHTKRmmlqTEhh3pSdrjCVm
	 UdpUnlADgJxfpFrvjFqsP/bgN+xoDISibT6FETt8VltIthPwm9QjgwYw8WlVVAQ7t4s1L
	 4Uwh4DaSq8fZDo08N2B9qj6vtQKj97kD0A1p3UnP2ce1fZ1/tPXjcUCMgD/iX+7O+K9gp
	 X+kmT8tdyfZ0XT+Hn0saCwzmBJFWKVTFWdw0rMOV05sbOigsF0fOp9SmzZQD0ddcZ6a6t
	 UJrXIMgsHUDo2CHnHgIA6iAzf0ai/EtfQnlZKmYRItLPdwlAeFSATzsqUFvZ0upwNLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1WITkXoP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0AA606A8AC;
	Fri, 13 Nov 2026 17:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1WITkXoP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689721F000C7;
	Fri, 13 Nov 2026 17:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590065;
	bh=oz8m6H6ZCX7ulKsN+QUJ5JcmKzHQNzgr/Z55VrQFl24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1WITkXoPQhlr67LxTSXyNQKZX3oBkIRj4bD8C+1PuW0B4JHNUPKCCPnXy6aP6RmT5
	 bhyDQYqvreqCPWikaEpcoHY6eIYbGCec2l4bqOY+CkDwrWn88HszWxW6DvePCbQSGh
	 s4P1HHTAI6Agc9AoHl+CZeFub3gGSaCwV9nX99dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 090/686] mtd: rawnand: ndfc: add CONFIG_OF dependency
Date: Fri, 13 Nov 2026 10:43:43 -0500
Message-ID: <20261113153823.922534771@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ee01b845694de..2aba02ebe03e2 100644
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



