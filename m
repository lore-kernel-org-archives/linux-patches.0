Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053296;
	b=1DyYLedflonwjuwwhuzU2J9lnq+gX33IO3XnCjez5L1z47obLiu23pt763ez10ZQn/u8
	 Z4K8TbET7rghRnmrQRKPYkWv0QDASrSlIRQ915tcw3kUe8C1CgteWxrS8CD+f9UUX/XFF
	 njTvKwPp7RPyQ76SjQuNbLv5D0Vn/VJfbv7LOpIchhiwv+mmefemND+Re2o50YtMyHNVo
	 RqsX2qIgbjJsrPck7cs5hIRGvqYQ9LzK5Vadczv4tyAWPl6pf3CmKpZUXSuovYlaGpY0S
	 DRwzwsXf6XJ1ac3zVJOEbu9//xVUnSvNPQuy0q2rX7pUPxTR7tk1UrarGyAlLwX17Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XiID0kWECMGQJuPpYRw+Q4d8K7fXZAE7uVTltxzrxFQ=;
	b=VblA/PJpO6GPjSz5eZy1Vn/XGlMWfBB3nV+vJhjiAR/BNn/nV2jOuqlfWzo/NSUkdv2V
	 dVikS2U2RH5PBqnu4ZmWe7b0c9ivHALSCY63y0tbMsbGxQztIdHBuZEssLWsFV9CB2BqC
	 7FVB+cAbbWlb+cjDkQem3u3E8AIBn56rrhcsoADldZyDWd/WilK/nT5JlQm8H71gZG/KT
	 E56nY1bzGOvgniT7Obl2g8J4Sy022eAlOt3YngBUy7A3u9hWHQosQlemtPQXwUPOel+MA
	 RBUmzfVy+pMrZFMoOxFHqciMRR1OhMVsq2bvmvwXfvaesERZ5wJsx9tNdLEIGQoagiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="QStU/D56";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279D3606A31C;
	Thu, 19 Nov 2026 01:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QStU/D56
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777511F000C4;
	Thu, 19 Nov 2026 01:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053296;
	bh=XiID0kWECMGQJuPpYRw+Q4d8K7fXZAE7uVTltxzrxFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QStU/D56ekTAi8Hh19ALHV0tjYIWCQaxklozjxHJ4X26+zq9CQU0SMhO4fFm4Y7iE
	 GEUYauSb+x8yjNvXYwhTtJzvUSTOcZvw9NmrWuCgoSwBLKzDWgUlvsrvXTswT1whGu
	 p6tkMot7YmxD7TSxHaXfF9qNnniUactd6+PuKs/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Xia Yan <yana06070@163.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0868/2214] veth: keep carrier off when resizing channels with a down peer
Date: Wed, 18 Nov 2026 15:42:24 +0100
Message-ID: <20261118150046.856758516@linuxfoundation.org>
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
index 67fe853b245a7..10a37c8c616f0 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1241,9 +1241,10 @@ static int veth_set_channels(struct net_device *dev,
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
 	return err;
 
-- 
2.53.0



