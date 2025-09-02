Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0E6BA4A;
	Tue,  2 Sep 2025 13:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819809; cv=none; b=gprwdRcvKIVxU7CLKX4az5jGMLJgALv1+HBN5+oUSGbTFAXRglMGEyP9aIzSx9ZlpXoBnbA2oMWjuZYe1BSkjy9G0+wzniOhj9J6scDlZbagp/EHyDxxVEPOfNm1QWiPfq8Knliel2MYSgWKmGzr1UKW4QmZcXCxglxJUNXztQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819809; c=relaxed/simple;
	bh=gZfWNp2pRVcRo+93AMOohDkZrVhTEXMVf7fJbi6EQLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p75kpYjofY/RXo4qQVHUoBC7QULkYgbU/PSPpZj9mHmXYM4dSqR54W8zymdGs1Nl6mdOaBl4ZrMs2OPd3zXjEiy5KvnI/eoyF1nFrAaiKyQtyE1p1ZTa1L2Eda9JC1eS0RwmDDqv8zYYNi4cyYm55LcdckO93Zk1yDu5xRypsQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNibNbCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNibNbCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E5FC4CEED;
	Tue,  2 Sep 2025 13:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819807;
	bh=gZfWNp2pRVcRo+93AMOohDkZrVhTEXMVf7fJbi6EQLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNibNbCycH6kjx/cyee9Mo55jugHl0c0STzLVRauYQwOkeHB9O7u8Gj2XclGP7wxl
	 zGCZOTZ7HsJLUElau2WYft8eI0BqP9fie7tK3CW40kXC7yqXe2FvpBL5BEG4ocidc7
	 3ACmbor0PRcjUtF+nVA6WZ/LL2sboA6sLYhRNE7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2eb8d1719f7cfcfa6840@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Takamitsu Iwai <takamitz@amazon.co.jp>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 134/142] net: rose: fix a typo in rose_clear_routes()
Date: Tue,  2 Sep 2025 15:20:36 +0200
Message-ID: <20250902131953.417665873@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 1cc8a5b534e5f9b5e129e54ee2e63c9f5da4f39a upstream.

syzbot crashed in rose_clear_routes(), after a recent patch typo.

KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 0 UID: 0 PID: 10591 Comm: syz.3.1856 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
 RIP: 0010:rose_clear_routes net/rose/rose_route.c:565 [inline]
 RIP: 0010:rose_rt_ioctl+0x162/0x1250 net/rose/rose_route.c:760
 <TASK>
  rose_ioctl+0x3ce/0x8b0 net/rose/af_rose.c:1381
  sock_do_ioctl+0xd9/0x300 net/socket.c:1238
  sock_ioctl+0x576/0x790 net/socket.c:1359
  vfs_ioctl fs/ioctl.c:51 [inline]
  __do_sys_ioctl fs/ioctl.c:598 [inline]
  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:584
  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: da9c9c877597 ("net: rose: include node references in rose_neigh refcount")
Reported-by: syzbot+2eb8d1719f7cfcfa6840@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/68af3e29.a70a0220.3cafd4.002e.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Takamitsu Iwai <takamitz@amazon.co.jp>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250827172149.5359-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -562,7 +562,7 @@ static int rose_clear_routes(void)
 		rose_node = rose_node->next;
 
 		if (!t->loopback) {
-			for (i = 0; i < rose_node->count; i++)
+			for (i = 0; i < t->count; i++)
 				rose_neigh_put(t->neighbour[i]);
 			rose_remove_node(t);
 		}


