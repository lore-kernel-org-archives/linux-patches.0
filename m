Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065168;
	b=zrru11fckQ+kkzGidhBBojsxvdpalRuqZvK6H8syZ4GtrD9LDb3F/d55VT7c6XTAGnNe
	 21AAs5A2cJuVFi+kKPHYi0s3ZNwWyIChTbpbddz1bjFDuzl2GqiXbTJpw6/qMkeu5i2vt
	 FzOXzFf+6Mi4R6KJMXaHuahTTMf/8poJOmDkUm6ylaHbfjFmhxe2EaQkQh72WroPwvc9F
	 GAB4Z0D8Ei9QlJOb2535/zQOI/bPOM794AQB6u46T2DHdnWt5RtZ2utNPpyRCv7UBN/s5
	 +4VqenprYCcGG8+XceeEE6VF/xD4U9wJ+IZg7kuhHP2/0Yzhrj/S36bzwX4aOS5EyNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BpSrZvenURKQm0lxQ0WEcR83LdXZGB1PTbByTIy55WE=;
	b=vBj4zjFe+18HQZUCEF/7zG6YJkYy+yKRN2msFXxekvTZt94CEM3VTpIHqpGzaL6JyLgN
	 JSR76hRcLtWeGAzVC5KuHvMrJEFGa068xVWBwoL55g8sXO8ATS+HHLOB4vq3YdXnwoyzp
	 llONlk2dtV1Rg4mI365wkAnfuY3v2XplKcGEIUWJY60YK/UEHMxVA+o3AHYSA50/Rt3vZ
	 xniGOIgZByyXwX1woIdPEkzZRqmCcUnXsshCbg6EBMpqrdt8OQ/mp/KHCP5V3U2r7kDBv
	 Mx2gie+Ajwzi/uZUa4v6U2KCkGwt8F0yAc9slbTTWMdt9NIaULnYgbF518je1rW6ojg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VjwpKhe9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2344E606A331;
	Sat,  7 Nov 2026 15:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VjwpKhe9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFEA1F0089F;
	Sat,  7 Nov 2026 15:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065168;
	bh=BpSrZvenURKQm0lxQ0WEcR83LdXZGB1PTbByTIy55WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VjwpKhe92APuQ1vhqrEgZxf+IYF8dfDbL17zSJIVJofk4wRJqfZRSgXAVHpjy6+6c
	 RUWUN/AYxHpPVjVkhv8XYUleX71kOp10Z4fdAGvYFNfrRq9W4J+QSnYQVu4LmVbWn2
	 Gm8hRj3NGhQyYRbV0Z9eNY2zJcXx+voptZx8IIZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0972/1257] ipv6: serialize address publication with device teardown
Date: Sat,  7 Nov 2026 08:54:28 -0500
Message-ID: <20261107135006.203178996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 72d7df23f7967..3bede30d4e989 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1168,14 +1168,18 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 
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
 
@@ -3897,7 +3901,9 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
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



