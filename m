Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060739;
	b=JbLeGwHeXtxoXhp0NOebMaW0dnhgRUCD0aRC56PMrMsjhXiebW1A9aaH1a7zp2/ncPq7
	 BEuRlZprIKATwSBIyo6lVwRmJfN7klo19wCppDibD6BITFvqtSZ2/3sTr5osllL119wrD
	 4d6oZkijY47w8tz5afB2L2AJHoFnY70Qsi5JaHyCNc/obuCCrVqZkglgrgy2Y58r/O7pm
	 7T9GEDHERVS0P7zBJ457j3LS4OYFUJpUEjJdfeLYMOp6pBD+HARTwWo43fppd/LItq9DN
	 XZ0FCM2NMDX1vbN0CYK04itgrNOMFWNp7b+eDahN1H/gITbbtieZdx7QnJ5NEYvg4kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fojnrgH65hH/mWvb07oVB3Oa/EGRonzhOxxr+XLEtzM=;
	b=U1MywTpWXkDEjuMEOnruvv2wX1mEKDinasqlU+0GV4r9+HPcgusQubsmPtJMKz1ljxD2
	 9TGgZUc6tG7qaFU+FSro0Io/ty2YQ2Z//vhV20tzcB+LGKwRAvmvDJWlEaoBSXPWOIcZQ
	 PUh4debGPw7Cs+DvK+GOFFItu5MWfTzyfzZKt6dcrE7hh3Et21qKOa1NbyLInL8EtRvaE
	 1rBwS+EDHX+GsNBdsHCsOHJ79m0xcq2FnzjKhLPsecFHb9HmWpihQO3rEiDUwjDHnmr8P
	 uLnEYsDZkBmG9mP8vV3WsFnUV1FxnLRQZpfc1eu7jK8RSbyBVWkyA98BBVyuUeIz1TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f2APgXzi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057A7606A326;
	Sat,  7 Nov 2026 14:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f2APgXzi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25631F0089F;
	Sat,  7 Nov 2026 14:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060738;
	bh=fojnrgH65hH/mWvb07oVB3Oa/EGRonzhOxxr+XLEtzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f2APgXziQt2XfJ5hxbZOiZaUmcKRbEDWC9DgPBO66MPrkLrbAbLxx1p68iy0r5916
	 YPUVRPjSq7GE8HsB7n2vC6bCDKMsbKFZwUvJm4HihhGGhbSRigof1DeL/OsKRF7Yq8
	 TsmNwOcw8cc1Jg6M/Xzwh3e8LIEcLx38oIgBMZf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0155/1536] misc: bcm-vk: validate write size before allocation
Date: Sat,  7 Nov 2026 08:36:11 -0500
Message-ID: <20261107135002.033133832@linuxfoundation.org>
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



