Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EF53BCD29;
	Tue, 21 Jul 2026 21:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668037; cv=none; b=Rppsfff8AyHgwwuJz6h9tMy6S+vNFrYzpu2Ce0WiroAEg6EfKKn994qfsJluXHH98IBMuNZ9+L1gHd9GvD2z0uGD4+0qE3ICEZVVccwKZSeb8c/7ST193RyyQ9icWjdxwovzoHo+ew09xJoJy/vR8qP8CQfSdMM9batno8k8+LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668037; c=relaxed/simple;
	bh=1qD567lOmxh0rJxZcf6WNNZwoD8Va3+TFj8dNObi9C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUUTB/TVIIUeqByQoXW5Apw+KWPgs5i6fh1k1pr8DHNKJbuGNEmQDSoCT1hFK/fYMVQaBuqqgvLsDSX2YiDy71BKLCb3whyWE5noxeXVqK5NoM8wbvPSZWnHuy+EUJFmXHwJmJAS+GV0KMzlJT91lzbtXaYxpngJw1fEydUp+WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBemkIBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBemkIBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CF81F000E9;
	Tue, 21 Jul 2026 21:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668036;
	bh=anx8Njge9mRvbtcl3c6RE4WgfPWq+EMdfVqXJtkvR0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bBemkIBKA1jsiXBhxEYonLL9cdsHQXfx11TPjrcD0Z8/g8STQ3T2vhtnSfTcqFwhw
	 B2j7D3Lokaqd1DEXOumQK4w630UhJ4qSLYPZrjZ3Hwy/sZ66GP5Kw1U9tARqHibQfi
	 bxQ57LzwaHMl/B+KdbwFZQrBV2aZ7rWxd5UE8t/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0007/1067] net/sched: act_pedit: use NLA_POLICY for parsing ex keys
Date: Tue, 21 Jul 2026 17:10:08 +0200
Message-ID: <20260721152424.697647462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 5036034572b79daa6d6600338e8e8229e2a44b09 ]

Transform two checks in the 'ex' key parsing into netlink policies
removing extra if checks.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_pedit.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 09310b56b45beb..1d06873da8f12d 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -35,8 +35,9 @@ static const struct nla_policy pedit_policy[TCA_PEDIT_MAX + 1] = {
 };
 
 static const struct nla_policy pedit_key_ex_policy[TCA_PEDIT_KEY_EX_MAX + 1] = {
-	[TCA_PEDIT_KEY_EX_HTYPE]  = { .type = NLA_U16 },
-	[TCA_PEDIT_KEY_EX_CMD]	  = { .type = NLA_U16 },
+	[TCA_PEDIT_KEY_EX_HTYPE] =
+		NLA_POLICY_MAX(NLA_U16, TCA_PEDIT_HDR_TYPE_MAX),
+	[TCA_PEDIT_KEY_EX_CMD] = NLA_POLICY_MAX(NLA_U16, TCA_PEDIT_CMD_MAX),
 };
 
 static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
@@ -86,12 +87,6 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 		k->htype = nla_get_u16(tb[TCA_PEDIT_KEY_EX_HTYPE]);
 		k->cmd = nla_get_u16(tb[TCA_PEDIT_KEY_EX_CMD]);
 
-		if (k->htype > TCA_PEDIT_HDR_TYPE_MAX ||
-		    k->cmd > TCA_PEDIT_CMD_MAX) {
-			err = -EINVAL;
-			goto err_out;
-		}
-
 		k++;
 	}
 
-- 
2.53.0



