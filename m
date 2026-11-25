Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618489;
	b=qyUcja8tYibZ/FeOb3VQXaQbXR/E+jeSExkB3pBSev4b5LCOALbKT/f5OqCLEQ0EwlLq
	 eBiqvvvGJxnR+9X0gjh1zzkZOrxLjvodG/LA1zYlzZ1la4GClzMKKx+EPHsbcuAA3jj93
	 A5e31dKc7VACS/+1y8Wne0Wz9bJ7MJm+VG91XTeE/rbcYHp7Do44idAsr0YpF/GyYtp+1
	 3v5udBTdiA7UIqt6/n596t//GohYMrpCe+1V6hKwl6dIBxHkFg0o6pRkYyqB8boMwnQjE
	 3jNO3IWsbEUUjsjCTNuVZFYntLC7n4/uR3lYmWrkgmD5dkuOrSjzStin4Rpw/oDnPdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=crE/EBZ1YjhfMT/X+z0GGwkkpEA4Wko/hygXZ+gFxqo=;
	b=0JwWm5cXm3CUCJRwtHqo/IVLj+ZvqGIqrwaRhPiBblHmCdalAgCTgHYBmQyEP1o1xR7Z
	 zLS2MUWpBwcOu81PswZnMVCth7i1Lhlcr9YR66oi4P7wQiV74xFMxusbWAuCnz2jjZ2D6
	 xDr5yWKAzftxXqYIjQEdz3MUYfZRx9SWxJBPtHs5+MEpXJdDHA1OkPytS0HAR1iq3zXbV
	 gzmcE6kj1WyhGvR8318CQ32+dyXdfORuuimxwNNpCOKNd9ZGujlLiKPtCELh/yBfotKiA
	 zn51f4OdFd9hSLKu0YKcApUixoP78qcznRVdvUEmT5stOUsAhdqGe2/CTnwg4wFlXIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BxKa//gB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD274606A321;
	Wed, 25 Nov 2026 14:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BxKa//gB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F281F000C4;
	Wed, 25 Nov 2026 14:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618489;
	bh=crE/EBZ1YjhfMT/X+z0GGwkkpEA4Wko/hygXZ+gFxqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BxKa//gBY4d8TFoebxYRvgoeQ1sRGMV3mh32qyqObu8gIMCIjfgP4zeBwGtdvpv4V
	 NbaDTZXCj32noaCK4ij5Q00WWspM+5n3hnaxQX97/556gQrXHFMniS2iq/BxykL/sq
	 bQNkVpaqVLX/zJqkK+U9r+uHM6NAuyd76yIMj/h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0295/1005] net: dsa: b53: restore the NSP IMP port 2 Gbps mode
Date: Wed, 25 Nov 2026 15:27:13 +0100
Message-ID: <20261125143828.645655674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 41af38324341df9d769641d6485abb67fd5209ed ]

The Northstar Plus IMP port uses the switch's proprietary 2 Gbps mode for
its internal link to the AMAC.  Its fixed-link description reports 1 Gbps,
so applying that speed clears PORT_OVERRIDE_SPEED_2000M and leaves the two
ends of the internal link configured at different speeds.

Force the 2 Gbps mode and flow control for BCM5301x and NSP CPU ports.  The
mismatch caused switch output queue discards on both copper and SerDes
ports, with one discard for every TCP retransmission.  With both ends
restored to their high-speed modes, iperf3 reports no retransmissions.

Fixes: b6a8a5477fe9 ("net: dsa: b53: fix resetting speed and pause on forced link")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261029211540.4123250-3-florian.fainelli@broadcom.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index e54f6d4d1f7bb..a2a5754c413c6 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1720,9 +1720,15 @@ static void b53_phylink_mac_link_up(struct phylink_config *config,
 	}
 
 	if (mode == MLO_AN_FIXED) {
-		/* Force flow control on BCM5301x's CPU port */
-		if (is5301x(dev) && dsa_is_cpu_port(ds, port))
-			tx_pause = rx_pause = true;
+		/* Force flow control and 2Gbits/sec on BCM5301x and NSP CPU
+		 * ports
+		 */
+		if ((is5301x(dev) || dev->chip_id == BCM58XX_DEVICE_ID) &&
+		    dsa_is_cpu_port(ds, port)) {
+			tx_pause = true;
+			rx_pause = true;
+			speed = 2000;
+		}
 
 		b53_force_port_config(dev, port, speed, duplex,
 				      tx_pause, rx_pause);
-- 
2.53.0



