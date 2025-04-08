Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D21F268FDE;
	Tue,  8 Apr 2025 12:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113895; cv=none; b=tqfQ1yC+ke+KRKX6DQhogvMzkWrEfQVoYdBY8GxnJ7w6A/pWj9/51VuZeGMghL9mD/1weZk2UHNE9nHjEpJl1pUxFyKUd0yRlDEXd9debafz8eRqQDSmqLWtuLnbfczjWqW5/NKppZwFjvSjsiRG7HvxmQenryJvgnm75olTTLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113895; c=relaxed/simple;
	bh=vuqaQR+YQYsB1gN7dJg4ZA1pnGlqvAPBf5wmLEyfrdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DH9WplOy/Jz1XDNHlvy4f2cIyTfDOdEO77UDpzHCBlZKqpa1niOwmEggESn5+C5viQEVCyLkOgHiN+qJo1kp6eCZS2gI4taGLirm5QPGo9dJ2aP8dOI/qfa1+VO95s4enHoelk5P9cXqwCszvkshI78S5VKEXFbmy/2nhRx0jTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAUCy3sb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAUCy3sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E137AC4CEE5;
	Tue,  8 Apr 2025 12:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113895;
	bh=vuqaQR+YQYsB1gN7dJg4ZA1pnGlqvAPBf5wmLEyfrdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAUCy3sbOfNFR6xxGemSMyoP0Uq7ANHim1vK/Po6HVPfxAq3juesPrzJIkhJW0fyX
	 cT07f7LVLv9ijbrQwAOQiqAA/JU3CMnQk1IswmIULqShwy5HyLingNK+ppiU3PgqYS
	 t62kZZ/vQSTdjLRrOrBQQsZNVV8KzCk5oSr8w/pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/154] net/neighbor: add missing policy for NDTPA_QUEUE_LENBYTES
Date: Tue,  8 Apr 2025 12:50:00 +0200
Message-ID: <20250408104817.176055804@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7ef3630ea20d7..005cc630f74f3 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2176,6 +2176,7 @@ static const struct nla_policy nl_neightbl_policy[NDTA_MAX+1] = {
 static const struct nla_policy nl_ntbl_parm_policy[NDTPA_MAX+1] = {
 	[NDTPA_IFINDEX]			= { .type = NLA_U32 },
 	[NDTPA_QUEUE_LEN]		= { .type = NLA_U32 },
+	[NDTPA_QUEUE_LENBYTES]		= { .type = NLA_U32 },
 	[NDTPA_PROXY_QLEN]		= { .type = NLA_U32 },
 	[NDTPA_APP_PROBES]		= { .type = NLA_U32 },
 	[NDTPA_UCAST_PROBES]		= { .type = NLA_U32 },
-- 
2.39.5



