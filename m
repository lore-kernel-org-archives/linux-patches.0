Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027892;
	b=E+DG5ov1D2RdVUMCvbgiovYRxgtezvhkbKmZrLzX6dgZTYgSUi/SDjAOv27NmqgkGqn5
	 YMlmyPDxVy/RV9wPpqZuu1lQ3hlwKd+BV74LJJEJt3V8C+8NMoqKFEvfIcP8u3POdDuE3
	 HgB2VQL6uuGkSD2J6oW21P1RcYOpfvwmDiyq/JBZXGpqZzMUKh7yA5DFik3UWIhppgOm1
	 Ep9TXHsEBWCESpn0fwVGDbcq83tNLIKZcnDbqtsOyO3/v/cjEp42+fRdHZbUqkFssRhLc
	 6G+RyENi+GglBryf0YuPdxw+NadMkNpYKDZTFf6dJv4c+ozSalnE+Q1xUaz1XIiPR1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qJ7EEe98gbgipwI6IJQz1AyteS528iVN9ncEPLDEpBY=;
	b=JHrHjydFqOOQqmLw/c8dn/H4b2ODbp7i6wK2dyXLu1SvV84EEWZU5u9eCJZUVzkkwQex
	 W6ANOO8J27fQA048GRPNzY5AsI710vuu2YcptAM8C9kWaSs4hyleeuZrWCzGAMPTqU/OB
	 JraTSDMSV30q0peuZpyXOv0H7tfWl1QBN9GvV3JfqG0goW18l417rPTv+K8xivjs1Gt+v
	 OH9lb1Urx74aR/UOx7960IQVSs2pG4Vps9f7mH9jwdJw/laayRecKlvp199OVpyuOnlWN
	 VvCqWdigBEkowI5+y93//qHi2ZlGt30DTNH9aADstMmofZBFEn0fvMnkFoH2aS6MqMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SXyqGVe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDAE606A31C;
	Wed, 18 Nov 2026 18:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SXyqGVe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915C71F000C4;
	Wed, 18 Nov 2026 18:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027892;
	bh=qJ7EEe98gbgipwI6IJQz1AyteS528iVN9ncEPLDEpBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SXyqGVeZgnSBtbOovigjP4nkVksRNQnE1xAXwIgJg6aYXxJAeCpMzFBtdvOG+Z0h
	 Rd43702zwMhzvb9L0R9Pg1lWgKQ9V6ps9X1FtWUjxgRPpQINByIOhOjzUgnYUkKzMK
	 7gvqZoqNsxyu3xDWYvMHExoQZyMYct/VQTSb9N/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1913/2151] regulator: irq_helper: replace use of system_wq with system_dfl_wq
Date: Wed, 18 Nov 2026 16:00:48 +0100
Message-ID: <20261118150231.470816007@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5742faee8071d..5b3cfac286676 100644
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



