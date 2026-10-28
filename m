Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208790;
	b=JPhmi0T+1rJpBN5f1xE1dSMNQAUD+uijhL1XaCFQVt7M6Oiwj5d5Hr+ZYELDpYAHKexS
	 XJyiTelmZVc4w93d8UxAlcX3rSZO5xWhgS5pUycXZidqAcuwT2xgimOkdEVl1jPE6Q6I8
	 BzGH5ptINnl+BR2tTF6hdtI0UsF3+m5lru2Wv9nCkiEIwKkE9anIbyr0NJHL6UoRtB3nx
	 w9Zor3OmzMLDhkSHqBx+pISFX/y6KqOVysEkiMC1NIez/nAKqFxCq8d5XjkX8VaBi7rxr
	 tXAaui72quk4SAb3RfoW6rAag8A1tBHvVs+AgbNuOFdf7BNYNdttVnNAsv1b9grQkRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1f4hmg5KV6wEsN3ioz1sYM8S1yY3dRvsg7mEfbk94rE=;
	b=UeXV9SwRXAN+Q1KgeerH9axjU2M7tio91vXbTyfwFtc/PgTZ2IIXN69Gx0Dl8+b+Ymlj
	 Mqk0hHYhc/p5e+58C3t9OD+SijYKgaxPhNRf54Q2zmPCzYjTOz4Vt3qYX9GzJJPNKLJSx
	 F7s5PMQLUgG/KP2jODKwAVhoGpBfFHEl7sKNe++eijHiR0RrAKPKoZ0qsdMpLa019P3VG
	 pNohfT8ov+tpSRyhKgnVbhZ+mlKIeshKcJpDrfrbSDlUkAyl/FlAjbDmtG83AFUxwTTWE
	 PNYi4Y1AlY+qnvrI47W6IPeb992dtM0S3wCFsYdssaAGG3ShAX2OysClHvlzsNz13MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kB1/D/Ct";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DF9606A31C;
	Wed, 28 Oct 2026 17:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kB1/D/Ct
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0591F01825;
	Wed, 28 Oct 2026 17:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208790;
	bh=1f4hmg5KV6wEsN3ioz1sYM8S1yY3dRvsg7mEfbk94rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kB1/D/Ct+xcoJfIoUS1pYnufoV3coNdrZ/mC8gJKa8ZwADHIwyU4XAKSj7fP0/RzC
	 2NkkcYYMWpN+j03IvmN3RduIhKCnUeoi3hE/Gk82kC/MUYiA/HAdJgYbZtqWEqGZB2
	 sE2m38Pnv8WBZxibsJ73G3bjeK1PZkf/trJiUsDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 5.10 244/516] net: sched: cls_u32: Undo tcf_bind_filter if u32_replace_hw_knode
Date: Wed, 28 Oct 2026 17:56:36 +0100
Message-ID: <20261028170009.280115374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 9cb36faedeafb9720ac236aeae2ea57091d90a09 ]

When u32_replace_hw_knode fails, we need to undo the tcf_bind_filter
operation done at u32_set_parms.

Fixes: d34e3e181395 ("net: cls_u32: Add support for skip-sw flag to tc u32 classifier.")
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_u32.c | 40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index e501390ccd758..5221ce128526a 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -709,8 +709,23 @@ static const struct nla_policy u32_policy[TCA_U32_MAX + 1] = {
 	[TCA_U32_FLAGS]		= { .type = NLA_U32 },
 };
 
+static void u32_unbind_filter(struct tcf_proto *tp, struct tc_u_knode *n,
+			      struct nlattr **tb)
+{
+	if (tb[TCA_U32_CLASSID])
+		tcf_unbind_filter(tp, &n->res);
+}
+
+static void u32_bind_filter(struct tcf_proto *tp, struct tc_u_knode *n,
+			    unsigned long base, struct nlattr **tb)
+{
+	if (tb[TCA_U32_CLASSID]) {
+		n->res.classid = nla_get_u32(tb[TCA_U32_CLASSID]);
+		tcf_bind_filter(tp, &n->res, base);
+	}
+}
+
 static int u32_set_parms(struct net *net, struct tcf_proto *tp,
-			 unsigned long base,
 			 struct tc_u_knode *n, struct nlattr **tb,
 			 struct nlattr *est, bool ovr,
 			 struct netlink_ext_ack *extack)
@@ -756,10 +771,6 @@ static int u32_set_parms(struct net *net, struct tcf_proto *tp,
 		if (ht_old)
 			ht_old->refcnt--;
 	}
-	if (tb[TCA_U32_CLASSID]) {
-		n->res.classid = nla_get_u32(tb[TCA_U32_CLASSID]);
-		tcf_bind_filter(tp, &n->res, base);
-	}
 
 	if (ifindex >= 0)
 		n->ifindex = ifindex;
@@ -898,16 +909,20 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 		if (!new)
 			return -ENOMEM;
 
-		err = u32_set_parms(net, tp, base, new, tb,
-				    tca[TCA_RATE], ovr, extack);
+		err = u32_set_parms(net, tp, new, tb,tca[TCA_RATE],
+				    ovr, extack);
 
 		if (err) {
 			__u32_destroy_key(new);
 			return err;
 		}
 
+		u32_bind_filter(tp, new, base, tb);
+
 		err = u32_replace_hw_knode(tp, new, flags, extack);
 		if (err) {
+			u32_unbind_filter(tp, new, tb);
+
 			__u32_destroy_key(new);
 			return err;
 		}
@@ -1108,15 +1123,18 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 	}
 #endif
 
-	err = u32_set_parms(net, tp, base, n, tb, tca[TCA_RATE], ovr,
+	err = u32_set_parms(net, tp, n, tb, tca[TCA_RATE], ovr,
 			    extack);
+
+	u32_bind_filter(tp, n, base, tb);
+
 	if (err == 0) {
 		struct tc_u_knode __rcu **ins;
 		struct tc_u_knode *pins;
 
 		err = u32_replace_hw_knode(tp, n, flags, extack);
 		if (err)
-			goto errhw;
+			goto errunbind;
 
 		if (!tc_in_hw(n->flags))
 			n->flags |= TCA_CLS_FLAGS_NOT_IN_HW;
@@ -1134,7 +1152,9 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 		return 0;
 	}
 
-errhw:
+errunbind:
+	u32_unbind_filter(tp, n, tb);
+
 #ifdef CONFIG_CLS_U32_MARK
 	free_percpu(n->pcpu_success);
 #endif
-- 
2.53.0



