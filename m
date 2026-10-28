Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215723;
	b=glbeCPNtHjIWBUUixFmNo9g8ABa6BfyuWxMmhJtJj0/VOhTS69YohBzA0Yx2hcbn+n3Q
	 kVBUTPfFQDEykXdoD0hnGleN5WA8gi6TYl+MPoycog6Q+OxnmuDbF1Nk5gpl+9CF5ZKlX
	 c1u8qJ5Otr4haZhD/0B9+JNM2LYXMgwizw/nvnEAGUQY+cWHLTGCKDKyfkEmNZDqqfkq2
	 B1ykzN6EywxFKdjJBV3l9rfSN+Ysa4cbfeklGifDy1kkQ8H30fiMC4JBoTkklz0MEMkS7
	 0J2accPQc86J67k7jU/QbTIq+u8UmlnYbrMOrafCCvwNWMifP+p4GzdXsIKJu2qiJ/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215723;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c2L0V2WdhLdFY+aM9q1HlJ+qu+VjdHIcMjHUQc3aP7s=;
	b=Xd6Orc74QfBucwsN46Els3HZr1yyFkZTE6GH2fvpc7JfnivQu//4ktuOH1sSQL0g8v/W
	 F1uCqFnTir84FhPiRFE376DW9zOeFu+1GC6FPxpBH+VydW5wGei+keSMESzNDtLhHt5qN
	 oRoZpgol8NDyk5v6tN5Dp2qWEKIS7MpGei97cXnGRSZ0GGY5t8FqK1NEIDyHreYmlDNbY
	 9LWU9WHsfLHvoMuv9RsKL2sMlgbtROuY7K9KnE/SYFtX6CKmAvnqE1DUF3nLNwNNspers
	 +dd2j3ueUDXsuHkPAymFS03s38e4OH+3EGIWDaPhaanEuLS/pRy/TfhpsAT8YfK6OXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yh6PoLYx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23CA606A329;
	Wed, 28 Oct 2026 19:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yh6PoLYx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506961F01825;
	Wed, 28 Oct 2026 19:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215722;
	bh=c2L0V2WdhLdFY+aM9q1HlJ+qu+VjdHIcMjHUQc3aP7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yh6PoLYx7izlP3FyyriLrM39QiLei8qbooykHBzn99S5Wq+Hf1sQ5Z5q6zjDftO3/
	 JkytAlrSc2kfxNEnsgYdJ55oVoEwRhfPr2UbJdPZpzp87n++zCZYmM2K0ebIxUVYpL
	 GzzygVJ5uZxZ6iBF8WCv4lsvjGJfDvKpsl/mV8b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Nogueira <victor@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1309/1887] net: sched: Add initial TC error skb drop reasons
Date: Wed, 28 Oct 2026 17:56:45 +0100
Message-ID: <20261028170529.220677440@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 4cf24dc8934074725042c0bd10b91f4d4b5269bb ]

Continue expanding Daniel's patch by adding new skb drop reasons that
are idiosyncratic to TC.

More specifically:

- SKB_DROP_REASON_TC_COOKIE_ERROR: An error occurred whilst
  processing a tc ext cookie.

- SKB_DROP_REASON_TC_CHAIN_NOTFOUND: tc chain lookup failed.

- SKB_DROP_REASON_TC_RECLASSIFY_LOOP: tc exceeded max reclassify loop
  iterations

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>

[ Adapted to this tree: only SKB_DROP_REASON_TC_CHAIN_NOTFOUND is added,
  to include/net/dropreason.h, and used in tcf_action_exec(); the
  cls_api.c changes are dropped as that file has no drop reasons here. ]

Stable-dep-of: f60b396ee174 ("net/sched: act_api: fix TOCTOU NULL deref on a->goto_chain")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dropreason.h | 3 +++
 net/sched/act_api.c      | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index c1cbcdbaf1492..df701ddb8324d 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -68,6 +68,7 @@
 	FN(IP_INADDRERRORS)		\
 	FN(IP_INNOROUTES)		\
 	FN(PKT_TOO_BIG)			\
+	FN(TC_CHAIN_NOTFOUND)		\
 	FNe(MAX)
 
 /**
@@ -298,6 +299,8 @@ enum skb_drop_reason {
 	 * MTU)
 	 */
 	SKB_DROP_REASON_PKT_TOO_BIG,
+	/** @SKB_DROP_REASON_TC_CHAIN_NOTFOUND: tc chain lookup failed. */
+	SKB_DROP_REASON_TC_CHAIN_NOTFOUND,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 9cbd8446532aa..9f21cc4d1dacc 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1131,7 +1131,8 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 			}
 		} else if (TC_ACT_EXT_CMP(ret, TC_ACT_GOTO_CHAIN)) {
 			if (unlikely(!rcu_access_pointer(a->goto_chain))) {
-				tcf_set_drop_reason(skb, SKB_DROP_REASON_TC_ERROR);
+				tcf_set_drop_reason(skb,
+						    SKB_DROP_REASON_TC_CHAIN_NOTFOUND);
 				return TC_ACT_SHOT;
 			}
 			tcf_action_goto_chain_exec(a, res);
-- 
2.53.0



