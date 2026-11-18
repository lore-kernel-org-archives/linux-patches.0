Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027758;
	b=lOpFzANoYJGj7F/DFx5gTfBSHQLgjrpbz5Mq3Uaiw7bFO+jmbZ+cY9YPp/x4wnQCU25W
	 WP4cQJsSsukDHgBzAwy4kKX4bz4bXILkQ7fqm3AjYPrHw6+awL5+jheBF5hpQmkH5KgAi
	 6Gi8XtJvnw/E44HfmjxGp8KaVIknq0ttwyc30UlmX9uVnXuP6mY/pfilCgx0YYlFDlrOU
	 iZs3Xm82u9NUrFM0XpnjNJThGfHKVndkK9ljemSYCW1w+zKxULvLYJmPcuTbmd6NmmVPe
	 mt5kUURpJFj5JJsClzeVKFSwyhjpKQfkgWHYrf7Zj+V6OqblgJVZtYH5ftVszQFE0AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zh8AFXsp3zEupz9vmVcB6233nzkINup/CflMAgagh9E=;
	b=fAP7XO99RwxoRqjEhhcPvu6Qpk7HsHpQj6nE28hYG/MUjhM0oWZ/pwIr4yOczogqIeUs
	 QMTKid9gh+/aYoL8Zxj2bUJtNnMF4iBZMax4glKRYJVbc5VU0RbiMpjS7HrtErs1jQOOB
	 0eMCE8Ph0uOSLFGsahWVlJUISuzdzZosZXT+XpSCpjsG8zKuDuorooWqRspL7mgymzswh
	 OJ/4io1KZimZQIt4SOn8yhLCe4GV5ZxwYaAGzUVSBpk2IjNhO7Yg6F08N5tvm9+WUOB6Z
	 N7LBeh/ocWXi255UHDiibdovNWZn5EmyshH11epamLcPrGAFMBtocUQDliqLUW+7SFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PeX+Qeen;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC679606A330;
	Wed, 18 Nov 2026 18:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PeX+Qeen
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E34B1F000C4;
	Wed, 18 Nov 2026 18:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027758;
	bh=Zh8AFXsp3zEupz9vmVcB6233nzkINup/CflMAgagh9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PeX+QeenV7kro1rJlGt9kYLVfzxuSN4szg0tq3T3z94Y3Jm8glHCa74BcCmvEMwtX
	 8chJJEh1GJMDkNXligt3HojsMKzz5I1Ir2HjUfPMVNfviVRO0Hji9rSecBQSjz5N+D
	 jcafyxYPCG5ky8pC1loA3HKCG/+1HoYFomd9Qi5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyi Chen <hi@tychen.cc>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1902/2151] eventpoll: propagate wakeup source creation failure in ep_modify()
Date: Wed, 18 Nov 2026 16:00:37 +0100
Message-ID: <20261118150231.079707789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 1c31ee84dbe59..206b91a539a13 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1926,11 +1926,22 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
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
@@ -1938,12 +1949,9 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
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



