Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019644;
	b=eNiF+lOt8DgGg7jzXm94geQVrivIGWahLC/YmdZyF3DNkYbfPWF8M2S7WUvLP4QRgDLT
	 lJy+P9YMGDXwvzkcZV3weMZ+dxg1lbCUL+bAN7EzKW/MXN3d+xu4pyrkvB/JCcyYOgahK
	 TiMUzHiNUqdk2eoAmxRTtH8gpSV9ZebGMG4E66ZwvEyTFpv7pDR5Ok5obOzYW4wjaudsA
	 SZppSQgx/rLzZOPUOy/F2X4iKEqwsHnuSeNsXIH+7PIYIqhYo6S3YqNA07OmOeOOke+h5
	 JDNiQ7akdhMwG1ZhKW6WjnUMvhGEuUD+tA4T2rrpyWaX1QyJ2Hh90lCQdVMRReTiKlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ETRUrhHUndL1WBJFnEq02Uh0a2dux6P5r7H48AEwDAM=;
	b=ii2IaypfMjG2scnp6OfIbrNZ23zF4TveYuPGmnbos9PaP2kp3152TQfRxp+vXJTHsR2T
	 LfC9UcCERhGzLxmxZyXSjP3DneSLxwmFiBwfv1rw0f+pT2g5/WtCG9/WvW6w5vIznBwh0
	 EmXUSRgIuB69g27OI42NBonl9F9JFETZmfG6/v2e85MbI2PXO8YRk2Uni9pmN2ACs3MxR
	 CJw//5701aOgOMXS+9nMEsw9e5atRL+qXl6+up60cWGhCBZh5qZ0FKzx6LnrcBhPJ9Xom
	 dH3cWEdAz8fRPBizVJeEuTlGPNT49bxjJNMdS0rVenJNl4Sy7bJws+sW7kbgthD6NJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dP5EgebA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056C1606A32F;
	Wed, 18 Nov 2026 16:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dP5EgebA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9241F000C4;
	Wed, 18 Nov 2026 16:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019643;
	bh=ETRUrhHUndL1WBJFnEq02Uh0a2dux6P5r7H48AEwDAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dP5EgebA3D4t5f1gSSTJGWZoliyXSXE0eyUgCEcAInkfdPEG/MYlMYxEor8wIx+QK
	 sxVJFTp0zWAxrf3nLqQ2KSLwNrLUNygh/+wONObC3+Lu7yWUpERHw/EdsdHmgqzMDm
	 vzuktqiG+fnfJt3duW0297VLKYQI3G5AYs6qdofw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1670/2651] srcu: Use IRQ_WORK_INIT_HARD for srcus irq_work
Date: Wed, 18 Nov 2026 15:48:30 +0100
Message-ID: <20261118150347.823257978@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit f8d95888093348be1235815946359f9cbc2f7012 ]

The irq_work in srcu is used to schedule a delayed work. The work item
is not scheduled directly because it is not always possible wake a
thread directly.

On PREEMPT_RT the default irq_work is initialized with IRQ_WORK_LAZY and
is delayed to the irq_work thread. A system booted with the command line
"trace_event=…" will freeze during boot because the irq_work thread is
not yet deployed (and tracing uses synchronize_srcu() in
tp_rcu_cond_sync()).

The irq_work performs just a wakeup a thread, there is nothing wrong
with doing this from hardirq context on PREEMPT_RT.

Use IRQ_WORK_INIT_HARD for srcu's irq_work.

Fixes: 7c405fb3279b3 ("rcu: Use an intermediate irq_work to start process_srcu()")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/srcutree.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
index ad27880dd690f..700d2c30feb29 100644
--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -218,7 +218,12 @@ static int init_srcu_struct_fields(struct srcu_struct *ssp, bool is_static)
 	mutex_init(&ssp->srcu_sup->srcu_barrier_mutex);
 	atomic_set(&ssp->srcu_sup->srcu_barrier_cpu_cnt, 0);
 	INIT_DELAYED_WORK(&ssp->srcu_sup->work, process_srcu);
-	init_irq_work(&ssp->srcu_sup->irq_work, srcu_irq_work);
+	/*
+	 * trace events started on the command line require SRCU before
+	 * the irq_work kthread starts. Since all it does is a simple
+	 * wakeup, having it as a hard irq, even on PREEMPT_RT is fine.
+	 */
+	ssp->srcu_sup->irq_work = IRQ_WORK_INIT_HARD(srcu_irq_work);
 	ssp->srcu_sup->sda_is_static = is_static;
 	if (!is_static) {
 		ssp->sda = alloc_percpu(struct srcu_data);
-- 
2.53.0



