Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A6D19EEC6;
	Thu,  6 Jun 2024 14:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683557; cv=none; b=XR21FbBjcCeTP3AQkN1zjpR4UJzQNkcz7HmvzYrU+m8kQVQUiVo+avjSwtdqpZqajFMjP+nrzClyPFpCLO88oMboXdHsvE8ABGKZxrvEGlxh2DnTUR+hs8ZxSyqvleY4yMgXuOCklKbjvDlHUyh7HFqGZ0e6iiK7Hz5WZ7hVol8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683557; c=relaxed/simple;
	bh=BGoTOA299Jjgum1dJlZI/XY8SlImY/QblUXHARRunuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKG9NlhOAZAhYtW15v2xtJVjNFwNIXo1TTALVUtu/RM+NVrEjZzsE3yoqkPDr1bp7oqOb5hO9UsW0WI+09pXQ2NPKjhogIJutqpL6C67KGVrf6J+azT4tPKYXrP8JXQg8D7waKz3qRiUtarps+OS1oFWngOZMjkEE2xAY2DeZfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gzl4wAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gzl4wAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACACC32782;
	Thu,  6 Jun 2024 14:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683557;
	bh=BGoTOA299Jjgum1dJlZI/XY8SlImY/QblUXHARRunuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gzl4wAitXkm0EPZK7dsDYpGxx/iaWZyQN1VQVxPTae6GcNP+NVPJf9wg40cAy0vp
	 VQLRJToC2mcq7EPGzyLAZ/uWBEfXGBE6HodQ5Mm5exE1t6p0Yn7+KrO1dIJIgffr+2
	 v0yrHYsB0NNWExg6OGZ4MTXhsiZL6uuojY+NqplU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 490/744] ppdev: Remove usage of the deprecated ida_simple_xx() API
Date: Thu,  6 Jun 2024 16:02:42 +0200
Message-ID: <20240606131748.159390643@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4c188e9e477cd..ee951b265213f 100644
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



