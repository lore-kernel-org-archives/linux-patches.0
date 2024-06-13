Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F45E143C51;
	Thu, 13 Jun 2024 12:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282363; cv=none; b=WNXfz81jpELRcZAQ6oeiKJNGw7He0FOA9Dt6dpOR+T61DEoB/6gFFL/FgO5xGt00O1BgDj1MPpl3lW1/nDJRjp6c76medxUn45ecIit4qwtmLxaQT0J96jIEPyj/HiRxP3RvVQQ4vEq2tjRRassY0e2+B4isGpk6KiGDkz7x0u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282363; c=relaxed/simple;
	bh=hRW0z+sdiW3mvE8n9E3lHPvhaw4Q0Zs4/EBG8RapiMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/r6uFBdnT+fZcQFBCHGkJM0nW60Z6i50qcnUTtVfq/w/06Z2OZbjjCB5SXk8b8nj/MBmG/gnDVZyUu9XKjYe2vw11hEdHEfKxL4JeWp1Bo33sudUPrmRwU3z4KOUCxiMfKmFEOXvomBPjQVsNdY10grhA1EWPE9Y79CsDqshss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uy4+/+ZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uy4+/+ZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75A6C2BBFC;
	Thu, 13 Jun 2024 12:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282363;
	bh=hRW0z+sdiW3mvE8n9E3lHPvhaw4Q0Zs4/EBG8RapiMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uy4+/+ZZKgEi8YA9jQuU/pwHxQljepTkPT+Z/s1FmQAXbkyNAnknP5cTOc4I7E9YQ
	 XQsbBs9oiOrHjIk46soleHzY1Y/PhxrB6fr2kf9LruB2wH+VWy4EOR72RvVUOaKtdB
	 ysM9MmJYyqp2ViXVcSwEAARYmkdxhf9WDJPnPAug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 221/402] ppdev: Remove usage of the deprecated ida_simple_xx() API
Date: Thu, 13 Jun 2024 13:32:58 +0200
Message-ID: <20240613113310.765548381@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d8407f71ebeaeb6f50bd89791837873e44609708 ]

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

This is less verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/ba9da12fdd5cdb2c28180b7160af5042447d803f.1702962092.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: fbf740aeb86a ("ppdev: Add an error check in register_device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ppdev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index 38b46c7d17371..f6024d97fe70b 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -299,7 +299,7 @@ static int register_device(int minor, struct pp_struct *pp)
 		goto err;
 	}
 
-	index = ida_simple_get(&ida_index, 0, 0, GFP_KERNEL);
+	index = ida_alloc(&ida_index, GFP_KERNEL);
 	memset(&ppdev_cb, 0, sizeof(ppdev_cb));
 	ppdev_cb.irq_func = pp_irq;
 	ppdev_cb.flags = (pp->flags & PP_EXCL) ? PARPORT_FLAG_EXCL : 0;
@@ -310,7 +310,7 @@ static int register_device(int minor, struct pp_struct *pp)
 	if (!pdev) {
 		pr_warn("%s: failed to register device!\n", name);
 		rc = -ENXIO;
-		ida_simple_remove(&ida_index, index);
+		ida_free(&ida_index, index);
 		goto err;
 	}
 
@@ -750,7 +750,7 @@ static int pp_release(struct inode *inode, struct file *file)
 
 	if (pp->pdev) {
 		parport_unregister_device(pp->pdev);
-		ida_simple_remove(&ida_index, pp->index);
+		ida_free(&ida_index, pp->index);
 		pp->pdev = NULL;
 		pr_debug(CHRDEV "%x: unregistered pardevice\n", minor);
 	}
-- 
2.43.0



