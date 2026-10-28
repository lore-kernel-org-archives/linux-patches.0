Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210626;
	b=K4l0i6D2teC2CRPNnjaeyWTu4Tjzk1Brp1dF1slW9If+niLcX3zkt0730Fb3H/gosKh2
	 rSQx3qF27MC1R4jvbe44FrACr4igiPavk0Puu65vvlNSfSoP82wxw7n3wA/xr35IPK9kQ
	 g72zLHvwL6M+9N7VaqQx8DDBApCLSZFJfVkkGgZ83bBzBlkO0NxSWlaYjILrd2QQnv1TQ
	 uUFlpF52G1eVZ8+9vZHg9gBgRpZyMmwSfZDZIk1u5le19V6iv4uMrgok250Xk3d4SzqK2
	 30ovbeYsQGaKe5WEHWW6OKHOQdM3+MSCXSlnWvbXHnnlAj+vKfDJrsLXbk4NeFkZJ3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lFHFKexXWJMl7kSasdBa8asWHMxGIUMNkjBHu0qMdkY=;
	b=kiNiUNB41AM4+E9va5rD8OEM8TtNBzN7AgTgBw+QS13nM31R8HA5/T7H/Pp8eIBfSYBJ
	 YYnuQRfhYiTM3uS4lmeCn4/RCfBqOmase+Kmaa21UyvvDanWUMvCLO/QktNlFjIFSj+co
	 GddbC88Au3Hv9v9zQvGRZwTr5mO/FXz0FNnW1LDfJjJ5sjBskpwqHSe3fmTY+eVbichEM
	 If6nfR0clVXMjg5lZB2puTnUe2HWlGXXBkQ+NP0SdfCaMlhTqWkBwHfqleg7385HMBlxb
	 Nf6XpXq1Cp7KWkxi4THlWrKUC/RwjW3BrU6g0Hwrew7EuTEEDCdadvhO2F3jvUaLrfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j5DKtSTw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D37606A31F;
	Wed, 28 Oct 2026 18:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j5DKtSTw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99591F01825;
	Wed, 28 Oct 2026 18:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210626;
	bh=lFHFKexXWJMl7kSasdBa8asWHMxGIUMNkjBHu0qMdkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5DKtSTwQGeu5bajo/bskZ9IrAQqd/MwAD+40qLC2fzbcMBtzZMXdYjeBFdtXy23b
	 srylqhz5h5Ce/8XfQogk3TLe6dFkEc/EikLIsiNtdrnJMjOw8e2txrqSAuabXe+DR+
	 dkrIe26/0vKcg6wyCSJzEXrGDdtwJIcCgQuHAgF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/571] net/sched: act_api: release all action references on NEWACTION failure
Date: Wed, 28 Oct 2026 17:54:00 +0100
Message-ID: <20261028170010.230511292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

[ Upstream commit 478eb5abb51931a152abab068f8a717b7ff480fd ]

When a batched RTM_NEWACTION request replaces an existing action,
tcf_idr_check_alloc() takes a temporary reference on it. If a later
action fails to initialize, tcf_action_destroy() uses strict release
semantics to clean up the actions initialized so far. For an action
bound to a filter, the strict check returns -EPERM without dropping
the temporary reference.

This error also makes tcf_action_destroy() return before releasing
subsequent entries. Any new action initialized between the bound
action and the failing entry is leaked together with its reserved
IDR slot, preventing reuse of its index.

Use tcf_idr_release() to drop each reference held by the batch without
rejecting bound actions. This allows cleanup to continue through all
initialized entries and preserves the module reference release when
an action is destroyed. Explicit action deletion and flushing retain
their separate bind-count checks.

Fixes: 55334a5db5cd ("net_sched: act: refuse to remove bound action outside")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260909070336.32979-2-xuanqiang.luo@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index c0bdeb522cfca..2c5191d9d4580 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -807,19 +807,14 @@ EXPORT_SYMBOL(tcf_action_exec);
 
 int tcf_action_destroy(struct tc_action *actions[], int bind)
 {
-	const struct tc_action_ops *ops;
 	struct tc_action *a;
 	int ret = 0, i;
 
 	for (i = 0; i < TCA_ACT_MAX_PRIO && actions[i]; i++) {
 		a = actions[i];
 		actions[i] = NULL;
-		ops = a->ops;
-		ret = __tcf_idr_release(a, bind, true);
-		if (ret == ACT_P_DELETED)
-			module_put(ops->owner);
-		else if (ret < 0)
-			return ret;
+		/* Drop our reference even if the action is still bound to a filter. */
+		ret = tcf_idr_release(a, bind);
 	}
 	return ret;
 }
-- 
2.53.0



