Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037337;
	b=qjdm2OLQIR7/SziPMCWMrjfvQsL7aaZGJ0X9mQjEjCADkfe658LdxMYmZToBS5vpk4W/
	 /VGpXD8X9mFqIobaIVB2q3g4fjUHOG8hxFhYCxj+GrXFeF3B7KkQBc7RQTTt6vqX/O5yR
	 1dwiDT+H2TBwpavZrGCwpwACvookj5oGjHkQlpICGEDscF1rNp3GwdhY9dcsn/XfBcEmc
	 rurPRwKET6rX6saTxV+N81YPv3nnZamOtCUqmPS5NIurCm70mRU3D9CchfPYGo1lCuciC
	 q2xu0oHGANeOZrBdVesYnlTa4MnWnQ9jJbTg1W6rSJnpIPO3aMTssp9qhf49GK2YDPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DCcCVBiOn4emRu/Q6WOFZqhNBvpw5H+6CRllEYJXJ9g=;
	b=sVyXapOjpE2vjTcAsXLyPRmkHfnXWI+ufOV3nNST8qtXA4YvEsp90jnYtPtXdRqlao48
	 liVoT9HdTWZ82PmY2Iyl09RSz3STV4O63WA81Chbps82xjGoG/FcjbwIlnQnxicOR/qCs
	 BxIpwj1gRZaXUws89eHFLfqtoZaW0VM5Za0VZ/cjyXIj30G+idWf/JFUCTObjG/fC2cBk
	 xFvv0gxfAjkk/Pj1SpKXOM8d0VlJkpcuvruitbJxqE8UCBOi8fdVZa50+obR9MkwPjIOM
	 OG6bKQcPPcRqJqTee9nxXAdCUChw/0hcJTFX8foeh0fKOf2khMX9k0hXndvKoMan/qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8+YllZi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437F560A5BC3;
	Wed, 18 Nov 2026 21:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8+YllZi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBB71F0181E;
	Wed, 18 Nov 2026 21:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037336;
	bh=DCcCVBiOn4emRu/Q6WOFZqhNBvpw5H+6CRllEYJXJ9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8+YllZieGIA9gJykRNAHwk6rikxAymhrv+qKkVcNuX53UyM3mPO6DzSPk/cD5R06
	 bijbY+YI+PxZQX70HGR7fetGG0GC9RbpJwvO8kSYLDscr6E8buqLovfgp2pRL7+mG8
	 MT4/aINVAtjAHQmbIxwvD2B9rVVnr8wOrLIAmRXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1368/3318] mtd: rawnand: ndfc: add CONFIG_OF dependency
Date: Wed, 18 Nov 2026 15:33:10 +0100
Message-ID: <20261118150401.536278713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d2cd9d7b04228..cbf8faef8b504 100644
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



