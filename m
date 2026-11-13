Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591091;
	b=hEgBWQkQWJZcjOx5fS/gXKp3v0CjnKdXkR4ISkU5otjbBvKreG5hLBVoiOFSAuHfE98t
	 JeZKw1owP1tTdad/VOAJPXWFYGHReKQGmBuiMQwVUo3FIYk5rk1vBVdPN7wEpwfo5cOqy
	 HiJUkhc3fNdnJz6TQWkbGq2fKw1YZYfema5tr7+unQFG3gCp7qOd2uwdFOILUqymdpKHL
	 7bnhKrSWACogPYNiG6TTMqFaCG0YfQCXDD7GI3wA/wRcvwjrIQ8sgDML7eAdmihxJ4g/0
	 SELUWPgiqgr0Z7VPbFeJ9NHp7q/BRTar7HOs3srI2mlRZLOyfQpp0+GXd+UEB5T4gvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vtVLlIuExrPO0Nmz+xKjZrDv+pHV/KXD98hKuv1CZAY=;
	b=p6tMZpi7jh+6XmWKrokkc31ZKeMbjimcc7vr3hMYRNstpSEtQKfGNy+FTX50sGWXx6lK
	 Hi8UcQzB8GcSkISeFoi0PCF66EOoKE4G61N0vIiJImtzvX0pNTf2Jlm9LpBrUHuVmTXZH
	 Rhgx9V+DhEvEWdPsKQDELgVJoBqfEybFKbGpkIAKWq9AOVT920qJhlFHTwT9OqKMa1qr4
	 bY8Gp5uw3t5WsAJMhbZoa8ggg3Ea7yDg5Er52hnzJQBSA66stzIEkzlKR6E0SlvK51Jd5
	 eb/Z8LQoDi6I9JiZX4LMHsS0H/2C8L4rRX/6VA6x1UjiWL0FnIAso5p8CJ/xPgXAjPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cyS8AWJl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C76606B355;
	Fri, 13 Nov 2026 17:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cyS8AWJl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1046C1F000C5;
	Fri, 13 Nov 2026 17:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591091;
	bh=vtVLlIuExrPO0Nmz+xKjZrDv+pHV/KXD98hKuv1CZAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cyS8AWJlOycel6GsP1J0bDakdH727As7xkpoODzSrxmX6wa+c+Z+b9Sd1X1vmyhWm
	 jhVWtirSx8bNWapaZBH18w2Ii1jGxDooq1V/5ohbaQJWgU0XDlPU2UhtVTwN1U/b5/
	 CsqIrlS1PwAeE4I+Z/l1lgwCAvkRvRPP81MZS9bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Xia Yan <yana06070@163.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 243/670] veth: keep carrier off when resizing channels with a down peer
Date: Fri, 13 Nov 2026 10:46:47 -0500
Message-ID: <20261113153820.079989592@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 564bf57bc8979..22387f66bf90d 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1371,9 +1371,10 @@ static int veth_set_channels(struct net_device *dev,
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



