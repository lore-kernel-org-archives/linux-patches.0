Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5012C143878;
	Thu, 13 Jun 2024 11:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278882; cv=none; b=Utz9cmqnV+wl1qeEYI4bGeW27sPVzmzEJhKBEM3BCGW24r1OEejhZDVsdw1nUs9M4DdvPUpFVar0bY0Q4+8tSxLa8JHg7GdpcB8+R4kr8Bntu1WO3vMVy4W2ada8IoHc+9sSxmdQqz/Tgq9Ux+pZM+D+gJeP1O6ZxdxgZIJvm0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278882; c=relaxed/simple;
	bh=FV2WhBCJ+Gd4nnOO8remGW6PfZkReSeanWHNjUb+YDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnNsPvxo88Rd8fHZEjHSfx3sRp7arhY7t4g2V4XlQ/SLl3xy00TGBzY/jlX7x0uLDnEncZOdKiqibALFrtBEgOggFVPx2chV35LVxXptm/+OFIWyajI8XJ4Al8EHbI06H6wWTYbwucFB3yO9nuam7eFc22BnVvnc3zjRLamSscA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoUMFFK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoUMFFK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9CDC2BBFC;
	Thu, 13 Jun 2024 11:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278882;
	bh=FV2WhBCJ+Gd4nnOO8remGW6PfZkReSeanWHNjUb+YDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DoUMFFK47sl7gt28qgSrXZnnoBe2t4FI7MHysVso+m4zRGyaSf7J7WMpiThAKK16R
	 t/0rRLXFhwbyv+SY57d1XJauQJpY8nKM52plyeVZ+n7zZhpgAhHEwTsXFRXZ7bAYVJ
	 YEr4IaK0fxof0Ayhjv6D9S26IpKdQ0Vw4I25irTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/213] ppdev: Remove usage of the deprecated ida_simple_xx() API
Date: Thu, 13 Jun 2024 13:32:29 +0200
Message-ID: <20240613113231.902832787@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 51faafd310a2e..af74b05d470c3 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -303,7 +303,7 @@ static int register_device(int minor, struct pp_struct *pp)
 		goto err;
 	}
 
-	index = ida_simple_get(&ida_index, 0, 0, GFP_KERNEL);
+	index = ida_alloc(&ida_index, GFP_KERNEL);
 	memset(&ppdev_cb, 0, sizeof(ppdev_cb));
 	ppdev_cb.irq_func = pp_irq;
 	ppdev_cb.flags = (pp->flags & PP_EXCL) ? PARPORT_FLAG_EXCL : 0;
@@ -314,7 +314,7 @@ static int register_device(int minor, struct pp_struct *pp)
 	if (!pdev) {
 		pr_warn("%s: failed to register device!\n", name);
 		rc = -ENXIO;
-		ida_simple_remove(&ida_index, index);
+		ida_free(&ida_index, index);
 		goto err;
 	}
 
@@ -766,7 +766,7 @@ static int pp_release(struct inode *inode, struct file *file)
 
 	if (pp->pdev) {
 		parport_unregister_device(pp->pdev);
-		ida_simple_remove(&ida_index, pp->index);
+		ida_free(&ida_index, pp->index);
 		pp->pdev = NULL;
 		pr_debug(CHRDEV "%x: unregistered pardevice\n", minor);
 	}
-- 
2.43.0



