Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFC7217704;
	Sat, 30 May 2026 18:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165244; cv=none; b=OkzNAeetDW56LJtWW5hW1AtBuuQSeFlItjx8yv0IA/yi8Uxj5+Sak4+USvg9w88S6cYYY9R6DKWcoB+7skO+UciWop8/vDbxIk0XaxC1vAofEY50ukrPTn3etRiTObOGdonBw0gbPnWHDdPkKCWvkb9KYC1KHEs0djkyzf/pcwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165244; c=relaxed/simple;
	bh=fUc+WG7wZ6PB1PW5HH4bwXmE6T0GoWanmq49hDxqfFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpQUKs8u5mDs7NOXFEWbGiG1B2xYSR77qasmxaZ3g8cBye3NxJvOr1bhRl8gwk8TcL+YWTxKw6y9xW1ay4v8/sT8WF/fFyety1pLC9JJSyHLIfzO1/TNQZKp9zXr8H1KqyfzghUymMeTQSEfq6QXgTaaWoZT0geHd2AyIC2N+vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0HyQvWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0HyQvWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27781F00898;
	Sat, 30 May 2026 18:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165241;
	bh=Xn+6bKzmT/+KOY3T8g6cZbVcC3PIjdODICYYyXUggmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P0HyQvWqhy5uZs3VXWe9As8IXSv7rahsX9En6j/9ywyaJJPejNyEtXOuHkYAoANSC
	 sFLMifNyikw+Q3zGCmRWrZ0iR9az4rOxpzFQ1DXEpj3Z7qz/S8k5kANn8wjFPFXM67
	 El71405jjyPpC6K+mOWIwGbSAdvGQSqJ5ssQdPkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Li <lipeng321@huawei.com>,
	Guangbin Huang <huangguangbin2@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/589] net: lapbether: remove trailing whitespaces
Date: Sat, 30 May 2026 17:58:22 +0200
Message-ID: <20260530160225.137129581@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Peng Li <lipeng321@huawei.com>

[ Upstream commit 2e350780ae4f2be8a2525929b6c69c2dd9591a20 ]

This patch removes trailing whitespaces.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: b120e4432f9f ("net: lapbether: handle NETDEV_PRE_TYPE_CHANGE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lapbether.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 1276071f93c04..f77cd8b69afe1 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -6,7 +6,7 @@
  *
  *	This is a "pseudo" network driver to allow LAPB over Ethernet.
  *
- *	This driver can use any ethernet destination address, and can be 
+ *	This driver can use any ethernet destination address, and can be
  *	limited to accept frames from one dedicated ethernet card only.
  *
  *	History
@@ -67,7 +67,7 @@ static struct lapbethdev *lapbeth_get_x25_dev(struct net_device *dev)
 	struct lapbethdev *lapbeth;
 
 	list_for_each_entry_rcu(lapbeth, &lapbeth_devices, node, lockdep_rtnl_is_held()) {
-		if (lapbeth->ethdev == dev) 
+		if (lapbeth->ethdev == dev)
 			return lapbeth;
 	}
 	return NULL;
@@ -418,7 +418,7 @@ static int lapbeth_device_event(struct notifier_block *this,
 	case NETDEV_GOING_DOWN:
 		/* ethernet device closes -> close LAPB interface */
 		lapbeth = lapbeth_get_x25_dev(dev);
-		if (lapbeth) 
+		if (lapbeth)
 			dev_close(lapbeth->axdev);
 		break;
 	case NETDEV_UNREGISTER:
-- 
2.53.0



