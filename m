Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032013;
	b=H2AYAZeVmXn8iEMbEtkV6vQC62f1cq3YCJF/kldUCrvamVBdJgVF6va+kkQScDXWsO1Q
	 5MG6dOdlUMaAWvSRDGP55Lo1RdaWfqC+hKXfKzKRgZyXMOYlzzO6tzJA+EWzdARenjxHh
	 pBg25iqtrOamRW+mBVb5Z7ZcJi0dePZ7IMklMgwyofiH16RKtLiTDkfbcaqeUx0dyKa9I
	 4EmEeOM8f6sMSEqXNqvgDr4qXo4InrK3dqnm/ATMMWIAhHdUfm3o40x0KzOv2zkIudiPb
	 bwGpd1i6fWLvwXzJR7RaXU5rQKT6fOVuYUhPyR/JvXwYhqYIM6oO9/gYZYpawDGn3Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PJmFa2Qrd3bogCGuljWS8dF3tYtNooe/gcx36zX61iE=;
	b=QhbJa+BeT5yICpnBkiBTRKstV0ONApFwV5Rs/3aujrh6UvQt5sA9p8uP88YCaBG/utdU
	 FGgiTjsv6mpCl8z+nhjNEOv+KrFEXYcFnoOf5Mj7tarN+ak3Ecv5xzdceKsQix248XJSH
	 +NQh3nzoxQOGg7QoHrMuIgjVF1ZVmKnu56V1tL4QWRoWkWgshyvmWvYjbhrhNmOdCsj/1
	 Ijb5hiYorWQBiX75XKhHBSHI5qJKH56ZatuWdHVdorGNOaX0C2+klhpVrN0GYJkjVhgP+
	 QTHd6wxs4ekRUr6VfG8+/O1KkMM7b6Tf1SSO4taUVMR5wk6cnJAqmNaj7Y9mt/56QCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lLfs3SlZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AC5606A32A;
	Wed, 18 Nov 2026 20:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lLfs3SlZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B301E1F000C4;
	Wed, 18 Nov 2026 20:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032013;
	bh=PJmFa2Qrd3bogCGuljWS8dF3tYtNooe/gcx36zX61iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lLfs3SlZSmbjoGp9CPiuTGsXguXGRomQOWqFPiWLPjH16z/1uMWwUB2SHiduhgpTn
	 245b/TwACBtN3+pLaUJfWKlw+V19u+TcUTtwNrM0ltpJ9Pnb48OTgk9GysLKR1l88J
	 /S/NCq1Dlh+oZfO8GLHoBxkaErWX7IZriOc2KtaU=
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
Subject: [PATCH 6.12 1261/1756] IB/IPoIB: Cancel normal flush work on device stop
Date: Wed, 18 Nov 2026 15:56:28 +0100
Message-ID: <20261118150059.874176465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index bbb00fdc12db3..e76770865e840 100644
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



