Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618707;
	b=ZT//xZdkjvrF5r2x/RCAgdB5LYYyS1IunvquUDSpWOePlLUZ2a1vcWZYp/hJDeSe5GIt
	 s8Ky5uRrv9O04W3Jm3aNcuU7jV+kRTrPliOxDvxlNOGUu2xBVAPC5LH9Cz4B/8d0F3m2S
	 A3ykmq8UXhM2YAG9d7znneYF4yE1QKRPnhD/lX/Sf0Ox7wj/ULzYUrc59E+coVCIODcO5
	 9P25hRfBZKGEFgy4gZCu3pQYFb6F4qrI87T+8FvPp03eN8ov2ONxWZ4t7zr/wwafswSsU
	 +btxoK4q+FoEhPmcYL+9E1ZZRyzN73+K9swpvuoGkPWJd8zmqTeiCRbm8obpzADdmxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xWbo+YOswebAp4rNcGaLa3fixRiXroZnJU4vUajiddw=;
	b=IF227w1I1fTxGeTmV2kZ7w3hE/uQw35KFW6gp/YaGQqaEqnwpy/4Mvo4LPIGB6wjy/UK
	 bzGsn7tZXYzxg0cpZ9PaDTCj5XqxBFx01/NQ29+tcaixuUAbwYOrD7Sl8FYbHD8WnpU6D
	 yfOO6lnz6hIRpSnCz1Odio043RRpHCT1WmoVU2Zwd7vh02/SOI7IJu6dvq+66N2XUpUeu
	 Gr9mBGvQCaesKzrpmJ4joxUCP7r3YzI5HkVmkH766KEBFy5cpopVcLGPFVwF1qRgcfpLU
	 kIlsLhaKfgKN5OdWDAOP5y8uV42EVnuEI3NfZsGc3XLs4cKTPaNXXH/Nxl/dz5n2snQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTkz2paL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC141606A321;
	Wed, 25 Nov 2026 14:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTkz2paL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC181F000C4;
	Wed, 25 Nov 2026 14:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618707;
	bh=xWbo+YOswebAp4rNcGaLa3fixRiXroZnJU4vUajiddw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yTkz2paLAfiE6Iy1Yn+YvYgumAlkwksgHBKVCnIYugPCsKigkrDOpvjJ7yI9NijD+
	 s07YwKDfePYV3soljZU/Sp+x48pzdcqZNXm8BorFVz80c3XKYre+N8F5TOGi+11RnV
	 L4Iy/95nLyeVYc1j/qjyEPphcivbkanNqPq8sCvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Stukan <timur.stukan.linux@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0308/1005] bonding: 3ad: dont set BOND_LINK_FAIL on a slave that is not up
Date: Wed, 25 Nov 2026 15:27:26 +0100
Message-ID: <20261125143828.950674635@linuxfoundation.org>
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

From: Timur Stukan <timur.stukan.linux@gmail.com>

[ Upstream commit 9a65b9c2a97594bcaaf393329807653eff895bbf ]

In 802.3ad mode, when bond_update_speed_duplex() fails on NETDEV_UP or
NETDEV_CHANGE, bond_slave_netdev_event() sets the slave link to FAIL if
the slave has ever been up (last_link_up != 0), and to DOWN otherwise,
so that miimon can set it right once speed/duplex are valid.

last_link_up is never cleared, so a slave that is currently DOWN but
was up before is set to FAIL as well. miimon then treats it as a slave
that is still in use and takes it through the full down path again:
the link failure count is incremented, "link status definitely down"
is logged and the 802.3ad port is disabled a second time, although the
slave has not been up since it went down.

Reproduced in 802.3ad mode with miimon=100 by setting a slave down and
up again. On NETDEV_UP the speed is still unknown, so the notifier sets
FAIL, and the next miimon pass sees no carrier and proposes DOWN:

	ip link add bond0 type bond mode 802.3ad miimon 100 lacp_rate 1
	ip link set enp0s3 down
	ip link set enp0s4 down
	ip link set enp0s3 master bond0
	ip link set enp0s4 master bond0
	ip link set enp0s3 up
	ip link set enp0s4 up
	ip link set bond0 up
	# wait for LACP to settle
	ip link set enp0s3 down
	ip link set enp0s3 up

procfs then shows "Link Failure Count: 2" in enp0s3 slave part. Also in
dmesg wrote twice: "link status definitely down, disabling slave".

Fix this by setting FAIL only for a slave that is currently UP and
leaving other states alone. An up slave that loses speed/duplex still
goes through FAIL as before, and DOWN/BACK slaves are left to miimon,
as in the other modes.

Fixes: ea53abfab960 ("bonding/802.3ad: fix link_failure_count tracking")
Signed-off-by: Timur Stukan <timur.stukan.linux@gmail.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20261101145653.63648-1-timur.stukan.linux@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 7019e5d8fdc8e..8212d406f3bc9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3973,18 +3973,13 @@ static int bond_slave_netdev_event(unsigned long event,
 	case NETDEV_CHANGE:
 		/* For 802.3ad mode only:
 		 * Getting invalid Speed/Duplex values here will put slave
-		 * in weird state. Mark it as link-fail if the link was
-		 * previously up or link-down if it hasn't yet come up, and
-		 * let link-monitoring (miimon) set it right when correct
-		 * speeds/duplex are available.
+		 * in weird state. Mark an up slave as link-fail and let
+		 * miimon set it right when correct speed/duplex are available.
 		 */
 		if (bond_update_speed_duplex(slave) &&
-		    BOND_MODE(bond) == BOND_MODE_8023AD) {
-			if (slave->last_link_up)
-				slave->link = BOND_LINK_FAIL;
-			else
-				slave->link = BOND_LINK_DOWN;
-		}
+		    BOND_MODE(bond) == BOND_MODE_8023AD &&
+		    slave->link == BOND_LINK_UP)
+			slave->link = BOND_LINK_FAIL;
 
 		if (BOND_MODE(bond) == BOND_MODE_8023AD)
 			bond_3ad_adapter_speed_duplex_changed(slave);
-- 
2.53.0



