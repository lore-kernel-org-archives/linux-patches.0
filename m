Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045667;
	b=BcVcgTfaF/nOl+uwtSqTXnAxOxZFu/8KHnIbE8IrINkSwJqY7hnJqHIrqjA5L0GEM9Uk
	 MiCT+QnL7a6K3Lu9E4RXdJq0AoJ5LuJfJ6MXwiyHrACDWx/hswqHLUWS5TCFPiJ8KcEsE
	 HvkQVPwyAIDCRigd/3spe9k9pKQyVfLcLR4kFuhy7jr0oGuF5V1MUMMNMPj2v4Wf+EIgl
	 DhXbOgFnHJBHfeAW2CGVGy+Z7XGdN99Bc1gDMVvlYiVLUc7pIHB6i+HB1C42TE9MRGZFt
	 BaXeJCTXD4rOdCLs6fP0G2gy8GHioPJBK1s3JW96RCSfi4NvhY0DGzw5dHdR2pCHOhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fzb0hZS2CqMSqdITzm9qxzkJUkjEKakgBsnzH4rN9n0=;
	b=mOT1TfIee8a6H/mistDuS3jj+tigyFTm1MmSWHLvZU3ChGGKjLDzYQY7X2y9ZrtfAbkm
	 fqyPGeu+kvUWPf7tyN04+X3a4+hM5vzmlsMc46RmPfOUaku7+AofAgn2GirabGdhnf3ZY
	 YbzexSOZTDRA+esLjmpPLsxoMg9KTfOCKAKZ4n4wqYoXkH36sXHLFp9Gay3g4yu22XSiA
	 xB7/JvfnCSyX/o9+3Phhgwz3tTxaXWu4pQPRSw/NpiKlR3mFckZ/ihZuBtdgoHQuoUu+E
	 2ahzN+NfGKVpJCQD8gih3NTo6kPwcR1FFgrr4/fXYhE6f82Mh70edQD7pX6sJRo/2nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oSVKW6wU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AE5606A330;
	Wed, 18 Nov 2026 23:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oSVKW6wU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662B51F000C6;
	Wed, 18 Nov 2026 23:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045666;
	bh=Fzb0hZS2CqMSqdITzm9qxzkJUkjEKakgBsnzH4rN9n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSVKW6wUMln4BIT7Rt+A5ulh4U5/eBl90WorYQXhacslnXr8txYRvwMU509A9/kjc
	 pSpMde5XDjULdZVEEbqadXQ75pxxRGy1W3uouYkFHAEmYPhRedC1f5gRTvzJcuPP+P
	 nBZuLYv3ZpYqJ9H6G5D92BTM+JSii2IhxQINX/bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1005/2857] ipv6: serialize address publication with device teardown
Date: Wed, 18 Nov 2026 15:33:59 +0100
Message-ID: <20261118150237.783578486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 06227034e2d93942119b922cf05f2de9da0ad848 ]

ipv6_add_addr() checks idev state before allocating an ifaddr, but
publishes the object later. addrconf_ifdown() can mark and detach the
idev between the check and publication.

This happens when a non-loopback device MTU falls below IPV6_MIN_MTU. A
forced interleaving published an address on a dead idev, and
ipv6_get_ifaddr() still returned it after teardown. Later device deletion
remained blocked with:

  unregister_netdevice: waiting for ac0 to become free. Usage count = 3

Protect the dead indication with idev->lock and keep that lock across
both hash and device-list publication. Recheck dead before publishing;
if teardown wins the lock, reject the unpublished object.

Non-unregister teardown does not set dead. The preceding change covers an
add that misses the initial hash scan but reaches the per-device list
snapshot. Both changes are required when backporting this fix.

Fixes: 8814c4b53381 ("[IPV6] ADDRCONF: Convert addrconf_lock to RCU.")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/179161099408.434549.14449036924552933828@kernel.org
Link: https://lore.kernel.org/r/20261012145306.GB779501@shredder
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261015050651.1841557-3-4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index cb11ea33e5587..7e54b264f672f 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1157,14 +1157,18 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 
 	rcu_read_lock();
 
-	err = ipv6_add_addr_hash(idev->dev, ifa);
+	write_lock_bh(&idev->lock);
+
+	if (idev->dead)
+		err = -ENODEV;
+	else
+		err = ipv6_add_addr_hash(idev->dev, ifa);
 	if (err < 0) {
+		write_unlock_bh(&idev->lock);
 		rcu_read_unlock();
 		goto out;
 	}
 
-	write_lock_bh(&idev->lock);
-
 	/* Add to inet6_dev unicast addr list. */
 	ipv6_link_dev_addr(idev, ifa);
 
@@ -3821,7 +3825,9 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 	 *	   Do not dev_put!
 	 */
 	if (unregister) {
+		write_lock_bh(&idev->lock);
 		WRITE_ONCE(idev->dead, 1);
+		write_unlock_bh(&idev->lock);
 
 		/* protected by rtnl_lock */
 		RCU_INIT_POINTER(dev->ip6_ptr, NULL);
-- 
2.53.0



