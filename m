Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058456;
	b=b5R60PaN26w+YOlDhnw4EJddVCuJkwxRUOUmLgAHJze+/jLjIy3JQMLk8f3p+BB8gT1Q
	 xeizIZLrUSfYGiS3pes65UJ2UwetwToExvzrN37A6k5IBnUrXimkuSAtof4Ek1ON+NY2J
	 X/n+SpXsbPXKYXokrsJNlOGGuUSfvwt6UacrvsjzhexHMth7lxshGXYve4BhnknQJmraY
	 baofvO+79WsTqbnyyHBeU3fpu8ARJQ32123pjBKze04q8LHmjWepcrO4EF1T0PscIdb4S
	 WwRzHsh/JVnDtTcLfSGBGDPysffnRuRZuwwwo30LHJjPT4oBbyLfzGfmt2Wq9tt3CSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RhTC3bji/+oYLmGAjGYS6MQbBi6qMR1PY9158Htw28w=;
	b=Swd+bWjpyzhYKIujCHYCC8bEYD74N/oCCJ840tnXT4KOM+jwsT2m1IuqpmQFF3AjWVRU
	 H5EhvmZFzDsEBtmYJ4Fqcx5QF4ScoHWlYaWF409MU3afBiW6FH4BrvqsJgNrVcr56ij30
	 bKMBYCaev3t21q37EXUJFnycSmQk8/43YxcNR2p9blVefOmKJbUOdrSkWrGNRZkgYWjxF
	 zBhzgfplVkX+HA9Jb5Js6asb0IQ2ifbwDUqlctRtx89qhgqZe4RM3sFFYE1LjVycfkvRM
	 Ah1EPxhenVcRvK2q7ppV0+aNkS/AvjaIC4RuZWdB7NpGJZCPTCudEf8WHYvViIinZPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=czc05yDF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE362606A32F;
	Thu, 19 Nov 2026 03:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=czc05yDF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0914A1F000C5;
	Thu, 19 Nov 2026 03:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058456;
	bh=RhTC3bji/+oYLmGAjGYS6MQbBi6qMR1PY9158Htw28w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=czc05yDF2j5qi0Nmf4tb/pTL8wZKo+tf8jT6/07/9zLSBlI2MNApC4uowqA/dWYFq
	 vNwFU2Uum06e8Q6OrZPTSx5zXsP0kHvBSf6QfHh/K1maM5C43tXdOjvNGOTREEB2yA
	 svTWvfc6mmBkMsyOdQ1B1kwA4rOegtUMLrMi6wuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0440/1848] mtd: maps: l440gx: Fix double put of the PM device in init_l440gx()
Date: Wed, 18 Nov 2026 15:41:18 +0100
Message-ID: <20261118145932.607119228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit e6ca524ee5b2705be30ea19ce2e55122d9f9ed8f ]

The PIIX4 PM device reference taken with pci_get_device() is dropped
again before the iobase resource is allocated.  If pci_assign_resource()
fails, the error path calls pci_dev_put() on pm_dev a second time,
releasing a reference that is no longer owned and underflowing the
reference count.

Remove the extra pci_dev_put().

Fixes: dd8e9ed6ed54 ("[MTD] Switch to pci_get_device and do ref counting")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/l440gx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/maps/l440gx.c b/drivers/mtd/maps/l440gx.c
index 85cd273ce0654..1df5ea5fafcac 100644
--- a/drivers/mtd/maps/l440gx.c
+++ b/drivers/mtd/maps/l440gx.c
@@ -110,7 +110,6 @@ static int __init init_l440gx(void)
 
 		/* Allocate the resource region */
 		if (pci_assign_resource(pm_dev, PIIXE_IOBASE_RESOURCE) != 0) {
-			pci_dev_put(pm_dev);
 			printk(KERN_WARNING "Could not allocate pm iobase resource\n");
 			iounmap(l440gx_map.virt);
 			return -ENXIO;
-- 
2.53.0



