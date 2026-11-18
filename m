Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038621;
	b=CmqmzQd5BEg65GIa5ILPTeYwSY+GP7vz7PSx2LOLne9kc1IR57TDYKIP5Rzy4/JxXuz2
	 4dgz9Vp+bWmXcAscmr9/YxJXKr7+GQfM9aICcbkWgpNWZHcE0pX6HxfcQ161ufyCo93zA
	 /+W9JYcUAOfL67bHUGWpuObP6+iSGz3T3BxJuxX3U/ld2QD82Jv3l7Lx2XWHx+s6zsUJ/
	 VxQye+O6zRTGv7OTZbvnpNdJcT9ICWhKITz901txiSj0hVyXyVE+KAekZi+tmc/PcOyPQ
	 n5FkgMixIplxpo6cREYO3urkvde1oqN/WLVd60hYguLJKUoxdJtajgALLrO9xMd5Vtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZzpLoMVQv5ZfOGeWjFKGnbHb1Z3mjNUmERHYi7uj6n8=;
	b=NJfHHsyhWz+o8/ISBa+zJ0iPsU/tVcHBC9bw9dlmiRMYXFRq1p3rDvdK/cIkZWz6eixx
	 gVrZk9M0FLptabqLu8BuuE93adMV/glXhGDcYJIDc3HcapM+CYMDVQ6Ru7cP5xQhWdq4g
	 S2Xb3edr/cJmneGqpjUlxbVQD9zoLzIcsKYctXROS17NhEm0A9qsPS0z+oXZb9/kVftbW
	 rmuJzxgepslLEAhEzScsocWLFll959xeN9iSwIQfsQ/GLO5GLZqzMQ4nNfRKOn060vuX1
	 JbGwHaD1YecNeZfv+p+DMYuz1N4ijj3j5KxVxbDTMeC9OG4nypkqnCSDJA98LEL7ZXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VHY3dwOX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C017606A32A;
	Wed, 18 Nov 2026 21:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VHY3dwOX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BE31F000C4;
	Wed, 18 Nov 2026 21:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038621;
	bh=ZzpLoMVQv5ZfOGeWjFKGnbHb1Z3mjNUmERHYi7uj6n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VHY3dwOX4iKyFc0cja2Uo36h5DbStdkSTXSMWNy6y+aBJE+RMDkwHU05QANgYC5KA
	 ocx1Vofi04l9idiusdglFTIId7bUkIqaoqJl7YrGjcPMD/MiD96XSOhCj5eVyIPI4P
	 EXjotCvbLzEXgronaPwzQlFe6zfz3uNS6nhxF9aI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hung-Jui Lin <alex.lin.programmer@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1808/3318] posix-timers: Report zero remaining time for disarmed SIGEV_NONE timers
Date: Wed, 18 Nov 2026 15:40:30 +0100
Message-ID: <20261118150416.093633666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hung-Jui Lin <alex.lin.programmer@gmail.com>

[ Upstream commit 141a27750ec3d91ad9d1ad1764ebb5e51b963478 ]

SIGEV_NONE timers are never queued. common_timer_get() emulates their
expiry by computing the remaining time from the stored expiry value.
Because an armed SIGEV_NONE oneshot timer is not queued, its it_status
stays POSIX_TIMER_DISARMED. So common_timer_get() cannot use it_status to
skip a disarmed SIGEV_NONE timer and evaluates the stored expiry value for
all SIGEV_NONE timers.

Disarming a timer with timer_settime() and a zero it_value cancels the
timer and sets it_status to POSIX_TIMER_DISARMED, but leaves the expiry
value unchanged. As a consequence, timer_gettime() on a disarmed SIGEV_NONE
timer reports the remaining time of the previous arming until that time has
passed, instead of zero as POSIX requires for a disarmed timer. Example
with a CLOCK_MONOTONIC timer armed with it_value = 10ms and it_interval =
100ms, then disarmed with an all-zero itimerspec:

  armed:    it_value = 0.009999000  it_interval = 0.100000000
  disarmed: it_value = 0.008700792  it_interval = 0.000000000

SIGEV_SIGNAL timers and SIGEV_NONE CPU timers report zero in the same
situation. All clocks which use common_timer_get() are affected, including
the alarm timer clocks.

Mark SIGEV_NONE timers as POSIX_TIMER_ARMED when they are armed, so that
common_timer_get() returns early for every disarmed timer. Forward
SIGEV_NONE interval timers in common_timer_get() regardless of it_status,
as they are never queued and therefore never forwarded by the expiry code.

After the change the disarmed timer above reports zero. Armed SIGEV_NONE
oneshot and interval timers on CLOCK_MONOTONIC, CLOCK_REALTIME,
CLOCK_BOOTTIME and CLOCK_BOOTTIME_ALARM still report their remaining time,
and the posix_timers selftest passes.

Fixes: becf8b5d00f4 ("[PATCH] hrtimer: convert posix timers completely")
Signed-off-by: Hung-Jui Lin <alex.lin.programmer@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261023151411.28685-1-alex.lin.programmer@gmail.com
[ sashal: adapted timer state handling to use the it_active flag instead of it_status constants ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-timers.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 7534069f60333..ffaf5f6c8eb40 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -648,16 +648,8 @@ void common_timer_get(struct k_itimer *timr, struct itimerspec64 *cur_setting)
 	if (iv) {
 		cur_setting->it_interval = ktime_to_timespec64(iv);
 	} else if (!timr->it_active) {
-		/*
-		 * SIGEV_NONE oneshot timers are never queued and therefore
-		 * timr->it_active is always false. The check below
-		 * vs. remaining time will handle this case.
-		 *
-		 * For all other timers there is nothing to update here, so
-		 * return.
-		 */
-		if (!sig_none)
-			return;
+		/* Nothing to update for a disarmed timer */
+		return;
 	}
 
 	now = kc->clock_get_ktime(timr->it_clock);
@@ -894,7 +886,15 @@ int common_timer_set(struct k_itimer *timr, int flags,
 	sigev_none = timr->it_sigev_notify == SIGEV_NONE;
 
 	kc->timer_arm(timr, expires, flags & TIMER_ABSTIME, sigev_none);
-	timr->it_active = !sigev_none;
+	/*
+	 * SIGEV_NONE timers are not queued, but mark them armed
+	 * so that common_timer_get() can tell them apart from
+	 * disarmed timers. An expired SIGEV_NONE timer stays
+	 * armed, which is harmless: common_timer_get() reports
+	 * zero remaining time for it and it never reaches the
+	 * signal delivery code.
+	 */
+	timr->it_active = 1;
 	return 0;
 }
 
-- 
2.53.0



