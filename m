Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619687;
	b=xYMtvbULg1uSG2Oz3psVr4oBBosMH2HjzwXh4cyFh4gGG5iQl9+6gFTN8/0HbhVNyW6A
	 JaPVf9dk0qYV364iQeAGcYvxx7TIQK9PnqgS+9CHiMph58oKuw+A1NsUQpuPzFRNcp2g1
	 Nal+3pGQGn6HpMCZz0GOHY22jhbVtN2pMKFwpyR9p52VWnuKnsicQChIJ6hUc5WyhBZk4
	 pkGGrrSdEwZFlumyOpz3lBYkN2CAM0wt6OT9F9k1Y2Kw7NIAGqQSoBpJFJ1F4qXYsllyM
	 0Uws1E0RPl63UR2uYToEtxuxWnxLh/rwqoXiIbGxEzwfapxMskDvnWj4QRyFTrHLEpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I4Ym+PwQ15PdfegeLVOoPPw75U07A/q1hjJkILoYmUo=;
	b=IdpV77x53OlrRUgqHuN6cb5QC4Q+hR4HjFM/rKDQ61vb4KF8Z4m4aEyHJKHbjQGObqUW
	 Lj+dIQHS2gffjjPn+URiR/5/7zkLJuvY+ngh+fiWpDjaA4Ng7tlgrEybdCeTXk/2aiyp3
	 pV4qvhs8DW7EW3G1SrJhlyrNdbQ/vMPbi4mNOR8G0xbLWNZ7kkDuCXckFMfCEVDSwoF5g
	 Z0YQcMhLsTP0ouvxrz7CC3GFMwtkSeazygu/MTzXHoaI9VKvc0vL/29zyuZ4lJZ2lON2J
	 fFNSgY2peL1EIFHWgFc9ZgfDb50NOlyHlGrfmsVI8CHddRQFlj+CnI4rWib+psJd50w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JQYQmXFH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BA0606A327;
	Wed, 25 Nov 2026 15:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JQYQmXFH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301051F000EC;
	Wed, 25 Nov 2026 15:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619687;
	bh=I4Ym+PwQ15PdfegeLVOoPPw75U07A/q1hjJkILoYmUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JQYQmXFHKiRUGrz8w3up1g+B0D3LCsR4KHGl8FR0Zv3scnU2keGI6+8284qqHAKIO
	 6FugTHOV1oIhoKqMRi2ljn1B/N6elZQMqcv6S4TobPBKM+2MXtCghTwD6Pye7yiadE
	 Yg5tL1HyaIHtVmqNmC4Rm1GDpbM7diJ+KTwIKBd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phat Dinh <phatdt1116@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 7.3 0676/1005] perf/core: Do not resurrect cpuctx->cgrp after last cgroup event exit
Date: Wed, 25 Nov 2026 15:33:34 +0100
Message-ID: <20261125143837.590289837@linuxfoundation.org>
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

From: Phat Dinh <phatdt1116@gmail.com>

commit 59f1398140869432c7171b9a2a279ca315467c4e upstream.

perf_cgroup_switch() relies on:

    /*
     * cpuctx->cgrp is set when the first cgroup event enabled,
     * and is cleared when the last cgroup event disabled.
     */

It computes the next task's cgroup, schedules out the CPU context and
then assigns cpuctx->cgrp unconditionally:

    ctx_sched_out(&cpuctx->ctx, NULL, EVENT_ALL|EVENT_CGROUP);
    /*
     * must not be done before ctxswout due
     * to update_cgrp_time_from_cpuctx() in
     * ctx_sched_out()
     */
    cpuctx->cgrp = cgrp;

However, ctx_sched_out() can disable events itself. If a cgroup event
has a pending disable from perf_event_disable_inatomic() (e.g. its
PERF_EVENT_IOC_REFRESH limit ran out) that the irq_work has not
handled yet, event_sched_out() consumes it inline:

    if (event->pending_disable) {
        event->pending_disable = 0;
        perf_cgroup_event_disable(event, ctx);
        state = PERF_EVENT_STATE_OFF;
    }

If that was the last cgroup event, perf_cgroup_event_disable() clears
cpuctx->cgrp:

    if (--ctx->nr_cgroups)
        return;

    cpuctx->cgrp = NULL;

and perf_cgroup_switch() then sets it again. cpuctx->cgrp is left
non-NULL with ctx.nr_cgroups == 0, so the NULL check in
perf_cgroup_switch() no longer catches it and the next switch trips:

    WARN_ON_ONCE(cpuctx->ctx.nr_cgroups == 0);

cpuctx->cgrp does not hold a reference on the cgroup. Once that cgroup
is removed, the next ctx_sched_in() dereferences the stale pointer:

  BUG: KASAN: slab-use-after-free in ctx_sched_in+0xb1f/0xfa0
  Read of size 8 at addr ffff8881008972d0 by task swapper/3/0

  Tainted: [W]=WARN
  Call Trace:
   <IRQ>
   ctx_sched_in+0xb1f/0xfa0
   perf_event_sched_in+0x1a/0x70
   ctx_resched+0x32b/0xac0
   __perf_install_in_context+0x475/0xab0
   remote_function+0x105/0x200
   __flush_smp_call_function_queue+0x179/0x8d0
   __sysvec_call_function_single+0x1b/0x1c0
   sysvec_call_function_single+0x66/0x80
   </IRQ>
   <TASK>
   asm_sysvec_call_function_single+0x1a/0x20

Only assign cpuctx->cgrp when cgroup events remain after the context
has been scheduled out, so that it stays NULL as the invariant
requires.

Fixes: e19cd0b6fa59 ("perf/core: Always set cpuctx cgrp when enable cgroup event")
Signed-off-by: Phat Dinh <phatdt1116@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261106101642.494674-1-phatdt1116@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1072,8 +1072,13 @@ static void perf_cgroup_switch(struct ta
 	 * must not be done before ctxswout due
 	 * to update_cgrp_time_from_cpuctx() in
 	 * ctx_sched_out()
+	 *
+	 * ctx_sched_out() can consume a pending disable and drop the last cgroup
+	 * event, which clear the cpuctx->cgrp. Cgroup tracking follow active cgroup
+	 * event, so do not resurrect it
 	 */
-	cpuctx->cgrp = cgrp;
+	if (cpuctx->ctx.nr_cgroups)
+		cpuctx->cgrp = cgrp;
 	/*
 	 * set cgrp before ctxsw in to allow
 	 * perf_cgroup_set_timestamp() in ctx_sched_in()


