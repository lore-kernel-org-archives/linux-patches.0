Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76146371049;
	Wed, 30 Sep 2026 19:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796829; cv=none; b=jeCzFEmkKleMFFnct/vqm5vN14YZJgpav1johtMB3pmphhZ071Eo7hZgSKIwKihH23n0XnwnXF1cKWPQlAjK1PP0+9cgi0us5qCZCt+V6gVBz6ihax7MQ66YLy2ZylcfRm1blgU9WcWb7yxyLA9np+IYZxfUdIOu7Peuukynz6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796829; c=relaxed/simple;
	bh=ZzONazAc2y4rfm/WlI/7qkWvkF7+jFCzQYI/BdPlQhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSfe7qWuJL+Z1TDO4wTdPMST09wRmR4gKh1hK6IBHTCSxCXQVSvbhv/J7O1cjRc6FEACCI9nQijiWRDVJNwZfNDr6G9vGEFggTuITi0W34alaE1mzEGlB5sFuwuIKwBxZoeaWwqjfp/y0UdMJk3XT28hjgakx0ZSMs/PzgZtAMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=heni+1Li; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="heni+1Li"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B8A1F000FF;
	Wed, 30 Sep 2026 19:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796828;
	bh=w+lwjC4xVR8gXhLeZvobM7x70e8y2Bu93cRMHicPrnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heni+1Li18thAfH/93sP0l4ujRDte5ETNj1And1Rqu1agI8K4ZLbK8Js/rBAvLHF+
	 ue60csMLlP5s5QhvGe1HHXgEgi7V7kvUDm2TrqH8BfUwR2d/cBg2Dq5ehg6OwQqHu7
	 n+k0BA5ehaQAhJrpf+LkV8ugjRqq7ya7G6+Tv2CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Breno Leitao <leitao@debian.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1005/1193] net: core: Fix documentation
Date: Wed, 30 Sep 2026 17:28:09 +0200
Message-ID: <20260930152456.569494090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit c6e7f276841d9a31009766f3e6f33e00cf3d93ed ]

Fix bad grammar in description of init_dummy_netdev() function.  This
topic showed up in the review of the "allocate dummy device dynamically"
patch set.

Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 310d1ac61a4d ("net: ethernet: mtk_eth_soc: unregister net_devices in case of probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2adf534a46f14..57ffe8b86d779 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10412,7 +10412,7 @@ EXPORT_SYMBOL(register_netdevice);
  *	init_dummy_netdev	- init a dummy network device for NAPI
  *	@dev: device to init
  *
- *	This takes a network device structure and initialize the minimum
+ *	This takes a network device structure and initializes the minimum
  *	amount of fields so it can be used to schedule NAPI polls without
  *	registering a full blown interface. This is to be used by drivers
  *	that need to tie several hardware interfaces to a single NAPI
@@ -10421,7 +10421,7 @@ EXPORT_SYMBOL(register_netdevice);
 void init_dummy_netdev(struct net_device *dev)
 {
 	/* Clear everything. Note we don't initialize spinlocks
-	 * are they aren't supposed to be taken by any of the
+	 * as they aren't supposed to be taken by any of the
 	 * NAPI code and this dummy netdev is supposed to be
 	 * only ever used for NAPI polls
 	 */
-- 
2.53.0



