Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212391;
	b=vovlkFHbqMFSi9rQhK853cq3Makw+ai/oHOcTG2uHTOa1XKnL5amUHqs1U6gQfkdU1Aw
	 vlVuEcSiob2OlgIeavkGO+kXhL2sz/aUtijDXUeJ2X1HUZV+BU4Llgjd8iny30wE1doIH
	 CcGVamhSxbK21LZ+w7NxgWOKzkwlkq7ZHGKscN2rJlls7qXV1phklmIpGggYpZO78h2Lb
	 sqlzyc8oqFevzA5xY7Rz3Sl8Q8VGlZ0fxiT9MvOCpWkW75+zJOn9zFtyOKeeYLS2i93qm
	 vGFcAXU4Kih7jJBn044gj7JjHyCkvnYLJbwSDph+uS0bdDJZxFf6g7kaYRPHelLDLTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=STlJzTgc53k31uZSK0tpEFV0kuuJoQDIyG36IgBI2V0=;
	b=APllJBjMFb+Z2AaG+d2oPtMqgFbffPJvGt+1RZbBQ11VnEBA7efQQ1iI6DSvV3f6/bRQ
	 DbrqWBrA/gYhGrbArv1rOXfNoAjh2wTYz2c6M/1d4HKuAI0CKNyvw8M3FCJz05a9GNUnr
	 B1dReW8RQeQurUVoDizn/az9oHd98KPPg89DMpEENRvPiJ4eQ3z61JgLPuO+YyPENBdNd
	 FgIoPUp9qW11+eliSyCBcHGpxWFkauONSvAgEEL+kgMqPhqR1fQs1NEMdlFLAI6ZBsfnH
	 kEV1FIiJY+u8PWc5KcGwHrgB/9ZVdOyHcI60wOhAHUOWGmwVg7OLO+/fg9+6TyTf9HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDSERJUs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8C8606A31A;
	Wed, 28 Oct 2026 18:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDSERJUs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F9C1F01825;
	Wed, 28 Oct 2026 18:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212390;
	bh=STlJzTgc53k31uZSK0tpEFV0kuuJoQDIyG36IgBI2V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDSERJUs66kLdYP9XhXQVcEaLPmXzp6lym1q396Jn44wl82b3xM94LgufDvalN+GR
	 obliefT/Vzn3GhFvUHKqGPJvd69gmBFTmrdiPEseqT4lhcnbShASsKK8qcEqeOFvwY
	 F1kKmoJkLrOVESJzfqsmxj9jYSbfd65PtiYnMqEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0137/1887] bna: prevent IOC timer rearm during teardown
Date: Wed, 28 Oct 2026 17:37:13 +0100
Message-ID: <20261028170502.353301811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 77b1718e39e5c9f6956fb60807326af20baf889d ]

bna: prevent IOC timer rearm during teardown

bnad_pci_remove() and the probe disable_ioceth path call
timer_delete_sync() for ioc_timer, sem_timer and hb_timer, but not for
iocpf_timer.  bnad_iocpf_timeout() then takes bnad->bna_lock after
free_netdev() has freed the struct bnad.

Deleting iocpf_timer last does not fix this.  sem_timer and
iocpf_timer rearm each other: bnad_iocpf_sem_timeout() can arm
iocpf_timer, and bnad_iocpf_timeout() arms sem_timer from
bfa_ioc_hw_sem_get() when the semaphore is busy.
timer_delete_sync() only waits out its own callback.
bnad_ioceth_disable() can time out and leave that callback live.

Shut all four IOC timers down with timer_shutdown_sync() on both
paths, so a later mod_timer() is ignored.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 1d32f7696286 ("bna: IOC failure auto recovery fix")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260922014605.588040-1-mhun512@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ inlined bnad_ioc_timers_shutdown() into the existing teardown functions. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/brocade/bna/bnad.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index aecdb98f8a9c1..1733ccb89311d 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3728,9 +3728,11 @@ bnad_pci_probe(struct pci_dev *pdev,
 	bnad_res_free(bnad, &bnad->mod_res_info[0], BNA_MOD_RES_T_MAX);
 disable_ioceth:
 	bnad_ioceth_disable(bnad);
-	del_timer_sync(&bnad->bna.ioceth.ioc.ioc_timer);
-	del_timer_sync(&bnad->bna.ioceth.ioc.sem_timer);
-	del_timer_sync(&bnad->bna.ioceth.ioc.hb_timer);
+	/* The IOC timers rearm one another.  Shut down all of them. */
+	timer_shutdown_sync(&bnad->bna.ioceth.ioc.ioc_timer);
+	timer_shutdown_sync(&bnad->bna.ioceth.ioc.sem_timer);
+	timer_shutdown_sync(&bnad->bna.ioceth.ioc.hb_timer);
+	timer_shutdown_sync(&bnad->bna.ioceth.ioc.iocpf_timer);
 	spin_lock_irqsave(&bnad->bna_lock, flags);
 	bna_uninit(bna);
 	spin_unlock_irqrestore(&bnad->bna_lock, flags);
@@ -3771,9 +3773,11 @@ bnad_pci_remove(struct pci_dev *pdev)
 
 	mutex_lock(&bnad->conf_mutex);
 	bnad_ioceth_disable(bnad);
-	del_timer_sync(&bnad->bna.ioceth.ioc.ioc_timer);
-	del_timer_sync(&bnad->bna.ioceth.ioc.sem_timer);
-	del_timer_sync(&bnad->bna.ioceth.ioc.hb_timer);
+	/* The IOC timers rearm one another.  Shut down all of them. */
+	timer_shutdown_sync(&bnad->bna.ioceth.ioc.ioc_timer);
+	timer_shutdown_sync(&bnad->bna.ioceth.ioc.sem_timer);
+	timer_shutdown_sync(&bnad->bna.ioceth.ioc.hb_timer);
+	timer_shutdown_sync(&bnad->bna.ioceth.ioc.iocpf_timer);
 	spin_lock_irqsave(&bnad->bna_lock, flags);
 	bna_uninit(bna);
 	spin_unlock_irqrestore(&bnad->bna_lock, flags);
-- 
2.53.0



