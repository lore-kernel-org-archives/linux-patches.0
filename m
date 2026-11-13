Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585524;
	b=DeFtZ8u9boRAnYQor+ogD97sq7Rn8zG0bIaJbvRDwPa+vLcGO8L3akq+dvQyso1IIxtK
	 5xfGLIOrz3zeIPHL6xVr/zqomFuv60qBRT6AB+OvA3dyOzNeEq3zweZzxrrDOyZx4v4CS
	 uy/4ZA/YPFFUVFGbfMUDenuuVTfLB8/5YLYD3WNP4LOTyw2wCWTgZJY7NJQp+6NOZZ44Y
	 N/maxUCyo/3oBm8JR/wzwBbwmS1VQdHRjJOYbdW7mSL96ADY+JgEiufLO4wsrs8XiNcS3
	 TYnnYfoh2wP8suVSeyZBb5+sB5iOi59SacM5PJiEkdBBWrmuz0+B6eaUiESm5Ll/e2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A4MA/GyEIpY+tNIzjHFGGqKwcGCt2ds8o2nBDZ3QNcI=;
	b=AIYzWv6cAW3qx7quCpoSWeaFSBOIzJdOMg225vfn+vhZEHMtsBcLWXWvOuiAjzPAPPLu
	 ZbwFx3TRWBzM5THFi2yBhaLBj1YjDpHyU/8uVEwHnV9ZcsfC6BLPp1fwHYnuziHllCMII
	 WHUNKuk5+DZ1YEeyu/sujQDOOopaLbYrhbT1FgXbRmz8WBXqxmZjHyBSLCxASprMP+vjL
	 6QU+LpSdmBy4WMBG/2Bgf5POlLTU57uU2R0KNeFmxzyhbbZfw6ZnuvW0AXw22RKCayI5V
	 QqPw/QVogC/LZlNyClrQAzf/wW8LYNEs1w++eks0uOxWQouznGzNm5qnEvX20lR8OkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nWSTJqrQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB44D606A885;
	Fri, 13 Nov 2026 15:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nWSTJqrQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5863C1F000C6;
	Fri, 13 Nov 2026 15:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585524;
	bh=A4MA/GyEIpY+tNIzjHFGGqKwcGCt2ds8o2nBDZ3QNcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nWSTJqrQy1pawi7YwTHjBxS1XsomNPccTjloQlLsHbIDYPferrmWAO1IdF9rOXJno
	 6wKaTT6pHNr7zgOzyOCSh9mUA8Kv/hfgp1idyj2J1/2lsSGDIm5vsgsjc94jAbTiS7
	 4XbbogJdPp74/IgNbFiGFV0nTZZfB/F/jHEqctYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Xia Yan <yana06070@163.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 167/507] veth: keep carrier off when resizing channels with a down peer
Date: Fri, 13 Nov 2026 10:47:51 -0500
Message-ID: <20261113153800.139745114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Xia Yan <yana06070@163.com>

[ Upstream commit 2d02191779345b13de91048db441191b20264d16 ]

veth_set_channels() temporarily turns carrier off while reconfiguring a
running interface. It then turns carrier on for both ends without
checking whether the peer is administratively up. If only one end is up,
changing its channel counts therefore reports LOWER_UP even though the
peer remains down.

For example, after creating a pair with two RX and TX queues per end:

  ip link set vca up
  ethtool -L vca rx 1 tx 1

vca incorrectly reports LOWER_UP while vcb is still down.

Only restore carrier when the peer has IFF_UP, matching veth_open().
The local interface is already known to be running at this point.

Found during LLM-assisted source review and reproduced with a veth pair
in network namespaces, without kernel instrumentation or error injection.
The companion veth.sh test reproduces the two mixed up/down failures
before the fix and passes after it.

Fixes: 4752eeb3d891 ("veth: implement support for set_channel ethtool op")
Cc: stable@vger.kernel.org
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Signed-off-by: Xia Yan <yana06070@163.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20261029024259.3700-1-yana06070@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 7db389ae866dd..c1859ffcdaf1a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1372,9 +1372,10 @@ static int veth_set_channels(struct net_device *dev,
 		 * to identify the range we have to disable
 		 */
 		veth_disable_range_safe(dev, new_rx_count, old_rx_count);
-		netif_carrier_on(dev);
-		if (peer)
+		if (peer && (peer->flags & IFF_UP)) {
+			netif_carrier_on(dev);
 			netif_carrier_on(peer);
+		}
 	}
 
 	/* update XDP supported features */
-- 
2.53.0



