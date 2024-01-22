Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869C7380;
	Tue, 23 Jan 2024 02:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975749; cv=none; b=ugc5uujdShq3N0Iy7ZBE9b5eZmQ8LaD0WmLLcT1eZQ5jC/ZZ5jql8B0DPZeOhOgqknb/S+6c0B6dMKKeda7cpxLq0Y/fLXdp+z2I183yteEWuy0+MdzCZ7xZKqpo7d3agTQC51u5myVanmrfVMAKQSCGeQNt2gj+5Nuuw+zd6Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975749; c=relaxed/simple;
	bh=IxlL/Bcx2TLJNtxavQHWoxs9K22qsTWlkIFm1xX1gPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtkLaxKh6HZP7E5GiWRqVlaQbEdZYwV6S/5RdyjKjCPKRJI7hR0ue3NOePxYEHMH0ukBpUW9uMDl/Wnzg5he6Ij10I17A0INiZ16zSWAfRE3p8il6ab2NhY/5K2EzyEq6Q6pfs9KC1iXsVba2OfWOp9Ltyus4dxgV50+tiL00b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lm5HDt1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lm5HDt1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE6AC43394;
	Tue, 23 Jan 2024 02:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975749;
	bh=IxlL/Bcx2TLJNtxavQHWoxs9K22qsTWlkIFm1xX1gPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lm5HDt1JeiGtCeb1Lik6ndwWbt4Y8/GmUAtdMbtV/4a/p1PZDwDQPsDbSvXoCAHfo
	 hfyIKCpMzBsQRICrOFtmTZ+YlAHAuZPzG+DZ5ZdwcCRwaIVvsn/4uEXFTGSPlOmL+/
	 9ntjzA0kYW4h4eGD02bFBIsskHfi8FzY3Rq7fQbE=
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
Subject: [PATCH 6.6 534/583] mptcp: use OPTION_MPTCP_MPJ_SYNACK in subflow_finish_connect()
Date: Mon, 22 Jan 2024 15:59:45 -0800
Message-ID: <20240122235828.463224221@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d6ee0e52ea41..5b37fee2a85a 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -506,7 +506,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	} else if (subflow->request_join) {
 		u8 hmac[SHA256_DIGEST_SIZE];
 
-		if (!(mp_opt.suboptions & OPTIONS_MPTCP_MPJ)) {
+		if (!(mp_opt.suboptions & OPTION_MPTCP_MPJ_SYNACK)) {
 			subflow->reset_reason = MPTCP_RST_EMPTCP;
 			goto do_reset;
 		}
-- 
2.43.0



