Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056432;
	b=Pd9/uRglae6fX+ddiwkv35cXSotdlipdAtE/4vTDJTkMQN0dh1EUVBP5ND6ETfZE5qqu
	 2bC0ubaofmAUGhNMeliYFhN/NLEIqzEIOP37pJKqwaT3E5bqSRVcAx7ucRqOEVtuUokxG
	 rCmKDhynyACFt1Y+70Awg//YIUsb4IY2/IY1BrNgdq9slCgZkPQuDYwAp7ysmmkNb+3L4
	 GBUlq96M5uo12iDZTx+WhWj4NW8skmjZFIm0bVVPz/3+xeMvhVkeSHDnheGlZYMKK3/er
	 j032l4ChlaFsEtg2jc7p71Sr71MS3zJjAO3k2jh36MjePJ/99sred06tfm7haKgeN/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fcg0Rp2oO4nD67z/dW8vh3UJZI93qq+iz6vxFe1wLWw=;
	b=xhzKawI0nhpuOIzRqW/VIQu8KwUeBZST9MxhMbzBeA3HLbVtSXtUVeztEnJde+Jlw0qX
	 sDmaqU24qD3sLCJ55iLtRmGk76Od/aUu2Ojj5yPh98gnKraDOlv7cgdgz658SIEaTWAIV
	 HSFe9tY2TQ+Dg5d+/mVG1O4m0pcR5y23rseBxm7Jlnrprqin+mpYKXwAIiNueDa0zrIsU
	 buB6iqrz09mhQacqdEXxsHvJAAUU8pE/Y+HGsMp3RXgrjPdqhFiU4h8j4YHSvBCz+ERYa
	 +QvayBYHDHndne9czUWvOktU27GRGuXpVDTiiY1YRLCatb/IopFAbA8fr87l2B+EVCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qZZge783;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C350A606A320;
	Thu, 19 Nov 2026 02:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qZZge783
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241431F000C4;
	Thu, 19 Nov 2026 02:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056432;
	bh=Fcg0Rp2oO4nD67z/dW8vh3UJZI93qq+iz6vxFe1wLWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qZZge783tV8aCTjN1F+r7ZPaGpHcoHOmBHKY/9ClIE3aUZnOPjeCo5onSZDy+vdCb
	 dFwjBirlo0AOE8QDQP62Z4Zs7HPFb2rvqHv/kh2fOXf0hNkvuYReKovC4UpjJIa7F+
	 Pqmdbdj1NCmFw9ToWzeQLC8LUi18mw84Jc4H+uLg=
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
Subject: [PATCH 5.15 1949/2214] IB/IPoIB: Cancel normal flush work on device stop
Date: Wed, 18 Nov 2026 16:00:25 +0100
Message-ID: <20261118150128.963135920@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e956513943c60..b275dfd3bf3c8 100644
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



