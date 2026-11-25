Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619572;
	b=P85MqGxnI7oFF4uiYm1b2atDcIMgJf3k9knYBoaT7gvveZptQinzLz9yCp4Dm1clNP8m
	 16u6KQGI5WDUwp4olfOKb9a9CTGLtadbQATBfmX4EvtgEim+KVhTnylpP0Qc6G4RGGegj
	 QrMKJw/tHzX0s6DuKAye3jWJzzbyrHl0F5sUWY7U4y4kBCK/05mchSiKUB0O9zBTLB2aa
	 56TmWgH9jWt0CBlRpYXyVZZ6NEI7FzyOVFkWSBH3oS9MReuYtFu1z3g1+NpCBWm+edyMy
	 Zt9CvdGdTU06p1IzOBAvXOFpwRJ8R6GzVWYPPy+/HUzpbs/5Tvba86NNwKbxJrpuYgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kP5+JqF4+wfgeVqebfIq6rlJW5ZV0pT9LLwf5rSG9Lc=;
	b=b1yGr+Bsw7O7MrFP25EfbeBhDhSjtjST8AM7xUia9ZUEaKaC6YSbhsGBxGaD7RzR6HQ/
	 r2dbNF6qz3hz+R+uKO1dqEpyyp4eg293MCJ4+7SYGhkgGs4/b8pG1p4U2LN+tIgxy+n6j
	 vEV0PYYqjuIoJ2C+iug+Vejo9pT10jSu8FJ+M89zfFvrRzBohz+xhalCqD8PXh8SpVXOv
	 Bwr4/JoC6RNskfyZocOwlSFx69tGsBW7p9b2ounPyW07/8wRvtBNT+dZhzcKemj50DO9I
	 VVbVRDQZPYN3viK8SE/quoywlWD72UmDAH+9KuxjxL889jAVmA7BlyuhKX6SEIC21hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lvH91KTp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1067606A31E;
	Wed, 25 Nov 2026 15:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lvH91KTp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051751F000C0;
	Wed, 25 Nov 2026 15:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619572;
	bh=kP5+JqF4+wfgeVqebfIq6rlJW5ZV0pT9LLwf5rSG9Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lvH91KTpZeCq/HH3dMgHk/xMFSVPjAAcHyM8MbS7o2aiF+ZTjAmRWhUeVOxOblF/j
	 6z6BrtstAUHS6JVa4WncwkWf2YS0/Tx13z6SuNlgOVbIDs+urITTjtpoY1FA3xHdWC
	 unlvVXaMGoPgsGd4U3h5CMajPR3kJNzlGoVkgUCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH 7.3 0638/1005] tsacct: Keep task begin times stable across suspend
Date: Wed, 25 Nov 2026 15:32:56 +0100
Message-ID: <20261125143836.699152694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

commit c49b3c20a2d0b22700e2100a527e68e829ece7f0 upstream.

bacct_add_tsk() derives ac_btime and ac_btime64 by subtracting a
CLOCK_MONOTONIC elapsed duration from CLOCK_REALTIME. MONOTONIC stops
during suspend while REALTIME continues, so querying an existing task
after resume moves its reported begin time forward by the time spent
suspended.

Calculate the begin time from the wall-clock boot timestamp and the
task's CLOCK_BOOTTIME start timestamp instead. This accounts for suspend
and adds the nanoseconds before truncating to seconds. Keep ac_etime and
ac_tgetime on CLOCK_MONOTONIC and retain the existing rebasing when the
wall clock is adjusted.

The new begin time can be negative: setting CLOCK_REALTIME is bounded
by CLOCK_MONOTONIC, which excludes suspend, rather than CLOCK_BOOTTIME.
A permitted backward clock adjustment after suspend can therefore put
the task's begin time before the epoch. Clamp ac_btime64 at zero too,
instead of wrapping in the unsigned field, and retain its positive range.

Fixes: f3cef7a99469 ("[PATCH] csa: basic accounting over taskstats")
Reported-by: Oleg Nesterov <oleg@redhat.com>
Suggested-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20130611200600.GA15168@redhat.com
Link: https://lore.kernel.org/r/alpine.DEB.2.21.1911071335320.4256@nanos.tec.linutronix.de
Link: https://patch.msgid.link/20261030054227.35453-3-dennylin0707@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/tsacct.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -24,7 +24,7 @@ void bacct_add_tsk(struct user_namespace
 	const struct cred *tcred;
 	u64 utime, stime, utimescaled, stimescaled;
 	u64 now_ns, delta;
-	time64_t btime;
+	struct timespec64 btime;
 
 	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
 
@@ -39,9 +39,11 @@ void bacct_add_tsk(struct user_namespace
 	do_div(delta, NSEC_PER_USEC);
 	stats->ac_etime = delta;
 	/* Convert to seconds for btime (note y2106 limit) */
-	btime = ktime_get_real_seconds() - div_u64(delta, USEC_PER_SEC);
-	stats->ac_btime = clamp_t(time64_t, btime, 0, U32_MAX);
-	stats->ac_btime64 = btime;
+	getboottime64(&btime);
+	btime = timespec64_add(btime, ns_to_timespec64(tsk->start_boottime));
+	stats->ac_btime = clamp_t(time64_t, btime.tv_sec, 0, U32_MAX);
+	/* Setting the clock back after suspend can make btime negative. */
+	stats->ac_btime64 = max_t(time64_t, btime.tv_sec, 0);
 
 	if (tsk->flags & PF_EXITING)
 		stats->ac_exitcode = tsk->exit_code;


