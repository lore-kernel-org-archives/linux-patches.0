Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015168;
	b=Ma30m6C7NerkpR3yUlTI6JnNqpoTH4RRVuZ9FvRlVzjr9U0/ZaRmwl/XMSaKQnVtWH/7
	 2sWsLo0xgSUNNUy0OYrjHMJORNYeC3+2L7fY3TI6gDGK9xwQU8ZcF8ztgnVxPOJ3sYpJC
	 Hrjj6j3WTK6FDJ3QtKSz2EuSSozQg/hAts10M2VXSUldkA9fIztKcAJj3G3QeS1giO2A0
	 36weoudlBFtk+RoXZgE18lWaCeCjJliOWSHs9CQDIS5JDq3hPv7ex+FxWcV2M2Pbzpn/g
	 Le7YVkt4y9XdKKYKM/ojwGwQ3oBeWyZJWI3MIT+9RtmnRd5Fp+oWGkRV3aLF7aRWLUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lDj82vT8WGl9Kwt7p78xjzIH7k6fLWh9oYEJmMRF6D0=;
	b=YWkEDFYYvx+yawkbUfnjpv9UUo2CX2zdkJt6lF8UBKDO6ACjtl/fjfOAqjE363hvk0sD
	 qsmK+xq2ZdFkCuB0AZDVoF+oD7d06YZVDRMDi6k1QevErIvNayXMvSAZWt6BqD2kgDvHM
	 SQRoXtwvjE3XDHNaNB+46m6zfQ4IieC0Ryi+viN3vXICSKeqVCgXEvukhMHSTT29cfY2S
	 2ublus1Sf4kpoe51FYac2e0UckIEJTmJnKmmmno4dKA/8dpaxFzmVUHEHSMAIu29XJWLg
	 e2kjr2eHX77pMkKh54s9cyuNIiTCfM2Co/SeP0qFLYJjCZpX1eKuvZVmgcy5Iu2zUyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K5nxMycO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7BD606A333;
	Wed, 18 Nov 2026 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K5nxMycO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB9D1F000C4;
	Wed, 18 Nov 2026 15:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015168;
	bh=lDj82vT8WGl9Kwt7p78xjzIH7k6fLWh9oYEJmMRF6D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K5nxMycO2T2gZ48NmTgm7ohJ4PgCNk+aIws2HTfa6IXMHQeMcwOT7ez2+LRAhKGoy
	 5fg6ZeG7WA4gpQdczkMzLL16z2kA3J6pU7MuPzK0GTeneHLwBxN4LfdopVSLh/ejEg
	 B/mzAhDpjJQuoe1iBYKvg3jPPtSZaVv4Ks5t4q50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Chris J Arges <carges@cloudflare.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0025/2651] net: Use a dedicated flag to track disabled napi instances
Date: Wed, 18 Nov 2026 15:21:05 +0100
Message-ID: <20261118150248.888326659@linuxfoundation.org>
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

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

commit 8dc87fc5d6a0eb337744737008177342a708bf36 upstream.

Trying to disable the napi threaded state while the napi instance is
disabled will hang forever in napi_stop_kthread(), as it waits for
NAPIF_STATE_SCHED_THREADED to clear.

This won't happen until the next ____napi_schedule() call, which won't
happen as it's disabled.

This happens in 2 instances :

 - Drivers that create but don't use napi instances (stmmac's rxtx napi
   for AF_XDP for example), here it's a driver bug

 - Drivers that create their napi instances in .probe(). Here, setting
   threaded off while the interface is down will hang :

   ip link set eth0 down
   echo 1 > /sys/class/net/eth0/threaded
   echo 0 > /sys/class/net/eth0/threaded
   -> hang

Checking on netif_running() isn't enough, as napi instances may be
transiently disabled when changing the MTU for example, let's use a
dedicated flag to track if the instance is disabled.

This allows immediately disabling the kthread when the instance is
disabled.

