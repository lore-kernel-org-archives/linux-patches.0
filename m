Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC71312C7FB;
	Tue, 30 Apr 2024 10:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474261; cv=none; b=GorWpM7aENkDWmiudRZJk8bKPSSJq8WHktj0hI8/6RvBfRWJsCszbe4juJjhssZynNtmn4R09MpDekQaN4h0/ZCNZAB5vsrDdr3XSVpzqJWa9ogbf4909NUnHpDSrtST+D/f19nAv2ei70EYwOxH0mPcrWuKsWg9+2TQIxj+da0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474261; c=relaxed/simple;
	bh=5bRbo1ymQgGaUnA61BVouMicYXe0cA+RbgEqWpSiLGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROdpmmcLzfP8SLenHR4TJSA8Ve4jCUvvJSpiULfYyBBc4lwTMI7MJmPlHoe3ZgZylRFycIn7Y/WT3EKX3DmId7ekAXJlgbFlhDiqjKDpq5LEb2rkPThGL4AoWV9+lrO1YJ0eXxR5EQk7uGnQgvb+2WXCe3VVyypEna80iL+mYBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSNUtSwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSNUtSwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F2DC2BBFC;
	Tue, 30 Apr 2024 10:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474260;
	bh=5bRbo1ymQgGaUnA61BVouMicYXe0cA+RbgEqWpSiLGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSNUtSwY9kldClWflI4f+8cVj7MSEox0NvvK37hug6KuIyFkywY2niAVY21Qy1EZf
	 C1Wk1KJM2FX5N1C8liY5YkqHonFLVpiEVNSfAELZnlj7MbU6sOamM7Qjm1eCwKfViZ
	 AvOuwQR40PcwVn3fOREfnzEVbUtN0LEvuEYvJA3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 056/228] bridge/br_netlink.c: no need to return void function
Date: Tue, 30 Apr 2024 12:37:14 +0200
Message-ID: <20240430103105.426941585@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 5ad4abfcb7ba3..d415833fce91f 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -666,7 +666,7 @@ void br_ifinfo_notify(int event, const struct net_bridge *br,
 {
 	u32 filter = RTEXT_FILTER_BRVLAN_COMPRESSED;
 
-	return br_info_notify(event, br, port, filter);
+	br_info_notify(event, br, port, filter);
 }
 
 /*
-- 
2.43.0



