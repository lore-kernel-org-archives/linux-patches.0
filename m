Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062074;
	b=UapQTOO6tc/XWlJ8hecdPncWFws5fK9ggHXa1b0p5XSiuRDTaszf+zwmfknLvLclcPG9
	 lrBjziNlwtu+l+2RL27BE5x3fQpV+sWzwxQZgtyD3QkJbJ/3it6bhBZAZ9e65arT3v1Of
	 bxzksi9dD4JQhiKKQRnZtlpxjV9ZhRPE+Ot8ai1PfnFZTHgwpO2lx1XvKf6XDvsAcAfKr
	 UWg+eQRqnSOtHEWSifbNyrfXUWcCEVDfozCY4Pvg2rlsPZ44RXxMhMRw6fJWCjAHrIBFQ
	 ybYDPptv4jpJy3hMfAN22bjDFwUbBfHNiDetyUG4zNev3xh4p5gJozfLijN55YuuRLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EyPVsz7bedONV6zAm+0DtrMXk2SxNrYXo2ri7oPeV1w=;
	b=ogwRpvQAtrmFRjFxIrWHNi9e53ycIYrVeiVxqfo66fQmJ3OFQ35L5xW3rHHCXqLLZxSs
	 dMsqus2VLY/BoNRw2MX4z+3asBNVbM0esCC08MGa5BEbfTANW9kXLBd1Nu7VRd6rvldmS
	 H99OXsFTpdIq+gje0/cKkjt64LTgHKLt72mq28zcLfgU0Gmr2tX9KlcQce8YaCppGcQBp
	 JiUZqQh04mvhUuU0rE+6GFUmDLnVNHkvYnZItFWvOBaUQ4GijB6P1lL6JtP5jhKqb3i8C
	 2LepNUr6ndGyiF2y+Jl4ySwLrG6nNDIY2SvtvjSwE6zRMgMha0LBf3279QJUszHnLoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CK/mUu5Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CF7606A32C;
	Thu, 19 Nov 2026 04:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CK/mUu5Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19B91F000C4;
	Thu, 19 Nov 2026 04:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062074;
	bh=EyPVsz7bedONV6zAm+0DtrMXk2SxNrYXo2ri7oPeV1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CK/mUu5ZrC4xVA9ta/dWXQ0xw5a7RYl+RNBvtE6IgGdXOr429VllYDHeWfOLdynkZ
	 eShloIZKQNykLrCRwQQk7ZY41NWtP8Ot1F2B86M1+0sTwDZqjeZQ7G3bWbmitwcsop
	 ngRTclfv4vgCJg3OaiorUZSy3bF36pxZ3p7xNJdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (gemini)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1728/1848] net/sched: act_api: reject duplicate actions in a batch
Date: Wed, 18 Nov 2026 16:02:46 +0100
Message-ID: <20261118150031.935594276@linuxfoundation.org>
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
index 4ae060a3b814d..088ee4d11ee82 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1445,7 +1445,7 @@ static int
 tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
 	      u32 portid, int event, struct netlink_ext_ack *extack)
 {
-	int i, ret;
+	int i, j, ret;
 	struct nlattr *tb[TCA_ACT_MAX_PRIO + 1];
 	struct tc_action *act;
 	size_t attr_size = 0;
@@ -1470,6 +1470,25 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
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



