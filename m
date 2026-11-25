Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618865;
	b=siLTphcmWb996N3PE9YyZ6gRU9HfsB0YN1LzV+C/uqfLI6JX31FtQkhdW0iv7chiI5Cm
	 WZRBYFjr1zg3NAgSyec2M5wDRBIibDHB5rlw7kcWOV+Zgm308tm7V5Nsqad3yen6CDHZV
	 F0mQd7SVZt85v1iVpWwv8OF9/doo7kbJVjAhXLAI6tMCyI9ITE/dj+WsypvGFOxj8GE8e
	 SfcWRTOWWPIkZ/i6+ILiXmoq6amX+tp+LLJJFCDMgr2Tu75xIy7ysu8suzRcXYsNK1Ci5
	 pCmhzzgOQuwv+itkTAXzNwFnLEsawK9KF7ewEEfEEt0AdvAYEU9UMkUer2OhzEIrT5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nsEWmjumPfPqz9DjoOzO1o/kyqdRhQuQJIlSIId9upE=;
	b=Z9T36oa/dz03tCyGLA3S45Jyj5ik9yK7FURo7hbljcq2S/67RTq5S66X11vCcKG84WnE
	 glczSKCsNseA+I4O4Xfo/qv6WwXXxs4Y40aHz0d8KbCg5ar0o3mWrrOOAd5Kk1hReOCSd
	 LxWHMna6TsannVzjKA0kB/pVkYeMugF0S469UGSfd4bq+B3nQP/6+cpXP0DxDopqkESYG
	 nWr3oiHNCLFH5FJwuOCYLHFn/H2lG3Sm86jZjWX1YgDHwXmJfQSbdHyfJKS9YKyt2U6gc
	 muLejgScVSieiAszhSWaLCRYE9I1XL1xiCDDTKYFlEO/2uaBfsQe4bf5bkrSWBC3K9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uuFkvluX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA53606A332;
	Wed, 25 Nov 2026 15:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uuFkvluX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BAF1F000D2;
	Wed, 25 Nov 2026 15:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618864;
	bh=nsEWmjumPfPqz9DjoOzO1o/kyqdRhQuQJIlSIId9upE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uuFkvluXF8ykobbGTuSMTfOiPzinDyB1mpOlRIPvtp8uo1Ug/hENNkfDgfdI71r3d
	 S/wuRi+myS0jOizAHzQhuA8XBHewtquz7ap9/07VD5vLoNVWwf7XjNOHAfLQ+X8yPx
	 +Hp/4dMtEuZt7X9S417cCgXklDZXwlFo/muHcJT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jagmeet Randhawa <jagmeet.randhawa@intel.com>,
	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0406/1005] drm/xe/guc: Do not attribute a TDR disable to a pending suspend
Date: Wed, 25 Nov 2026 15:29:04 +0100
Message-ID: <20261125143831.262110389@linuxfoundation.org>
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

From: Jagmeet Randhawa <jagmeet.randhawa@intel.com>

[ Upstream commit eb1f465e9119f7680458218a63bbb8d32844908e ]

handle_sched_done() treats any SCHED_DONE with runnable_state 0 as the
completion of a suspend whenever q->guc->suspend_pending is set. That is
not sufficient to tell apart the two producers of a scheduling disable.

When a queue is suspended, __guc_exec_queue_suspend() sets
suspend_pending and queues a SUSPEND message. If a job times out before
that message runs, guc_exec_queue_timedout_job() stops submission, which
traps the message, bans the queue and issues a disable of its own via
disable_scheduling(). When the GuC acknowledges that disable,
suspend_pending is still set, so handle_sched_done() misattributes the
reply to the trapped SUSPEND message.

This signals the suspend fence for a queue that was never suspended,
tripping the exec_queue_suspended() assert in suspend_fence_signal(), and
skips the wake_up_all() the TDR is waiting on, so the TDR stalls for its
full 5s timeout and then triggers an unnecessary GT reset.

