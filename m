Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96560407CEF;
	Wed, 30 Sep 2026 19:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796826; cv=none; b=S9+orTlDEBriCfNKwMiLFRY9Tljpb318mm2m5TCDv2ZYzkfF/id8lBPsH+TZSQCVbM2vNQveYbvxYTu0L/ZCSrGjfupwHRlso/ZJlPtsOFWQsveaZZdYOuPtHCRjFMifNc8H9hzmdz9R4tqPhI1pEMoyeP6aSb8KZVfZSxXd8CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796826; c=relaxed/simple;
	bh=D6lVFNw++dZAiOrpyWiP35WXEbdjK+nuCUUD7dR6N9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZMLaUlxvIW6IDkID81BWn559rdXhpnSFugy5+L9wDFgdfWq9c24uKDFSzKiwIyyJBRrLxw73M1HbcZ3PgvWMh+d9xv2n+rjUBJI2kohPlVBcaVTv3W0wBrDpTnfjdqFkbRoCsRsxDb6goqV7CjVzbJ6M/CRQwUAur9rRlOsM0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UuQqQRSP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UuQqQRSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A221F000FF;
	Wed, 30 Sep 2026 19:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796825;
	bh=HeN3HA0PfdcgyStVDT9gKZqwfqSiAzbB8dqQvk4gO9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UuQqQRSPs0fedV0iRJHqVM3OmooUtf48eSJXyQBEiqz0hw/zG/kdJvJAv//Nv28Yc
	 Y3+WJOcEsF3MMkgn7fY1mCTT90WRsooty5nOV9kpuBg92QjMZxqJZD2f/LCZ56OCHQ
	 gHlX0HWDa9DjlWQ6SZlgvClJebdCUQKR+yItpYdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Cohen <amcohen@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1004/1193] net: Do not return value from init_dummy_netdev()
Date: Wed, 30 Sep 2026 17:28:08 +0200
Message-ID: <20260930152456.547324293@linuxfoundation.org>
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

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit d160c66cda0ac8614adc53a5b5b0e6d6f1a05a5b ]

init_dummy_netdev() always returns zero and all the callers do not check
the returned value. Set the function to not return value, as it is not
really used today.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240205103022.440946-1-amcohen@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 310d1ac61a4d ("net: ethernet: mtk_eth_soc: unregister net_devices in case of probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 2 +-
 net/core/dev.c            | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fdd3ae0a506ea..e704b6b920712 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3197,7 +3197,7 @@ static inline void unregister_netdevice(struct net_device *dev)
 int netdev_refcnt_read(const struct net_device *dev);
 void free_netdev(struct net_device *dev);
 void netdev_freemem(struct net_device *dev);
-int init_dummy_netdev(struct net_device *dev);
+void init_dummy_netdev(struct net_device *dev);
 
 struct net_device *netdev_get_xmit_slave(struct net_device *dev,
 					 struct sk_buff *skb,
diff --git a/net/core/dev.c b/net/core/dev.c
index 36a6d621c10a7..2adf534a46f14 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10418,7 +10418,7 @@ EXPORT_SYMBOL(register_netdevice);
  *	that need to tie several hardware interfaces to a single NAPI
  *	poll scheduler due to HW limitations.
  */
-int init_dummy_netdev(struct net_device *dev)
+void init_dummy_netdev(struct net_device *dev)
 {
 	/* Clear everything. Note we don't initialize spinlocks
 	 * are they aren't supposed to be taken by any of the
@@ -10446,8 +10446,6 @@ int init_dummy_netdev(struct net_device *dev)
 	 * because users of this 'device' dont need to change
 	 * its refcount.
 	 */
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(init_dummy_netdev);
 
-- 
2.53.0



