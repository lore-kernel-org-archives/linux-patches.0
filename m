Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034912;
	b=Wu4rUB/mVjoAOlKCGXbQNVcGSEeeaMwPOTFO/CYV/em08Q4fFBpwo56ffN9fuOFl3yr4
	 dqh1wNz0NPqSkQ/vb/gJvi2PJuoyiOR6QYKjI1xluAzQClelTozJ3nyHdTyk2f+CFvn+G
	 zBCk0w80iqA/UPuT43wdTJGUusQKg15JOtFtEeFv4bV5tZoVCN4quoL9KC+019PYhmNs3
	 1KHv8w4zIkRK8vYwXcBi/xGAwfKm0vOSec5wQMJsj3gXhv69FeybBb1Ehy/YPk32Fuuq8
	 E+Y4w0bAvBepVoy7ef2I2PtxV4gzT5neHuVxNioWi9eAdAu5dufGlQZNXxJF8Apy8YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lp3b39vfODmlYVchUVvz9oCdfPC0YF3nXjIOwfwklfQ=;
	b=2q2l/cvtxhtADY5xruiRh9qbvfZRJ+yD/Krwa5C00yfOb+/RqE/tYgc3e8CgOYK0DC8p
	 DL80H/1eGZnhAU5I+a/XAIwKVZ24Jc6ToZFloqxkK0qC+pyoUKQN+uxGoEbijs7wJd3ma
	 6ZdrHvlO0/ssJYGmNEOAjoD11/yKHbqQ94yBgBPoygRlkQHmb/AwLlw7z4c5iTEhAFnDH
	 1nNaYZXLdMCa6nDWXFanxGuXxIjgXtua5F/YX9eDI9b7ImLNKLiG/4zeF3/194mYyaS0P
	 /ggdclarIPeS9j2+z0/znUltzpam6nGRwRBJz6W7FqlO3vBLU7d+mTKpTh5R8iKO9Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="A/WX3T/Q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E0E606A31C;
	Wed, 18 Nov 2026 20:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A/WX3T/Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957451F000C4;
	Wed, 18 Nov 2026 20:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034912;
	bh=lp3b39vfODmlYVchUVvz9oCdfPC0YF3nXjIOwfwklfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/WX3T/QUZPyfdHa5S1WKUIWEWOpNTN2TRdyxeecZD6rfJhikTOH1W3x5FF5ADsnF
	 k9aAzBdVWEpnpx6/C5PtDnw8lWCky24jFyYjjGbVOgOtWZNiLnpqecTo3lxOWDtkwv
	 cpVHTC0yzwy2UmyNW99pSsQDU/RQ7BjZK9WkqrGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0535/3318] net: team: free skb when broadcast has no txable port
Date: Wed, 18 Nov 2026 15:19:17 +0100
Message-ID: <20261118150333.294683331@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 489114c9ecae44e523361a4b3e610ee5ebd9189c ]

bc_transmit() sends the original skb through the last txable port.
When no port is txable, it returns false without consuming the skb, but
team_xmit() still returns NETDEV_TX_OK. AF_PACKET sends then retain the
skb and its socket write-memory charge.

A TX-enabled, link-down port keeps the broadcast transmit op installed.
Carrier can stay up through a second link-up, TX-disabled port or be
forced on by userspace. Free the original skb on the no-port path while
leaving the existing drop accounting intact.

Discovered by Sashiko during review of previous commit.

Cc: stable@vger.kernel.org
Fixes: 5fc889911a99 ("team: add broadcast mode")
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20261001182326.572045-3-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team_mode_broadcast.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/team/team_mode_broadcast.c b/drivers/net/team/team_mode_broadcast.c
index 61d7d79f0c363..69dc25a5847a1 100644
--- a/drivers/net/team/team_mode_broadcast.c
+++ b/drivers/net/team/team_mode_broadcast.c
@@ -37,6 +37,8 @@ static bool bc_transmit(struct team *team, struct sk_buff *skb)
 		ret = !team_dev_queue_xmit(team, last, skb);
 		if (!sum_ret)
 			sum_ret = ret;
+	} else {
+		dev_kfree_skb_any(skb);
 	}
 	return sum_ret;
 }
-- 
2.53.0



