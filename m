Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709874EB33;
	Tue, 23 Jan 2024 00:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970122; cv=none; b=u18fpwDuWG38h7j/W8fncOaPHgOiioifkU4+V6zv2i1TytW0OVbowxQLWYp86ibTbJJ2HWP6cgD0kmruwP5oKohYTOP6O1SRzkn+9/PSb8CpdPWbWrTF08a44RN3BTwbBnwtad2vOnSUrhUQas48W587lvT13xMVqYSirkxYl3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970122; c=relaxed/simple;
	bh=+sRZjtACrKDjaAP7AYzt+HmBQMvp7796cE6qOnKWkLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SA1UnXQIOxs+NxmvOPmyMHYma9RsAwSYseOuZ5CvQUrCdXCPqjKhQ3R2cGwa1zzDroL6/zf4agC1sxFZNOP56pa88TEK4wMhpu8mPsKlIaE7hdyVXUMHfJRTrFIjWefXib9P9mV6UEPgk6b6FI4C0sN0whjk/z/cpG8wIHl9Zp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4erzypQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4erzypQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5ECFC433F1;
	Tue, 23 Jan 2024 00:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970122;
	bh=+sRZjtACrKDjaAP7AYzt+HmBQMvp7796cE6qOnKWkLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B4erzypQvWPCRhRibVLFdV8S/NJWD5YuiDezZBCsk1Eg6P96VvAWhl/izMmaudcXb
	 L9zHFTAp/oxSL2qYwTjfF1n/gLjnMKXpyYE8HgCzwnOi7qkuYhTqx6vW2afyZa2XI6
	 VMRI/rOp+RpmK2dsQFf5fuwM/X1Anf+N4taD97R0=
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
Subject: [PATCH 6.7 593/641] mptcp: use OPTION_MPTCP_MPJ_SYNACK in subflow_finish_connect()
Date: Mon, 22 Jan 2024 15:58:17 -0800
Message-ID: <20240122235836.767551141@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 613bf6f1f3a0..d720314debb0 100644
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



