Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046314;
	b=XptLJjH1dMEkE0gdgNiauYCHCWiagXC/Z4Hh7A01DRmQ1GOSin5pBhwyxWry1iCbTlEW
	 fMZKkAS3ekiQWbr6cvcDfM9DE5snzoRpVGjND2BdpgsfUrPt2ZWUeLOeTg9zRWAy65sXv
	 2Nc8iu05Xiuxi0cJ3qYaVBwR+rTWScIFHkXWy6aTZsZTWJFQN+jpm7TsIqzNr57Zl3MvT
	 mtjnGRLxwgj50BocQF4ULJJ8Lk3U9rlWownnvWYvOzQdWjKTV+hPGqcJAghBOaV4RHb9w
	 PhuoNE1dirhs8coDSbSEdOwiEV6Z+6Eqg1B2y3N6M/fYjhF947a8siNIiHqFghRfDSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Xk2W7BC3y0Dlxa80HLi30dY7zrSvru89Af43sg9Tag=;
	b=2X82daM6KLtTpCn0Ps5xZ2kMxD8V+Kajj9S9xKPrqa+O/OVZlU41XnIwhZw4zXh51WCq
	 +vtJot7qy4ZqaAXAP9puBdc6yHcSf55o3gV8J/xtw9wnKn7qGxUQhuyybnP4xoI0Yi8ZI
	 gGPeDAnhiVlFvcoahsfPGSGbZ5727X6APoGYHKUPYm5PhlXltiLKTcP9hofqqmBzrYqHs
	 d7VCeMiolQbrWrnp9AHBD2tWTRZXWq/2dziYwgeMYYIS8sGlZkVLYq4UG4jF12qzJ3xUm
	 MygkOJ5b95zKhkiLQXVp9qufzB+tAXxfW2pcIHjGlybP2RolFB5LpjKAFb1zn2i9ruQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NoauKbsG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46B0606A320;
	Wed, 18 Nov 2026 23:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NoauKbsG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091E61F000C4;
	Wed, 18 Nov 2026 23:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046314;
	bh=1Xk2W7BC3y0Dlxa80HLi30dY7zrSvru89Af43sg9Tag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NoauKbsGVGA06hUCDFLiw72pzwOJR9IX2JIy96xEn22a4A3wvXtrKIo4P1qOJaNpC
	 +lVeo0Z3+yRG+Q8owJeuJziaK2u6XDE8G6yxEU94Nl2CSwpkpVhntwbuUvsCrgktew
	 pqv2VXaJtAx1Uw+mgqo4/QpO5dZS0oSek3+NH9BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Xia Yan <yana06070@163.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1236/2857] veth: keep carrier off when resizing channels with a down peer
Date: Wed, 18 Nov 2026 15:37:50 +0100
Message-ID: <20261118150246.058279236@linuxfoundation.org>
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
index 2eef96cfd279a..e8064b9253720 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1301,9 +1301,10 @@ static int veth_set_channels(struct net_device *dev,
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



