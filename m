Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997C53A4F35;
	Sat, 12 Sep 2026 20:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243454; cv=none; b=J0tp+CXuuQ9SZm5A0N8s9tRGTMl5KDnC//Yo2bVnHTMzKvRTYBRZr4EKHoJ56K3Gu1khXr65Sw2OIcLNk/ZINaW/Fj6IOiPbmn22ZeiTTcw+/0eYLfuCzQKRIQB7ADkTvH2wGNjnfsQDeFuwDOP2yMP6JjBBImgvmvEf/IalouE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243454; c=relaxed/simple;
	bh=oq+iKraq/qG5I3btgY0F3W8GZe6qZjXd60Hi6avaF0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kN4kBbrtlZ6Er2mLFl4hH+NEap0iMToHqqs6bwV02cERxkMWDSPfWtiydd2GyixjoJ8HxU+PXveDDkz2lpIOY2BfH4j/AvnonMgcC4Xois01CRgLm8ak5WH5MeFM+4ZDrtrrUwPHfHBZWM47jxZhbFzT2YuMXq/YF/jprn7ieAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEhuTi+C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEhuTi+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A94C1F000FF;
	Sat, 12 Sep 2026 20:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243453;
	bh=1SqBehHB4P6WcOCP7TBd+x5vt6vZ6bjO2pSPbYB1Zyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEhuTi+C7PLg8Q6SuuzYxh8mE4b9fY+2nkscAxX9Bs7dPYXjS3TaY+b3qYNX9NCIR
	 WJbghndqnZ+XQuGs/gY3uPiW2LmQ/QecJ2ytTv9JpCQHIYc3etBvjilZrAYHjMkvOE
	 lP8leHzJagcUidzGubrPqLOycRawEMlxePhPBzPs=
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
Subject: [PATCH 5.10 760/798] net_sched: export pfifo_fast prio2band[]
Date: Sat, 12 Sep 2026 09:06:28 +0200
Message-ID: <20260912065534.486957941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b46a70602da44..fa5c253770e1e 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -610,6 +610,7 @@ static inline void sch_tree_unlock(const struct Qdisc *q)
 extern struct Qdisc noop_qdisc;
 extern struct Qdisc_ops noop_qdisc_ops;
 extern struct Qdisc_ops pfifo_fast_ops;
+extern const u8 sch_default_prio2band[TC_PRIO_MAX + 1];
 extern struct Qdisc_ops mq_qdisc_ops;
 extern struct Qdisc_ops noqueue_qdisc_ops;
 extern const struct Qdisc_ops *default_qdisc_ops;
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 243a1d6b349c7..43ef80f11a9d7 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -618,9 +618,10 @@ struct Qdisc_ops noqueue_qdisc_ops __read_mostly = {
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
@@ -645,7 +646,7 @@ static inline struct skb_array *band2list(struct pfifo_fast_priv *priv,
 static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc *qdisc,
 			      struct sk_buff **to_free)
 {
-	int band = prio2band[skb->priority & TC_PRIO_MAX];
+	int band = sch_default_prio2band[skb->priority & TC_PRIO_MAX];
 	struct pfifo_fast_priv *priv = qdisc_priv(qdisc);
 	struct skb_array *q = band2list(priv, band);
 	unsigned int pkt_len = qdisc_pkt_len(skb);
@@ -755,7 +756,7 @@ static int pfifo_fast_dump(struct Qdisc *qdisc, struct sk_buff *skb)
 {
 	struct tc_prio_qopt opt = { .bands = PFIFO_FAST_BANDS };
 
-	memcpy(&opt.priomap, prio2band, TC_PRIO_MAX + 1);
+	memcpy(&opt.priomap, sch_default_prio2band, TC_PRIO_MAX + 1);
 	if (nla_put(skb, TCA_OPTIONS, sizeof(opt), &opt))
 		goto nla_put_failure;
 	return skb->len;
-- 
2.53.0



