Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032764;
	b=ZJY4xmNaB3LYPcZ+mANCwzOj6xP4jCQ+jtY/z2ne/efJrpG9yGRProYiTubSqclb8b5v
	 AvoJdfhnPOeUadytZBbXJ6XqJW6hd4rizpWgCIK4rItxuL8AYH+uCPDXg04e0jx2oZGnW
	 V/V6pCP3tOengCamfqw1r+Q8BN/X/9iFQewi8st6LGitm8XqO5Qwyu30CydJOvVp6EJl5
	 40ZTVGLwOiU5bNWKju7uckLETjnUgSfRtT3vyA4/ke/PWQoaw8uMWLwN0xYBpCvFr3Q7h
	 qLhDQuPhkpX5w1Myx2AtRxgV+mZudOzZGG+tD1bU0GXKh3tzpTDfYmmTRJ96m742aXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BgnkUerDgLwflY4mKy0LHzVy691aUS5UrkTeFNYtzg8=;
	b=wMJXuvT5j0Y4pghOw7e/G6Ub70cg6rCW0id7iJA7sMGa6l/WYXbxL0HxfMc5P+EZqP6A
	 u6F1rM/TE+puNhyms4K+CGFBbxkOznSG7Z8N3LQinRmP2Ltc+gIP5J0ksg7Fz61ot5Shj
	 QaGaCcE9b2P+Qju5fm+XGqeTnNAQIeVlaWhBGmLNUKFELQmiYazb9x5HxSldd/3qWm2h8
	 E1VyAavNQPF+I0lkkmxRD9hrHm/x1D9EDC9es6N5xj1WO4E2wtXqDnAL1oUT1TDxYoMsS
	 vZJcn00ZyhlFYMudwaM/b4gzRlWzYFq3+gTGIvZoxVVMpHINXQUtXZ/NM5ZYsRlPzoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zOlTC4bh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748D8606A320;
	Wed, 18 Nov 2026 20:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zOlTC4bh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74A81F000C4;
	Wed, 18 Nov 2026 20:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032764;
	bh=BgnkUerDgLwflY4mKy0LHzVy691aUS5UrkTeFNYtzg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zOlTC4bhfeSVxAKpVZeuq/KEUMAuH0ez69isTEcNWhmiBHKCzfDvM+T6T8Bdtiypj
	 Qd4R04PM1YHr3dX/bwD3BmnR2LQ9KwbFqG43XPwcA2Q574KNrotRn5xXRQOhPFPcNO
	 4qy4dE4qW4MHDNKvWWQFsKLROIhPwkl91S/T+i54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1528/1756] regulator: irq_helper: replace use of system_wq with system_dfl_wq
Date: Wed, 18 Nov 2026 16:00:55 +0100
Message-ID: <20261118150109.797932745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Crivellari <marco.crivellari@suse.com>

[ Upstream commit b6f4bd64f453183954184ffbc2b89d73ed8fb135 ]

Currently if a user enqueues a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistency cannot be addressed without refactoring the API.

This continues the effort to refactor worqueue APIs, which has begun
with the change introducing new workqueues and a new alloc_workqueue flag:

commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

This specific workload do not benefit from a per-cpu workqueue, so use
the default unbound workqueue (system_dfl_wq) instead.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Link: https://patch.msgid.link/20251106142914.227875-1-marco.crivellari@suse.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 8a6d73e316f9 ("regulator: irq: freeze deferred hardware access during suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/irq_helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/irq_helpers.c b/drivers/regulator/irq_helpers.c
index 0aa188b2bbb26..2a31704da6c5d 100644
--- a/drivers/regulator/irq_helpers.c
+++ b/drivers/regulator/irq_helpers.c
@@ -146,7 +146,7 @@ static void regulator_notifier_isr_work(struct work_struct *work)
 
 reschedule:
 	if (!d->high_prio)
-		mod_delayed_work(system_wq, &h->isr_work,
+		mod_delayed_work(system_dfl_wq, &h->isr_work,
 				 msecs_to_jiffies(tmo));
 	else
 		mod_delayed_work(system_highpri_wq, &h->isr_work,
-- 
2.53.0



