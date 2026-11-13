Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590193;
	b=0jvgqPpDCmWVyTfd/Jrhy/s1r3z1JPyzHmHLeFPTCvpvE4ZcJeioKiqVkKx1dVHtv72x
	 DwF2ajStoGUv4v1MBUDrRsz6ctu2DScYJvzp7/4sl9XYCsm2oIWoSoQ6hWD60RoqyZMld
	 1NlqwHJ6KIQcLaeL5b93a3DZwIsasQTjxfFLe9uVZvF3n3N/qWlB8Xxs5/mbiMSoDtMsC
	 Hl3N2vHkcX1D5Q7+u4v46nJqc/BTzfbtnTK7eU/35CN/rWoRwjaWaJxlbVJiiTYI8w0Cw
	 XHuc/AyW6uoFiArK1CNmQEIVWy8IIpHzGeLTbKeNhjc0FdW0bpZyAM1utJDvBdgCOug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pqpopvVU0ib6SyiFSCjUdjg1Tu3dfCipVlnFFwrkFlU=;
	b=336PpzSHbIEpTKQBlxdH1Hqm49clPsDsNyy/fjXINxmvgsMjvtWYLsT4zruPh1VBWoXn
	 aNcGldAnK7Aa1bX6DI1QpAilME5SXWX/YXipcirKv7VVZbkt2Fl2X0sLKzyW8n8DTK9aX
	 Y9MVE2QlekoaNzW0mSdea4gBXmqr64OES+0iu3KIapAMprBr9UlCSsxrVbwkNUxTuiZ+j
	 W3RWcAPSyFaZ9MHARXzcZccDSRfI1b3vnM6J5ptUlxUTNuscKm0zqkshx3F9SNqx1OiAp
	 9MnB8B+NW+i/jDVl/X6n9TI3C0RDhsrMEDdvlMzyoff97X4i9oWt2H2v/01uidLs+Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0vwiQTh0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8EA606B36A;
	Fri, 13 Nov 2026 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0vwiQTh0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7DF1F000CB;
	Fri, 13 Nov 2026 17:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590193;
	bh=pqpopvVU0ib6SyiFSCjUdjg1Tu3dfCipVlnFFwrkFlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0vwiQTh0JuyvmAFQ4Vhh4fl4+iUmbKP4heGXfgl0Qltnei/6q/grnPdZTJaZhm6fI
	 y4BUGE2ON4RqlnNan2XrVP8NF/lxulDaRmbDu+QLhZNUfT0tw0khEzk9BgTKz8EF5N
	 uoPhNEcbuN69JMEEkVhyq0flkPV+VUMEb4a5SE1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 201/686] drm/vc4: Publish the output fence outside of job_lock
Date: Fri, 13 Nov 2026 10:45:34 -0500
Message-ID: <20261113153827.857460660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 9ee552a42c3905b4547e83173d46413137ec329a ]

job_lock is taken by the V3D interrupt handler, so nesting an IRQ-unsafe
lock under it creates an inversion. drm_syncobj_replace_fence() takes
drm_syncobj::lock, which other paths acquire with interrupts enabled. For
example, a thread interrupted while holding it blocks the handler on
job_lock, and the handler can only make progress once the submit path
releases job_lock, which it cannot do while waiting for drm_syncobj::lock.

This is reported by lockdep:

[  188.139076] ========================================================
[  188.139086] WARNING: possible irq lock inversion dependency detected
[  188.139096] 7.3.0-rc3-00067-gc4f3feeaf60f #67 Tainted: G         C
[  188.139108] --------------------------------------------------------
[  188.139116] swapper/0/0 just changed the state of lock:
[  188.139125] ffff0000054f8ff8 (&vc4->job_lock){-...}-{3:3}, at: vc4_irq+0xa8/0x28c [vc4]
[  188.139234] but this lock took another, HARDIRQ-unsafe lock in the past:
[  188.139242]  (&syncobj->lock){+.+.}-{3:3}
[  188.139256] and interrupts could create inverse lock ordering between them.
[  188.139267] other info that might help us debug this:
[  188.139275]  Possible interrupt unsafe locking scenario:
[  188.139284]        CPU0                    CPU1
[  188.139291]        ----                    ----
[  188.139299]   lock(&syncobj->lock);
[  188.139312]                                local_irq_disable();
[  188.139320]                                lock(&vc4->job_lock);
[  188.139335]                                lock(&syncobj->lock);
[  188.139350]   <Interrupt>
[  188.139358]     lock(&vc4->job_lock);
[  188.139372] *** DEADLOCK ***

Hand the fence over after job_lock is dropped. The job can complete and
drop exec->fence in that window, so take a reference first and publish
through the local pointer, as exec may already be gone.

Cc: stable@vger.kernel.org
Fixes: e84fcb95e074 ("drm/vc4: Export fence through syncobj")
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patch.msgid.link/20261004-vc4-misc-fixes-v1-1-b763df9e33e1@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_gem.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_gem.c b/drivers/gpu/drm/vc4/vc4_gem.c
index 5eadf11f289a8..812636318cd9f 100644
--- a/drivers/gpu/drm/vc4/vc4_gem.c
+++ b/drivers/gpu/drm/vc4/vc4_gem.c
@@ -639,8 +639,11 @@ vc4_queue_submit(struct drm_device *dev, struct vc4_exec_info *exec,
 	fence->seqno = exec->seqno;
 	exec->fence = &fence->base;
 
+	/* The job can complete and drop exec->fence as soon as job_lock is
+	 * released, so hold our own reference.
+	 */
 	if (out_sync)
-		drm_syncobj_replace_fence(out_sync, exec->fence);
+		dma_fence_get(&fence->base);
 
 	vc4_attach_fences(exec);
 
@@ -662,6 +665,11 @@ vc4_queue_submit(struct drm_device *dev, struct vc4_exec_info *exec,
 
 	spin_unlock_irqrestore(&vc4->job_lock, irqflags);
 
+	if (out_sync) {
+		drm_syncobj_replace_fence(out_sync, &fence->base);
+		dma_fence_put(&fence->base);
+	}
+
 	return 0;
 }
 
-- 
2.53.0



