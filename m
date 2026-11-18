Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032740;
	b=I1hE3PlxPZzpdSLzCkNsUCNlZlk1y06MI0gMRffJdrOv5gVs9meqmSrj7BTmbGoG45b/
	 L3Ke9klzRxBi+3hPrP98QWYull70f9mOlqm87HyBd+1fnMAE7A/aA4vMOhTb0sz19Jfwu
	 W76z7yXiipj8Pw3W0t6Ur19U1b28cgUi21+Rg3EGep6/cg5Db5sgnvtZRgd0BqvRN8Na5
	 UbdItRyC1Dlw7j2/TzOtNQhyuezSLX9YpGuCr+yc74DKLy62yxHjVvmq/yJZaUzlATIaU
	 +pt7n5POhR/7rAro8VrHebHXBuWRGzLrmkezlfaXMafCTDV+vWPRJ+792sgOdmSfO4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2t0LeqeMl4uKYKxxp+Pf7VxvAcFHFO8ap/mGRG2Qgaw=;
	b=X2JQ3sM6t7P6AVoY+3oj4uJFXqvlEvSgSI0bBD4L/RYN4CITfjZkn59pjbEFbeA9IvYh
	 aWzDeIaKRTiuciUy5AgxRF+pYA81hTxzxaKt5J7mA0j5Ii6y/NCwN+AI3Z9/V7PYGuUgb
	 bGKMMSmBqwUk6iizOp7Y+5A4AgqR+AsEcWuh8aQaKTTgrTutAhz2fiQLR8xmrWNjEen1/
	 gFnPSm0QvnaKoV044J6e7AVtYBSOO8g5HOcalFnj/4pmXqxTngXIjPs99pqg1llefTrcT
	 mX2XwE/rZ78/8P0JL6Wf2vkuUdvXmo4XRv60RgBG38tf3yl/u4A7NmEtJv0I8RgTLdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hc+hEI9S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60130606A320;
	Wed, 18 Nov 2026 20:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hc+hEI9S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B870F1F000C4;
	Wed, 18 Nov 2026 20:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032740;
	bh=2t0LeqeMl4uKYKxxp+Pf7VxvAcFHFO8ap/mGRG2Qgaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hc+hEI9S8672+ec8pDk3Dml6yC8ntHcBygf1k+udZQ4ODpbmd9dPQBKKs7/mVdOT4
	 FrQ2b3CclJlh3/qH7CX6jyLJGCysdaWyvTvszUwziaSCLZqEbOmODX4h+gUqQFeHsU
	 doHU785/5I8+EaKP8WfyhhIbAGrSESwjLlgFG8I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyi Chen <hi@tychen.cc>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1520/1756] eventpoll: propagate wakeup source creation failure in ep_modify()
Date: Wed, 18 Nov 2026 16:00:47 +0100
Message-ID: <20261118150109.365284446@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 665a1528ab579..538c57469395e 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1912,11 +1912,22 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
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
@@ -1924,12 +1935,9 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
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



