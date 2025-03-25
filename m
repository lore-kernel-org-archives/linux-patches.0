Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A93A25D545;
	Tue, 25 Mar 2025 12:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906308; cv=none; b=G5SqWQW8vST9Qs3Gpd1JzKi1mmDTBTUfBVAcGLwhUeukY3mFBGgaGK8Zkd3IzIjRHNDRDoJI1SSGORrxALEWMbW2CRDG30R4F9kz2ZzlQ5ScfiAIJPvAIgzMLwnFZSXbop2G+l+2CvZ0JPSNY5B3QBYXRNUtRQ9c7WF/BAsu5Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906308; c=relaxed/simple;
	bh=QA+1OpxEtHvuP/5hx/LzxZ7V8iB/fNJ/8Z0KUcpXMfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrYM6wUQervkLJluRsN9fuHC0FdUnzkbLx1NP/6Oj0K7HoCJaeNqIq2J4KFmllVuhkmbpc1bkv6twbQK3nxdaPeYDMq9VwqPO/ETFNyNKEsmdHm6yZcQ915Yff9TgiCQaR8Gc4yMMCYvAkcS0q9hfIWs8VOO2/RYkAg8I6EZx08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9EyTsHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9EyTsHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B404C4CEE4;
	Tue, 25 Mar 2025 12:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906308;
	bh=QA+1OpxEtHvuP/5hx/LzxZ7V8iB/fNJ/8Z0KUcpXMfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9EyTsHau5+wpVEn2sPAIg9VmlOC4hmDVIPbqI/WFBqEcRs/SGvyNAuuchSE0u8oT
	 lHYf31VlDze5C90M/mldsbN7NUzsGHYdI7iOmcbgAQAAxBhpPQyS9tmc3ZFraxAk1G
	 wr1WDtFQ6PTvmzfxQi4eOZLvqAkuzcwa+fyzOJJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/116] net/neighbor: add missing policy for NDTPA_QUEUE_LENBYTES
Date: Tue, 25 Mar 2025 08:22:16 -0400
Message-ID: <20250325122150.459618063@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 90a7138619a0c55e2aefaad27b12ffc2ddbeed78 ]

Previous commit 8b5c171bb3dc ("neigh: new unresolved queue limits")
introduces new netlink attribute NDTPA_QUEUE_LENBYTES to represent
approximative value for deprecated QUEUE_LEN. However, it forgot to add
the associated nla_policy in nl_ntbl_parm_policy array. Fix it with one
simple NLA_U32 type policy.

Fixes: 8b5c171bb3dc ("neigh: new unresolved queue limits")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Link: https://patch.msgid.link/20250315165113.37600-1-linma@zju.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index c7f7ea61b524a..8082cc6be4fc1 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2301,6 +2301,7 @@ static const struct nla_policy nl_neightbl_policy[NDTA_MAX+1] = {
 static const struct nla_policy nl_ntbl_parm_policy[NDTPA_MAX+1] = {
 	[NDTPA_IFINDEX]			= { .type = NLA_U32 },
 	[NDTPA_QUEUE_LEN]		= { .type = NLA_U32 },
+	[NDTPA_QUEUE_LENBYTES]		= { .type = NLA_U32 },
 	[NDTPA_PROXY_QLEN]		= { .type = NLA_U32 },
 	[NDTPA_APP_PROBES]		= { .type = NLA_U32 },
 	[NDTPA_UCAST_PROBES]		= { .type = NLA_U32 },
-- 
2.39.5



