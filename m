Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050403;
	b=MWo1oHwBuvNUpAJa5cSk2xssFaZuTAeN1wDGCqOJa3TrPB2L9MDhZxVxIt/5YWBQOPcN
	 TD/4EegjjAMJ06mBqM4WJVxtJyFnqE7IscvfpQZNQVxnMXVmgUSo1JZmwhS4xdL/+9GlK
	 OF+M75Ubk62g12x/vTrFJdHgeaYpxLL902y8xPmAOiGrZpes4uuuaHwPsm0RHBba+gAPc
	 jRZITndN+Je5gW1OqvbUjvGf3pV5rEwcK0J226EAmhqnT7qaLhpOMNKXE751zCJ2l5tzi
	 Co5bGbi6DqrgRtuJ8bTXnRK1pT6r+VSbnYIPfDpN8Z5g+FbUW5bJJU2u1t3XFYXRzCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ug2+TygJQE1PCBhLOo3iLnxPg7G9LW3hgPL6ZVE05+w=;
	b=sN+w4TnXC+fUyPD9vKZEKOJFu5lo8MgZVGUowbI+MUvHcPCaB5N2f1faU5pWqdgR3jfy
	 FqXQnML8z21FfczIfxvbcFhqKqEQIKS0jlQPmG6yFDZn/G1Ai/P3b8qClZl6IiMafUfJL
	 y9/qkPU5vcexMLpTtYoZppmJeE1rUzRnpeV2YexEjPR3xRIRZOxlniN/lEHjpq8mehEgf
	 e/QaSCPO970vFXf5a8vAGgGnFsgMTwAFDXYopwMvOlSJicNgwlxGt3ZXUX0RFrJ2W08L7
	 XYmjjwQLzMliFCWUpJepSk4UKy7xNNiFioC53NCit7RY8KCO8eoOa3vuLjEX5nwzuZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ON+TtpiK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F488606A31C;
	Thu, 19 Nov 2026 01:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ON+TtpiK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97501F000C4;
	Thu, 19 Nov 2026 01:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050403;
	bh=ug2+TygJQE1PCBhLOo3iLnxPg7G9LW3hgPL6ZVE05+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ON+TtpiK8XlYsP8hYojmdDZB3trv2QdfMDolw9ARmTc+0RVkWubSeMZsQExMRq69e
	 7aEZPs1xJQeLxl5sJxOHaly95nQ35hgIDUg+iEC2XRBb27+Gp8XRcq16PQ9G7HYkzK
	 rV7KY5RNg2z/isDef2SGftHb3OY2L6QPCkwmrA9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyi Chen <hi@tychen.cc>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2695/2857] eventpoll: propagate wakeup source creation failure in ep_modify()
Date: Wed, 18 Nov 2026 16:02:09 +0100
Message-ID: <20261118150338.601891685@linuxfoundation.org>
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
index 799fdf442e433..a58cfff09c93e 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1587,11 +1587,22 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
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
@@ -1599,12 +1610,9 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
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



