Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214802;
	b=1vg1rkCBLU1Obxsb5hq8JWOXMzVKO4Zm2pHc1AJrTLNbESHWfZxDJ3GimLEV3ot8vH38
	 KN0zxwWE/jHKS9Y3tC0Q8FnLeHprDx/Sxn4LhL5cOoUowV9Z5tPpxjmW+7l2W739qF7cb
	 gnAbERDqb3u7mquSqR871ddlJhRJOuh5WWWO5wl9dVKGSou3zlTp84LrKXMd/29aCRa7/
	 BCgoMZs4YnDaV+9jl+ktdEwgv2vFKj3P4YoPbUmT51JLn2ZL1Hgguu5YWoTwLRU+UWWxV
	 jvEIKBGz4se7mpCr09sqdAnpEgyYtECx6HDliaMPRCF+G41PGNZsL5+SaFFQ21uY7Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zec/XScPuhQef/n9OPc17Qnl1/V+aGm29TkB4bxJ7z0=;
	b=QT0vQ6NfqedK4NAOmqRxdmbMOwoMKXjqM6tB2EBbHZiXWuC/jfnJl2HldOOCZqBGUCLz
	 kp6kYXu0TmDDGtSpryNgnuW3iYu7ZPo63zzdrh8qPAaR7Tc2NjYH1Sz1Hs3jZNRxXpGcC
	 dqu7Fhs0Sl9+wCDCqX0WldZm8BLIOCywOF8fjb01RMVGH4BE/UZsN7S7CDgU06XR9xUKp
	 eUrk3Hz6O4VLsQPEqtwUT1JgYMRlvp75sjeGhOM1uITYd4R19atbG7u9IUPf8AKhQccfb
	 3abW7/OCysz0GkNySfEQvx1LLFY/brHW4KWVb4dbbSIg4b3oIu/yIzJnzHzZGqYZ29g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fnXyX0rQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2BA606A335;
	Wed, 28 Oct 2026 19:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fnXyX0rQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731471F01825;
	Wed, 28 Oct 2026 19:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214802;
	bh=zec/XScPuhQef/n9OPc17Qnl1/V+aGm29TkB4bxJ7z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fnXyX0rQ8iyucUiMwwkVBwHzWeMSZh8+JC4mjfdN1J40BPMchTB9aL7WfYIfTd78A
	 khgsQbaUjiGq5w8wCjENzx32eWpNyA0P6wn4NLQcBcI2Kf5SMn7bS/WmcxkwtNbt9Z
	 2Ava3nDBKKMYe3RUdVLzdtSRYMr645oC/gzLRTOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3d8bc31c45e11450f24c@syzkaller.appspotmail.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0950/1887] team: fix header_ops type confusion with non-Ethernet ports
Date: Wed, 28 Oct 2026 17:50:46 +0100
Message-ID: <20261028170521.024358298@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit 425000dbf17373a4ab8be9428f5dc055ef870a56 ]

Similar to commit 950803f72547 ("bonding: fix type confusion in
bond_setup_by_slave()") team has the same class of header_ops type
confusion.

For non-Ethernet ports, team_setup_by_port() copies port_dev->header_ops
directly. When the team device later calls dev_hard_header() or
dev_parse_header(), these callbacks can run with the team net_device
instead of the real lower device, so netdev_priv(dev) is interpreted as
the wrong private type and can crash.

The syzbot report shows a crash in bond_header_create(), but the root
cause is in team: the topology is gre -> bond -> team, and team calls
the inherited header_ops with its own net_device instead of the lower
device, so bond_header_create() receives a team device and interprets
netdev_priv() as bonding private data, causing a type confusion crash.

Fix this by introducing team header_ops wrappers for create/parse,
selecting a team port under RCU, and calling the lower device callbacks
with port->dev, so each callback always sees the correct net_device
context.

Also pass the selected lower device to the lower parse callback, so
recursion is bounded in stacked non-Ethernet topologies and parse
callbacks always run with the correct device context.

Fixes: 1d76efe1577b ("team: add support for non-ethernet devices")
Reported-by: syzbot+3d8bc31c45e11450f24c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69b46af7.050a0220.36eb34.000e.GAE@google.com/T/
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Link: https://patch.msgid.link/20260320072139.134249-2-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team.c | 73 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 874a8b78803c4..386c989641a3e 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2158,6 +2158,76 @@ static const struct ethtool_ops team_ethtool_ops = {
  * rt netlink interface
  ***********************/
 
+/* For tx path we need a linkup && enabled port and for parse any port
+ * suffices.
+ */
+static struct team_port *team_header_port_get_rcu(struct team *team,
+						  bool txable)
+{
+	struct team_port *port;
+
+	list_for_each_entry_rcu(port, &team->port_list, list) {
+		if (!txable || team_port_txable(port))
+			return port;
+	}
+
+	return NULL;
+}
+
+static int team_header_create(struct sk_buff *skb, struct net_device *team_dev,
+			      unsigned short type, const void *daddr,
+			      const void *saddr, unsigned int len)
+{
+	struct team *team = netdev_priv(team_dev);
+	const struct header_ops *port_ops;
+	struct team_port *port;
+	int ret = 0;
+
+	rcu_read_lock();
+	port = team_header_port_get_rcu(team, true);
+	if (port) {
+		port_ops = READ_ONCE(port->dev->header_ops);
+		if (port_ops && port_ops->create)
+			ret = port_ops->create(skb, port->dev,
+					       type, daddr, saddr, len);
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+static int team_header_parse(const struct sk_buff *skb, unsigned char *haddr)
+{
+	const struct net_device *dev = skb->dev;
+	const struct header_ops *port_ops;
+	struct team_port *port;
+	int ret = 0;
+
+	rcu_read_lock();
+	for (;;) {
+		if (!(dev->priv_flags & IFF_TEAM))
+			break;
+		port = team_header_port_get_rcu(netdev_priv(dev), false);
+		if (!port)
+			break;
+		port_ops = READ_ONCE(port->dev->header_ops);
+		if (!port_ops || !port_ops->parse)
+			break;
+		if (port_ops->parse == team_header_parse) {
+			dev = port->dev;
+			continue;
+		}
+		ret = port_ops->parse(skb, haddr);
+		break;
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+static const struct header_ops team_header_ops = {
+	.create		= team_header_create,
+	.parse		= team_header_parse,
+};
+
 static void team_setup_by_port(struct net_device *dev,
 			       struct net_device *port_dev)
 {
@@ -2166,7 +2236,8 @@ static void team_setup_by_port(struct net_device *dev,
 	if (port_dev->type == ARPHRD_ETHER)
 		dev->header_ops	= team->header_ops_cache;
 	else
-		dev->header_ops	= port_dev->header_ops;
+		dev->header_ops	= port_dev->header_ops ?
+				  &team_header_ops : NULL;
 	dev->type = port_dev->type;
 	dev->hard_header_len = port_dev->hard_header_len;
 	dev->needed_headroom = port_dev->needed_headroom;
-- 
2.53.0



