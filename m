Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046181;
	b=Me1LVehiR8nB0yj/o0we/y/Fy7N019w9WsihMy/50XM1Bp1x6u+P4ltt6RcTb7xyysMx
	 ApBB5GBopzSGb9gq8W6OKH0X1Rh/DPFV8Ar1n7ObHqTimdWgVcC86JKYnRBVIMnPLbdRT
	 MHWssYrQQyTtrWjIo+Q5NPYxIZrQHNxgcE9/fEEkDJ5i9K0X171mMHFwEizuR2bWuUd6r
	 NM7MO50OGs3PIuPJn9+THfLaCJ5whIWbampSdu4XKN7Jn+nfLdu0x/oHjTbXZdcoZd4oW
	 g3FRAwWX1jN9ySDFAJgaFJ9dh8LA32tCTDjFmRpUMQQOnnlmxpv+IIrTS4eS+RXw9zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fTHluGsto1CNN75NMG2+1n34wc5QZv+Q1wG6d2UxkDg=;
	b=hdIZREUuMAUu/x+D7lkTivHDMTAxMwXNnG7tvKqO8RST5PAGJR8nD+wLLc8osGtIxMZL
	 hh9qOVFjbQ904kEsBMXnLPAeOGorx3W6v279urLSLyyBCJjq08Y4SrpOhKsAn1Ieg98A1
	 Tffd6keCtnr46UAcieBLJS5IT5Nyi9mF4DysHAnQcealsaydSKh90yIX2dpR1Dwyu54iW
	 zf17dWudoyWuxcGoID00jArqzutq5WS8iFlnrFKkkTftSV07Z2Dk3mT7JCjlSgdQWN/en
	 K+mrlZaGyH/iTd/pB/R23FjCKPa0Wm0/+v186hWVtGHEqBP4uGE3EWDolbqVmJ3ZmMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjZIDvxg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406BE606A320;
	Wed, 18 Nov 2026 23:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjZIDvxg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DB71F000C4;
	Wed, 18 Nov 2026 23:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046181;
	bh=fTHluGsto1CNN75NMG2+1n34wc5QZv+Q1wG6d2UxkDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjZIDvxgqdfYua3YrsD7j2LJoaMAGAqBN4xS82y8EN/lfPdztqvF3lxFKlwM4SyvP
	 a2R9GhakW+3F+3LzRwZLYae+trHe/JzZQ8o9S+yS+hfV0Mt6CG5qTrKTCmN1tEIPJK
	 fDkd8+OGKU9FgIFa4Qp/FickMlVRf8dMxDpaFbU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1162/2857] mtd: rawnand: ndfc: add CONFIG_OF dependency
Date: Wed, 18 Nov 2026 15:36:36 +0100
Message-ID: <20261118150243.428071623@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ed828149c94cf..602952b3f9f65 100644
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



