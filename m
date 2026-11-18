Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059085;
	b=icbCLh8qpWCrlPCC1vkkY1ZA3lYM3AXicD46mKG6sHpYcg98cpsuV1Cf+m5DlxB6lB9z
	 ZQo8Mxul3leyYO9g4XmIWaWs7j4U9kHelGxleQrDxqwJ7grHmKbuR+5MDuwLCgOhCVJqg
	 m2QWSsMnp8VPQqUagCrWb4MnvPoztW15cxCnKB+ey8vXmrh7yjGPjF/gEvDYH2Awb14Ik
	 F/DcszC+1Hhb0WC46rqtSrKTnQtvlmmDg9wUaiTPm6xu1pz90Dxsv3Wa8mlf1PPWQfyKY
	 j80deDpBpNdAvIV2aenEqfyEw2WEvLxgJxO79koYTERy7h6nu6cDYgHGoS8hn3/u1kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yGk+bey16N05Qhb9gyvx4nNlE2CT+UwjSLKyFO+XlV4=;
	b=amoS3zlkP1anCjG/4/OS58On5uBVSeOJROwz69BpGsOJu58+pSzBl2aJK6NdxSY835P6
	 hUJez8xNYkTgAF7jDK31bw8h3cGRoRzYoso0SzuT3hbXFl65JsfgETqpev9sh6KZH2Z+B
	 jVBxInrHC1jQGqpIEYTXxWWsUrAzsxnnI0eoDL/ZZk9teeCGuolbBp9yDf+Neq/0anjwQ
	 q7wz8FKlHWpRmmIon3A8kelX7FXU/54oWoMI3Y3UJa0NaaAMkYehiOyj+jMnZv0THuh6D
	 RuB4tl6JTucPMstJb9IEwdjUE8nUpeLeN6oX7uPSsgOYQk9ghaLrPgO+4k0dfncBCBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ISEqOCcQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6233A606A320;
	Thu, 19 Nov 2026 03:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ISEqOCcQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FA71F000C4;
	Thu, 19 Nov 2026 03:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059085;
	bh=yGk+bey16N05Qhb9gyvx4nNlE2CT+UwjSLKyFO+XlV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ISEqOCcQt51Z91rSh1x4aHxfL1dEMuyLEKxkG0C94mcBpNHOirhW3v8cxv7gsoN7i
	 HUyPY6raLquR3Q98zkEoRY8s1Rr+wgs1Psb3eP3imZWFEmnEe8C9479GUdZNPJuYit
	 4nnUQ/EW7Or59CN2tsYot+40ZOg1ifqOu1cWRWFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0717/1848] net/sched: sch_qfq: prevent aggregate self-replacement
Date: Wed, 18 Nov 2026 15:45:55 +0100
Message-ID: <20261118145945.856366808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1c38447b456a7..7092082b4a326 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -520,11 +520,14 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
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



