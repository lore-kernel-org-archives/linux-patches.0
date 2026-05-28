Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEA223394D;
	Thu, 28 May 2026 20:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001135; cv=none; b=Kd0tUAtJ6Qg2V85++8ucPffiizo4FqFRjJRadyl0AggnC9HaqsiomwSHWlx14mTwGX56nkVfLiu+iSaT5Nu+Nyd5eNBbfE7EQ8vi3S+FwMGJnpszDKHHFYXOO7qmPpp0WY5VeOMojG5qenjUSMTmyecrZbU5vLeRlZxZ3nwrmAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001135; c=relaxed/simple;
	bh=GKSntXG+sxmy7K4JwxNArTNNTniH+t4lDiNSChzOj4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5BusrcKLhfPdVRhVGGZUW4vR0FLP2tqa5MmkLkea2ztOCfkYvZnst2k+/22s1R3wEoIxz84Dw0pKAXEJTB9yTJAIYLp164YxFzw3YIzN49G2zuU+a6ZNhc/MY+tp17IzTv6IPtXx1bLRebjE62Y+5eUAOgb2XR8tDf5ntMBBtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVWCtmLM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVWCtmLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3CA1F000E9;
	Thu, 28 May 2026 20:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001134;
	bh=/A2SQ0ew1i6SDiSQ5weoi/YQZuzwgf24YLVQTUGEQVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EVWCtmLMo2PkeiYBH4by/Y85wXFVhOH0nTpvPEYfX+CTcI8qU9KtQqmpnKLwDDKUt
	 JVHHJUtn//FAryI3FRF0ksVG7IJMOume+jAjoS8QTZaJhSa2w2pgVTqz4RqjRqBvQ3
	 tVxPP+pYMVEXh6GJpfanfUnSUX0ZFvfu90ynA6og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/186] mptcp: pm: ADD_ADDR rtx: allow ID 0
Date: Thu, 28 May 2026 21:48:02 +0200
Message-ID: <20260528194929.011514767@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 03f324f3f1f7619a47b9c91282cb12775ab0a2f1 upstream.

ADD_ADDR can be sent for the ID 0, which corresponds to the local
address and port linked to the initial subflow.

Indeed, this address could be removed, and re-added later on, e.g. what
is done in the "delete re-add signal" MPTCP Join selftests. So no reason
to ignore it.

Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-2-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ applied to net/mptcp/pm_netlink.c instead of upstream's pm_kernel.c ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 4a5802126c8e4..23aef214f30d8 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -305,9 +305,6 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 	if (inet_sk_state_load(sk) == TCP_CLOSE)
 		return;
 
-	if (!entry->addr.id)
-		return;
-
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk)) {
 		/* Try again later. */
-- 
2.53.0



