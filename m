Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050224;
	b=DpHYEyoVF0WdjCo8gWcjpjF0srj6hlIXBdVSjZB0/pLwH0WJ41MgP2I58g+lADda2CBL
	 5s8BnXY3ESdjN4Hwh8Hms4C8ncZc6bZpXYCffq2QwqCMPEky78wrffCdkkOwSf66FLc8T
	 /HuhgW0yPFup+YXa1zuRt8xdu+MfYzm12n8yRUFstUUXV3neVXnAcIHnwwne9hHAgHvyn
	 FopMHbCYVHJyhaUejBgbOkZ6oZ01zMnFQ8pbUPeyNcqTne71mUWnv37nhD1Wvp72JNVCT
	 Z3AqkPKlG0GX0o1ybXEfxup7pCRATtm+/v9O13sb9984MdTHMPBWDs1eKjAOCLWbp8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ByayToAbcZjpWNyC3/VkRVFdQ+DMDTHYkICKPzCTY/o=;
	b=dmQxDTro1LMghqaILxRKgdwHaOLBzNJsFPkp9Gc/752mVK/QcPch0CPr4zb3X9y/QlCg
	 rsaar2Z/3nWKewGHF+urz8k5RTMmMfps8Yfy7OEqfU+9K41/D8SiwgZOd0lcQvnCOjfG5
	 DJSn99KH+BUWECOmeAm0arvNWWLCCz5EfwBUR9W1MICXYh6967gYBIv32lswcbBz3peZP
	 Hh42aqWviEHJcF099FJ+vJeA4VfH/ZTjnbBdHPQ84qiaITrEyIq907rFaOzinR6yfmRhM
	 A9i0KHOq+Xx4bopNR4qgMRbXOUxV52q2ZcUkvxoOuM5BgxCKxEY+Nci9uxnHJv74qvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sI/bWV+F";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822A6606A31C;
	Thu, 19 Nov 2026 01:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sI/bWV+F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3AB1F000C4;
	Thu, 19 Nov 2026 01:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050224;
	bh=ByayToAbcZjpWNyC3/VkRVFdQ+DMDTHYkICKPzCTY/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sI/bWV+FUKTof9xFhl7pCPYlEaJzG2zj2MvCduO51W1l3a2RzO/ghRRKXA10w4UzD
	 e/EkSBUAHFvYR0XZDm58614HvVdbeAqw5v8vOEUFfwjNgNKjBWgf9tTGcgIO94ZeiM
	 0e4EFyledFuzaTEf3kjJj3cAkfN0HcE/rYDIjipQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (gemini)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2633/2857] net/sched: act_api: reject duplicate actions in a batch
Date: Wed, 18 Nov 2026 16:01:07 +0100
Message-ID: <20261118150336.396757625@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 0ab2c48775996..5fff8f6a0f111 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1994,7 +1994,7 @@ static int
 tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
 	      u32 portid, int event, struct netlink_ext_ack *extack)
 {
-	int i, ret;
+	int i, j, ret;
 	struct nlattr *tb[TCA_ACT_MAX_PRIO + 1];
 	struct tc_action *act;
 	size_t attr_size = 0;
@@ -2019,6 +2019,25 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
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



