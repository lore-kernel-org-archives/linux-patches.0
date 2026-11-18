Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062008;
	b=aL7nEVtPU5KlVyuM/JZ5VN+hue2CIM9MT+8ZQPyLh1W68Y06GwS0Q3G7CaWFRGAhkx2G
	 jQa/s3rWL/rfUNrU5HM9lz1pDEBzgbJu/tSpm7J4eo1ToiMZMZSMYpd3eaPG54aZ5kXl2
	 rh9tPJ08M75nTldNeY5lOGeKop74G1zJSMrh3aMdLYaeT5/7QfXTb9IcGX2R8FpXQgTLs
	 tVqI2fiVX3WMzSxDhNEN5tRhK4k6DgAB8lc2jKFOVV9iDw3OxuNbSIFjbwA10oFN6KnsW
	 oX+rHW9ro7sZ1D0egH4/fAhSmA+VGmheShKSeo3EuKqTUHXxeJcUcrZpVWBgrg2tMWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WqKLj8wlmEMZpikjnU0h32wXmg4j0FB6jXpLu/u/J3I=;
	b=hSQoZ1HQFr8Aki7r0ES4KjHcPM8rBDbKAamfuWB+Cq+7/Dl5rGq4tfWQMek0t7U6KJHD
	 Zy7sEfgGpJscg36ibSuK8As4qtfKGDUizLMElZpZj9In7OoxYB8fwEU3pU8ClupBXdIsV
	 MCgJWL/9E2ILEBl8b9ueGj5qcgsW88IfRjI1KsaNXG4e+024Qcg8aPZA/5e2eqEwIlAYS
	 nZtq9CROVI3qU51GRWwf3tSyNF3xp4/09l5mBf8bUXy3MFFogb+nP9ZlMuSEWhYkOmVCE
	 bsPl1HbBQb4TZcY5SOb5EB05sONjkeTfMOmqxh4qWwfH9XnlwOEp8CmFDr+craOWGWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iJMJZFCf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4507606A32A;
	Thu, 19 Nov 2026 04:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iJMJZFCf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BE71F000C4;
	Thu, 19 Nov 2026 04:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062008;
	bh=WqKLj8wlmEMZpikjnU0h32wXmg4j0FB6jXpLu/u/J3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJMJZFCfX/JdWLiwglr+PPEEtnNXU+nUndNwElvUJNqLVVR0JAroa3DllvjZSJSRl
	 0n1aPYewzZvKm45C2vgF+FEfVbovQ77p6kKjcDu/Ma5CyJoqZCTo/8RSL+3kplwk4b
	 VCc+ynqwgkDfYlWlS+GXgJFLHTlXj7WHBmadN774=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyi Chen <hi@tychen.cc>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1757/1848] eventpoll: propagate wakeup source creation failure in ep_modify()
Date: Wed, 18 Nov 2026 16:03:15 +0100
Message-ID: <20261118150033.004903465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8962ac6eeef47..8cf4354e22e77 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1635,11 +1635,22 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
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
@@ -1647,12 +1658,9 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
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



