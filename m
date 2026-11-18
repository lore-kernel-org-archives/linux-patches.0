Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018123;
	b=NU6mGk52133ve7dz8ZLGCOmO3zMj5CQnkkJF1tW+wDKZSWm0X45lBZ3q8eePAgCm615p
	 z8pTnM4ZDFgSfAR6BsL7nPLv4Yk6GM1MKZMQwm5k1kV8+wKG43GsHZsTWyGko0F91FOkJ
	 lbUh1+Wk+JHVQHwR1JLCKpv+cfpQLm48gfToUc1I0Ch39oBzWcqVEQ42cTTmNGCQU+mUw
	 dN5zSFf80JDElNCwGTH8jOgzCJbuSaoZweU41GDNh3aCvnTk5ysLBNKdFXWfZVH8Y5Lf2
	 YA2g44qnRrAlrKO+62gX5zywRqydcPmbAhWHRilUpuvM1rl8AY03wJV/t0uQtpOR0GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jx9d8nM8Rr9hmZqxnJ7a4t9MsUxUjcMp6+lCZVJf3Uo=;
	b=K3TazeDz4mEMEJa/4VcIHqcMeQPCbnPPLbYVUYwo4fXtWDEnJO4IWvm9BXFFLNn5pTyW
	 2hubfzEvYnwq/rxBh95CNTvDf/jW0YY4+lT76SKQwGHE6XGTjjlHaP7bxu448D69KyuE7
	 XVaZ2/UPdmbctDBzsJRah1IGOLnudtD2XxzEiv79pfJpVEu8P4+6t+HbBYhGJAbSz0NzF
	 38YFWLqmU72Ghz/crC32p3qNamV8NypQXVcPakj3SLMKtEpz/Ucjgrb+2d2qeEJBSIxZB
	 WhLrkw3l9ydpqBhnnkVHh49rfnXgomPoFjMW772zSUajp1b7xI1F3DHXlqCRD3GZ09A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JFe7sGI1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F57E606A32C;
	Wed, 18 Nov 2026 16:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JFe7sGI1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E781F000C5;
	Wed, 18 Nov 2026 16:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018123;
	bh=Jx9d8nM8Rr9hmZqxnJ7a4t9MsUxUjcMp6+lCZVJf3Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFe7sGI14BNSbfwkxZJLRjLDZ6kgddbAeSYADthvrSLhgvb39tEJRL/RnwJ5/Gdde
	 9b89dX/Awd5hrRVNSi7SbHH8yHdvT4sEM+TLgzRRzHkK6kz24J7W8B1uXGHYUcMDW6
	 QUGB/qrIeA+FN0CTIzL7+8pwtuV5pOf+ahqSISfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1114/2651] rv/rtapp/wakeup: Use "rv_this" the rv_monitor variable
Date: Wed, 18 Nov 2026 15:39:14 +0100
Message-ID: <20261118150328.109655453@linuxfoundation.org>
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

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit 5e9bdf2924c9041ff1520b528db6104626e9ef41 ]

Commit d9e4c61a12dd ("rv: Use generic rv_this for the rv_monitor
variable in LTL") renamed the rv_monitor variable to rv_this. But
rtapp/wakeup monitor was late to the party and missed that.

So for this monitor, rv_this is an empty struct. The reactor fails to
work, because rv_react() checks monitor->react and sees NULL.

Correct to "rv_this" and make the reactor work again.

Signed-off-by: Nam Cao <namcao@linutronix.de>
Fixes: d9e4c61a12dd ("rv: Use generic rv_this for the rv_monitor variable in LTL")
Link: https://lore.kernel.org/r/20261001044218.3508990-1-namcao@linutronix.de
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/rv/monitors/wakeup/wakeup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/rv/monitors/wakeup/wakeup.c b/kernel/trace/rv/monitors/wakeup/wakeup.c
index 01b47416f24e0..2e803e79181e6 100644
--- a/kernel/trace/rv/monitors/wakeup/wakeup.c
+++ b/kernel/trace/rv/monitors/wakeup/wakeup.c
@@ -128,7 +128,7 @@ static void disable_wakeup(void)
 	ltl_monitor_destroy();
 }
 
-static struct rv_monitor rv_wakeup = {
+static struct rv_monitor rv_this = {
 	.name = "wakeup",
 	.description = "Monitor that real-time tasks are not woken by lower-priority tasks",
 	.enable = enable_wakeup,
@@ -137,12 +137,12 @@ static struct rv_monitor rv_wakeup = {
 
 static int __init register_wakeup(void)
 {
-	return rv_register_monitor(&rv_wakeup, &rv_rtapp);
+	return rv_register_monitor(&rv_this, &rv_rtapp);
 }
 
 static void __exit unregister_wakeup(void)
 {
-	rv_unregister_monitor(&rv_wakeup);
+	rv_unregister_monitor(&rv_this);
 }
 
 module_init(register_wakeup);
-- 
2.53.0



