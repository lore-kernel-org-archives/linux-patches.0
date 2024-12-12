Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40BC217656;
	Thu, 12 Dec 2024 16:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020770; cv=none; b=qg1rmoDq5NJmwmRscA+AouyxmBHjsojsyxfAZRgx7AsyIfBvTtPS9Dj2S68lduXCoFn4dHydUZUFuE4dfjkgwOu9y0knRyZRBz8yvDieybGNw7Z7/bx9YSX3SkJK5xSdtbmihGfLPifypYwXDuS69bwoTTemj8aoDsBsNQkYzcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020770; c=relaxed/simple;
	bh=zH9EJcpkfah2zZXiegTAeioc+o/uDmWKlP/90iJhiQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNAcv0fzbtEOPP5rmCLsPc7AWrEHRZb38nOMs1qwL6UCXN995QPbcsrGJKIjN6EaNILqnt4QxprKvwclXpDvkevBOs9XTi2wwGYvZMarj0dUOlyk9kkqDId74iFYGV13kleviSGmZYlAOrXrBnufuZPJet65kkGSxHZHG16PWoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwWlJfq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwWlJfq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2607C4CED3;
	Thu, 12 Dec 2024 16:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020770;
	bh=zH9EJcpkfah2zZXiegTAeioc+o/uDmWKlP/90iJhiQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwWlJfq2bmYJiOc/VWR9NotdTwrujWjPzORg6npLJg/gktG+Kv1CgTS1jZJEbMM3T
	 Ec3r1qhlt6JPgmpyhb1TE006thhp+BSLFVxFR9qe+Y/f18Mb5DSiwoFbDQpTMSGOSA
	 JjHe93HobKZz5+N+6QmXvB2bOMxAVtOdnV1Oljoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+57bac0866ddd99fe47c0@syzkaller.appspotmail.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 526/772] netfilter: nft_socket: remove WARN_ON_ONCE on maximum cgroup level
Date: Thu, 12 Dec 2024 15:57:51 +0100
Message-ID: <20241212144411.698162917@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b7529880cb961d515642ce63f9d7570869bbbdc3 ]

cgroup maximum depth is INT_MAX by default, there is a cgroup toggle to
restrict this maximum depth to a more reasonable value not to harm
performance. Remove unnecessary WARN_ON_ONCE which is reachable from
userspace.

Fixes: 7f3287db6543 ("netfilter: nft_socket: make cgroupsv2 matching work with namespaces")
Reported-by: syzbot+57bac0866ddd99fe47c0@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 4148df6d6a471..2d33674e9e5e9 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -68,7 +68,7 @@ static noinline int nft_socket_cgroup_subtree_level(void)
 
 	cgroup_put(cgrp);
 
-	if (WARN_ON_ONCE(level > 255))
+	if (level > 255)
 		return -ERANGE;
 
 	if (WARN_ON_ONCE(level < 0))
-- 
2.43.0



