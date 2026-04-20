Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DDC3F23DB;
	Mon, 20 Apr 2026 13:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691547; cv=none; b=KtNVDWYuS/CDfHKJxsEgUl4FZN25GkoeYclp1eUCM2cTe6jyJMPOOdiRxm0r1LA0BJIsMX0VPxN/MlaGfBj0SUtJtOSeWmY8eQvSmv+wkIAgb8RKk2ACLPmPaFcomIT+XBjBcClVnde+rLRGkyZe6xNlGxVwn3rdBTux2r7yNnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691547; c=relaxed/simple;
	bh=EmrrolUQ9+NKYFK+I/2JSP0Cd7peVIsW0fvVyG/GObM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzFORqI1yRer5mTxPzhG8Sz44QBmHYXHQJt2vZVTGTECUg4ngw7fUiZ6Fc++ncOS++o4NYpkoRMTEmFu1LKtBQjRWgkgkY6UHRk8jPvP5OkGEubDrEqNfUcYHHzaI0ONrb8N77MG14W1/mB0NY9DqaE/PuauZDN545W9m8y7vOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tOnxE9wA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tOnxE9wA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE665C2BCB6;
	Mon, 20 Apr 2026 13:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691547;
	bh=EmrrolUQ9+NKYFK+I/2JSP0Cd7peVIsW0fvVyG/GObM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOnxE9wAiw+cqfqL2XLxbilTZCT9i79lHbixfK3T65UoCfEwkEyWrfWJeaBIpRvz4
	 dxhY0l5x68a8uLjkQKNJrFVV5U/fkDLw2XmPU/skmGtiHAuwIaRNy3U25J1Eb9+1Mx
	 4nEDfOf5I5JWtdKWAJ3fSP0N8RYM6IMA8BIu8F0zNsXiuNxrrHNhBoD8vOHAuNsuB/
	 hzB0b2jwQYmxCNrAmxVHSaBMjetGujOtUWoDkLlWTnssO3birerXq7GM2X/eZEHFCg
	 KBLnTgJl4f/rzzp9ZvnugvhzA+50xWc8rk1lt/lsWFsFB+vo4baFGtKBQ3byjSIiE/
	 tYkzcr7H41K3g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Li RongQing <lirongqing@baidu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	przemyslaw.kitszel@intel.com,
	anthony.l.nguyen@intel.com,
	mateusz.polchlopek@intel.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] devlink: Fix incorrect skb socket family dumping
Date: Mon, 20 Apr 2026 09:18:07 -0400
Message-ID: <20260420132314.1023554-93-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 0006c6f1091bbeea88b8a88a6548b9fb2f803c74 ]

The devlink_fmsg_dump_skb function was incorrectly using the socket
type (sk->sk_type) instead of the socket family (sk->sk_family)
when filling the "family" field in the fast message dump.

This patch fixes this to properly display the socket family.

Fixes: 3dbfde7f6bc7b8 ("devlink: add devlink_fmsg_dump_skb() function")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260407022730.2393-1-lirongqing@baidu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 net/devlink/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/devlink/health.c b/net/devlink/health.c
index 136a67c36a20d..0798c82096bdc 100644
--- a/net/devlink/health.c
+++ b/net/devlink/health.c
@@ -1327,7 +1327,7 @@ void devlink_fmsg_dump_skb(struct devlink_fmsg *fmsg, const struct sk_buff *skb)
 	if (sk) {
 		devlink_fmsg_pair_nest_start(fmsg, "sk");
 		devlink_fmsg_obj_nest_start(fmsg);
-		devlink_fmsg_put(fmsg, "family", sk->sk_type);
+		devlink_fmsg_put(fmsg, "family", sk->sk_family);
 		devlink_fmsg_put(fmsg, "type", sk->sk_type);
 		devlink_fmsg_put(fmsg, "proto", sk->sk_protocol);
 		devlink_fmsg_obj_nest_end(fmsg);
-- 
2.53.0