This was tested on mvpp2 (probe-time napi_add) and stmmac.

[ Backport: place the disabled state after the threaded busy-poll state;
  the adjacent per-CPU NAPI state is not present in 7.3.y. ]

Fixes: 689883de94dd ("net: stop napi kthreads when THREADED napi is disabled")
Tested-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20261029153130.121204-1-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Chris J Arges <carges@cloudflare.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 15 +++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3e64af0b932d7..02119fa153c97 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -433,6 +433,7 @@ enum {
 	NAPI_STATE_SCHED_THREADED,	/* Napi is currently scheduled in threaded mode */
 	NAPI_STATE_HAS_NOTIFIER,	/* Napi has an IRQ notifier */
 	NAPI_STATE_THREADED_BUSY_POLL,	/* The threaded NAPI poller will busy poll */
+	NAPI_STATE_DISABLED,		/* NAPI is disabled */
 };
 
 enum {
@@ -448,6 +449,7 @@ enum {
 	NAPIF_STATE_SCHED_THREADED	= BIT(NAPI_STATE_SCHED_THREADED),
 	NAPIF_STATE_HAS_NOTIFIER	= BIT(NAPI_STATE_HAS_NOTIFIER),
 	NAPIF_STATE_THREADED_BUSY_POLL	= BIT(NAPI_STATE_THREADED_BUSY_POLL),
+	NAPIF_STATE_DISABLED		= BIT(NAPI_STATE_DISABLED),
 };
 
 enum gro_result {
diff --git a/net/core/dev.c b/net/core/dev.c
index f803d8ba866ff..e0ce0fd728a8b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7266,6 +7266,13 @@ static void napi_stop_kthread(struct napi_struct *napi)
 {
 	unsigned long val, new;
 
+	/* Instance is disabled, we can immediately stop the kthread */
+	if (test_bit(NAPI_STATE_DISABLED, &napi->state)) {
+		clear_bit(NAPI_STATE_THREADED, &napi->state);
+		clear_bit(NAPI_STATE_THREADED_BUSY_POLL, &napi->state);
+		goto stop;
+	}
+
 	/* Wait until the napi STATE_THREADED is unset. */
 	while (true) {
 		val = READ_ONCE(napi->state);
@@ -7296,6 +7303,7 @@ static void napi_stop_kthread(struct napi_struct *napi)
 		msleep(20);
 	}
 
+stop:
 	kthread_stop(napi->thread);
 	napi->thread = NULL;
 }
@@ -7691,6 +7699,7 @@ void netif_napi_add_weight_locked(struct net_device *dev,
 	napi->list_owner = -1;
 	set_bit(NAPI_STATE_SCHED, &napi->state);
 	set_bit(NAPI_STATE_NPSVC, &napi->state);
+	set_bit(NAPI_STATE_DISABLED, &napi->state);
 	netif_napi_dev_list_add(dev, napi);
 
 	/* default settings from sysfs are applied to all NAPIs. any per-NAPI
@@ -7727,7 +7736,8 @@ void napi_disable_locked(struct napi_struct *n)
 			val = READ_ONCE(n->state);
 		}
 
-		new = val | NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC;
+		new = val | NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC |
+		      NAPIF_STATE_DISABLED;
 		new &= ~(NAPIF_STATE_THREADED |
 			 NAPIF_STATE_THREADED_BUSY_POLL |
 			 NAPIF_STATE_PREFER_BUSY_POLL);
@@ -7772,7 +7782,8 @@ void napi_enable_locked(struct napi_struct *n)
 	do {
 		BUG_ON(!test_bit(NAPI_STATE_SCHED, &val));
 
-		new = val & ~(NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC);
+		new = val & ~(NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC |
+			      NAPIF_STATE_DISABLED);
 		if (n->dev->threaded && n->thread)
 			new |= NAPIF_STATE_THREADED;
 	} while (!try_cmpxchg(&n->state, &val, new));
-- 
2.53.0



