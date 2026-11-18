Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046388;
	b=zEf005PRO2d2DIZYCK0Pu2Olwp/gZUut6JIQKu8b7JURug0cYvzt6yrcxkLbnyrxw6EL
	 ryiSsj3xeMuNXMClwnc8N8R2J7pqEQBLqSW4voJRLtVxpS6UWN9n7KKeGinNnluzFGzaE
	 f08QVm5bIaJMyo+5eyRnzWAyoaORIOZVKDFeAOK/6rLBlyZ9Jpk/neZ3YC/KVtfcpCaUL
	 DENAMlk42E8i8iaZEHtga1cNhpmn+IXHSeAoxIcXub/7zdEBBe17uw/e+l4z4074E+sDZ
	 8sDnsKxaoOKvJKd794mA2+mIMFQLBJli6TnlP43h/k2RXPZAkIEkDo88VQcSWCUNKzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vTxVJdqKZkNRoJ9N7qOFNgYo4HTU6rH7EP5rPnW2TKU=;
	b=R3Ohp63XMxhqvwGRUyeEKk1LQUBdbp0IhmjXxGZNj2925+8nW69+VXycMr4p09mjOiWI
	 yCt9qsUz61OxhmmfKzZBKd4IkI6QsN5w1ZCm8T1qaG13rlB9NmnX6/Jzr6LB46kByBPyO
	 +Q08v/UIBO6Ak4f5VoD3/Vf3bA4rz+F3pqLDMLYLVqz0Q7dEAw6QKIPU0w6PykQY65fSB
	 2oblBd+MegiL8fDxIkCUacq3v8dfLTJKf9aTMKBT3+djc70IVYmWy0Cgw1u7KTQhTfq1M
	 bQKYCajjZTjesMRl7xVQ4lGNMqvvurpaqkRzrfHFiXxfumIETKZB7z0SJx30Nqgf+5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4RkF0W3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1428606A325;
	Wed, 18 Nov 2026 23:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4RkF0W3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A641F000C4;
	Wed, 18 Nov 2026 23:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046388;
	bh=vTxVJdqKZkNRoJ9N7qOFNgYo4HTU6rH7EP5rPnW2TKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4RkF0W3WZ0Fv+gvFVOqY9u1sgiD5vuPnfr+IFEzFn2NT93ym9YcIWreyj1omB/Bn
	 09C05e5q8R2ccesH1yznqnI0O5XO4XgNHFFOyfwqAFa/ENO/j/bbhg/p2oQ82nGSMA
	 v+h1R7viXshpihLHgt67HgAmkqK9ctUiOmzBEZB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1264/2857] net/sched: sch_qfq: prevent aggregate self-replacement
Date: Wed, 18 Nov 2026 15:38:18 +0100
Message-ID: <20261118150247.041665953@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 2e54b3e187300893688c2c7517894f5d96732e05 ]

qfq_change_class() snapshots the current aggregate settings while
holding the qdisc tree lock, but drops the lock before selecting the
destination aggregate. During that gap, qfq_enqueue() can move the
class to an aggregate matching the requested settings.

When qfq_change_class() resumes, qfq_find_agg() then returns cl->agg.
If it is a singleton, qfq_deact_rm_from_agg() frees the aggregate
before qfq_add_to_agg() immediately accesses the same pointer, causing
a use-after-free.

While holding the tree lock, skip the replacement when the destination
is already the current aggregate. Any estimator replacement has already
completed, so the class change can finish normally.

Fixes: 462dbc9101ac ("pkt_sched: QFQ Plus: fair-queueing service at DRR cost")
Link: https://lore.kernel.org/netdev/20260731140533.566493-1-david.lee@trailofbits.com/
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
Link: https://patch.msgid.link/20261029180957.43015-1-david.lee@trailofbits.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_qfq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 62ac5eba222ff..c33ad67eb0580 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -521,11 +521,14 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 		sch_tree_lock(sch);
 		qfq_init_agg(q, new_agg, lmax, weight);
 	}
+	if (existing && new_agg == cl->agg)
+		goto unlock;
 	if (existing)
 		qfq_deact_rm_from_agg(q, cl);
 	else
 		qdisc_class_hash_insert(&q->clhash, &cl->common);
 	qfq_add_to_agg(q, new_agg, cl);
+unlock:
 	sch_tree_unlock(sch);
 	qdisc_class_hash_grow(sch, &q->clhash);
 
-- 
2.53.0



