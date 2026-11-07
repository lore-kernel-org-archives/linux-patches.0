Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065281;
	b=WwPuVJV3McEzbEo6T1Fx8orqom/8ltLvUkX8f2Ctt+T9bDW6DVYGPk6tFmUQaL/eYcrH
	 WczCt1P0OHx+7RpkguSamrmuMXWcw4x5GJ2K7VySCj+9CXBp9Z6czkG5pSqa/0FNORJTZ
	 RYMVlOCfRfDkRmT8H9bndXAJX7pF90Eb6WuJUUGUigM5mDWH+RrLzJBovtPW2HEOQskE4
	 RxjG3jvYpXxlTRResea+frxwizouTuifekQkvX3S9tRQclSKDhtCsRrCAvovjgjeD83PX
	 Z4cGHukQBm84/sKjjmPSuu0NVpoi5DdP7TouAzUrCQIIVAZ+lA/DViYkJRjTIqzq8ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vA3mtX6KS0nbSawHYZocFisBRYSwYkXm52ks3eB4OUY=;
	b=jyQpyljvrjNwVZmTSZAXRZKEKLm41b5bvCVUGuDinvMdgxqFV9sS2D2gM3pZKYPGjga9
	 9pn1Raia/n4o4owUPA2GVnNY6fUnSi3Ab26p06Njp6IVI3/OZMIJPcUJIg+/bvaVtEovX
	 vfM9AAuF7B0bDUwq8vZ4MUtqq8AFFXH5zIROfYGDPlCgte194V4U7WI+EndKCwmElx++I
	 1jvmpTN25l2ot2JqBCfAKRdB/FUdnMqHHRoL6pjBc2cveDz6xmh8CCeauft3S4XMENZKk
	 COMpd1wSXsuWqJyW2eRmQMeo4GZKjXRMpwXb2zQdBFAMYK0JQPvNEHXnBNZe8+ks67g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="o/eUMdHc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7609606A32C;
	Sat,  7 Nov 2026 15:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o/eUMdHc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965EB1F008A1;
	Sat,  7 Nov 2026 15:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065280;
	bh=vA3mtX6KS0nbSawHYZocFisBRYSwYkXm52ks3eB4OUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/eUMdHcdJc4sXNWxooaHDHmpdXqp0DI1XMCYTDb0lXs4sJVZ86ntZJgeWI6SILbY
	 GukWagAC7JFB2Uk0GERzgtBGZZx5S4POLh1sCkDohp1QnLI4KBr0mZMr6X9ltNMB/s
	 8B+5o94PAlKe3w3t2W103pZ87qCrlbWa7Ur5FmLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	shaos <shawnq1@163.com>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1042/1257] timekeeping: Require permission to set auxiliary clocks
Date: Sat,  7 Nov 2026 08:55:38 -0500
Message-ID: <20261107135008.092375963@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 524d95c8a2000cba6cb80a173d76cb746c561244 ]

The generic clock_settime() entry point delegates permission checks to
each clock-specific callback. aux_clock_set() does not perform one. Once
an administrator enables an auxiliary clock, any local process can
therefore change the global clock offset.

A test process running as UID and GID 65534 with no effective, permitted,
inheritable, or ambient capabilities set CLOCK_AUX0 successfully, and a
separate process observed the new value. The same process was denied by
clock_adjtime(). An AppArmor profile denying sys_time also blocked
CLOCK_REALTIME changes but did not see the auxiliary clock operation.

Call security_settime64() before mutating the auxiliary timekeeper. This
matches CLOCK_REALTIME's permission model, enforces initial-user-namespace
CAP_SYS_TIME, and gives LSMs the settime hook while preserving authorized
clock changes.

Fixes: 60ecc26ec5af ("timekeeping: Provide time setter for auxiliary clocks")
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: shaos <shawnq1@163.com>
Acked-by: John Stultz <jstultz@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261019080324.4147815-1-4ncienth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timekeeping.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ea2e6e55f37bf..1b342825bd8f1 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -14,6 +14,7 @@
 #include <linux/random.h>
 #include <linux/sched/clock.h>
 #include <linux/sched/loadavg.h>
+#include <linux/security.h>
 #include <linux/static_key.h>
 #include <linux/stop_machine.h>
 #include <linux/syscore_ops.h>
@@ -3215,11 +3216,15 @@ static int aux_clock_set(const clockid_t id, const struct timespec64 *tnew)
 	struct tk_data *aux_tkd = aux_get_tk_data(id);
 	struct timekeeper *aux_tks;
 	ktime_t tnow, nsecs;
+	int ret;
 
 	if (!timespec64_valid_settod(tnew))
 		return -EINVAL;
 	if (!aux_tkd)
 		return -ENODEV;
+	ret = security_settime64(tnew, NULL);
+	if (ret)
+		return ret;
 
 	aux_tks = &aux_tkd->shadow_timekeeper;
 
-- 
2.53.0



