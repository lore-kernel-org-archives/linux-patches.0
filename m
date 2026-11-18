Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054244;
	b=TrscwDi7Dsjc4ydbrPIJgqtqS/Hovc7qcagbBhLg+ERsSJShew08Ui54mjxrObrCkS89
	 bjjwMQf1CU3YCgY+TLaCi2hRYfgwYcnynypUfl2+wa6SQBJgyFBgw4+NEcp2XxdbpcwS5
	 4+5vbIBi+q7qbF38mnbdzZvQx1Y/obiLOQwqyJkcAIqtUZDHENzNyBrDOb82aH15U+dYj
	 /mcclyLFspMydFUkF1y4DQIga/w3Psl7ty/Q9fOx4WUXD5lN6UkEbrfTZWSCdRBon6nO/
	 HCr8s0YNLvFfL3JedDUPCu03viQKsCcOLyR8rL6sZAZ639bLC/n9EI2h3SzjQPxnc3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kFcPE9zcjx/yubkgArfclZdOZvA4v0MAwhAOD1grQ3Q=;
	b=jutm0Jw9lXLBUT/4jx2N2BPvm7QebPC0/rXblBJ18xPP++RkODDjlD/us7eSELyKzgrE
	 cJF2FCBpVDuI2arrwWgf2Zd7Y73GVGAjwPq2F/LPIAzPSYXFQHE1vMhYH/kXTxrdarDQj
	 ydSn97wRr4BxXvXsexSXLGthhceIm6cR16huwU8Bz1YigP6vSdjTM2xtEd0cYunZuflut
	 YBUnqRXE1LIpD5BcgEt8xbjcc+ptbbQe0nVP4tBB3FjTMb5CdF0c6ppPVUb06I1DfWHUs
	 F5FSn5hIPuR4XBMzHK1lKywBFJtkZDFIOQKsvzOCDN+YdcTvOST7z1Lew+ylqbdYD1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rO0BHHue;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDD0606A32A;
	Thu, 19 Nov 2026 02:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rO0BHHue
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BBF1F000C4;
	Thu, 19 Nov 2026 02:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054244;
	bh=kFcPE9zcjx/yubkgArfclZdOZvA4v0MAwhAOD1grQ3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rO0BHHuegdNf49MbGWP5WekxmRcwO9FBPCYkQnYsLQUyjh8v+KSXTK/n4PSE3Pa4i
	 xCjqkNuvbuOj6jB6aPPMzxcgeD/knf0N/1c6xBUASqnA+CH0r4qSeH9hbYuP/tI1aD
	 THOVMWWXGEWE7Akw7ddkYXnFIC3S865sjIuyHiL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hung-Jui Lin <alex.lin.programmer@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1164/2214] posix-timers: Report zero remaining time for disarmed SIGEV_NONE timers
Date: Wed, 18 Nov 2026 15:47:20 +0100
Message-ID: <20261118150058.590162150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted it_status state handling to the it_active flag ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-timers.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index fc08d4ccdeeb9..23683372ddcb1 100644
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



