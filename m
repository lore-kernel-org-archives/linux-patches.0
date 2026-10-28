Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215387;
	b=TV4NHkXt7gKsuF3srHcAxLu7KvJJydoLj5fJYCn7EX/Vj5mSrUDTCN43zx/ensBXSEaj
	 ckyQeOQebf0DpfIIw1/IPjS9rbJMU0bAobTDu9fLy20DZN8qxCmXBawOXvECC0lz3rFYJ
	 /lKNbp70OPfxgLvHW8WtsKdtu1uzul4HpSe/Vh4mPx3vs9ila1YZ8qpLOUKuHfsMKok0n
	 kwOmeguGMKC6CP2AUPQN9N6dlQ1h1FRTrvVW0s6PRo3xQYsPEFYITxOUNTj74DDdxlbdd
	 KIU3FttEhlWVsmHhud35ojUwGoCF/J+jWfem6ECbdEDTxKTJolBn7J9s1LVQbVMPljw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6g5TGdGvu/Uc8feFdCis1nrRjpB2p9tu2RYbGV6jRpQ=;
	b=DTPywoKcADm4F83cWR7zr7ma5OsjLGukAvdlrTrTA6CeeHh3JU5U289jLK9PBoYz1JsP
	 FrmdR7ZkU4LYiic00h2skPrVw/SOX6VPzSbMfPyFGRNqZGDaEf+KINaJF1q2XFXsCNQTI
	 X/KAluM/zqJkGif/Jf8kug0+98H9R1w+s1CIYYhPHpMGgIyu3sJH2Ip3v6Fh9wrr1OTrw
	 2Y0JKV6dFILtG8kdyyH0lC1jVlzOTPgrYqm19ryg9F3LR+LHIiT09kwoEuhT/RIlwl/eX
	 hJeIV2fnhDfhKs2jx3FP+xHj6zNfusa1LzvdtaGWLlGmKC7Qz2heJqRlUvguK1T/9ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fZwFA9AA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23668606A31C;
	Wed, 28 Oct 2026 19:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fZwFA9AA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7090D1F01825;
	Wed, 28 Oct 2026 19:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215387;
	bh=6g5TGdGvu/Uc8feFdCis1nrRjpB2p9tu2RYbGV6jRpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZwFA9AAQK1PfP7YBbKpUpyyXhFGtHe60kvtoaToTeXuwfA6YUXBHB+WHZOgftDqc
	 dERFm6t2wrEXJhBdsH5FSjrsIxEky2kl+Cn8tj5lMu7qLQANt9ByJJNwObznMPyAkT
	 yCEFijSj6JNYva0u45H2ouNkeW896UWWfaROf5Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1194/1887] net/sched: Handle TC_ACT_REDIRECT from qdisc filter chains
Date: Wed, 28 Oct 2026 17:54:50 +0100
Message-ID: <20261028170526.576861049@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit ec48b3be2c8595dd290be883dbd4fb8b2f9f5d5e ]

When a TC filter attached to a qdisc filter chain returns
TC_ACT_REDIRECT (ex: via an eBPF program calling bpf_redirect() or an
act_bpf action), the redirect was silently lost i.e no qdisc classify
function handled TC_ACT_REDIRECT, so the packet fell through the
switch and was enqueued normally instead of being redirected.

This has been broken since bpf_redirect() was introduced for TC in
commit 27b29f63058d ("bpf: add bpf_redirect() helper"). We got lucky
for a long time because bpf_net_context was a per-CPU variable that
was always available.

