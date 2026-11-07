Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065383;
	b=Qu8I+V1DZlITrsb6/IM8CLVyCuK9vuIcA13ZZ+ToD13lMvEKNyhVVcywerUvzsHLDyGl
	 wf2dWAYqNOAAeq6Y60DdGttK0jv0DpLrzAy7ntm9Q23YWLTaLvCk8lKiYWUNM7mYfzwPs
	 pyG/uwKfgayayxXaDHxCjYKtrVubu4+InQc3ethawk9LmLO9xaz9+pDA/GEdl34n66sTf
	 ERoNLzmVmfH/OihMTPM/V8nrXYUSgw9EhimH1oZBz6VoEsRl6UJLpVK1RQnO0ty6JbVT2
	 lvxIHtZcuKQlv/T/Myh5DBz9B809iKNrvIcoGsTal4ykGE88uu2SOVUP9OiDPjZLspg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xv5TmQGrk7ENojLua6FokEZuAw2gFFxL3JonnUOqRJ4=;
	b=jn/uIvhvQ3le9hE3rg7XIxmevhq6zEmH+1HpFSuF6txL8tlR6qIJiO2KWm4tqPsNRZZX
	 635BeF7Wzx7pPNWvfhjS7Lx2xrkc+p/uAXvTb4D+5oZsFKVVNh1mSqIGwyKSOKOIlZuTW
	 EYVviYLiEgZicwcoEeQ/+qhhSOj8LPQLUVteuS8H2NjatqNeGS5sBSTHh7H7eo88F2Tjc
	 m+GGmmdGphaKCt071tNcqNKBl//mJCQ1hWKQR5Mx77aKritzlZBfEqItg1oSDCEUgPvBQ
	 uCde+BJ36AMpnMK/OII1aLoGEOB1R0d06sTYVnP7aXXK8SdCbW05NW2HEufuOwJiXkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JS5BSxD6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52355606A32C;
	Sat,  7 Nov 2026 15:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JS5BSxD6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E281F0089F;
	Sat,  7 Nov 2026 15:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065383;
	bh=xv5TmQGrk7ENojLua6FokEZuAw2gFFxL3JonnUOqRJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JS5BSxD6e0wkQzgniQIswVv2jZzrunjr6eH2BgX2HOU+J9sSfykc8EsgPdY/7YKS0
	 jYhIw1C0EdqK1oxJ8Q6JED+rJ+0se+dDsdvEESug2PaOa8IDGgKKnHzzGFw2gx8I84
	 U/X+XTJdBwJBchM1IZVfkcGGOFkdBZABCKCxiJvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hung-Jui Lin <alex.lin.programmer@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1109/1257] posix-timers: Report zero remaining time for disarmed SIGEV_NONE timers
Date: Sat,  7 Nov 2026 08:56:45 -0500
Message-ID: <20261107135009.881475246@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-timers.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 436ba794cc0b5..4c80c2dada9d3 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -694,16 +694,8 @@ void common_timer_get(struct k_itimer *timr, struct itimerspec64 *cur_setting)
 	if (iv) {
 		cur_setting->it_interval = ktime_to_timespec64(iv);
 	} else if (timr->it_status == POSIX_TIMER_DISARMED) {
-		/*
-		 * SIGEV_NONE oneshot timers are never queued and therefore
-		 * timr->it_status is always DISARMED. The check below
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
@@ -713,7 +705,7 @@ void common_timer_get(struct k_itimer *timr, struct itimerspec64 *cur_setting)
 	 * is a SIGEV_NONE timer move the expiry time forward by intervals,
 	 * so expiry is > now.
 	 */
-	if (iv && timr->it_status != POSIX_TIMER_ARMED)
+	if (iv && (sig_none || timr->it_status != POSIX_TIMER_ARMED))
 		timr->it_overrun += kc->timer_forward(timr, now);
 
 	remaining = kc->timer_remaining(timr, now);
@@ -915,8 +907,15 @@ int common_timer_set(struct k_itimer *timr, int flags,
 	sigev_none = timr->it_sigev_notify == SIGEV_NONE;
 
 	if (kc->timer_arm(timr, expires, flags & TIMER_ABSTIME, sigev_none)) {
-		if (!sigev_none)
-			timr->it_status = POSIX_TIMER_ARMED;
+		/*
+		 * SIGEV_NONE timers are not queued, but mark them armed
+		 * so that common_timer_get() can tell them apart from
+		 * disarmed timers. An expired SIGEV_NONE timer stays
+		 * armed, which is harmless: common_timer_get() reports
+		 * zero remaining time for it and it never reaches the
+		 * signal delivery code.
+		 */
+		timr->it_status = POSIX_TIMER_ARMED;
 	} else {
 		/* Timer was already expired, queue the signal */
 		posix_timer_queue_signal(timr);
-- 
2.53.0



