Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056774;
	b=AXrH2GjFLIfU1mTLpCs+V9TGe2SSE7maZs8XuJumzsj9cS23SnuSwHLJTJXhLQlx7wq4
	 xBGaVeAoEd630e1wFBc4AKooGFwVWEJbb+u1pEIjeTUZ7WilYlARS4coL+CZHvPJroyXY
	 ua82lqBOlO7YrWpqqh5ioICA340n5k84l6HmqTEpY9reAh6EndrmwWBKp7sda7sHUPEPQ
	 rh5CL5vOk7TETWq92AhOPrcBgCUMTX6CjvnEgTyLsWClmZ/5sCjWK0gdK33L2Td0/tOkv
	 1FIWzRbgWflPpilZHMgmCULCQdvw90yT4TWcaiNHKeyhOrGGkh6e8AR/4cENDjj0Qow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/o0v0EF2JGSjp2d5E8WomETwlbJyHZuk80Jl/Josm70=;
	b=OEYiD4yfBiywmFg/OLOBkWgiW4TYZ+xhgnlWz6pKUEGrD/N2Osja7Te+u7ggvzdfQefm
	 YB0mZkn4WmKig697nHegF6Xg12lLdQJxY3kpw19NvCnKk+AA+KPHPiFoyRyWh1gwXMamO
	 jTSZs6F5C0uGTXQeitMMGqsedlFxvh8AZI9lqvPI4xKWIo/EbVAGGT/R3hVEUZ+rXX1As
	 LaGL9IpPkiD5LTmolMpA1zbPUCVT8tENhGgU5Tn7FzfnWIOti+4HCbhEtA9fIh++hJxJc
	 b3eZXyziSDcZQxkqyIF46lWXwCpdXyDuiuaFg9nzKr/bcoEyePrgBlBdfT3WSJuNd/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPHu14d4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7A3606A31C;
	Thu, 19 Nov 2026 02:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPHu14d4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA421F000C7;
	Thu, 19 Nov 2026 02:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056774;
	bh=/o0v0EF2JGSjp2d5E8WomETwlbJyHZuk80Jl/Josm70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPHu14d4/1q0mRCBVjp6RacqCTnFUAAvL5JA9ynJa85CHi/+JOwIwSUr3uTj6jdiV
	 AsYZXkRYrqb1eBrbl4YdYifoP3DEPsR66D5wmEDBppG0hVVdIBPxzznksKwB/3vQ+a
	 6q2JCmVGEquqMp7CaBhTcSXuuC3dVwIe9Etw3hMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2107/2214] regulator: irq_helper: replace use of system_wq with system_dfl_wq
Date: Wed, 18 Nov 2026 16:03:03 +0100
Message-ID: <20261118150134.919300884@linuxfoundation.org>
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
index 5ab1a0befe12f..64be715a395fb 100644
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



