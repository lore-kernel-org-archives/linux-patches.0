Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036109;
	b=FDSDGW++KQqKfVKb3wH/fQHd/vzqpkg4lzcHsx7YH72TeW0b/LueJ9Stmj38NgyCsUzu
	 4UuYYxB3JIFkWcrc5Bz2R1u97mWisEeJLpM7Rwf4uyAVLKORLsOwzGCjLu5Um31LG7N6R
	 +8kYcJwz8jkBVzZwdb/tNnant+q/SceoRv0nuDJQbR+gFGiUhHJNaPVqbbrIKTSUs9liZ
	 hBa93VucEnWrNROIkJPsML2vZlu29jOE5HDAngWFo1mOj6TRi7QhtzWT6DYS3REQs4aUz
	 +S63cbdUOjdeqN17To9cDWjqBEELRk4lVmO00YP4vUY4loZybhFuFit5CFduNko3nBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XJju89zuHbW+PtwL9fGdJG4/YMdGuhqD2maeMr+SSlU=;
	b=h+fkVtDxw5+a6s6lyvlY3OtHk7fmfddilt7vgzsX/k3s7XjcmOX67k7YzbpUb4xTCGVt
	 R0ynJInpiwiAiGxhri3qt4IyDrlh1db8G5Zwcfe4lrys+XgLpmqrZKpHHTKAPO1BtjYN1
	 t9oGkbthfrNV2+b0uLGA8q5qt3uKOi8N/7wyZ7VWymWP9NjkXAuxa6tvfF/2SGw7d89ir
	 +egHS9ZSqb0yXiycjC7RrUM1tUK17gVQTOvkEHkAQT67N2CNWsQ2QOWZ1Dq2+pgdcX4Cu
	 4xHBdOrofhsjxegNUA/S8nj/+Glb5l1yR3sUNzmK19xpSewahV8Q968SuYHWI931AUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ovxxEtma;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B3F606A332;
	Wed, 18 Nov 2026 21:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ovxxEtma
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D611F000C8;
	Wed, 18 Nov 2026 21:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036109;
	bh=XJju89zuHbW+PtwL9fGdJG4/YMdGuhqD2maeMr+SSlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ovxxEtmasROXR6YG5WoohV7sZcwvSVxQowA+GJw02fpvVgs+j+ROWU+NDVEDSV52o
	 Yuk+4pQwUlZXm6OrQg9ZIU7MmEiGZ72g8UoK0BsaLddGKv7pF+ebfrDfk/TJEh3Ljk
	 Q+/pNGdTvHTqm5Dt8qUv8ta2ppZg7AOjGUUiPyXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0942/3318] mtd: maps: l440gx: Fix double put of the PM device in init_l440gx()
Date: Wed, 18 Nov 2026 15:26:04 +0100
Message-ID: <20261118150347.837291890@linuxfoundation.org>
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



