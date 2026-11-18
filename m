Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056630;
	b=snR07EDqj+aujys4GNCuDjtUbdGU7Rqa5KkGLXkiZX6MlAZgnajV/FaCoSAa5EblrzED
	 0Qo3KI+BCe1Oshv38goAQ1yZ0/upv08L6R/NPBuA3XX7SnD9SGGMIv6KwJEPiPv28AL2H
	 j8UKibEEDnbYwBaSZ/+H/JRFarSwtKN4aaCTyq4fGzXfASxa3+R+fNEtTzw0iXtriQeUd
	 iVCHPXzR1eMSHszMWSi2KkQCcfc+md0Qikqu/AWW5pn0RW74uniw2fYGEo4YWe3Ldg9fe
	 KTROtY/5O+HzPpA5ZWQL61yP13txSnZk3NZ3km02cXs8QabGtc+QjCjtAJmjnrWuq0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h0vE9We9MDOtWolRRQK+ebOroUUz6eeRd4r5AqFual0=;
	b=4DYYUXjIE7WLO18xc/zpK281/SLq/EGmB6Cu0X5i1gsH9QOlWtq4ZeLDPo0hHqgMV6I8
	 aYJPvzu8k+wUNUqjS9jXzkMHJ/Z6WuRI3/Iq28LmpxeWszrmNT2cLVQgcBBEOBtNNiEfR
	 5JK99mF6aj/EZD3Khj8uwnQSlWBn9QvP/VXwaXHB6wp9TKn3ucPAtquij3x0eIaE6LxMT
	 0UNdfeI7tlhLQhVyAp5TWAnJ+nnlfKXlPwP6/x/wSamk6V5pv5wMJXWDkd9Dbjnu9f5l1
	 1StOsKAzEBDbYJeWIyiBOmWJOgJ5QOAZp0PO69ip0h9yEhqzKpwWTIHhcJdK//aDRmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N8qJ6nX9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8660606A31C;
	Thu, 19 Nov 2026 02:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N8qJ6nX9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2660A1F000C5;
	Thu, 19 Nov 2026 02:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056630;
	bh=h0vE9We9MDOtWolRRQK+ebOroUUz6eeRd4r5AqFual0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N8qJ6nX9JFa3B6PtdjnGSbD9sy9KfgNdjAjhBUnxFhC5Ei+AiZxeLYy4m04/MzzqR
	 yI7Wpzi8DZjVS0JC6NdPf8mUW5TNPffZQU5jjM+rqZyk6sE7p/IDwl7iQ39vagQFnX
	 vjjWj/oDUFfplcCg5XixBuLzt9VYt4XZqG+gcDYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (gemini)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2056/2214] net/sched: act_api: reject duplicate actions in a batch
Date: Wed, 18 Nov 2026 16:02:12 +0100
Message-ID: <20261118150132.935952176@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit f67b3ed1308d7a282e2d6202d61af052ab0da39e ]

tca_action_gd() builds actions[] with one tcf_action_get_1() per nested
TCA_ACT_TAB entry.  Each successful lookup takes its own reference to the
resolved action, so repeated TCA_ACT_INDEX entries in one request yield
the same pointer in multiple slots.

For RTM_DELACTION, tcf_action_delete() then consumes two references per
slot: one in tcf_action_put() and one in tcf_idr_delete_index().  A
duplicate therefore drives the refcount to zero mid-walk -- the delete
frees the action and removes its IDR slot -- and the next slot calls
tcf_action_put() on the freed action:

  refcount_t: underflow; use-after-free.
  WARNING: lib/refcount.c:87 at refcount_dec_not_one
   refcount_dec_and_mutex_lock
   __tcf_action_put
   tca_action_gd

Three duplicate entries are enough.  Reject a repeated action while a
delete batch is built, dropping the reference the extra lookup took, and
return -EINVAL.  RTM_GETACTION balances its own references and keeps
accepting duplicate entries.

Conditions to recreate the bug:
  tc actions add action gact index 100
  tc actions delete action gact index 100 action gact index 100 \
                     action gact index 100

Fixes: 16af6067392c ("net: sched: implement reference counted action release")
Reported-by: Sashiko (gemini) <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260824153903.4143642-1-victor@mojatatu.com
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-K1TH.v1.r3.20261012134653-1@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 0f3285916ea94..dce7fe0d181ae 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1461,7 +1461,7 @@ static int
 tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
 	      u32 portid, int event, struct netlink_ext_ack *extack)
 {
-	int i, ret;
+	int i, j, ret;
 	struct nlattr *tb[TCA_ACT_MAX_PRIO + 1];
 	struct tc_action *act;
 	size_t attr_size = 0;
@@ -1486,6 +1486,25 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
 			ret = PTR_ERR(act);
 			goto err;
 		}
+
+		/* A delete consumes two references per slot (tcf_action_put()
+		 * and tcf_idr_delete_index()) but each entry takes one, so a
+		 * repeated action would hit zero mid-walk.  GET balances its
+		 * own references and keeps accepting duplicates.
+		 */
+		if (event == RTM_DELACTION) {
+			for (j = 0; j < i - 1; j++) {
+				if (actions[j] != act)
+					continue;
+
+				tcf_action_put(act);
+				NL_SET_ERR_MSG(extack,
+					       "Duplicate TC action in a delete batch");
+				ret = -EINVAL;
+				goto err;
+			}
+		}
+
 		attr_size += tcf_action_fill_size(act);
 		actions[i - 1] = act;
 	}
-- 
2.53.0



