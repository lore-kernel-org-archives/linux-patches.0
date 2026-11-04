Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829534;
	b=QXIL3EkjcaqTCyA+2fIOo7XWFk0CSk+syHshDnOzjB/jy4PJIo5pDnKO68IEWwQLEUFe
	 cwwG0pjnLrgBk5xxXE2ce55ip1YsAEiKn1jJ20JYseOKLkLI8hbC2JyVD0/RqXltidGcR
	 gpgteTXjB1FpsPFcWXqtdxA6R+RNpGdzlD0J5yisdhGYd/Ry9wWpwcBjQF3e28a86P4YL
	 PlRWI/dGzSIABLKV0J4HGGBi62lH5aE63rRU8LiQPXmbY8AueYQHChpup5zk3gBZ/Gh1t
	 GG5rEbSIanlNfwJ/wfP7C/EtBIQvUxcwaZATekHQttoo6jfD7IShAty8TcCNi4KeiFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wQHVmvCnLwdZrEcH/gg5eY9HXGhLhTxT9Muxl8Y0CIo=;
	b=FGRHoOKMX+gNxS0NK/NOxYjun1V/3AqqLzAtJp2cWOe3d5CaH0OAdOTFhpKGrnMHjnXs
	 B6hJ6xFqo+cpX7J1p/hO5tu8lcr0ykiEQafmAZVr5nhzV3T/lmRfrARRJXDUWH68nCVse
	 HUFKtnS6zi3Pokj8DJ0IfIAJCZU66gd3Ci4PoU/Xzy41HhWEWg7xLRaI2E3YBTHvMoN9h
	 tSLs9YxIwaBP5W4GmOfrg8kkw0hjJfoon9r4+1qjHMslAgHFgExPXjb2G/dU7k/Aetq6v
	 u09BS6vMzC8uQApmIrLrDWTpgFk4pZHo4MK3Mx/2IlWLzWYFvJWtT088p9qDFm9e5OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C16k3rvH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177BF6074F92;
	Wed,  4 Nov 2026 21:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C16k3rvH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A021F00A16;
	Wed,  4 Nov 2026 21:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829533;
	bh=wQHVmvCnLwdZrEcH/gg5eY9HXGhLhTxT9Muxl8Y0CIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C16k3rvHktXXuOHPsER8uF9femg7C3+0vBOBbTZyanx44pBSWWeNWOCuVdCDjLqPp
	 798WvBMzc0tCGmrxp0hJYVLq5yKqGYtfje/1SntKd39gIrrLxAsaWIa694Q2RU0+w4
	 DCJhNvqbKyibCXIlLF1qjLUAjQxOhDQPVG9x/Lyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0187/1005] misc: bcm-vk: validate write size before allocation
Date: Wed,  4 Nov 2026 15:58:40 -0500
Message-ID: <20261104211049.025285661@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit f66c40cd90954f52809b3eabd386137f56bb6215 ]

bcm_vk_write() uses the user-supplied write count to size a
flexible-array work entry and then copies count bytes into that array.
The allocation expression is evaluated before any overflow check, so a
very large count can wrap the allocation smaller than the subsequent
copy.

Reject empty writes, check the allocation arithmetic before kzalloc(),
and initialize the __counted_by field before copying into to_v_msg[].

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260629160605.29412-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/bcm-vk/bcm_vk_msg.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/bcm-vk/bcm_vk_msg.c b/drivers/misc/bcm-vk/bcm_vk_msg.c
index a36a6c7d384a9..4663d758de3ce 100644
--- a/drivers/misc/bcm-vk/bcm_vk_msg.c
+++ b/drivers/misc/bcm-vk/bcm_vk_msg.c
@@ -9,6 +9,7 @@
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/overflow.h>
 #include <linux/poll.h>
 #include <linux/sizes.h>
 #include <linux/spinlock.h>
@@ -1090,6 +1091,7 @@ ssize_t bcm_vk_write(struct file *p_file,
 	u32 q_num;
 	u32 msg_size;
 	u32 msgq_size;
+	size_t entry_size;
 
 	if (!bcm_vk_drv_access_ok(vk))
 		return -EPERM;
@@ -1097,20 +1099,26 @@ ssize_t bcm_vk_write(struct file *p_file,
 	dev_dbg(dev, "Msg count %zu\n", count);
 
 	/* first, do sanity check where count should be multiple of basic blk */
-	if (count & (VK_MSGQ_BLK_SIZE - 1)) {
-		dev_err(dev, "Failure with size %zu not multiple of %zu\n",
+	if (!count || count & (VK_MSGQ_BLK_SIZE - 1)) {
+		dev_err(dev, "Failure with size %zu not a positive multiple of %zu\n",
 			count, VK_MSGQ_BLK_SIZE);
 		rc = -EINVAL;
 		goto write_err;
 	}
 
+	if (check_add_overflow(sizeof(*entry), count, &entry_size) ||
+	    check_add_overflow(entry_size, vk->ib_sgl_size, &entry_size)) {
+		rc = -EOVERFLOW;
+		goto write_err;
+	}
+
 	/* allocate the work entry + buffer for size count and inband sgl */
-	entry = kzalloc(sizeof(*entry) + count + vk->ib_sgl_size,
-			GFP_KERNEL);
+	entry = kzalloc(entry_size, GFP_KERNEL);
 	if (!entry) {
 		rc = -ENOMEM;
 		goto write_err;
 	}
+	entry->to_v_blks = count >> VK_MSGQ_BLK_SZ_SHIFT;
 
 	/* now copy msg from user space, and then formulate the work entry */
 	if (copy_from_user(&entry->to_v_msg[0], buf, count)) {
@@ -1118,7 +1126,6 @@ ssize_t bcm_vk_write(struct file *p_file,
 		goto write_free_ent;
 	}
 
-	entry->to_v_blks = count >> VK_MSGQ_BLK_SZ_SHIFT;
 	entry->ctx = ctx;
 
 	/* do a check on the blk size which could not exceed queue space */
@@ -1355,4 +1362,3 @@ void bcm_vk_msg_remove(struct bcm_vk *vk)
 	bcm_vk_drain_all_pend(&vk->pdev->dev, &vk->to_v_msg_chan, NULL);
 	bcm_vk_drain_all_pend(&vk->pdev->dev, &vk->to_h_msg_chan, NULL);
 }
-
-- 
2.53.0



