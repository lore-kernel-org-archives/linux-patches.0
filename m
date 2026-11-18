Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033769;
	b=cHS47WSuIQeF41okVC0yT6EBr1TYDVRKuKRFtz+JJQW6VwTVd2DF6zR+HIkrH73leyG4
	 0CYm5iHB9oWmnMQnAjuqE2wo6ThV/ZS/dWvlQgevya3OztpV1IuCzQ2/5ICFjpJoOPzhC
	 spMYGk4MvkvUZT6UPi01/WpAGloTrTFsaJZevDE2x+PoPhKWHzAOtDUOwyOHrjt/iL0xw
	 opZOTLDnMFyd+KCvavA8JmXWlQc+2QqyeW2kpAcLg5hUbM4IA4y6ER+4rSYEUEg9muOfp
	 9YHNDLna/Oqzv/uohq78Hwj0Ti9fWwoyfyykNmujoe8HSYnzbK+x61k3ip4I4cYCEIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DuWbtBEx4dj4tAouLmhvI/2b8VbH70rjgIm4xQ+0LZ0=;
	b=NuWD0CI4l99K5DDm6ubLcxbSmr9wU/1Sx3v6RUZtrnNqlgNhkSE2Tkwrdf8hDHdT1pet
	 eunbmHcW3RZQS9KlEHOJ3gcXFjUxVMVysUTAu53bDUlgTIbeGpBx0/CNfLOzQJHlL3JjU
	 oZgCzfctrdwO0HCEmQROOi5p2thW+NUOIrj5Jl/CbxQxI0WgByR0TLyjP1Fk4FGrDQhF9
	 0wpXqankbvIZHrrjbod44LQEjCkCEzMRTgxP21dri7BuI7yVrwPzO5tFT+iztik67Xwe4
	 uKHoZTLVPMdJLFbzLT2Qp90eZKWET09dGASbOMedf74GLOrdqQoDeQ9p2EmeHcOcoTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aqvJA7cB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E16B606A330;
	Wed, 18 Nov 2026 20:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aqvJA7cB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A361F000C4;
	Wed, 18 Nov 2026 20:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033768;
	bh=DuWbtBEx4dj4tAouLmhvI/2b8VbH70rjgIm4xQ+0LZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aqvJA7cBj/5SafRl7xtmkFmXoJOct/g2P/yIK7gCLyNbG/3gWi/ImKY5sXntyQ+hb
	 FOhQD0Za8wk12STT25XDsYQ+NYJWxy6E0MhGwitcmpxpb8m68YGzQTywFXTwpky6zt
	 0R9RUcwWSn6szMZ4KGC6Svi4pDEcBllmTsyzRsoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0133/3318] misc: bcm-vk: validate write size before allocation
Date: Wed, 18 Nov 2026 15:12:35 +0100
Message-ID: <20261118150318.398291770@linuxfoundation.org>
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
index c339a83e4f4fd..0cdc4aec56522 100644
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



