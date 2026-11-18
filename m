Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049899;
	b=xCeVy84wcBsmWfnRLBALuGetsMGI2BoYP/WzZzSw6xFFCrLFYAx8yT+Pi9qORkU1Ik3y
	 uadm6eczDqeLQ3NssUu6h2zq7S5RB4ujn8hS5CxXpln0p+SiEHyZIIFxnZ1fhSrFAQLwg
	 f117k0cY61Dhv5eD84U7hAAidVt68P7X59qQbdc89QtvqZjLUismrDPCavnWRW4Vz04Lq
	 HnZ4dQlxfm1NSK5J3c8V3Mwyk5ycQfySVcNdKUdoDouheZYWESNw5MuaOyulUufS7WMXt
	 pTEJdTaZ4MAIPMswr24tDEOC46Z+NbSg+fyCDZwfjns0ajPpTExQIeTMO1+so12MXKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/1Py3KKr8lcIlNT5Y/KGdja/x2mmFU5AXRvaiZlNSiM=;
	b=pJ5rnBaNmQT0AN9ODh+vkm5Mdm0MP5NtlvbjUY/KDfwb26sJ0xSHjGP7mqaWDi75FVml
	 8f9p66fvUuuOVRS8Lr9ery+p7WiPJbj12woxMN4hM6k9ktvB5YWGKN4wjLYnKiFmAt6Ps
	 z+6iohgURDM6Z1nylJENruIQ43p1JMPpFnXzwYeBTbwoa3AxfGmVlE+wHp/H9FoTTuKUi
	 tZ3TVt35fn1iYkNHI74Z7Nz3KVe4n44lv+ShSvsTfmwR3cUg5h8oVZyCiYA+njiQMbyMt
	 mRB/JDKMcoJoriDeATJ3/iwimLDawbJgF71cZMArkDSXDiI02wjScNxiFTmDPRsJ6Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m/75KHpb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA46606A320;
	Thu, 19 Nov 2026 00:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m/75KHpb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0CE1F000C6;
	Thu, 19 Nov 2026 00:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049899;
	bh=/1Py3KKr8lcIlNT5Y/KGdja/x2mmFU5AXRvaiZlNSiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/75KHpbBVnp67ITP6M22HOf0fZInY0GdePf/GI8FgrrXBf44RxJUsAzEp+dxDhML
	 hztNnb8+4EiHFc1vP+vR2F3taPHAR6rOqbUTwJcV9CXXobDKzGMdNdKeqiCnRZcmtV
	 kO0MgJ5Gd9BSabG5aC6GFkWBnI3yqKLRCjFPl2aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Popplewell <john.popplewell@nmc2.ai>,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2516/2857] IB/IPoIB: Cancel normal flush work on device stop
Date: Wed, 18 Nov 2026 15:59:10 +0100
Message-ID: <20261118150332.133335350@linuxfoundation.org>
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

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 66196a559be5963b1ced18418c876caf9bfb76e6 ]

ipoib_ib_dev_flush_normal() can race with ipoib_stop() because the normal
flush work does not run under RTNL.

Before commit a77a57a1a22a ("IPoIB: Fix deadlock on RTNL in
ipoib_stop()"), ipoib_stop() flushed ipoib_workqueue after clearing
IPOIB_FLAG_ADMIN_UP and before calling ipoib_ib_dev_down(). This ensured
that any in-flight flush work completed before ipoib_ib_dev_down()
performed the final clear of IPOIB_FLAG_OPER_UP.

After that commit removed the workqueue flush to avoid a deadlock with
workqueue tasks taking RTNL, a normal flush can continue running
concurrently with ipoib_stop() after IPOIB_FLAG_ADMIN_UP has been
cleared.

The flush may observe IPOIB_FLAG_ADMIN_UP set and continue running while
ipoib_stop() clears IPOIB_FLAG_ADMIN_UP and brings the device down. The
flush can then call ipoib_ib_dev_up() and set IPOIB_FLAG_OPER_UP again
after the device has already been stopped:

  flush_normal (ipoib_workqueue)    ipoib_stop() (RTNL held)
  ------------------------------    ------------------------
  test_bit(ADMIN_UP) == 1
                                    clear_bit(ADMIN_UP)
                                    ipoib_ib_dev_down()
                                      clear_bit(OPER_UP)
  ipoib_ib_dev_up()
    set_bit(OPER_UP)

This leaves the interface with ADMIN_UP clear and OPER_UP set. During
device removal, ipoib_ndo_uninit() waits in destroy_workqueue() while
holding RTNL, while ipoib_mcast_carrier_on_task() may keep retrying
rtnl_trylock() as long as OPER_UP remains set, resulting in a deadlock.

Cancel the normal flush work from ipoib_stop() after clearing
IPOIB_FLAG_ADMIN_UP and before bringing the device down. A pending normal
flush is canceled, while an already running flush is allowed to finish
before ipoib_ib_dev_down() performs the final transition to OPER_UP
clear.

Only the normal flush needs this synchronization. The heavy flush is
already serialized with ipoib_stop() by RTNL, while the light flush does
not bring the device back up and therefore cannot recreate this race.

Fixes: a77a57a1a22a ("IPoIB: Fix deadlock on RTNL in ipoib_stop()")
Reported-by: John Popplewell <john.popplewell@nmc2.ai>
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20261014-ipoib-cancel-work-v1-1-6c0faac016b8@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 81db89e95fcbd..1c132b08710ae 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -189,6 +189,13 @@ static int ipoib_stop(struct net_device *dev)
 
 	clear_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags);
 
+	/* Normal flush runs without RTNL and may bring the device back
+	 * up. Cancel it before the device down transition.
+	 * Heavy flush is already serialized by RTNL and must not be
+	 * waited on here while RTNL is held.
+	 */
+	cancel_work_sync(&priv->flush_normal);
+
 	netif_stop_queue(dev);
 
 	ipoib_ib_dev_down(dev);
-- 
2.53.0



