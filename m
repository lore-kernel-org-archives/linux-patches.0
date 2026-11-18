Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056749;
	b=3rfWSpea90sCd5c0hqTlEYdz11HF+2pSF1OpdtbcywqjaZJ9eMU7qztDmXB2xjxls3rk
	 wQoRxe9q4Rz7RcJ8upbcX2IsIfeXdnN6jcQscAnfN+yNNZTHeOgT76eqIY/HgdO5c4nRp
	 TOpnI/yLniCkH9vFcd/xGLapmyp3xPx33wCjKtiFBola80ldNUztT37TeWPB6vUqweuej
	 yMSnHmorGWqV08MWw28wd+SumzIPW7ycYXjq2MVEp80AeAdFfYBjzST2odrbctyAmTaz0
	 4aToP2CzUYlFl/Wr5Dd+a4mkZco/a4uUcyXw7gXi9oFzyqVp4JAHZ9Vutfm0XJS1eZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OoL+jNOz/dZV5RpBLiTjNvQoX/GNsPl9njaMQqtX//Q=;
	b=dSuTtkRbKplSGoA8/wVk8NkDBXbDHVLHEBsvUg7ezcy7XRexbFrSmAruhC+0IFtNeDh3
	 YYWqg0fXlSMuNWMcixc+gJ7Pit+TLYy8tcKADUYIpZ4lL+CpvNkBRpYqigR14CBXwsE21
	 grEissn68DzJ/KTcV4KmOh5Qbr/7cTk0XxL9SBVfX2zstLUQHHBR3wK1ONBG6qaYeF4lB
	 Su+686ACgSF64FRQrkeM3n17t4fBpMtgyfkmaNY6CEYNVwaVryw7WcRtgTh7SAV/4tONb
	 z9PsdCSorNG5fcyEaBoaVaHcwAAa1lK7y+sGMqytvsdnes5l2yUtppGWkdVpnIoGfrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yM+CYx82;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2699606A32F;
	Thu, 19 Nov 2026 02:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yM+CYx82
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAF91F000C5;
	Thu, 19 Nov 2026 02:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056749;
	bh=OoL+jNOz/dZV5RpBLiTjNvQoX/GNsPl9njaMQqtX//Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yM+CYx82ZO999MO3SulPt4sm5gM1tFORxida1GoQMl7OLsezaJ61EdHm4wl78Gy/C
	 3XRcnZi8eUIhRnEBct/frUT7ib7aW9Fp5dJV4bO5PWvEopme4+tEVi9w4Z86czd1IH
	 LG+lRPBz65nDgNyHDYktSzLmUK6YNH8ABF2VFcYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyi Chen <hi@tychen.cc>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2099/2214] eventpoll: propagate wakeup source creation failure in ep_modify()
Date: Wed, 18 Nov 2026 16:02:55 +0100
Message-ID: <20261118150134.637304911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 50df3717f908e..2053d80fb84eb 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1667,11 +1667,22 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
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
@@ -1679,12 +1690,9 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
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



