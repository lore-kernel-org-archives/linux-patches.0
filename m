Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022375;
	b=fajbCjjkRtbfAOa0YIQq0uUNFkrO47VYfsRX9+5jnyRD5r/lFKX+HCunDUX9w1Sb093u
	 23E+SEyKFgsdqAL/JxaYOa/Z8Odc/e50FGZlYv+ysGm05Iq3SLuM/LABxDJ7O4mp/NeO8
	 ZMeDHgfqi3ePExbxUaw7y/Lmdc7/v92yaJUFITXGb5LkDRNm1+innZjZEFzsRJQRJmI/p
	 QtZLW+7nVhIkYsKx+wSwl/fiCO8b1n4z0R+62eE89FRXyQPySdg2SF7UiOE6imfrhSdhf
	 5aSV0Wv3U44XV5RLiKEXFInC9aOPhqj9+twIP9mWmEaAr5aqnPvJpcisOtLuBEoaATQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=exEpAzfIRhXplO/thZ0gsNMC36VVeQoqIHuRXn0TFck=;
	b=AAs0ifI8AY9XYCXL9ZiP4r93FrvAmeNV8j7EwlbGINBUeeVqNFlTgeaMJ+1gp270piQm
	 YxwM6qBzV3T2Pd2nIPLCXSYXGFH9zhxJavCpGTlUgXLPYcPwDa79G2JaTexjzGRmEpkrI
	 XViHZlnXld1n+NufWdBj0/qzo6d1+r07IU3ZlVzZ3yI2x+tIPTtciEnx1rM8Ruhz8/Rct
	 cmBfEPZkre5uPmJ2UVLxy/hrR6jT+rBehYGWmDMAJ218AWU2EOPlZqvKIdlu8xZwVfGz6
	 UEVG/USSdN9IxBgRo6I4NHeP/EOcHHdilK/7sQ4DMk4WnUD2SHwXjmUz2K24fiy/5Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P+7fPdVG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D3E606A31C;
	Wed, 18 Nov 2026 17:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P+7fPdVG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D72D1F000C4;
	Wed, 18 Nov 2026 17:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022374;
	bh=exEpAzfIRhXplO/thZ0gsNMC36VVeQoqIHuRXn0TFck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+7fPdVGoDq+6O4fwDGyWHv8Aje0ciBx7Jczngf74u31R/6a3I55uQ29uQIyPaA+T
	 T9G0E0UUsUxg+IX1R06RoySM7mr8O6Xe/twvB1RXVWtngG7FQaiRa4xfi2/F7LfhnP
	 xWgETEEZAVm/JcQRZuEWjSJ6HL+xEJGj/FbWtpao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Breno Leitao <leitao@debian.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kayra Cizmeci <kayracizmeci@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Stian Halseth <stian@itx.no>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2640/2651] sched/cputime: Dont warn when the tick period starts after idle exit
Date: Wed, 18 Nov 2026 16:04:40 +0100
Message-ID: <20261118150419.156726621@linuxfoundation.org>
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

From: Stian Halseth <stian@itx.no>

[ Upstream commit b327e63683a2b894b500027375342c25222b58ef ]

kcpustat_dyntick_stop() warns if idle ends before the tick period
that the next tick will account has started. That happens on x86 in
a CPU's first idle period with the tick stopped, right after the
switch from the jiffies clocksource to tsc-early.

On the jiffies clocksource ktime only moves at the tick. When the
clocksource switches some time d after a tick, that d is lost: ktime
continues from the value of the last tick. The next tick comes
TICK_NSEC after the last one, but ktime has only moved TICK_NSEC - d,
while tick_periodic() still adds a full TICK_NSEC to tick_next_period,
which is now d ahead of ktime. When NOHZ starts,
tick_init_jiffy_update() rounds it up to a multiple of TICK_NSEC and
the sched timer is armed there, up to nearly two ticks after now. A
tick stop saves that as ts->last_tick, and an idle exit before now
reaches ts->last_tick - TICK_NSEC sees the tick period in the future.

Nothing is accounted twice then. The first tick covers a period that
starts after the idle exit, and the code already handles it. Drop the
warning.

Fixes: 96a494c9cfd8 ("sched/cputime: Don't account idle time twice after dyntick-idle")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reported-by: Breno Leitao <leitao@debian.org>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Kayra Cizmeci <kayracizmeci@gmail.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Stian Halseth <stian@itx.no>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/all/auTCQauaU733PY5z@gmail.com/
Link: https://lore.kernel.org/all/CAHk-=winC2u2D1FAX5grfq9F=bxmARxhuiQ4MvHAiJFu3iF6gw@mail.gmail.com/
Link: https://patch.msgid.link/20261031081408.3378884-1-stian@itx.no
Closes: https://lore.kernel.org/all/bfe9b14a-6e65-41c5-b638-26f6e033788b@molgen.mpg.de/
--
 kernel/sched/cputime.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cputime.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index faac7c2066d84..a19e61890c74c 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -479,7 +479,12 @@ void kcpustat_dyntick_stop(u64 now, u64 tick_start)
 			kc->idle_tick_overlap = 0;
 		}
 		tick_start = max(tick_start, kc->idle_dyntick_entry);
-		if (!WARN_ON_ONCE(now < tick_start))
+		/*
+		 * After a switch from the jiffies clocksource the tick can be
+		 * armed more than a tick ahead, so the period may not have
+		 * started yet.
+		 */
+		if (now > tick_start)
 			kc->idle_tick_overlap += now - tick_start;
 		kcpustat_idle_stop(kc, now);
 		kc->idle_dyntick = false;
-- 
2.53.0



