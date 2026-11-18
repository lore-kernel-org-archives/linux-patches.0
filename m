Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042358;
	b=TBTPUSfRayCapRYNl1j16yD+h6/Ag/GLCFV7OkBHMHYGa9GAp1I/kn8f0cFgytB9HQe0
	 QecqU5I1jrxRidKp/OZwQkJdogeKBkOUsADgp2qxwvTT1RzFqk3hmRWbXnTt6Sx284hLT
	 B8wWwQKRa1JgYLqtD+mhvkGJQWWZDY6sc3aE4rWuV0J1ixmSDnjHKCvVVOI7zAl7+dV68
	 UH44nAA/19isUujx3fagn32uYYVkdvBLCWI6DMVqAUVpQgiERBCHrwtBRS5+uDpsEbZlO
	 szyNp1HBB0HKYUEh1lqv4407OOtgsCfaYrqjdrVy9X0ldFzeq17T7VnD4DiM+1Mxagg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bAe0PycMy34DRb4GQge+EqcbELOvjRFJ2ZVlt1vy80o=;
	b=ad7bS7WgBum67L6g9APBLYXwIvWG8SdQ9RbsbA7i8Jt7OjmZ0H3/w0uymXuL7VUPged7
	 y4KPf9o48cf0Vtq9rhVOLh+E6TyKhA+r/inhk/0L3jq8art6ehlTpgEr2eSzpKkZZHmto
	 LTfWo8GmO//szsFP5JluQn+9iem52PIdnkfTYfTxw+8XP3OUbkq8rzijjmF8NiMfER3+G
	 cHedSkX4kHVNfZF5QhDK7PCGILvRtxhPB0Jq6/LuL4bdTC9wbnLM31qVbvqyWRVB7G4UJ
	 G2XCoyjpVLFMxos2LdkgOLxL8rmHbuor9oq6mli/2r3S0aXvDpN/1V/VbObxAV+XBAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ItXlJQ7Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E20606A325;
	Wed, 18 Nov 2026 22:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ItXlJQ7Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5242C1F000C4;
	Wed, 18 Nov 2026 22:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042357;
	bh=bAe0PycMy34DRb4GQge+EqcbELOvjRFJ2ZVlt1vy80o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ItXlJQ7Q6082yrRMrk/IhFFmyGv3lgUvrhXGA/W7awauc+LOJ3En5YLh98WkdVyJF
	 BUIZq93AnvZfLagulF2R7b0Nfb8BXrLOGVC9kIzcgSdIxhoyci0K2LBIk3YExM7Cyn
	 kU2m5Uv30IdVY2GAOKRJZe4rmFdSWFD6Mr4gsw8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3141/3318] regulator: irq_helper: replace use of system_wq with system_dfl_wq
Date: Wed, 18 Nov 2026 16:02:43 +0100
Message-ID: <20261118150454.107424282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ba07a7016a272..ad424d7542f14 100644
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



