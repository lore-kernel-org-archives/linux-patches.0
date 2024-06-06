Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123E219D068;
	Thu,  6 Jun 2024 14:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683448; cv=none; b=aEB/0hLqTxyPliixMFHP/dEESIGwEXVm64VE5KxcgE9ihtkry3wXTKv87e+17Ng7MR8QO6TZCAa/VOBZ00q9nV/GrgPV+GN984p4WfSohr4VJX9QxcXUVrg73EM6wP2oc0izpSUgQ/KimTHawuCwqLqfbXaHMUaUjk6fn3GrHVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683448; c=relaxed/simple;
	bh=gYodxXJtY7I6bvpqjM7qPgCMNDV/F2YcVs5g55uVTHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ES5ZVfENA5S5FYOfhRS2ZvLShrkuijA6IVZJX1lwQBkF26zp23Pm/qUbBSi8fH1CPHEkFKreSG9LXKkDdHltUG1Ijwswq63NdnJeg/sBKVm81mnXHto00FPAlb5CfvCCn0KqMHJlMEoaez/IOhm8ooxD72ZoCDBQMy5FL4Alxb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzy93+Z3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzy93+Z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1885C2BD10;
	Thu,  6 Jun 2024 14:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683448;
	bh=gYodxXJtY7I6bvpqjM7qPgCMNDV/F2YcVs5g55uVTHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzy93+Z3SUtNtM4Jy/Hd0YbE5P9GnPUjVaw/2P2GHekn18I+aBczjZ76HBsMyZQvy
	 9Y9W68z2QBmQBPKKdzofDQFhP4xd+fEGUt1HyX1Khxu09aAd14hS6cpmP0vBqStg/I
	 ehcgIKU2GyIwdTKdSUxCnPRiHx+s/vJPjoX/bOUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 332/473] ppdev: Remove usage of the deprecated ida_simple_xx() API
Date: Thu,  6 Jun 2024 16:04:21 +0200
Message-ID: <20240606131710.904920346@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



