Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022675;
	b=gOWUZN1CvgDN8OxOpQ59dIKW/MT3KUWcRgDIE4+Hdnizd1WFuoVz35n4zz21ix8ulkwr
	 wIR6/D8Q8JIusH0zBibRH58ofVWk13JuSVLPcE4itbhod3Mi7x5tc1G8eBwQ7pEFJTRgO
	 W07/Tzba33Zbm1ZzUSOSXe/aRaOitxU1pL/sNp+D0TnmotVuWjP36mnzIcnjPQHN5x0H7
	 TxcywcxR7Q7OK3CwR/c2mRLQq270jdnuha+7bVYYwjYWvpQpcBmeNqABJ1OWD3S+lN8Ij
	 ytaj51KVr9KQ36BgOnO2hFvDThy9VhVtm9gYJNUqmHee6cQo3dAYc9eHb52bfqyy+4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B8In5UecZdglJPHyLfxVFR8UhWfs0GXKkwVdymvucu8=;
	b=sddgiOYswbw1ou67W+U7DJCsqviDqZ56nIMBBrNGzvIhuidDwt9bxzfHBtAnoJsWw1M3
	 tUrtr2xTk7t0YbLxWZzsX7cMJHb43H5+3vhAtOC7yAsERwWzfhtjyNHveoe/NSKmahS1D
	 XOOPx+pXAdfwICilJrAtoqeTDKDGT2ktdeTbDiERPiqvNMzcpYu8vcluMjyycwg+AUIv6
	 7zLs54HrbC6JPkRutxyd2Q7lWz3mCMP4CdYt0BhavkboOIhAgpuBWByosMss/zxLHcxxb
	 MiIkGlcIi8eit1GR1LnI1i5m+Tka9AA9P42W7rfFnVmp1VSdDTt2VtgTKCPJEN6sLCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QmYCTutv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB6F606A325;
	Wed, 18 Nov 2026 17:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QmYCTutv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6F61F000C4;
	Wed, 18 Nov 2026 17:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022674;
	bh=B8In5UecZdglJPHyLfxVFR8UhWfs0GXKkwVdymvucu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QmYCTutvfFKmNsFq9/gQL03sVhXwPRg/Uppse5O0tgNf60kAMxlVbhpRsQP5h3+O+
	 B6jUeS6Qwn4L65gZE6P23d8GIUOnajvizyM63WJrW/VNSQsCMMk4Ds0jJtNhd6tMjo
	 4IpFyxoS9zDVUNpb8iqbe4T8xDQfY2z0HQW6HwEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Chris J Arges <carges@cloudflare.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0056/2151] net: Use a dedicated flag to track disabled napi instances
Date: Wed, 18 Nov 2026 15:29:51 +0100
Message-ID: <20261118150123.784354897@linuxfoundation.org>
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

[ Backport: omit threaded busy-poll state handling, which is not present
  in 6.18.y. ]

Fixes: 689883de94dd ("net: stop napi kthreads when THREADED napi is disabled")
Tested-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20261029153130.121204-1-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Chris J Arges <carges@cloudflare.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7be5b78b2bff7..e272d0006c6bd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -431,6 +431,7 @@ enum {
 	NAPI_STATE_THREADED,		/* The poll is performed inside its own thread*/
 	NAPI_STATE_SCHED_THREADED,	/* Napi is currently scheduled in threaded mode */
 	NAPI_STATE_HAS_NOTIFIER,	/* Napi has an IRQ notifier */
+	NAPI_STATE_DISABLED,		/* NAPI is disabled */
 };
 
 enum {
@@ -445,6 +446,7 @@ enum {
 	NAPIF_STATE_THREADED		= BIT(NAPI_STATE_THREADED),
 	NAPIF_STATE_SCHED_THREADED	= BIT(NAPI_STATE_SCHED_THREADED),
 	NAPIF_STATE_HAS_NOTIFIER	= BIT(NAPI_STATE_HAS_NOTIFIER),
+	NAPIF_STATE_DISABLED		= BIT(NAPI_STATE_DISABLED),
 };
 
 enum gro_result {
diff --git a/net/core/dev.c b/net/core/dev.c
index 673223065b955..95126e2360792 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7127,6 +7127,12 @@ static void napi_stop_kthread(struct napi_struct *napi)
 {
 	unsigned long val, new;
 
+	/* Instance is disabled, we can immediately stop the kthread */
+	if (test_bit(NAPI_STATE_DISABLED, &napi->state)) {
+		clear_bit(NAPI_STATE_THREADED, &napi->state);
+		goto stop;
+	}
+
 	/* Wait until the napi STATE_THREADED is unset. */
 	while (true) {
 		val = READ_ONCE(napi->state);
@@ -7156,6 +7162,7 @@ static void napi_stop_kthread(struct napi_struct *napi)
 		msleep(20);
 	}
 
+stop:
 	kthread_stop(napi->thread);
 	napi->thread = NULL;
 }
@@ -7541,6 +7548,7 @@ void netif_napi_add_weight_locked(struct net_device *dev,
 	napi->list_owner = -1;
 	set_bit(NAPI_STATE_SCHED, &napi->state);
 	set_bit(NAPI_STATE_NPSVC, &napi->state);
+	set_bit(NAPI_STATE_DISABLED, &napi->state);
 	netif_napi_dev_list_add(dev, napi);
 
 	/* default settings from sysfs are applied to all NAPIs. any per-NAPI
@@ -7577,7 +7585,8 @@ void napi_disable_locked(struct napi_struct *n)
 			val = READ_ONCE(n->state);
 		}
 
-		new = val | NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC;
+		new = val | NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC |
+		      NAPIF_STATE_DISABLED;
 		new &= ~(NAPIF_STATE_THREADED | NAPIF_STATE_PREFER_BUSY_POLL);
 	} while (!try_cmpxchg(&n->state, &val, new));
 
@@ -7620,7 +7629,8 @@ void napi_enable_locked(struct napi_struct *n)
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



