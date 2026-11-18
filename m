Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059799;
	b=0Ia9hN5CJYc0SZ1kSHV8qGNnwOyRIaXS2ws7p9ExuA7RyWmzGSvMf+mSzM2tjMLX7MN8
	 q7ZY9CbytShC5gQJEguFyZQYHXcIj+UTH64mAo29dMgtvkj8jm50ar755g/YKIUQFO2CQ
	 L0rGgOaL7ecujoXDUPhxYrRfodnTTOkguCVaA8bWae/WcsBHkO4h7bsofj4GCXXJqDPwY
	 DLXtv6/4w0UcTa9taAkIRomaCkvMt1fKsdOK6zwUM5Mnaw4TPVH0+GTKutG7fsr7OAjvj
	 3EHEefUfDIKoq1KS7+JH/BAmFpWfMDaWQvL6wuB4BKPK5NC+fUCht6lRtXNXWXFv8/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BdbpntOZa/9BOmgd8l4hNZFSLwpsaOpDyDBMslBV3Lc=;
	b=MsqNVhaacR4hbb0yRVtsovr+PFm49lRZtM9qaqC7am682KG0xmqlA+ppagKnj8yU1XBP
	 GBP4n6+bgIGBsBDK81SAZQZiQDIYjbyN4Jy0bycP+8B1hMhAbMveMXAwfcT7oFcrNIvZA
	 qhICd56teTqpvQqSL0/NHr9lrtptMzy2UKyYN4EhdWSP6cnEtyZz2kt+gUA4sS3LJCD6t
	 V0TXLfOZI8uviHeK6zgFfWnt7cycyJvCQbWybJLyOS5reRGRO/BrgN4AfwisC6xiWdWSK
	 vTfHIbYEWsK2tbae6YNhZONbBDCuHAy8QAFOa1Pq2J4zgE/llQjmri4fGRGA+2JC+3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JE7s5tDO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEC4606A326;
	Thu, 19 Nov 2026 03:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JE7s5tDO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E121F000C4;
	Thu, 19 Nov 2026 03:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059799;
	bh=BdbpntOZa/9BOmgd8l4hNZFSLwpsaOpDyDBMslBV3Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JE7s5tDO6lylyMRiqvWx4wngN5Hch3haREz+T25jk5rhTg00zyWkFQNeum5abe0pr
	 LPkwvrl5vzEqpnj8hddTWzSYsABcMGm6v9aunh2TBdx6/iDj2pwWGbr5SvHMaci9zl
	 gxtDkblfDfU+CarHvcnwQN+N23EScZj3oG7hqi8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hung-Jui Lin <alex.lin.programmer@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0969/1848] posix-timers: Report zero remaining time for disarmed SIGEV_NONE timers
Date: Wed, 18 Nov 2026 15:50:07 +0100
Message-ID: <20261118145957.518915656@linuxfoundation.org>
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
[ sashal: adapted it_status state handling to the it_active boolean flag ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-timers.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 3a68c650ff2a3..2f1cefa2499a8 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -686,12 +686,8 @@ void common_timer_get(struct k_itimer *timr, struct itimerspec64 *cur_setting)
 	if (iv) {
 		cur_setting->it_interval = ktime_to_timespec64(iv);
 	} else if (!timr->it_active) {
-		/*
-		 * SIGEV_NONE oneshot timers are never queued. Check them
-		 * below.
-		 */
-		if (!sig_none)
-			return;
+		/* Nothing to update for a disarmed timer */
+		return;
 	}
 
 	now = kc->clock_get_ktime(timr->it_clock);
@@ -901,7 +897,15 @@ int common_timer_set(struct k_itimer *timr, int flags,
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



