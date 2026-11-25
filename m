Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619960;
	b=aetZw0XNsokQgABxU1+HHcP/OLNC25QUH3FPhCY6UJvarEfsMQsqLfVGlA9dhQfQeceY
	 cofVgMHw7+RXM8UbXmH6ellG0NgRJfqbpH8dTJ5viNfEK11NrP3944fR8m5y1EnvzW3a6
	 RiNZwDBhXtiRhvQScV9/TJVgrA2ew5XyYfXxgNK3rcO4U1K3LLne8kSYaDwLUBwB6NH4j
	 GfXtImK/2ZjKPRSRm+wZzr4J3ilD0bjeYpHtAsldOiKpXJJgxwpc97KY/pt9CheS3eMdL
	 nSApU/KYO89+ppTVUkU/oxYbpDkfBhKUHcPS/QwwA0tIXY6f1QzANsaC9ouovvW+gcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Uh9Y7T1vGtibdWvtnbOaln7QzfodINE5LaxBpJ7gbNU=;
	b=zKRMwkMkwPc7F7VB9IIfqbc0C3SH5qBIpUwzBQP6toQOoOpffjadxHdG3CiKS4U+wULz
	 EmiDLx6TtmYHZiA63tgMAbsJ0f6sBk3dALHkjef9rDF0xR7jfXozPso2HCf5IdddBNFBb
	 fkz8kSP+zMuvwUyojoouXRcuDhoM7vhJfSeo0V29ocYaw/qIUi860egN5jwR3JONKyDjm
	 qGPoA8BP0qtHg39onzkO5TFbeYawSqUhk3Y8M7fIxZmoifSDNh119ZCLwhln4EUWBz0N6
	 u4CJ7EHbUjJsc4pxLpS2VxlUeL72dZymLkAot4vsv2obt89UnQZHt5/1mmNkDJO9ymw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pQaK9kl7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9586606A321;
	Wed, 25 Nov 2026 15:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pQaK9kl7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BF21F000C0;
	Wed, 25 Nov 2026 15:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619960;
	bh=Uh9Y7T1vGtibdWvtnbOaln7QzfodINE5LaxBpJ7gbNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pQaK9kl7qD/nsEiQZKgS09goyU9kcn+zDqzKsx9KZsPcY7iIljaKT5TBzKopUyb54
	 PC8OwV3cy571Mvf/bw3nnbVlB6XyYhGMsf09h+w1rkQapNKBXngPzOsg4Q4mkxt1OA
	 wTMrDtygmyTW9kc+WQD3dctV4JJD/eAtN3PxIw4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kuba Piecuch <jpiecuch@google.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.3 0763/1005] sched_ext: Read exit_kind before flushing in scx_flush_disable_work()
Date: Wed, 25 Nov 2026 15:35:01 +0100
Message-ID: <20261125143839.621188413@linuxfoundation.org>
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

From: Kuba Piecuch <jpiecuch@google.com>

commit 3133107d98057595c0af39ff907c852134926912 upstream.

scx_disable_workfn() sets exit_kind to SCX_EXIT_DONE before it tears the
scheduler down. scx_flush_disable_work() reads exit_kind after syncing
disable_irq_work and flushing disable_work, so it can observe DONE from
a disable_work that was queued after its flush and return while the
teardown is still running:

  CPU A                          CPU B
  -----                          -----
  scx_vexit()
    scx_claim_exit() -> true
                                 bpf_struct_ops_map_link_detach()
                                   bpf_scx_unreg()
                                     scx_disable()
                                       scx_claim_exit() -> false
                                     scx_flush_disable_work()
                                       irq_work_sync()      // not queued
                                       kthread_flush_work() // not queued
    irq_work_queue()
  scx_disable_irq_workfn()
    kthread_queue_work()
  scx_disable_workfn()
    exit_kind = SCX_EXIT_DONE
    scx_root_disable()
                                       atomic_read() -> SCX_EXIT_DONE
                                   bpf_map_put()

Once bpf_scx_unreg() returns, its caller drops the struct_ops map
reference, and the struct_ops trampolines can be freed while
scx_root_disable() is still running and can still call into the BPF
scheduler, e.g. ops.exit().

Read exit_kind before syncing and flushing, with acquire ordering paired
with the atomic_try_cmpxchg() in scx_disable_workfn(). DONE is only set
from disable_work, so once it is observed, the following
kthread_flush_work() sees the queued work and waits for the teardown to
finish.

This patch was created with the help of an AI coding assistant.

Fixes: d99f7a32f09d ("sched_ext: Fix scx_flush_disable_work() UAF race")
Cc: stable@vger.kernel.org # v7.1+
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-195908@kernel.org/
Signed-off-by: Kuba Piecuch <jpiecuch@google.com>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext/ext.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -7131,10 +7131,17 @@ void scx_flush_disable_work(struct scx_s
 {
 	int kind;
 
+	/*
+	 * scx_disable_workfn() sets SCX_EXIT_DONE before tearing down. Read
+	 * exit_kind with acquire ordering (paired with atomic_try_cmpxchg() in
+	 * scx_disable_workfn()) before syncing and flushing so that, once DONE
+	 * is seen, the following flush observes the queued work and waits for
+	 * the teardown to finish.
+	 */
 	do {
+		kind = atomic_read_acquire(&sch->exit_kind);
 		irq_work_sync(&sch->disable_irq_work);
 		kthread_flush_work(&sch->disable_work);
-		kind = atomic_read(&sch->exit_kind);
 	} while (kind != SCX_EXIT_NONE && kind != SCX_EXIT_DONE);
 }
 


