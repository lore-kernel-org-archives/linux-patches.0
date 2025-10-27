Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AF1322C8A;
	Mon, 27 Oct 2025 19:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593317; cv=none; b=LBp3qsNC+zd/bfbgrHmZyu95qBMOp6OTNezeWnVy/jeSdHTRjAig9QXZD67LJLBYRXVYm0682Ww+qiYrM/4R3LFOo4HCba/LGGY3H0Re5Eky7rfT1P+vSD3GnzARtPW5NqqJOui2nNcOxTRfQ3dprAz/Hc52fEUxoTlvl841y+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593317; c=relaxed/simple;
	bh=gDArKzLF5qfyVkb15xL8ZgrV74YfZ8OXmg9dWjTvI0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GW3zR9cWtCNhWMZZ5lI4E0sRg0MBk8Esq4DjlNbDaer9uspvnIznNiHJyaqT3V5mDnGPK7AfZG4tjq4SJ7MZ/ygvHq4xt1PDJ2QgFCDMfKIzIQ9FKqWUOywqxQSGsyW4nWzjBnwMCd3rSazAOM1L1sZm9phu7IM70ipc6VTdCyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlSk1eKJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlSk1eKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953ABC4CEF1;
	Mon, 27 Oct 2025 19:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593316;
	bh=gDArKzLF5qfyVkb15xL8ZgrV74YfZ8OXmg9dWjTvI0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zlSk1eKJAUy9VIbYL+6UZlAKhOL0klYcmsfyKe8zqylJmmrCTfhLreyj2ZzeiOkVN
	 DhocU/t6SiJLTM1yuxNt9ASBvJTiuM/qHE7Easy27Otl7PF0J6//l/H6klgUQwpugS
	 KrPFQrZ0MI1/treC7Qrjkux8pTL5pikCi8YN3PCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jiri Slaby <jirislaby@kernel.org>,
	Tonghao Zhang <tonghao@bamaicloud.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 096/184] net: bonding: update the slave array for broadcast mode
Date: Mon, 27 Oct 2025 19:36:18 +0100
Message-ID: <20251027183517.490461055@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tonghao Zhang <tonghao@bamaicloud.com>

commit e0caeb24f538c3c9c94f471882ceeb43d9dc2739 upstream.

This patch fixes ce7a381697cb ("net: bonding: add broadcast_neighbor option for 802.3ad").
Before this commit, on the broadcast mode, all devices were traversed using the
bond_for_each_slave_rcu. This patch supports traversing devices by using all_slaves.
Therefore, we need to update the slave array when enslave or release slave.

Fixes: ce7a381697cb ("net: bonding: add broadcast_neighbor option for 802.3ad")
Cc: Simon Horman <horms@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: <stable@vger.kernel.org>
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Tested-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/all/a97e6e1e-81bc-4a79-8352-9e4794b0d2ca@kernel.org/
Signed-off-by: Tonghao Zhang <tonghao@bamaicloud.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Link: https://patch.msgid.link/20251016125136.16568-1-tonghao@bamaicloud.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2385,7 +2385,9 @@ skip_mac_set:
 		unblock_netpoll_tx();
 	}
 
-	if (bond_mode_can_use_xmit_hash(bond))
+	/* broadcast mode uses the all_slaves to loop through slaves. */
+	if (bond_mode_can_use_xmit_hash(bond) ||
+	    BOND_MODE(bond) == BOND_MODE_BROADCAST)
 		bond_update_slave_arr(bond, NULL);
 
 	if (!slave_dev->netdev_ops->ndo_bpf ||
@@ -2561,7 +2563,8 @@ static int __bond_release_one(struct net
 
 	bond_upper_dev_unlink(bond, slave);
 
-	if (bond_mode_can_use_xmit_hash(bond))
+	if (bond_mode_can_use_xmit_hash(bond) ||
+	    BOND_MODE(bond) == BOND_MODE_BROADCAST)
 		bond_update_slave_arr(bond, slave);
 
 	slave_info(bond_dev, slave_dev, "Releasing %s interface\n",


