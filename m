Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062107;
	b=bQ5RDPK9qTD+y0mEco6xoxzgkjJB7moDYvLVhjZnHMd2kIED14wYlIltvGthfOgXN6o2
	 77nDMXL1BFg7fkFt2D0MM9bykgELG/jtv7WdMY5R1PkODnIP6TFNa9TnlkBM9+9ppxpFc
	 bWTzZEFweyyML5NCEohIJXeH9hKucr0k0DmEskMzDeNAYUwzmfRzCiRGz9Kn+AXf3CeNI
	 apILrlpNlYZLrU3K8Lz410n83s29BrzdS6OplewipVaGOI4+vZLsKmsQr1g5MUH/ZwOx1
	 If42TJixfaySY0ivKTT/4ulMgeIz1nuD8mqeoUL8rYaadJTIp2EpALdiAtS/jaF8gIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZsLxRUn5dv2olOyl5l9hC0zsVViRpBZMc6XWNG5O/Fw=;
	b=ylZhJMuTXJWU7CsRMnlMd7fmWo/keEMnic81jh7XhMhdnRW9fsBhkX0Z0ba0nCEwEEt/
	 zzppQBj/60Q7cbNI5QcAxumu8t1ULqsq/3b1YolI1lOoEy1o+KblnH0EZEhw9oNsOGcOE
	 j+n8NZCiFPhP5YzAIhgNg/CUoICg9ewZkXORQxjW+4gTGxJapcw0xygKtYeIZmidGWwCy
	 axXqCn2r5AsYzFPqmHjT0f/NiJAqj5/KQVJrNDcqArudjvnkkdq47TAfwLwmPGOxW1rWT
	 B1nMLbQljCSqzgjL/btfF0V0mo4HCcr9nqbCoPBA9w3ofLnUD3M1ak7yorWupZVU7WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i+XE8wIh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A319606EE81;
	Sat,  7 Nov 2026 14:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i+XE8wIh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB461F008A1;
	Sat,  7 Nov 2026 14:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062106;
	bh=ZsLxRUn5dv2olOyl5l9hC0zsVViRpBZMc6XWNG5O/Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i+XE8wIhotIbrDoojs0mUs38FUBST9R9RrZyRt8rN46LwR8wdIrpjKazoPmpVaNpa
	 UlGRvPhmjNv6luC0XB828Hfg8zUtTnB/AI52okx3mtJ6cxfG8bBaBHfpY9Y41xKn+v
	 W7ICULSncdRPfJM+yum8MgaF/TSVVDqwIuFFLZLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1071/1536] mtd: maps: l440gx: Fix double put of the PM device in init_l440gx()
Date: Sat,  7 Nov 2026 08:51:27 -0500
Message-ID: <20261107135027.771354040@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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