The suspend path marks the queue suspended before disabling scheduling,
and a trapped SUSPEND message never does, so exec_queue_suspended()
distinguishes the two cases. Use it to qualify the attribution, the same
way the VF migration replay path already does. The trapped message is not
lost: it completes the suspend once submission restarts at the end of the
TDR.

While here, wake guc->ct.wq after clearing pending_disable rather than
before, so a waiter observes the updated state on its first re-check, and
wake unconditionally since the suspend and destroy paths have waiters too.

v2: Rebase onto drm-xe-next. The suspend_pending check moved under
    sched->msg_lock in commit cf4171a20d13 ("drm/xe/guc: Fix race
    around q->guc->suspend_pending access"), so the
    exec_queue_suspended() qualification is folded into that locked
    snapshot rather than reinstating an unlocked check. No functional
    change from v1.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Jagmeet Randhawa <jagmeet.randhawa@intel.com>
Reviewed-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20261020190705.20127-1-jagmeet.randhawa@intel.com
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 48 ++++++++++++++++++------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index e80291cdf0edc..8124f9d7b44cb 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -3128,8 +3128,17 @@ static void handle_sched_done(struct xe_guc *guc, struct xe_exec_queue *q,
 		xe_gt_assert(guc_to_gt(guc), runnable_state == 0);
 		xe_gt_assert(guc_to_gt(guc), exec_queue_pending_disable(q));
 
+		/*
+		 * A TDR stops the scheduler, which can trap a queued SUSPEND
+		 * message, and then issues a disable of its own. suspend_pending
+		 * is still set in that case, so only attribute this SCHED_DONE
+		 * to a suspend if the SUSPEND message actually ran, i.e. it
+		 * marked the queue suspended before disabling scheduling. The
+		 * trapped message completes the suspend once submission
+		 * restarts.
+		 */
 		xe_sched_msg_lock(&q->guc->sched);
-		was_pending = q->guc->suspend_pending;
+		was_pending = q->guc->suspend_pending && exec_queue_suspended(q);
 		if (was_pending) {
 			clear_exec_queue_pending_disable(q);
 			suspend_fence_signal(q);
@@ -3137,26 +3146,27 @@ static void handle_sched_done(struct xe_guc *guc, struct xe_exec_queue *q,
 		xe_sched_msg_unlock(&q->guc->sched);
 
 		if (!was_pending) {
-			if (exec_queue_banned(q)) {
-				smp_wmb();
-				wake_up_all(&guc->ct.wq);
-			}
-			if (exec_queue_destroyed(q)) {
-				/*
-				 * Make sure to clear the pending_disable only
-				 * after sampling the destroyed state. We want
-				 * to ensure we don't trigger the unregister too
-				 * early with something intending to only
-				 * disable scheduling. The caller doing the
-				 * destroy must wait for an ongoing
-				 * pending_disable before marking as destroyed.
-				 */
-				clear_exec_queue_pending_disable(q);
+			/*
+			 * Make sure to clear the pending_disable only after
+			 * sampling the destroyed state. We want to ensure we
+			 * don't trigger the unregister too early with something
+			 * intending to only disable scheduling. The caller
+			 * doing the destroy must wait for an ongoing
+			 * pending_disable before marking as destroyed.
+			 */
+			bool destroyed = exec_queue_destroyed(q);
+
+			clear_exec_queue_pending_disable(q);
+			if (destroyed)
 				deregister_exec_queue(guc, q);
-			} else {
-				clear_exec_queue_pending_disable(q);
-			}
 		}
+
+		/*
+		 * Wake after pending_disable is cleared, not before, so waiters
+		 * such as the TDR see the updated state on the first re-check.
+		 */
+		smp_wmb();
+		wake_up_all(&guc->ct.wq);
 	}
 }
 
-- 
2.53.0



