Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4301DE8BE;
	Tue, 26 Aug 2025 14:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217215; cv=none; b=EpV8nU907skXG8chCfV9hbzDOZ2l7MSu5+SfkapdzJNa/qfMaIl6/9sN5d3QQhEdPfdqkwgQARALMnaSZC+cQR8o4LdeVaKDHYtb474xDl701VpwFpWr9/XoRCTjOp/lP0OzAc0W4p77xIIk/YkjS2+xmPyvnLroK4FI+jff+JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217215; c=relaxed/simple;
	bh=h1Vw24IXINTvTPwC3nA2oEg8s+YW7mj9dgMsdPNb8CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqOSG2NuhU8vKg+PhkPLPaajTUIxNDQK68MJ0TmiF6QuTgpWYD9n8uAfrRhlKT6MYK1qocKExLN5K2UnvRrvqiYb8YEgsq3mvibZroavtZWYowVCOWBYlctzNZqCOQ1kt8BeFm1L0XIl/jh3jxZF4Del+1R3T9nj0aoJIwB1Hsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVefFlFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVefFlFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66266C4CEF1;
	Tue, 26 Aug 2025 14:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217215;
	bh=h1Vw24IXINTvTPwC3nA2oEg8s+YW7mj9dgMsdPNb8CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVefFlFtTUOj3VBQK9XvkiYo66mfXmj61LykUEocGn69QU8GOWHq6iNapR3pITQce
	 SKQWqwpZYGJEWHKfZCOUHeQHsSmYi6dHphC8L8iVzxdx/1rHUzylfmRXHa3I7lweWC
	 2qdrUqQoe39GjU7pO2QeWU+zoPqb1QN2s5eT2vw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/523] net: appletalk: fix kerneldoc warnings
Date: Tue, 26 Aug 2025 13:04:29 +0200
Message-ID: <20250826110926.041815121@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 709565ae14aa2670d6b480be46720856e804af41 ]

net/appletalk/aarp.c:68: warning: Function parameter or member 'dev' not described in 'aarp_entry'
net/appletalk/aarp.c:68: warning: Function parameter or member 'expires_at' not described in 'aarp_entry'
net/appletalk/aarp.c:68: warning: Function parameter or member 'hwaddr' not described in 'aarp_entry'
net/appletalk/aarp.c:68: warning: Function parameter or member 'last_sent' not described in 'aarp_entry'
net/appletalk/aarp.c:68: warning: Function parameter or member 'next' not described in 'aarp_entry'
net/appletalk/aarp.c:68: warning: Function parameter or member 'packet_queue' not described in 'aarp_entry'
net/appletalk/aarp.c:68: warning: Function parameter or member 'status' not described in 'aarp_entry'
net/appletalk/aarp.c:68: warning: Function parameter or member 'target_addr' not described in 'aarp_entry'
net/appletalk/aarp.c:68: warning: Function parameter or member 'xmit_count' not described in 'aarp_entry'
net/appletalk/ddp.c:1422: warning: Function parameter or member 'dev' not described in 'atalk_rcv'
net/appletalk/ddp.c:1422: warning: Function parameter or member 'orig_dev' not described in 'atalk_rcv'
net/appletalk/ddp.c:1422: warning: Function parameter or member 'pt' not described in 'atalk_rcv'
net/appletalk/ddp.c:1422: warning: Function parameter or member 'skb' not described in 'atalk_rcv'

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20201028005527.930388-1-andrew@lunn.ch
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6c4a92d07b08 ("net: appletalk: Fix use-after-free in AARP proxy probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/appletalk/aarp.c | 18 +++++++++---------
 net/appletalk/ddp.c  |  7 ++++---
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/net/appletalk/aarp.c b/net/appletalk/aarp.c
index 45f584171de79..be18af481d7d5 100644
--- a/net/appletalk/aarp.c
+++ b/net/appletalk/aarp.c
@@ -44,15 +44,15 @@ int sysctl_aarp_resolve_time = AARP_RESOLVE_TIME;
 /* Lists of aarp entries */
 /**
  *	struct aarp_entry - AARP entry
- *	@last_sent - Last time we xmitted the aarp request
- *	@packet_queue - Queue of frames wait for resolution
- *	@status - Used for proxy AARP
- *	expires_at - Entry expiry time
- *	target_addr - DDP Address
- *	dev - Device to use
- *	hwaddr - Physical i/f address of target/router
- *	xmit_count - When this hits 10 we give up
- *	next - Next entry in chain
+ *	@last_sent: Last time we xmitted the aarp request
+ *	@packet_queue: Queue of frames wait for resolution
+ *	@status: Used for proxy AARP
+ *	@expires_at: Entry expiry time
+ *	@target_addr: DDP Address
+ *	@dev:  Device to use
+ *	@hwaddr:  Physical i/f address of target/router
+ *	@xmit_count:  When this hits 10 we give up
+ *	@next: Next entry in chain
  */
 struct aarp_entry {
 	/* These first two are only used for unresolved entries */
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index c9edfca153c99..f38b170a51af0 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1408,9 +1408,10 @@ static int atalk_route_packet(struct sk_buff *skb, struct net_device *dev,
 
 /**
  *	atalk_rcv - Receive a packet (in skb) from device dev
- *	@skb - packet received
- *	@dev - network device where the packet comes from
- *	@pt - packet type
+ *	@skb: packet received
+ *	@dev: network device where the packet comes from
+ *	@pt: packet type
+ *	@orig_dev: the original receive net device
  *
  *	Receive a packet (in skb) from device dev. This has come from the SNAP
  *	decoder, and on entry skb->transport_header is the DDP header, skb->len
-- 
2.39.5



