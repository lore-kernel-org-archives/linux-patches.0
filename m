Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063721;
	b=aNuGvD4sf3dTzMPFRQ26WkWYUPAFAOxUG4AesUi2fBbQmR5p2xhAPPxEMYVZBf9AvP2X
	 D26/PID1WG+HEd5lWsOJUFso6mfmPbsApC8vuGL4aRNKynUX64/+gW+tIobSeflDyZv7z
	 XzHvC4w0f3BrbLgh9jNvdvJhsdwje5aJcKtN0DX6WMD1XtuVDbYKQws8b7/u776XTzcn4
	 kSWXhqc1/mafDS7d+6/h2RKZW5Oah4nZ7ldspiQZfWTCNhN0geL3BEn7WwxgUtpxyEBMM
	 cw49Yax/qErTpA5DuLhwr+Zbq+51nApx4d5slvQgzAm7xSlig+hD/oUyauN1tDn1YdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l0YwAkajAHjLQ43vATJ+FCVdKhiMnNXZO4p43/lcKIw=;
	b=sniLB/wxSVbs1NRASxn9dp7y/qkkTLr5K0WSDERxmvg4uE4bBINyXegJjfPvvIXC0WGp
	 bMmEhtlbF139pVARSc/Qhfr3t1V2OtL0jHjZRUXu3IrO0dKoH69SYcpBHjWsx8UHCUmUe
	 JOGlQ5iGS8IstBVkdBysShMN5Lrl7qdsfggtRv/Mf7o1Uo2CIUzp7R2E4O5Wrx1per1SL
	 zKJn+qP5Aoejn7UZUBBEfrK17NmMxK+kOPuxzES5XhYajPuO2dOm5rO1QK+LZvRww6J9B
	 GMm9nvJxEPZCkZXX6bmF2yR+zciQlplelkeQbq92ZX6FKldjLjwaEQZ9/Jj9IBC4A9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uL0EZDgq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D54606A32E;
	Sat,  7 Nov 2026 15:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uL0EZDgq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F8F1F0089F;
	Sat,  7 Nov 2026 15:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063721;
	bh=l0YwAkajAHjLQ43vATJ+FCVdKhiMnNXZO4p43/lcKIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uL0EZDgqxDigdeYabpmETU3XeEOFFbKNjiDPqFYwkYiFre1u2KYebt1cZqqL0a2mS
	 2bcyHqLPxcaytuiKtuh6SKfqsus10G8B5yHn8W1plI/6qmOwMNQ8vQ6PUKaXmXO4Pk
	 A8xBRfEHwqVGzCG9RDAvb5Wg2SllldzGJYSbuf0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 821/869] macvlan: fix passthru promiscuity accounting while down
Date: Sat,  7 Nov 2026 08:58:23 -0500
Message-ID: <20261107134920.820056959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xia Yan <yanxia@cmss.chinamobile.com>

[ Upstream commit b6743653d134c9ef8436e2db1be1ad4c1e0d0091 ]

macvlan_changelink() adjusts the lower device's promiscuity count when
NOPROMISC changes, even if the passthru macvlan is down. The reference
is acquired in macvlan_open() and released in macvlan_stop(), so a down
interface has no reference to change.

Clearing NOPROMISC while down leaves an extra reference after the next
open/stop cycle. Setting it while down can remove a reference held by
another user of the lower device.

Guard the count adjustment with netif_running(dev). Keep storing the
requested flags while down so the next open uses the new setting.

Comparing changelink with open/stop exposed the unmatched count changes;
the same issue was also described in earlier macvlan reviews. A netlink
test on UML reproduced both DOWN cases before the fix and verified the
expected counts afterwards. Repeated flag updates, two open/stop cycles,
deletion and bidirectional small-frame delivery were also checked.

Full x86_64 builds completed with WERROR disabled for allmodconfig, and
WERROR and KASAN disabled for allyesconfig, including the resulting
dependency changes. Neither comparison showed new diagnostics.

Fixes: df8ef8f3aaa6 ("macvlan: add FDB bridge ops and macvlan flags")
Link: https://lore.kernel.org/netdev/179170088566.434549.4699134797461783473@kernel.org/
Link: https://lore.kernel.org/netdev/20261016003009.2692872-1-kuba@kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Xia Yan <yanxia@cmss.chinamobile.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20261022090809.12019-1-yanxia@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 7151ae883136b..c38989009c76f 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1630,7 +1630,8 @@ static int macvlan_changelink(struct net_device *dev,
 	if (data && data[IFLA_MACVLAN_FLAGS]) {
 		__u16 flags = nla_get_u16(data[IFLA_MACVLAN_FLAGS]);
 		bool promisc = (flags ^ vlan->flags) & MACVLAN_FLAG_NOPROMISC;
-		if (macvlan_passthru(vlan->port) && promisc) {
+		if (macvlan_passthru(vlan->port) && promisc &&
+		    netif_running(dev)) {
 			int err;
 
 			if (flags & MACVLAN_FLAG_NOPROMISC)
-- 
2.53.0



