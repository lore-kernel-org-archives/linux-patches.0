Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043167;
	b=SMbrYOh+Q5GWfELog51CX+msLWyRgQGGJTBxtzbVodx3Bi+kO5SB00k+fRRfC4gESJ3u
	 dnOAnhNarCCLkHX7ZozpHl78BkC7QEkSA+jrSAGGkxmhRCAeRHhKzkF0pucNeI0IBvrSa
	 G8TUbHuaPexk1lolSh9OOqhrq+IpxX8L8qSut+/9c5wmN5mZCglVHOD5h9BYKTn3ykgjQ
	 gEI8h/JGB1U6f/RiSijLlZahquyfMwiltCLQcO0Ej88gi5UY6UBMtSOHqma9zLfx1n4Ut
	 O0jHHh+QBDKQNX5yHmmXZai/Q3WWdZzRPOf0xh+QMj8loOXwQPW7DZyqikHwO2MHSYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UiSlzbL9UJwFG5SSsWCAFL0uuSdp0ABVFp/54gX14uY=;
	b=tjt4gJOsTZqnFG9qJz6S5BLTYKcqQS7dLzkrsXnLkMSwJ7+Plhf+dXCNTwV9gqvQ+Nna
	 SoB5HZJSfDpeMDy7UpTcdZbVVob4vd6TOrGmY9zn6HDIhGt9P/BAeDLKt0GBZz5iBjpQC
	 cqavg9EyXsTUTVhTvHjcu8HcN9TdNCsXsUIi8BLjqkdj27ZmNcpGIvVAesILZ4Yk1k+0C
	 zPFOBcWDBQZnJCGWOcaKEiKw6GKBb2ikxnIvaIKmSLnUh6ikF2SD2JWP10XTjeswmlmNL
	 m1HZjLhsq/WF3CbyfEfG6hOfCerWx0meut5cDdg8XMlccskekdAsH9TfVaARccFdCew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Su37CTC5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5391B606A31C;
	Wed, 18 Nov 2026 23:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Su37CTC5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715B71F000C4;
	Wed, 18 Nov 2026 23:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043167;
	bh=UiSlzbL9UJwFG5SSsWCAFL0uuSdp0ABVFp/54gX14uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Su37CTC5dbonYCkkFygAsDZK3nuWaHnzJuM6AwkkWAvPxQ8kNLKbpQuBgdNKPGqCL
	 9wNbiKcrDB4gc2LkoT4+dbg+8YvtKcflriyMo6T69JoTAU3EyuK01Wt9ezEtBKp2Uf
	 2qvbvdBgNPifPYkJabGlsWSyVHlv5DFTMhk/iWrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0115/2857] misc: bcm-vk: validate write size before allocation
Date: Wed, 18 Nov 2026 15:19:09 +0100
Message-ID: <20261118150205.500280540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3f98979dd0fa3..5c465aee8d277 100644
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



