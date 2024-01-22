Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BED6774B;
	Tue, 23 Jan 2024 01:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972009; cv=none; b=E6XA7jdKZNdMfCmm7bWpDF5X1ZSmEK+cCnCaqYhchAF8EcOlgRVsng1DhrnqQe5x7HENFNkAoh+PUsf9KnTOwMvznOyCX8bqX5k8lfpWDKTJ8xYxXJNN4wM6Q0Vs5ei3uMQ/zUQemKRY+IhRGUPLGuotZhg+NzzL9hzHEEuD1Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972009; c=relaxed/simple;
	bh=9fgZVG/CggudqAyF60eESX+GiH+5aPKJzqkvW5eBRAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oji/aBGz9dvPXiT635Wc2xvtJVxtAkucJOgiiuLXb40t+2bGpfeMunsVvudfsPB0BnYuTe5NyuhQzGR2O8dRNlAXTUDsf+u1+b0y/Plt2iAcBo986RcSj1WRlaxUqASRVlwbfyo3eeJkOOFJVKiuASXkfNvBWF/S5/IFBCREt2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jV/TaPgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jV/TaPgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982B0C433F1;
	Tue, 23 Jan 2024 01:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972009;
	bh=9fgZVG/CggudqAyF60eESX+GiH+5aPKJzqkvW5eBRAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jV/TaPgwmOy+fgHEu/Ca/JdBWL0mpL6bPetjNK6Ufn9u0QHfXZlHT+mBBGmdKd2Zv
	 4NCTHvLDNNFFf4GwHh/9NKvBF1c1F9jyjnhdnk7Jnye5E2fbObQ41TAdupri4TXLC2
	 8cttlLl+5mSYyuZg7eK3YvR9kTb7GWEj8mePtG6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Florian Westphal <fw@strlen.de>,
	Peter Krystad <peter.krystad@linux.intel.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang.tang@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 384/417] mptcp: use OPTION_MPTCP_MPJ_SYNACK in subflow_finish_connect()
Date: Mon, 22 Jan 2024 15:59:12 -0800
Message-ID: <20240122235805.070999394@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit be1d9d9d38da922bd4beeec5b6dd821ff5a1dfeb ]

subflow_finish_connect() uses four fields (backup, join_id, thmac, none)
that may contain garbage unless OPTION_MPTCP_MPJ_SYNACK has been set
in mptcp_parse_option()

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Peter Krystad <peter.krystad@linux.intel.com>
Cc: Matthieu Baerts <matttbe@kernel.org>
Cc: Mat Martineau <martineau@kernel.org>
Cc: Geliang Tang <geliang.tang@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20240111194917.4044654-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index a7090922480e..caf7981fbee5 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -438,7 +438,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	} else if (subflow->request_join) {
 		u8 hmac[SHA256_DIGEST_SIZE];
 
-		if (!(mp_opt.suboptions & OPTIONS_MPTCP_MPJ)) {
+		if (!(mp_opt.suboptions & OPTION_MPTCP_MPJ_SYNACK)) {
 			subflow->reset_reason = MPTCP_RST_EMPTCP;
 			goto do_reset;
 		}
-- 
2.43.0



