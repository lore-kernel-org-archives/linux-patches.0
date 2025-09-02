Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7860E326D53;
	Tue,  2 Sep 2025 13:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820488; cv=none; b=oUFKPdTWqo//R2fd3hLjeGVRx4h3fGfEADobWxY4qDR+2H6FN7pzUoEQca0pXKn2eyvF/owBZvK7WSzZj4RC9EDCFaMwe7/k3WQEXFBcW2xn60jCh5e3x6u0L49SVTKx7AHpWPBBaAPtP6V9z6Nyb31sGGpHMteVsNVpsUiFLtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820488; c=relaxed/simple;
	bh=7q1BlMAkbaZ96ft7MociAFMA45TN8oatms3WeSMrP5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDxXUZWvVck2vLoXt9+UqbftE76cg2rV75sqHdQKJCzmLIKqDo6dyuRPUb7XjH3R6Z1G4fQbXqrotvKUydCiiENvXorxYJGz9upcxWqhR4iShNaIQQweRSf4B7lLTmA+FH3/wdCMmUq5sqyVBTZIhJKI/8fV6XuOIcGT1dCrTnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+qIo+PE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+qIo+PE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD78C4CEED;
	Tue,  2 Sep 2025 13:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820488;
	bh=7q1BlMAkbaZ96ft7MociAFMA45TN8oatms3WeSMrP5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+qIo+PEVfn/H3diguM2zjNrHoa1ff7dN3epgpwswo0KNKnvDO42FHfaTj16ehEMj
	 XSfgsQARYBuSUh9+r3r7bgnx7+yghzkBz/C0EaQUEEnGlxj3s0YlTm4MLhBLJJtpDH
	 tJkouUZWXCBjzQ/KrqLvc9lZtQFRNWPRVZSeE2/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2eb8d1719f7cfcfa6840@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Takamitsu Iwai <takamitz@amazon.co.jp>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 46/50] net: rose: fix a typo in rose_clear_routes()
Date: Tue,  2 Sep 2025 15:21:37 +0200
Message-ID: <20250902131932.342747036@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