commit 401cb7dae813 ("net: Reference bpf_redirect_info via task_struct
on PREEMPT_RT.") turned bpf_net_context into a task_struct member that
is only set up by explicit callers. Without a caller setting it up,
bpf_redirect() itself crashes with a NULL pointer dereference in
bpf_net_ctx_get_ri(). However, even with bpf_net_context available,
TC_ACT_REDIRECT from qdisc filter chains cannot be honored without
adding skb_do_redirect() calls to every qdisc classify function, which
would require changes across net/sched/. Isolate it to ebpf core where
it belongs.

Instead, add a tcf_classify_qdisc() inline helper in pkt_cls.h, as a
wrapper around tcf_classify() for use by qdisc classify functions and
tcf_qevent_handle(). When the classify verdict is TC_ACT_REDIRECT,
the wrapper converts it to TC_ACT_SHOT, dropping the packet rather
than letting it continue silently. Dropping is preferred over
letting the packet through because the user immediately sees packet
loss. Silently passing the packet through would hide the problem and
leave the user wondering why their redirect is not working.

The clsact fast path, tc_run() continues to call tcf_classify() directly
and is unaffected: TC_ACT_REDIRECT is returned as-is and handled by
sch_handle_egress/ingress() calling skb_do_redirect() as before.

Fixes: 27b29f63058d ("bpf: add bpf_redirect() helper")
Fixes: 401cb7dae813 ("net: Reference bpf_redirect_info via task_struct on PREEMPT_RT.")
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20260706185609.330006-3-daniel@iogearbox.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_cls.h    | 14 +++++++++++++-
 net/sched/sch_cake.c     |  2 +-
 net/sched/sch_drr.c      |  2 +-
 net/sched/sch_ets.c      |  2 +-
 net/sched/sch_fq_codel.c |  2 +-
 net/sched/sch_fq_pie.c   |  2 +-
 net/sched/sch_hfsc.c     |  2 +-
 net/sched/sch_htb.c      |  2 +-
 net/sched/sch_multiq.c   |  2 +-
 net/sched/sch_prio.c     |  2 +-
 net/sched/sch_qfq.c      |  2 +-
 net/sched/sch_sfb.c      |  2 +-
 net/sched/sch_sfq.c      |  2 +-
 13 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 857d9ea60d469..42ddb2689b8ec 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -156,8 +156,20 @@ static inline int tcf_classify(struct sk_buff *skb,
 {
 	return TC_ACT_UNSPEC;
 }
-
 #endif
+static inline int tcf_classify_qdisc(struct sk_buff *skb,
+				     const struct tcf_proto *tp,
+				     struct tcf_result *res, bool compat_mode)
+{
+	int ret = tcf_classify(skb, NULL, tp, res, compat_mode);
+
+	/* TC_ACT_REDIRECT from qdisc filter chains is not supported.
+	 * Use BPF via tcx or mirred redirect instead.
+	 */
+	if (unlikely(ret == TC_ACT_REDIRECT))
+		ret = TC_ACT_SHOT;
+	return ret;
+}
 
 static inline unsigned long
 __cls_set_class(unsigned long *clp, unsigned long cl)
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index a911ed58d078f..8fa5325920ebf 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1720,7 +1720,7 @@ static u32 cake_classify(struct Qdisc *sch, struct cake_tin_data **t,
 		goto hash;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	result = tcf_classify(skb, NULL, filter, &res, false);
+	result = tcf_classify_qdisc(skb, filter, &res, false);
 
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 63ec888d6b495..62c02ebdb4ecd 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -312,7 +312,7 @@ static struct drr_class *drr_classify(struct sk_buff *skb, struct Qdisc *sch,
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	fl = rcu_dereference_bh(q->filter_list);
-	result = tcf_classify(skb, NULL, fl, &res, false);
+	result = tcf_classify_qdisc(skb, fl, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index 2f1e8a5d5b37b..f65dae86c6186 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -389,7 +389,7 @@ static struct ets_class *ets_classify(struct sk_buff *skb, struct Qdisc *sch,
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	if (TC_H_MAJ(skb->priority) != sch->handle) {
 		fl = rcu_dereference_bh(q->filter_list);
-		err = tcf_classify(skb, NULL, fl, &res, false);
+		err = tcf_classify_qdisc(skb, fl, &res, false);
 #ifdef CONFIG_NET_CLS_ACT
 		switch (err) {
 		case TC_ACT_STOLEN:
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index f618ec382081b..8a4f4c4963708 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -91,7 +91,7 @@ static unsigned int fq_codel_classify(struct sk_buff *skb, struct Qdisc *sch,
 		return fq_codel_hash(q, skb) + 1;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	result = tcf_classify(skb, NULL, filter, &res, false);
+	result = tcf_classify_qdisc(skb, filter, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index d7c144af98916..1bf86b65dacfd 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -95,7 +95,7 @@ static unsigned int fq_pie_classify(struct sk_buff *skb, struct Qdisc *sch,
 		return fq_pie_hash(q, skb) + 1;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	result = tcf_classify(skb, NULL, filter, &res, false);
+	result = tcf_classify_qdisc(skb, filter, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index eb99bc1a76f6f..9550176e3a481 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1152,7 +1152,7 @@ hfsc_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 	head = &q->root;
 	drift = HFSC_CLASSIFY_MAX_DRIFT;
 	tcf = rcu_dereference_bh(q->root.filter_list);
-	while (tcf && (result = tcf_classify(skb, NULL, tcf, &res, false)) >= 0) {
+	while (tcf && (result = tcf_classify_qdisc(skb, tcf, &res, false)) >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
 		case TC_ACT_QUEUED:
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 1fbaedc130e7e..7515de8511adf 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -240,7 +240,7 @@ static struct htb_class *htb_classify(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	while (tcf && (result = tcf_classify(skb, NULL, tcf, &res, false)) >= 0) {
+	while (tcf && (result = tcf_classify_qdisc(skb, tcf, &res, false)) >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
 		case TC_ACT_QUEUED:
diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index 62cc1a21a603f..3dff4b1d4aa97 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -36,7 +36,7 @@ multiq_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 	int err;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	err = tcf_classify(skb, NULL, fl, &res, false);
+	err = tcf_classify_qdisc(skb, fl, &res, false);
 #ifdef CONFIG_NET_CLS_ACT
 	switch (err) {
 	case TC_ACT_STOLEN:
diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index fdd9caa41e80f..7ef77ead388e6 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -39,7 +39,7 @@ prio_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	if (TC_H_MAJ(skb->priority) != sch->handle) {
 		fl = rcu_dereference_bh(q->filter_list);
-		err = tcf_classify(skb, NULL, fl, &res, false);
+		err = tcf_classify_qdisc(skb, fl, &res, false);
 #ifdef CONFIG_NET_CLS_ACT
 		switch (err) {
 		case TC_ACT_STOLEN:
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 51d962e5113bc..62ac5eba222ff 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -711,7 +711,7 @@ static struct qfq_class *qfq_classify(struct sk_buff *skb, struct Qdisc *sch,
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	fl = rcu_dereference_bh(q->filter_list);
-	result = tcf_classify(skb, NULL, fl, &res, false);
+	result = tcf_classify_qdisc(skb, fl, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 58bf4c803f7fe..693f562bd8648 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -260,7 +260,7 @@ static bool sfb_classify(struct sk_buff *skb, struct tcf_proto *fl,
 	struct tcf_result res;
 	int result;
 
-	result = tcf_classify(skb, NULL, fl, &res, false);
+	result = tcf_classify_qdisc(skb, fl, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 779e632ede19c..31b5aeb416cea 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -171,7 +171,7 @@ static unsigned int sfq_classify(struct sk_buff *skb, struct Qdisc *sch,
 		return sfq_hash(q, skb) + 1;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	result = tcf_classify(skb, NULL, fl, &res, false);
+	result = tcf_classify_qdisc(skb, fl, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
-- 
2.53.0



