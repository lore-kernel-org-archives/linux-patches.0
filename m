Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212336;
	b=TxQiGHYJxPA48GpRQP/q04wws7yfSD1qc3WkM7BSPXXTIc8fOBgmrteL+T+BfveIuDY3
	 5v+AXzGb5YrnYWAtA2ghheQ2oFtopZWhcsNLGjil9dmvn+x6YBTqhn9obCNo4Kbu3KrVB
	 nvHNaGHUECGS+PL03Gb71C9wCASZq3hlv4MQoRbbPcOuyYiouw7Jr5svDPN4FOfqr+DGJ
	 xlaYrL4wTUlgYyDVxuFgS246Xgj13FCQo/2gKbBR3KfZd6zDCx8W0sCzXONcZpFnyjJD2
	 rlSt00eQXonNkaPgA4V2wOdlo5f/h0H5oM9yO+2nChPITl4xT6iD4oVub0cVppljmDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=66rDApj9Rtis78jwWQajWEgmCEMgZRVItPHKo8/1KZQ=;
	b=WvbbV/wuRhf1gSfhT8dzCb3P0EGW+Ds4vu8HXQ+oCnX7/MXyH7Ni6heS/nAkfvc8qkzV
	 0ayaU26BQvdBAbz3UrNmPF4Hnj7DgfBgg8AVnQUwOW25TOk0kn27QzoKjriHNsN3v4AnZ
	 hc4YwhRfxW5zB7OPNuj2q1qwTUmoHFe8U+7J6pLmONZgcrPTcCWT3l7aiIUuxOj0X9N3U
	 67nzw286j9HCFArLGmwmcNa/rZm4CbB82VyZ5eg6nK1GKnvy/vsqD9QWwWIIQGqhTa8aD
	 goYuC4+R3gs2uKrI2PWva+wOfEKugdmLwWZtHIMC2VjDBdS15qivhfV6p8oOdg0zZdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZwCNlCFn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5926C606A31A;
	Wed, 28 Oct 2026 18:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZwCNlCFn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94811F01825;
	Wed, 28 Oct 2026 18:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212336;
	bh=66rDApj9Rtis78jwWQajWEgmCEMgZRVItPHKo8/1KZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZwCNlCFn4yh4Ehsu6JmrCqHHjlw9jC+3k2vehaFXIbD+TZzZ9kjlp1x6NvMgQYIt8
	 RMDejZaWCAQ3uhZ+qtqbclacNf61EU4V+v4QYy7hl5INr26gH8hVcLf/uQd0K/0UIG
	 Sfb99h3GbH7CIH1xRXhsW24CYVd7xLjNP6kykTFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0119/1887] net/sched: act_api: release all action references on NEWACTION failure
Date: Wed, 28 Oct 2026 17:36:55 +0100
Message-ID: <20261028170501.944123570@linuxfoundation.org>
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
index 630f285f8db07..8aa291b835e9b 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1142,19 +1142,14 @@ EXPORT_SYMBOL(tcf_action_exec);
 
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



