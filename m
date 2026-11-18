Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053126;
	b=kmi5zreno6Yov/VVQ3RZk6+oW7sbSNfXr3c989iOB5/1A+tJ244Ylo1d0pU/ivLpv47O
	 l0+w/YeGxOFJveJisBdS79dRQKl1XCyIDK7A/eYdachW0TGa/bT6UMIzZI1PhaY7/hnSM
	 MA6A88w2GjKNPdtu0XhiFhOWdyyA6pXm4dluY+VjHxbcLy3RJNFMXJCRZXSupZyMN1Kpn
	 iTYbHw+9d1+D4l3g3w7CKykskT7zDblrzLeFQ1j9t4L5lONK5AS3qvO0M8TqpN1oaxsl+
	 0dWr8Xgu1QFWEaxzENpi9uNmtnbi6KyWzAnhmO7tqQF6uNtJp0f74Rzy6Eo9rbKd8SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KnuPd9TGBQ7x+zbH/KmwMRRCSnt6fzEVE0ADs4F8vGQ=;
	b=zZc+L8h6PW3O1RvvgCAhsFyjLL+T6KboQ95Uxxv8RUhqNQVDgpi+IQCOL/EW7+VE3kjL
	 pN1QxkTck8UmRDWX3n8B4Vt58EoUx7klNIn1Q8h3T2IP4CNcElwZ5el00tGsIATz6q4Wi
	 KzuofIlt4qvPq6V3c5uJeQRgQg6MEteV4dhL8kkeNJHIRmMN5hO9KAhmLQ3b3boXfBdo1
	 zkV6sX6Cl60woqlpXGOepzqZXgsd4zaUSATt2rOVEX0FbQ/JAgfN2GZXvjyNfPdYfcn/O
	 YWBMU+sgeoY396HteB53SpA/VCkUqBi0XJVobAS/vc3KPzKVjybQgjeab1uEQ8LZg2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fBksTVop;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97C0606A325;
	Thu, 19 Nov 2026 01:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fBksTVop
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240DC1F000C5;
	Thu, 19 Nov 2026 01:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053126;
	bh=KnuPd9TGBQ7x+zbH/KmwMRRCSnt6fzEVE0ADs4F8vGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fBksTVopaOL9xzxF/uKv5/GbkE2glOAuIPf+Hhn05B7MPRbLAbrklqkcN0i7Fpx/q
	 VC7TpfFxdS1I0v1CqZsgQPM43AgCYzSU+qDpIpMN7jt3ldafwo+gIB5GCXuCKywZCj
	 +VAGgVPmzmB+GHL/LmDbS7TZtj/ISz80AR5r9s7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0809/2214] mtd: rawnand: ndfc: add CONFIG_OF dependency
Date: Wed, 18 Nov 2026 15:41:25 +0100
Message-ID: <20261118150043.835081556@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 77655fdbfa9b8..a9d24643d3984 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -71,6 +71,7 @@ config MTD_NAND_AU1550
 config MTD_NAND_NDFC
 	tristate "IBM/MCC 4xx NAND controller"
 	depends on 44x || COMPILE_TEST
+	depends on OF
 	select MTD_NAND_ECC_SW_HAMMING
 	select MTD_NAND_ECC_SW_HAMMING_SMC
 	help
-- 
2.53.0



