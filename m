Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211638;
	b=r1oVyqcCOl6a7TUwY9Qv6FZx0GqlQxMqFDa71ErjWLZNj31LJcXxF/G0BStayCv1JsWf
	 yXK1BXGsXmT7L6pOo2EI09/91gW1wAomHwMEx6yY6nwBsTm0+5Akn7QoMAzWyU8mkIN8C
	 c8ikk1bV1N4U3PrIE0Cz79AIYi1h5sd2k4zyg4eNIfyqQZeLDTNVLa8V6YPUy6WZm1HOH
	 A76K8geYnYaHooEB1ooQ/q/+uIuCWzNnotIVsL4FVbdTTa4Gew0Mj/EXPx2l3PXxrT90T
	 OHbl03Ts6AxJmG1dga26bFWq/uDVQjih7PFt+kZugp7p2ArDRfVCcJX9ZkmHsBAy9bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2E0qhKJA+z9S7/bXCNP2UXc2iV6AQO63/uylE0BFS+M=;
	b=Y/VZMOt79fzvVh/V2/IGpdHyRzimQYD+cf0HztfCOhnp5cLDeE+sQo/ATjbridc9mnIo
	 5fuw/0Os3TEDQ/ETkrmBZ0D3JDvxn18zASEs1JDdAWExmKSZKTtt3VY1NQyUTTfeYxO2c
	 KMB1Dak6rKh/NV/hx6pVJHJElwJ0xMvIfItOqG1DayCmeqJ7zbPdEssYv3Br3wV7cUP7q
	 fefXj+DslpoWSwl2zxjEWfIEM/YG5vFiM7j2thFHjgLjMpisEeQ8j/5wbXtUPI1R4Zrc6
	 t+Rw0nNZTjT22snRdjrxmsAZBOCUMsZBNtacuF0E0kyNqXdOwO4v/PcUnUibAaOCqCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SJ2YRAPi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5563C606A31E;
	Wed, 28 Oct 2026 18:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SJ2YRAPi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A7F1F01829;
	Wed, 28 Oct 2026 18:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211638;
	bh=2E0qhKJA+z9S7/bXCNP2UXc2iV6AQO63/uylE0BFS+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJ2YRAPivxrXEh0KbmbwZ06zhjh2yKZDLBBsmipJyogLbmfpZiLesUGOBdFOSutII
	 7D7OWXCZ9jNmVbGedQekcEWJisuFlmVzS49qttCAzJTUCV72HQKxXeKfiZR+L3/pZ1
	 zjBnLMg5GZbTLMpPMQ/tjnqUIoETXHfoM+mcy5XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 447/571] drm/i915/gt: Unmask interrupts only when ACTIVE is true
Date: Wed, 28 Oct 2026 17:59:54 +0100
Message-ID: <20261028170018.633027967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Krzysztof Karas <krzysztof.karas@intel.com>

[ Upstream commit 5346b1cec6afa4f9b4b49a9f84e3cfef95a3f7bb ]

There is a small race window between intel_rps_boost() reading
a stale ACTIVE state and queuing rps->work, where ACTIVE may be
changed via asynchronous calls triggered by wakeref drop.
This means that rps_work() could be triggered after the GT has
been parked, so unmasking RPS PM interrupts would happen without
holding PM wakelock. This sequence of events may be observed
during live_rc6_ctx_wa() selftest:

1) live_rc6_ctx_wa()
   -> intel_engine_pm_put()
      -> wakeref_put()

ASYNC1) wakeref_put() callback
          -> __engine_park()
             -> intel_gt_pm_put_async()
                -> intel_gt_pm_put_async_untracked()
                   -> intel_wakeref_put_async()

