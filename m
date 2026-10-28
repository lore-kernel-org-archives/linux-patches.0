Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213838;
	b=ia3A/4VGWqcN2wOpAJGdvUCVDXjFghw57aNSNHqVKwBj0FooaGqKhAY1pugnzgVmJVMa
	 XrbhIafz74JJnPSGDVutwnsXJeDXUqLKTlvFqmD8lUokBu0O5OTy4tLZrEDLZc4Titl9/
	 xlG0BzEeyY/T30AVnvj9QWY5YwNnHK/wGIyu/HwFVPZWkrloFcECHdhwuyBg758TWix1W
	 NrH4hPiLob/da3LV+KEmQFpSJX4IC04JwmCSZ9r7/JlsmgB6CSEDNTs4Lbdn2c1G30B2Q
	 6oQr5QeZdVeT6yUG7KzxWuyZh3Xc/Alcz+hblBYthbzbKBK5t6bRCJMtUvV4nULIh6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=87+q0d/9iCrrAR7G9WFVNuAPYi5jyewbi3YZuW419qs=;
	b=AiNfAHcfVVeOKNpS1nLfkSJU1ot5UVuw6yOTW3nX4cRB4z+bkqgSXEcXEXbTSfxgFoys
	 +1ykUz6yTLr8mfMTK9ihnjrkAKgHIUIciD9Tz8vLyAKjQxMgK2TmWI0GLROy22xgpbZu3
	 /id4hPUZYv+ec3+Y9qzJLfPHpQOuGfprU5vIr4gGcH01R2O6svl1M8sX5NZUEq7bTZdPj
	 rAYOa4A4gAOX4w2gH5HedaL6BNlkc3b2YzD7Xe8GbRQ/di+gYWGOApBdzZAlmbcJt0VIP
	 wXAbaNNNeV3XG4NwM5op3MIsXvOLWoARFmyZqxlBQIZNJ3CfXtps4IRZ3gd8taYgMZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U0Jm13Vx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AD1606A31C;
	Wed, 28 Oct 2026 18:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U0Jm13Vx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03C01F01825;
	Wed, 28 Oct 2026 18:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213838;
	bh=87+q0d/9iCrrAR7G9WFVNuAPYi5jyewbi3YZuW419qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U0Jm13VxCiABqlEc57Al0JmEodqUlex90HKdLlEMUJXRXM0TafmZ1ixBo9wjDoH1y
	 FZ4LzPJNpo1pdldaHW7PmEVi5bYYk/22iNKMR53TbiRwWM5GMhPkwloTLISfnuNB8K
	 bZ59opvKvObKGA+KOIC9dmg9WCwGm8CNZBkNNntg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0647/1887] pktgen: use cpus_read_lock() in pg_net_init()
Date: Wed, 28 Oct 2026 17:45:43 +0100
Message-ID: <20261028170514.134057343@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 979b581e4c69257acab1af415ddad6b2d78a2fa5 ]

I have seen the WARN_ON(smp_processor_id() != cpu) firing
in pktgen_thread_worker() during tests.

We must use cpus_read_lock()/cpus_read_unlock()
around the for_each_online_cpu(cpu) loop.

While we are at it use WARN_ON_ONCE() to avoid a possible syslog flood.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240821175339.1191779-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/pktgen.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 23ec71a882906..9756e9f9be645 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -114,6 +114,7 @@
 
 #include <linux/sys.h>
 #include <linux/types.h>
+#include <linux/cpu.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
@@ -3615,7 +3616,7 @@ static int pktgen_thread_worker(void *arg)
 	struct pktgen_dev *pkt_dev = NULL;
 	int cpu = t->cpu;
 
-	WARN_ON(smp_processor_id() != cpu);
+	WARN_ON_ONCE(smp_processor_id() != cpu);
 
 	init_waitqueue_head(&t->queue);
 	complete(&t->start_done);
@@ -3951,6 +3952,7 @@ static int __net_init pg_net_init(struct net *net)
 		goto remove;
 	}
 
+	cpus_read_lock();
 	for_each_online_cpu(cpu) {
 		int err;
 
@@ -3959,6 +3961,7 @@ static int __net_init pg_net_init(struct net *net)
 			pr_warn("Cannot create thread for cpu %d (%d)\n",
 				   cpu, err);
 	}
+	cpus_read_unlock();
 
 	if (list_empty(&pn->pktgen_threads)) {
 		pr_err("Initialization failed for all threads\n");
-- 
2.53.0



