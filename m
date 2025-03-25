Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41D52561D7;
	Tue, 25 Mar 2025 12:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905947; cv=none; b=G4q8wKRfP0JpmIHVSRZSyTtld9z7kfzTn2cO6WrvYbEezIsJSZJn45fCSG0RNger8RaWfpe9gJBJVfhAg6BX1Xo1Lk+Aq7VP3dZp44baxj3IxaeHjO+BVdGN2AywWX4s7GZ8DiD4tPN9XbmbjGRzAapdMOlXUmvQEGCLk5DcZUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905947; c=relaxed/simple;
	bh=9Eq1bVsY5CRRspzaFC+FPXEPICkJ8RkNdRF2bFZTOL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ID9ZRGg+BmVtu89SzXJBK6gQMsnU5LLtOcE+s1PxQuIX4GDHCDK5orzTkF/bQGmWGJXtFP+zDVmr2ebenPP+L+r2W7irtezHKVSyxHO70l5uS4YQHNzhM9c3Yj6Efrd3YZbDtfeofDVmcIrdjtZsuj7RjTe0hmS1hN6jpXbkV6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGTeif0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGTeif0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682E8C4CEE4;
	Tue, 25 Mar 2025 12:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905947;
	bh=9Eq1bVsY5CRRspzaFC+FPXEPICkJ8RkNdRF2bFZTOL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGTeif0EEJARbe0u6Rkazy2RBKs1i/hd7vLMhQ0b7zAcKA+c54K0rm6Dm4VgxNglt
	 4ug6svrLtxD7bkVWAo1/mv1yWYoevwvPoZjX2GVBmUy2iqkNPla7Hi35SCkYem+8YM
	 2Z72j+LtetwBpHqlMSGDocBOucSxcmePdHB/l+/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 050/119] net/neighbor: add missing policy for NDTPA_QUEUE_LENBYTES
Date: Tue, 25 Mar 2025 08:21:48 -0400
Message-ID: <20250325122150.333960973@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index bd0251bd74a1f..1a620f903c56e 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2250,6 +2250,7 @@ static const struct nla_policy nl_neightbl_policy[NDTA_MAX+1] = {
 static const struct nla_policy nl_ntbl_parm_policy[NDTPA_MAX+1] = {
 	[NDTPA_IFINDEX]			= { .type = NLA_U32 },
 	[NDTPA_QUEUE_LEN]		= { .type = NLA_U32 },
+	[NDTPA_QUEUE_LENBYTES]		= { .type = NLA_U32 },
 	[NDTPA_PROXY_QLEN]		= { .type = NLA_U32 },
 	[NDTPA_APP_PROBES]		= { .type = NLA_U32 },
 	[NDTPA_UCAST_PROBES]		= { .type = NLA_U32 },
-- 
2.39.5