ASYNC2) wakeref_put_async() callback
          -> __gt_park()
             -> intel_rps_park()
                -> intel_rps_clear_active() [clear ACTIVE]
                WITH INTERRUPTS:
                -> rps_disable_interrupts()
                   -> cancel_work_sync(rps->work)
                   -> rps_reset_interrupts() [rps->pm_iir = 0]
                WITHOUT INTERRUPTS (TIMER mode):
                -> rps_stop_timer()
                   -> cancel_work_sync(rps->work)

2) live_rc6_ctx_wa()
   -> intel_gt_wait_for_idle()
      -> intel_gt_retire_requests_timeout()
         -> dma_fence_wait_timeout()
            -> ops->wait() [i915_fence_wait()]
               -> i915_request_wait_timeout()
                  -> intel_rps_boost()
                     -> intel_rps_is_active() [check ACTIVE]
                        [OPEN RACE WINDOW]
                     -> queue_work(rps->work)
         -> retire_requests()
            -> i915_request_retire()
               -> intel_rps_dec_waiters() [from 1 to 0]

If ASYNC1 and ASYNC2 would execute during [OPEN RACE WINDOW],
then:

3) rps_work() executes from the workqueue and may satisfy
   "(!pm_iir && !client_boost)" test (in TIMER mode rps->pm_iir
   is zeroed by an earlier rps_work() call or never gets a new
   value after previous intel_rps_unpark() event), so it jumps
   to "out" label, bypassing intel_rps_is_active() guard and
   executes gen6_gt_pm_unmask_irq();

4) GT is parked and runtime PM wakelock is dropped, so only
   a raw reference in __gt_park() ->
   intel_display_power_put_async() remains for 100ms, then the
   MMIO write in gen6_gt_pm_unmask_irq() detects missing
   wakelock via assert_rpm_wakelock_held() and emits
   "RPM wakelock ref not held during HW access" tainting kernel.

Commit 3e7abf814193 ("drm/i915: Extract GT render power state management")
dropped the "if (rps->interrupts_enabled)" guard that
gen6_pm_rps_work() had around this unmask in i915_irq.c.
INTEL_RPS_ACTIVE brackets the same window, since it is set in
intel_rps_unpark() before rps_enable_interrupts() and
rps_start_timer() and cleared in intel_rps_park() before
rps_stop_timer() and rps_disable_interrupts().

Skip unmasking when RPS is no longer active (reaching unmask
operation is independent of INTERRUPT mode). This does not
prevent RPS operation from resuming on the next unpark.
In interrupt mode, intel_rps_unpark() calls
rps_enable_interrupts(), which enables and unmasks the PM
interrupts. In timer mode, it calls rps_start_timer(),
restarting periodic engine-busyness evaluation. The timer
generates software RPS events and queues rps_work() directly,
independently of PM interrupt delivery. Neither mode requires
the late worker to unmask interrupts while the GT is parked

Fixes: 3e7abf814193 ("drm/i915: Extract GT render power state management")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/16562
Cc: stable@vger.kernel.org # v5.5+
Assisted-by: GitHub-Copilot:claude-opus-5
Assisted-by: GitHub-Copilot:gpt-6-astra
Signed-off-by: Krzysztof Karas <krzysztof.karas@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patch.msgid.link/20260910081329.3300417-1-krzysztof.karas@intel.com
(cherry picked from commit ca4a6deadad15b91ee083afe445fa6bdbfb68206)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
[ sashal: Retained `&gt->irq_lock` in lock/unlock calls because the lock is stored directly rather than as a pointer. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_rps.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/gt/intel_rps.c
index 0a03fbed9f9b7..3f2101885cfcc 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -1752,7 +1752,8 @@ static void rps_work(struct work_struct *work)
 
 out:
 	spin_lock_irq(&gt->irq_lock);
-	gen6_gt_pm_unmask_irq(gt, rps->pm_events);
+	if (intel_rps_is_active(rps))
+		gen6_gt_pm_unmask_irq(gt, rps->pm_events);
 	spin_unlock_irq(&gt->irq_lock);
 }
 
-- 
2.53.0



