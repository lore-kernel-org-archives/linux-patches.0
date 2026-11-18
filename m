Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054241;
	b=Q6JMHnw22zY463BvzosKoBiXcpS1tmyu87+TPd+XsZIZb+5T7L+1Ixug5n96+7IS0+9h
	 QWIzeRte1wP6xyE7Y6HFytIDVi9lN2zLtIjqS67wQ3YanyXesZ+67C3eWb9fJvW4Br2lY
	 Q/7mienSAlem7QoB34ZxSk9og0pV4wwNAb2izI/76+Vf+PhsdmpxaizF8WWrTAMumKHWv
	 GbrQOWngCHXvNx9eHM/Ni82e4KMKem6T9MKbfMwMoWtU4kGKWQj31dUYWt/Tqr9f0VW1B
	 pd31buFCHT6W6NXRbJHDwHw/ZCReLDv6k441fIO4j1D3YXSmJ/1h1K4Vc/0G1BECCPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7X0KOIlfZKfRoeLohdH/IOywcH2NpbZzwcDxAHsSZ14=;
	b=OVYTSQnfrYLBZGk8B1hMmhH1oMukFGO8R+NOEDdu6f7vqSaHUu1zIfVK0eEZf6y6Cfgg
	 ZUVgOWFjVKghRN0nofReKy/maYduFIK4C9R0bVPAOL3JXTh5cjpkxVzvdd7MOPx+UK1yJ
	 1MScedylUZBMhkLdZNpxUJ5X3Yb2hwNifoZr+DXmEgDiVCahvVzMX1MlN8HXUKaKBR+2h
	 xF2EdRXp4RjGoSZcjoig7j4ddk1WAXRW6ql2HAcOnFzsjhJx1tJcEq7OqSFZNZCX5dGs+
	 6Btkz2ZzpXO8D8loBgaAj9LXl89ieRLeuAb3B9XnFrpRFw08j1rUaEMT3QlMhZHYP2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t1UdXznO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05DE606A31C;
	Thu, 19 Nov 2026 02:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t1UdXznO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D72F1F000C4;
	Thu, 19 Nov 2026 02:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054241;
	bh=7X0KOIlfZKfRoeLohdH/IOywcH2NpbZzwcDxAHsSZ14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1UdXznOQFcgSoXr2Jrc64gaCVVzrOYzqq/SIlFAXGjHSlcYGPAEfRj9Og4KOK5Hp
	 digrYQ7Km10ti1aVRGOSrPalIl6V1GstajP+Mrfut1eSYaP1Wjz+GOyeh8kANxgwcL
	 OSn9WOkXahSWuFX246XynDBuNGH3WyLD2pOIFJ/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1163/2214] ipv6: remove ifaddr from hash during ifdown list cleanup
Date: Wed, 18 Nov 2026 15:47:19 +0100
Message-ID: <20261118150058.553818850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 6ace56ed7b13a9c6d4cb7ef0d82d3a3d53324a63 ]

addrconf_ifdown() clears the address hash before snapshotting the
per-device address list. A concurrent ipv6_add_addr() can publish an
address after the hash scan and before the list snapshot.

The ifdown path then removes the address from the device list and drops
the list-owned reference while it is still linked in the hash. Once the
remaining references are released, inet6_ifa_finish_destroy() warns, but
a DEAD address continues to kfree_rcu(). The hash therefore points to
freed memory that later RCU walkers can dereference.

This follow-on was found by source review and was not separately
triggered at runtime.

Remove each non-kept address from the hash immediately before removing
it from the per-device list. Keeping it hashed through the delete
notification blocks same-address publication until NETDEV_DOWN has been
delivered. hlist_del_init_rcu() is safe when the earlier hash scan
already removed the address.

This handles a late publisher captured by the list snapshot. The next
change serializes publication with teardown so an add cannot miss both
observations. Both changes are required when backporting the complete fix.

Fixes: 73a8bd74e261 ("ipv6: Revert 'administrative down' address handling changes.")
Cc: stable@vger.kernel.org
Reported-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/20261004135117.GA206930@shredder
Link: https://lore.kernel.org/r/179161099539.434549.2238120015372268173@kernel.org
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261015050651.1841557-2-4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index e4f1c67c6c511..aa033c2cd8a0d 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3933,6 +3933,10 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 		}
 
 		if (!keep) {
+			spin_lock_bh(&net->ipv6.addrconf_hash_lock);
+			hlist_del_init_rcu(&ifa->addr_lst);
+			spin_unlock_bh(&net->ipv6.addrconf_hash_lock);
+
 			write_lock_bh(&idev->lock);
 			list_del_rcu(&ifa->if_list);
 			write_unlock_bh(&idev->lock);
-- 
2.53.0



