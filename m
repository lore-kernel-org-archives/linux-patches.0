Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213002;
	b=tcvlEq0oo7+ukOw5hCZYWBqLfXt1fDoiU5zF+7KUozVcTZ0Kf3ZUvA++DbAwIZZbgc20
	 V7i60nyvspElLcbsHypbbePLNB9dO+/u3ecy42qXZ3dP0pZ/NGcflYtvwubIm5VhiQ8QR
	 SOPeTcBtGAg3i7dcKZBX3iddWgJZC82LxS5wovg+XQEwQsvz8DdAsJpLp9ndY0uxStjbu
	 D07x33eBd/JnME1JwvdTDSh5xWqoD7cMP0DDvHYXJOeApPK6TcSRe4dn/YlSwj8e20FSt
	 Lpkk2zI0aIqSa2e5IVRsQ+VubFrP1k7kKbvZa13M8w4PapF2v4qz8Yhhc4Df3IC4okg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=57RoiG2Y1lH/ow6Pu6bPUVqxMNYpxSCj8SHzrhi4rrE=;
	b=C28Lwjr117Qi11RtGRKw6OzjY2gFIs3upLHqbOHvyLKWk3afP1fSuEZe2KnSa1jclE/y
	 xwz7aZZpV4GrlC+SNkVXoVRsGr2XSLBFBkgbq5sWyDkOE6bxp90JVqOuUY2LlmS2HbMvk
	 RTwlSMG0aAMWI3w1zLW+RegW0AXOUyqIaT1ZRuSCtMBV8v4SD1t9xx/VJDWIngvPvpm+V
	 LkpbZhRQ0oLvNbURhRqGQB0OhbnipdFE55krw2c4VKK3vZp6qTRKft0e6jbXshJo1TEA4
	 0os/kKR361dK7aaSmi7AsPMHtiuSAxYYama0YsViOVe+13pXFxKX/tQfpz4N7IQ6RqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYjHlsWH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1903606A31A;
	Wed, 28 Oct 2026 18:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYjHlsWH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5184E1F01825;
	Wed, 28 Oct 2026 18:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213001;
	bh=57RoiG2Y1lH/ow6Pu6bPUVqxMNYpxSCj8SHzrhi4rrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYjHlsWH8x6EBc4y1+0/I8E47ivOqDcOGjUHWmxTUvu6UFMM3MOAgcDERT8KP9C+9
	 svZ5oD1HogTm11YSX9MJOoYThtQOaSYjV5JvB4a2t6SHr902J7J2CtYIZeo0SWvbm+
	 +gnhy4O4EIC+rj/wD1TP+rHHagDEokL4Fy8I0xzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yi Yang <yiyang13@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0353/1887] vc_screen: reload vc pointer before if (ret) in vcs_write() to avoid UAF
Date: Wed, 28 Oct 2026 17:40:49 +0100
Message-ID: <20261028170507.263338253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Yi Yang <yiyang13@huawei.com>

[ Upstream commit 226bd5603371cd9f6642cbb9e9a677f445de3530 ]

The reload of 'vc' added by commit 8fb9ea65c9d1 ("vc_screen: reload load
of struct vc_data pointer in vcs_write() to avoid UAF") sits after the
'if (ret)' block, so the copy-failure break path exits the loop without
reloading vc. If the vc was kfree()'d via vc_port_destruct during the
unlocked copy_from_user() window, the post-loop
'if (written && vc) vcs_scr_updated(vc)' is reached with a stale
non-NULL vc. The '&& vc' guard from commit a287620312dc ("vc_screen:
fix null-ptr-deref in vcs_notifier() during concurrent vcs_write") only
handles the NULL case, not this stale-non-NULL case; vcs_notifier() then
reads param->vc->vc_num from freed memory:

  BUG: KASAN: slab-use-after-free in vcs_notifier+0x7c/0xd0
  Read of size 2 at addr ffff888007149190
  Call Trace:
   vcs_notifier+0x7c/0xd0
   atomic_notifier_call_chain+0x70/0xa0
   vcs_scr_updated+0x77/0xa0
   vcs_write+0x71b/0x7e0
  Allocated by task: vc_allocate -> con_install -> tty_open
  Freed by task: kfree <- vt_ioctl (VT_DISALLOCATE -> vc_port_destruct)

Move the reload to immediately after console_lock(), before 'if (ret)',
so every break path below passes a fresh vc to the post-loop
vcs_scr_updated().

Fixes: a287620312dc ("vc_screen: fix null-ptr-deref in vcs_notifier() during concurrent vcs_write")
Cc: stable@kernel.org
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Link: https://patch.msgid.link/20260901113131.2760010-1-yiyang13@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Adapted the direct -ENXIO return to set ret and jump to unlock_out. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vc_screen.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 27b44dc123859..22735ca14395a 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -643,6 +643,19 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 		ret = copy_from_user(con_buf, buf, this_round);
 		console_lock();
 
+		/* The vc might have been freed or vcs_size might have changed
+		 * while we slept to grab the user buffer; recheck here, before
+		 * if (ret), so every break path below passes a fresh vc to the
+		 * post-loop vcs_scr_updated(). Return data written so far.
+		 */
+		vc = vcs_vc(inode, &viewed);
+		if (!vc) {
+			if (written)
+				break;
+			ret = -ENXIO;
+			goto unlock_out;
+		}
+
 		if (ret) {
 			this_round -= ret;
 			if (!this_round) {
@@ -655,18 +668,6 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 				goto unlock_out;
 			}
 		}
-
-		/* The vc might have been freed or vcs_size might have changed
-		 * while we slept to grab the user buffer, so recheck.
-		 * Return data written up to now on failure.
-		 */
-		vc = vcs_vc(inode, &viewed);
-		if (!vc) {
-			if (written)
-				break;
-			ret = -ENXIO;
-			goto unlock_out;
-		}
 		size = vcs_size(vc, attr, false);
 		if (size < 0) {
 			if (written)
-- 
2.53.0



