Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83F78801;
	Tue, 30 Apr 2024 11:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475807; cv=none; b=l2mM6yN/I4HJsesXMf+bwFZD2k/qMEah98OqpW8Db2iDy8q0w1S958zGfJL7PJCXoNNOO4poRfXs1Xu0GK24Jv4O84hEjTHdIjjJQ7APauY//+R2iKT0ul8KgNR4kkmeYy5KuRHSCvZdc2G26m87RyBDQEiM5c5+r4WVRjrpGLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475807; c=relaxed/simple;
	bh=ehIWqThAQzhCcCGHbHtKC78Q9xhaZfkgCwE725AIKF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GU9Y8TjsnserKyVYfqgHJD1QK/H/2wVrTdNC4Wa1ScCxF21YvE0g5FazNHMMz28BJlKz/pX0/hCuS4vx27pgQhnqmBS6h6Fg+Pbsg9rBpIPQ97nBE97gomj6+Htp2lcqMc4D2kpuDq8aY1FOnDNrtyitMaQ3fE18waVWx5A18Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwB6FDBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwB6FDBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E112C2BBFC;
	Tue, 30 Apr 2024 11:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475806;
	bh=ehIWqThAQzhCcCGHbHtKC78Q9xhaZfkgCwE725AIKF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QwB6FDBTzWquL2HfpxTFL7cqoA2VCM3PZZOTzFwfR+u9AFkgBbwEDHHqFli63JB72
	 LscqYpB2p5sWBZta+rmTLl2piJ8jW9DtoNw/vXrHyx63R2AlsIEd8qCTgA+XNncgj8
	 Ze6sMSMT1oZW/iVxB6ZGprbDsxVotmHYl7gSU1C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 23/80] bridge/br_netlink.c: no need to return void function
Date: Tue, 30 Apr 2024 12:39:55 +0200
Message-ID: <20240430103044.101067543@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 4fd1edcdf13c0d234543ecf502092be65c5177db ]

br_info_notify is a void function. There is no need to return.

Fixes: b6d0425b816e ("bridge: cfm: Netlink Notifications.")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index e365cf82f0615..a1a703b7d5235 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -619,7 +619,7 @@ void br_ifinfo_notify(int event, const struct net_bridge *br,
 {
 	u32 filter = RTEXT_FILTER_BRVLAN_COMPRESSED;
 
-	return br_info_notify(event, br, port, filter);
+	br_info_notify(event, br, port, filter);
 }
 
 /*
-- 
2.43.0



