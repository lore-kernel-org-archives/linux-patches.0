Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021570;
	b=aiUQGGlqn6/FfRFQAuvFhUybXBhtmQSm70kYM3Tuq0B1a/YcimCtRVZhoyxNX20AeICM
	 daLCbibhx6zEm6djDolbt8yD4tqATARLzVIGqGVeaeE8r3vjIAG6c9xrXqEQEImJnHw1d
	 egiv8ueW+9k0lnqp8VLAGEbYsa5DnJwPg1JJseOJiwg+UHKb1rLwWMzX34xtjNki0k43/
	 F+cxmhNwvaQP9UjKleRP0FpFnI4EnOqCP94rofHQE0tpoVSurx36D4Cx2QzRAmloSusUD
	 yNM80hDJCMmirqEHUhenmxQB6EzOOwrZGxUTXQ3T5NpeySp8p3KwWWbew+uAyaFR+Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ymue0rTduGOk6+9uowlQzV7tjNW09BPJpRnUrdiz5bY=;
	b=jvq4GX2xRiVmmmfsxPRm2kPn9AOUXWN7YIOglYO14My8jWlW5GUW4GQ/zBPSNyOlhDbd
	 +JwQE+1l/WkM8twOQ4hZLQp0s327d4btUMK2AqbBBklKIQw6lKheIA/SFlnSgCe5LYyhS
	 8Ddc1fMpAT2p9nN13dU060gfaRtiV+w5qJxvsVvGEec5aoby2w9+WuAzGI0lwolMifK9Z
	 CuUoJFkitvZgtVw9K8S+pRCIiWFMblcEnECAtXXzyCFl9n3KUKiz0Rw0SNhFU3L1oASW7
	 2IQegJj/LDsnVnqirEeN5zDu3zqkiCNtO/uP2OU+C7QTcU9ekvK720T0WVmMePw50MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ui5X4XN0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019EB60A2603;
	Wed, 18 Nov 2026 17:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ui5X4XN0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0C41F000C6;
	Wed, 18 Nov 2026 17:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021569;
	bh=ymue0rTduGOk6+9uowlQzV7tjNW09BPJpRnUrdiz5bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ui5X4XN0GyZfpywyDH2V0nA+iUswXptRV6kxf14Mw30CtSRIiiP530DQhh+c/t73w
	 EknB2VYRkTd6+QZVPYQh2WoP8dp4+B142c2hvfSQyXgJ1QLnIcb0+8Od7Vhf8CFoP2
	 g13N2KLiTp4PVpXi3uXWFdkydyi7nB5aD9DBM6w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyi Chen <hi@tychen.cc>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2353/2651] eventpoll: propagate wakeup source creation failure in ep_modify()
Date: Wed, 18 Nov 2026 15:59:53 +0100
Message-ID: <20261118150409.759117274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianyi Chen <hi@tychen.cc>

[ Upstream commit 9f2b8f4a452db79741c06e6ea91448347f4a975c ]

When EPOLL_CTL_MOD adds EPOLLWAKEUP, ep_modify() ignores the return
value of ep_create_wakeup_source(). If allocation fails, it returns
success with EPOLLWAKEUP set but no per-item wakeup source, so the
requested suspend protection is missing.

This can happen without fault injection on SELinux systems: creating
the wakeup source's sysfs nodes can require GFP_KERNEL_ACCOUNT
allocations for security.selinux xattrs, which can fail when the
caller's memory cgroup is over its limit.

Create the wakeup source before updating the event mask and data, and
return the error if creation fails. Leave any newly created per-epoll
source in place until ep_free(), as ep_insert() does on failure.

Fixes: 4d7e30d98939 ("epoll: Add a flag, EPOLLWAKEUP, to prevent suspend while epoll events are ready")
Signed-off-by: Tianyi Chen <hi@tychen.cc>
Link: https://patch.msgid.link/179240281988.1700986.8309527041821666235@tychen.cc
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index e0c4bf88a8383..872396a0ad64a 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1982,11 +1982,22 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
 {
 	int pwake = 0;
 	poll_table pt;
+	int error;
 
 	lockdep_assert_irqs_enabled();
 
 	init_poll_funcptr(&pt, NULL);
 
+	/*
+	 * Create the wakeup source before committing the new event mask.
+	 * Leave the old mask and data unchanged if allocation fails.
+	 */
+	if ((event->events & EPOLLWAKEUP) && !ep_has_wakeup_source(epi)) {
+		error = ep_create_wakeup_source(epi);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * Set the new event interest mask before calling f_op->poll();
 	 * otherwise we might miss an event that happens between the
@@ -1994,12 +2005,9 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
 	 */
 	epi->event.events = event->events; /* need barrier below */
 	epi->event.data = event->data; /* protected by mtx */
-	if (epi->event.events & EPOLLWAKEUP) {
-		if (!ep_has_wakeup_source(epi))
-			ep_create_wakeup_source(epi);
-	} else if (ep_has_wakeup_source(epi)) {
+	if (!(epi->event.events & EPOLLWAKEUP) &&
+	    ep_has_wakeup_source(epi))
 		ep_destroy_wakeup_source(epi);
-	}
 
 	/*
 	 * The following barrier has two effects:
-- 
2.53.0



