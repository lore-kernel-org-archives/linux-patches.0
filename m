Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061447;
	b=e5fLph9qf8BKdwVGxmL3hnPAfGXyFdcgc0E5pwNFzan8I8u8tmPLXBKfrqBU5KIG2QcT
	 biiSAULm/Qz07ONSUpEijcDtffNOSChyEXaWEdhPXBiPy06jJaAd5pXet9mpPDz8uAeBZ
	 y6xCpBe/IuM0vE/0OA0ItIxi9LKPKMVAQxcky+ooahpSsNzVQLrkdo746hSMfwXQFChrR
	 ddg4YIdGvB9P9wK7thxGoKkiVxcSYUV5JfbYaiJyyV+haO/spAe+jhXN0+NSJlrEZd3bq
	 uNQOJoIj9Gl/LrY7NA8bvau3JDteUO7Mlp4haSFy94jXvmakdR+e8hWbmI91f/4GWPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uoORuVwO5GTtkJkEo1uZlgac7Cbn29Mi/ubeCbJzUJk=;
	b=aMjvM/hhRjPb8wqLIm5V1DRkmqBkQHQX8b8voHdEvO8VB00baLQBenX3xKI0qjUAMePs
	 vi4WuxiFog8i96i/urPSC4aU4B+lLC5Z+M3DdWcPctfxMAWirmTQMAwgp1WMwtpQD3rmF
	 SEKku0sf38Rdz5YQmbuyJ4cyPuCA3OAAAUJw26OUf6gA5Hr4pizlnPIeiJ9cxIngVZ8eR
	 EQt6tMxY7gRpZjdKkn26lwgtx1mmAUGiWrQrM+fBgcN/zMKUvpGqlmmYIi+TxRyCT+NY5
	 QyU7AKe3A1u1VlAVC0SOUAmz+kgFHgWLlG+MFHd8fUnjS/D1ns/sxecL++SiGOIVKQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u0e/I69z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA6E606A333;
	Sat,  7 Nov 2026 14:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u0e/I69z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6791F0089F;
	Sat,  7 Nov 2026 14:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061447;
	bh=uoORuVwO5GTtkJkEo1uZlgac7Cbn29Mi/ubeCbJzUJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u0e/I69zwB0NfG7yGxUErasLE3U7mU5sUO+9x6/uAKXTZT7jThfj0RyWVxhu/VNk7
	 W74kXqBTNRIAwUXz6DuLBuv/8I8gAl3tadYsn8d5uLESVkEVaTWVYlXTTGH+6qx84o
	 OrBeDzQj27Vo7nbih2n8qTZ9hwU5IVNLO3SqR2yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0554/1536] net: team: free skb when broadcast has no txable port
Date: Sat,  7 Nov 2026 08:42:50 -0500
Message-ID: <20261107135013.155964355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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



