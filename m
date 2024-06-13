Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40B614198E;
	Thu, 13 Jun 2024 12:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280014; cv=none; b=KLg7SZTg1jli/PHkPPScC5+OoJfYr/BthIx5NL0xrt8GYFcbhQz8kihnOlb9Gg44NDWCPi9yRcs7V9C+Tde5rdx/BwaiW/QPkSEWCgVZYmZS3uDT1nIrtFYnafx5dq6cKaeYLc5K4BceaztltKwJWqCO1vEBFWh5nj6amXFWbk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280014; c=relaxed/simple;
	bh=DCp4jC7dg0uNn6aSqgvaePNcLHMQ3hXhcBcTaCOcfSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cqaixbodc1B83BrD1FDCx3kHOM2P6ToQsms4KYO8nwmalu/OffixutAnRPQq1AC9pziRlr4Z6pgfMouOeiJkK50dQxJUaf3qLik/zf7j1HhITM6HWKZZkjUatuqJHBv8pUe1YZEWGe7pwaAUkw/YvfGa1s8Kowx7ps456WhPltY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0SmFbLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0SmFbLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383B5C2BBFC;
	Thu, 13 Jun 2024 12:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280014;
	bh=DCp4jC7dg0uNn6aSqgvaePNcLHMQ3hXhcBcTaCOcfSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0SmFbLxnDGIl89pe9VPdN6HABZ/Qf7+Wm4PWN5idCfpIjMZFH/3pSIe84gw0Yb7i
	 dh0jdyWTCJfrEOxz1C7JUqxCCCKYV98hTZZ4jkFKhfv1ejiYVx6rWEp09i5mSDiOoQ
	 vuwds6j6Jo8MlVaZyxRdwcZU0lvYDY79KOwKJF0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/202] ppdev: Remove usage of the deprecated ida_simple_xx() API
Date: Thu, 13 Jun 2024 13:33:31 +0200
Message-ID: <20240613113232.120601526@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 34bb88fe0b0a6..5246e0faaf9ae 100644
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
 
@@ -762,7 +762,7 @@ static int pp_release(struct inode *inode, struct file *file)
 
 	if (pp->pdev) {
 		parport_unregister_device(pp->pdev);
-		ida_simple_remove(&ida_index, pp->index);
+		ida_free(&ida_index, pp->index);
 		pp->pdev = NULL;
 		pr_debug(CHRDEV "%x: unregistered pardevice\n", minor);
 	}
-- 
2.43.0



