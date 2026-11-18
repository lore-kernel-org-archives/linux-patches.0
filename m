Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032598;
	b=2XdBJT2UZ2ehjt2hGAc4cppyhR6HfV5q3tyZFW4DbTZ5k5SF2Je5skrA2dpHqei6QTaB
	 RSxqFhCcuwK/L0AJQjMdaw7t5qjIyCiKjSGJ7nZLRoPDiiiIu5Ov6V+swFHcNwB3GbvAl
	 lfMhqrNVuaxSfYTITanoBdUwG4LVGBk9/ObER4GIHa2G8K3lGv8hZgavhfYIi85bUuGTm
	 cZOup624VFBgPf8wGirP1tXaZbHtOnN73Prrfb+YXCgqh5qqaH1prqeIH77HntNiqXzhG
	 7tXxWP04Fdx+vMUU+p3oWfEVU9RyVcMJFV+cSyAznev9r31oFxXFMv1RM3+j4AxjVpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XBhUlFed5NNEaPWnZprKjmPDmwvJgAa+z0ECt0fCcKg=;
	b=yOproSw4Wkj9R2V/XEcdjXAybNqIHMusSa/1d0ae1pzavOZOoxzrPGuofiZ/LNpg/EVu
	 YKqZHMKVsEtutiM5f2g1AcdPulQYNAB9c1RF0rozXc0IAIcn3ek1InsdEhTPkOqdjo4k+
	 VKPJ5A5iXaMcmVAXnDZAecBFDIdmHn0HqvyvpQRx9Msqem++sZ+LzpZXb7xdBH0OKhG7R
	 15l1uPYxiCFMUMv8s/xejj9+N2c/h1QwRMttFUw+avimcGjzmtOhQooSXzj7s2xugiVq5
	 MOBqyoF/qLieoWMg6eg1GWHpjzWqNWMalPYFyMYF/vjpIfe6LcU+4VevtUpVsAS/NuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ubUWv96B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D590C606A331;
	Wed, 18 Nov 2026 20:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ubUWv96B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330D11F000C6;
	Wed, 18 Nov 2026 20:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032598;
	bh=XBhUlFed5NNEaPWnZprKjmPDmwvJgAa+z0ECt0fCcKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ubUWv96BzlVpCpI5Q26OdhO8cJp+sEfAXk9mI92POT3ubSqy9qUuugOVtM+UF/km2
	 WfWO67qnXMGrD8oh6IAqqRtArV0/T7uEAG5eZ0Ghlr3UO7/9vCPIPzamx3j0c0J+gq
	 /+Vav2P2mEsDrXVQfelKrmE6AoSrnSGDpGlQqDuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (gemini)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1423/1756] net/sched: act_api: reject duplicate actions in a batch
Date: Wed, 18 Nov 2026 15:59:10 +0100
Message-ID: <20261118150105.814590533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 29a6bf8630838..22f840ed11326 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -2001,7 +2001,7 @@ static int
 tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
 	      u32 portid, int event, struct netlink_ext_ack *extack)
 {
-	int i, ret;
+	int i, j, ret;
 	struct nlattr *tb[TCA_ACT_MAX_PRIO + 1];
 	struct tc_action *act;
 	size_t attr_size = 0;
@@ -2026,6 +2026,25 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
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



