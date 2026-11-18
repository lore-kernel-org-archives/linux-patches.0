Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050425;
	b=Fltw1Xyno9dIW6Mom+nabdqFigDtXP168208Cgpe7EQVoMsBa1Q/H/ymB+Mu44BPrQFl
	 m35JLWTew3beBXvsx4PHeIRDzaPrJAqyjhWf7h0ly/dsVjWMW0raNervzYPHBCTWBUdLJ
	 +DIjZ4oxW2b7TtCLSN+ZdKMGG3/M+FUjTwaMIo2G3dDvqBWva5m+pEbUAWz9z5GINOc+4
	 Nu/Ogy8SGEP1D9N1hhnrHUuUDtOVdPvBDRBe2Q50dE2iasQNF4JYFETKifnG4Bkelvg0a
	 zq443+Wla+7kgffIfVYIi2pN/eWrp7coQBo076eqIxtROvEYWZEDaKv+6+rzmOZg0DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hQ9+Ej7hF1gdiBQPENzfm2Psq8Wz5NGSu4UiHV4DP0o=;
	b=RFpPTgT/MfH1jvThkFzIGnPNcZaKIYyJW74FRDT0rbOey7tsqNx97gplXUD3PaKdBy1+
	 J0bH5Im65+koxt3JqY3FQOi4udl4sZf534WjGPImpo0a8GR75kW1HH/C3QJJAJ7/JhJN9
	 Wzu0PUUJLeZZ6B6XorbjwQsMJpZZNX6XNwrRVBZQo9oWlomw8keSPuAq7jyyS+vsv1Te3
	 Ca1x670wwa+dxQ1FSj745fb9WdQwG02I7wbRXiV7t+qyPhcjlAGPMeEPf7qKTKaqP1dm0
	 HvAsDyIFYiBP6yWwqhwpCuckddmPdnt0bcjzwAov1VvopYgiVms3+5wh38X+RlC9s5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BTd85MYY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84423606A31C;
	Thu, 19 Nov 2026 01:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BTd85MYY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F531F000C4;
	Thu, 19 Nov 2026 01:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050425;
	bh=hQ9+Ej7hF1gdiBQPENzfm2Psq8Wz5NGSu4UiHV4DP0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTd85MYYawOddGtR7x7U4v/H3ub+jl2clxpLytO4jTyDb8RoaxdwQ9ENkEvmvGLLB
	 vuTE+k6GHtvaeMyJiU2Qi9jahFEOUFGqgNqn+HYEItAbdIYPv/3s5KY1ZAuE8gV7Jg
	 Rd3cnNUn6S77YHp0NtaifUj1RCMcC1nkibFB3oQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2702/2857] regulator: irq_helper: replace use of system_wq with system_dfl_wq
Date: Wed, 18 Nov 2026 16:02:16 +0100
Message-ID: <20261118150338.851076514@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



