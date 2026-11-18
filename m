Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042121;
	b=vZeyuWiraAnEp3Marsz7IWQveVxlj+fNntr7k86YvPYKoUc4+QtJpF/7d3HpELOflGsb
	 4W5r8sJQR4NkKKObA5moDDh82Njl1iExtOWa9a/O0zDSlezpG1xpIkd00GC12XOa6W0e/
	 8/egEy1pbI0HcVnEPv0IlhxHaUVjdcznyFtVxOlBkxrP5YGU5wFvM6Ar8Ipt8XdW+HCS1
	 ZECjzl6ngMMmtKsJvjizuuUqO3gjjnArA/o7mrvNVMsg7KTYyS3qhKbsVYkv9tNiUGgpG
	 zmml8kpWRlVieaJSp3DOPPAASzWQ9iRaMs0fvCWkLgOFdekepplkFRNGRyR8NvcTGEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5zyGRI9CmyQvLslphpZYXphSc/tUYmahzZNUmTK93jc=;
	b=yIcETTidE70Efse2Qwd26sm4MAWKa4I1NSZh9P/C3mURDWLwoYBKNPBwnUB+PhUU2Q+Q
	 XiShmqKwHooyBCK4YUjj2l4wiaMKQVNCguq+qy0LwTMnPeIJHJRMruEaoalrJE9XJUasq
	 95bO95chFVWFygN4s92S2q/JnxPWGIjehSf6Cqt5iSZYRdFXUEzpmOgIPmBWUlioiLC/5
	 ZSKABcSSbYY4MqgemGwglDv/o10mP3IA1iICLQfbn4+xX/UJOioVv4ChG6N8xfLHglOZq
	 t+WbXOIvD2MSFqWfHqwqCOQemgGuTPoXl4K3+rpx7E6zHBWTE28tMArpozuZc0d7tmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qeHy6P/k";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C8A606A31C;
	Wed, 18 Nov 2026 22:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qeHy6P/k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9011F000C4;
	Wed, 18 Nov 2026 22:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042121;
	bh=5zyGRI9CmyQvLslphpZYXphSc/tUYmahzZNUmTK93jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qeHy6P/kJAn1i8QLfok/M7aZvp6JwB2BSg0geSN/eQV68V8J2MFnQzFQsOzBJxVko
	 i8K1mIMS0YCOT/TrPkO1VrR8WK9cGl7wTIBeyfg0wkWERlJ29sBaSHZqpPxbjguznp
	 dYAymcVG0kpFd0SkqvGoGRR+EtvOhmnQuFUdpQGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (gemini)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3056/3318] net/sched: act_api: reject duplicate actions in a batch
Date: Wed, 18 Nov 2026 16:01:18 +0100
Message-ID: <20261118150451.822830147@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9d3aeaf5ff9a4..94026b9ae4c00 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1987,7 +1987,7 @@ static int
 tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
 	      u32 portid, int event, struct netlink_ext_ack *extack)
 {
-	int i, ret;
+	int i, j, ret;
 	struct nlattr *tb[TCA_ACT_MAX_PRIO + 1];
 	struct tc_action *act;
 	size_t attr_size = 0;
@@ -2012,6 +2012,25 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
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



