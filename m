Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036106;
	b=dM1Irl+hiZ6GfRs2XNuzLK5SNBWwNMSeTcY1UZbPgTHIt8JHnKJQ8vz5qsSnU8h7ZbDr
	 CSS2+Sk5sxbZGE2r+C/asIDDDqV52ZZWxIlSf8ZxoK3toXqZITIusx1VARHTppKLP925e
	 LOvPN3ZGIQGZvchIFrsz+bfblN9qMAGpOpKUdD1OZjJRJ+aoQ3TjXzGWu1StZLTJSKkMA
	 Gn099hhEHRr+MgqTYveXwtbKQzC/U1kO+Y9AtAp3jodlRAqNXHoWjNo10LvNtmp0V+mjT
	 jvJ6usOMyylg0vuZkDgBcLN4QWTGnIbbqlsw/Bv/uUcOgypnnfBIS9RRgZxOjfAyI3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TQXZDdJTuk2jIMn27NtRN7j9XjVe1boQpDkWUWKeCUE=;
	b=Rh0R2+48KORfcxL5PH11+R8cNoiA1UXh9tIQ9wFNka9/mdhk8zm6wf/VkPE7pn+1dq91
	 3ptn9IR0O/2V7lp0VrrE5WUHNyNVEGC/VUT9BmXQG1TOrDc1Uv28SpmMAFfLO8PTR/TBU
	 dKP8f3uNnBeoTs8Mp+etQRwJSEoqwcZjRG4ULPdQm3PN5KeyHlGPOWxSNlweWfSrLhDq4
	 +MPz3CiKRv7Xsdp1K4XwQgaQDKXKZxgR+bMeUWacHn3UYFwmsFMSSz6rqoAQWXElknj4e
	 j/uC3kVpQVU0WdXfSffLBu2KGoq6NLsnXXHI2Dx95ZtwiYeHV2GeSwhzcqvojd83+YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xc1vKxSg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4F8606A325;
	Wed, 18 Nov 2026 21:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xc1vKxSg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF7F1F000C8;
	Wed, 18 Nov 2026 21:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036106;
	bh=TQXZDdJTuk2jIMn27NtRN7j9XjVe1boQpDkWUWKeCUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xc1vKxSgkP9jyalH3riYCCDYR4uJg324QQEKAD3cq+L8lBXAs7plBYLcY2DG9AKiA
	 7SaDUbBNt1nzq4ESg5TN+CxivGBbhEU/ivJStHeSsACUzh3EUGwj0BTu0m7KwMezbm
	 2Cm3w8Juzv3hYmGsr5GAp2qweNnhg2l/JjGeSyek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0941/3318] mtd: maps: l440gx: Fix double put of the ISA bridge in init_l440gx()
Date: Wed, 18 Nov 2026 15:26:03 +0100
Message-ID: <20261118150347.801415731@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 521ad948e04934b2d70ae899bc016bbb38802e90 ]

init_l440gx() takes a single reference on the PIIX4 ISA bridge with
pci_get_device() and drops it again right after the lookups, before
the flash window is set up.  The pci_assign_resource() failure path
then calls pci_dev_put() on the same device a second time, releasing a
reference that is no longer owned and underflowing the reference count.

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
index 832b880d1aaf8..85cd273ce0654 100644
--- a/drivers/mtd/maps/l440gx.c
+++ b/drivers/mtd/maps/l440gx.c
@@ -110,7 +110,6 @@ static int __init init_l440gx(void)
 
 		/* Allocate the resource region */
 		if (pci_assign_resource(pm_dev, PIIXE_IOBASE_RESOURCE) != 0) {
-			pci_dev_put(dev);
 			pci_dev_put(pm_dev);
 			printk(KERN_WARNING "Could not allocate pm iobase resource\n");
 			iounmap(l440gx_map.virt);
-- 
2.53.0



