Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618764;
	b=Sc/gs9rOcEfKGSWRvBHmMId8kS0gTwTwHnwrxe88JAn+HbG2vtuy3Ua5eBc77qNVlTDu
	 S/eycy9TwdaVGX3cYRbJHrh2+cnSQebDiV/Xd1Egbw/PF0ZkNTYDsX5iCRJlwcqTzi26j
	 SzoKQ16eHJr+yyxoqlQ86Ta1DuHrESsdPVTcDgssnsTUeLUNCQ2qctXhMUV4tmUZpJd/R
	 P1xHIoQPDp1UHmhMoIs7pW+fqXv9tIMkJ4hq6yyiUue1wF+m8ng5Koha/2H7Eu5ehwOKf
	 l6BZ8kxDSNr6X9uclMVK/TnY7MiPpNd9fmXZDCxlklF7JXTC0pU2sTkk7R1FTkkoMbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xwZYuR9A9tKt0+9srnKnQCR1TgT4NHPTYPy6skdFxEw=;
	b=kSHQgOnSAYsUQ9KsjZ0VoAY5JTJbqyIKeH2vlmBUwdp2DviFfh8FeSrDwHOXEtHPeVu7
	 D7fo25MmD5T+ADFHmPPlmbA5TUNK6SRcwieG1U2raQ9/SaVDEi0hnn7hh3wfCvTBEeAAw
	 nvmeAgwTYjCJODo2M/l2Y8KGEWKMmVeWW8Xz8ayufD93faZfld7JbFyOyL5o3l79hn5a3
	 lA9nWbP7EBB8HqzSHtD5/hDaTNcABg0tgxdtCNq25Pg2CYupws1gdi1T6zXaeswTs6BUZ
	 Sqo94OWFQTyaOtGqOkqYbJyP7HPcFez0BqJclS+He+sn9MMeFmPhOU9gPEhhNNUIJTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y5xv8ZPB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EF3606A321;
	Wed, 25 Nov 2026 14:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y5xv8ZPB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FC41F000C6;
	Wed, 25 Nov 2026 14:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618763;
	bh=xwZYuR9A9tKt0+9srnKnQCR1TgT4NHPTYPy6skdFxEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y5xv8ZPBrTxGmRegzWqK3KtGSjRdoP+RG+NaFTb3CbeyRoaiKULet+Pe3nY5f4wie
	 5JTX1lHsW/5C/B2C96sRBuq8RzWW3IryZYoFFD2/Eug4McBICnJURWPx5Al8yQLny/
	 K4vu53GVyZydrs4tY2+Bbg85LFbPs894qSgiTRZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satyanarayana K V P <satyanarayana.k.v.p@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0382/1005] drm/xe/guc: Protect timeout handling from device unplug
Date: Wed, 25 Nov 2026 15:28:40 +0100
Message-ID: <20261125143830.686565186@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>

[ Upstream commit 78945c8c44bb2cfd6e5d2f762535efce0cefb086 ]

The GuC scheduler timeout callback accesses device and GT state while
handling a timed-out job. Guard the callback with drm_dev_enter() and
drm_dev_exit() so device unplug waits for in-flight timeout handling.
If unplug has already started, mark the job with -ENODEV and return it
to the scheduler for cleanup.

Fixes: 6eb2aad402cc ("drm/xe: Move hw_engine_fini to devm managed")
Signed-off-by: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Piotr Piórkowski <piotr.piorkowski@intel.com>
Assisted-by: LLM
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20261013152417.3189567-7-satyanarayana.k.v.p@intel.com
(cherry picked from commit 3e9a95f3df5b0f9de163c5ee4e4e287750ef9655)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index 864859bd0ccc9..bdaec10c6d197 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1505,6 +1505,7 @@ guc_exec_queue_timedout_job(struct drm_sched_job *drm_job)
 	int err = -ETIME;
 	pid_t pid = -1;
 	bool wedged = false, wedge_device = false, skip_timeout_check;
+	int idx;
 
 	xe_gt_assert(guc_to_gt(guc), !exec_queue_destroyed(q));
 
@@ -1520,6 +1521,11 @@ guc_exec_queue_timedout_job(struct drm_sched_job *drm_job)
 	    vf_recovery(guc))
 		return DRM_GPU_SCHED_STAT_NO_HANG;
 
+	if (!drm_dev_enter(&xe->drm, &idx)) {
+		xe_sched_job_set_error(job, -ENODEV);
+		return DRM_GPU_SCHED_STAT_NO_HANG;
+	}
+
 	/* Kill the run_job entry point */
 	if (xe_exec_queue_is_multi_queue(q))
 		xe_guc_exec_queue_group_stop(q);
@@ -1683,6 +1689,7 @@ guc_exec_queue_timedout_job(struct drm_sched_job *drm_job)
 	 * We want the job added back to the pending list so it gets freed; this
 	 * is what DRM_GPU_SCHED_STAT_NO_HANG does.
 	 */
+	drm_dev_exit(idx);
 	return DRM_GPU_SCHED_STAT_NO_HANG;
 
 rearm:
@@ -1696,6 +1703,7 @@ guc_exec_queue_timedout_job(struct drm_sched_job *drm_job)
 	else
 		xe_sched_submission_start(sched);
 handle_vf_resume:
+	drm_dev_exit(idx);
 	return DRM_GPU_SCHED_STAT_NO_HANG;
 }
 
-- 
2.53.0



