Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044203;
	b=eoP/kAvcCzmhdht69r15WWSeh505GY9GJcvpJ9t1T85AgSilxtUANIQAn332+90um0/y
	 FpjH6bVXF6xMgjPEX/47D+h58+7XHKdQlIF9CXRq0pIeH+b+2FGs8hMWDxjXRlQwgxqbx
	 mw5bTwDzC/S5YpSoQuqFlqKFgLoc7Xc8qM4OHSUL0Fa4Y/q93NfB+QmfeEN+cfR97qz1h
	 7wj70Pwv7ttrK9cyYRYTWfEBHL/0Q0F5GGw5mrxboPZfqjkez76e/MOwJfrqx7MhW+z4H
	 dCdibqdYd9sO0xF8xwArD7l8yuJE9DHL+M/ZidsmLQ64+Ltt3JAi+m1FiOnG2SvO+Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vzc4X4XqJQscV4xFyP8my5rGLnlwWEnBtXB/zpQG7Pg=;
	b=jl/FxdxUTRuX7wYZC/bZbc7A2DrMWw4jWeySBjk1QVA8hiAyKVyZEGhK2lNCrD7SEoQI
	 ccH1HjZNay82gFh91zQC5RlaAi3fII7a5FBTkepy5UUCLVXy0KYpsXdmP6vNRJZFI9QqM
	 C9u2fWMsR3uRsNauz+wuoF8c/Jq5t637+w305jArbXKcyLlk29TJxtdoz0+aEnoHJZzgS
	 /IVMKSP1J81GTwhoLNp4plqEIqhYOMANIfK3KNbbmb4+LDyoI2ypX+I4+TT/GzNyR9LyE
	 wfoB//Ug2P7+A3CPHD+Vz/xfSgpln4lHjv0CkOqq6zmbv8FqKN51LINUDqfrIdV68Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UIFpQbuC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E8B606A31C;
	Wed, 18 Nov 2026 23:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UIFpQbuC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B861F000C4;
	Wed, 18 Nov 2026 23:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044203;
	bh=Vzc4X4XqJQscV4xFyP8my5rGLnlwWEnBtXB/zpQG7Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UIFpQbuCh9oynF8mgrjmIO7xGvnXa0Zjy2uQS0V0eX+flO032K8rChzhyfK+x+V0c
	 bypbhfbq4/u8RgZSLDHDoW910yqMQjT2cy65BVEkcUmPqzplw349YOFrGlJh4U+wus
	 23va8plv9/gDhzbqfoAxT54Y8hFLrcWehWSYcGpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0484/2857] net: team: free skb when broadcast has no txable port
Date: Wed, 18 Nov 2026 15:25:18 +0100
Message-ID: <20261118150218.864474251@linuxfoundation.org>
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
index 313a3e2d68bf6..1c5006cfc191d 100644
--- a/drivers/net/team/team_mode_broadcast.c
+++ b/drivers/net/team/team_mode_broadcast.c
@@ -38,6 +38,8 @@ static bool bc_transmit(struct team *team, struct sk_buff *skb)
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



