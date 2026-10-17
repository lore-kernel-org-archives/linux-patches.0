Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC5F356A12;
	Sat, 17 Oct 2026 18:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260042; cv=none; b=ooHfq7r8puKqOsTbIaIF4jOvccEuvC7ZmBkYUpmVWr+Xm3XM63kPFAvUZtOZwRvBxfD8CzpRWmAfpjsKxBx+/tPiZySkdsRRsbmFLZ45hJMgtv/L8eRTuqcnOClJQinLBtX2OhrITixeMu3EL06OX5rVF+XacMieGziHPu7Oo9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260042; c=relaxed/simple;
	bh=4hyT4zlZLIE9rGahgChWzX0k+aVv8QLf6k6Wix8mI2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DbhzHkySrErYnWnEulfZsRu0L15d7pSi3tb1jjW+kUaiyZJlaESYMonMKlS4lLqmGUaabDSPeKh7gkFitjUf2HgC3paeq+1ICYV4WIyFdzwcrHnladjRhKJbi6N6PAkWY+ovL9fq13+AuGQbMbr5OgTWH/FHqGgoKHWp+f6z4bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0qRuIKvK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0qRuIKvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F84F1F000C4;
	Sat, 17 Oct 2026 18:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260040;
	bh=gugOqSKZ/3mG4O+67wARJ1Qy2KKZsZDtBuRkHRpnfeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0qRuIKvKoTYPLDddxXfmfC3vfXnWYz0Va0sgEkQo7eHiz1dC51yQ1xKfGXGoq+AgX
	 3YlsDs8JNGSdkSoILgZGZxruU9SfUDB9GRQ1jD5aTyDN+/jCh8RFdmLztLUGJSuvWg
	 +w73RaxuxcC4M49g8uF42HYUkv+eqNFqSbQLHdjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Dave Taht <dave.taht@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1372/1674] net_sched: export pfifo_fast prio2band[]
Date: Sat, 17 Oct 2026 18:00:44 +0200
Message-ID: <20261017160506.377382199@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5579ee462dfe768297563a6083e21df52c3ad856 ]

pfifo_fast prio2band[] is renamed to sch_default_prio2band[]
and exported because we want to share it in FQ.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Dave Taht <dave.taht@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 709f34f7c28d ("net/sched: fq: add overflow bounds to quantum and initial quantum")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h | 1 +
 net/sched/sch_generic.c   | 9 +++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 8b4b4809fa1cd..79e029b5d1a2e 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -595,6 +595,7 @@ static inline void sch_tree_unlock(struct Qdisc *q)
 extern struct Qdisc noop_qdisc;
 extern struct Qdisc_ops noop_qdisc_ops;
 extern struct Qdisc_ops pfifo_fast_ops;
+extern const u8 sch_default_prio2band[TC_PRIO_MAX + 1];
 extern struct Qdisc_ops mq_qdisc_ops;
 extern struct Qdisc_ops noqueue_qdisc_ops;
 extern const struct Qdisc_ops *default_qdisc_ops;
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 4c82aef3386ff..d42b38c86f61c 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -727,9 +727,10 @@ struct Qdisc_ops noqueue_qdisc_ops __read_mostly = {
 	.owner		=	THIS_MODULE,
 };
 
-static const u8 prio2band[TC_PRIO_MAX + 1] = {
-	1, 2, 2, 2, 1, 2, 0, 0 , 1, 1, 1, 1, 1, 1, 1, 1
+const u8 sch_default_prio2band[TC_PRIO_MAX + 1] = {
+	1, 2, 2, 2, 1, 2, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1
 };
+EXPORT_SYMBOL(sch_default_prio2band);
 
 /* 3-band FIFO queue: old style, but should be a bit faster than
    generic prio+fifo combination.
@@ -754,7 +755,7 @@ static inline struct skb_array *band2list(struct pfifo_fast_priv *priv,
 static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc *qdisc,
 			      struct sk_buff **to_free)
 {
-	int band = prio2band[skb->priority & TC_PRIO_MAX];
+	int band = sch_default_prio2band[skb->priority & TC_PRIO_MAX];
 	struct pfifo_fast_priv *priv = qdisc_priv(qdisc);
 	struct skb_array *q = band2list(priv, band);
 	unsigned int pkt_len = qdisc_pkt_len(skb);
@@ -863,7 +864,7 @@ static int pfifo_fast_dump(struct Qdisc *qdisc, struct sk_buff *skb)
 {
 	struct tc_prio_qopt opt = { .bands = PFIFO_FAST_BANDS };
 
-	memcpy(&opt.priomap, prio2band, TC_PRIO_MAX + 1);
+	memcpy(&opt.priomap, sch_default_prio2band, TC_PRIO_MAX + 1);
 	if (nla_put(skb, TCA_OPTIONS, sizeof(opt), &opt))
 		goto nla_put_failure;
 	return skb->len;
-- 
2.53.0



