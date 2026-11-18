Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061738;
	b=InnrtGscNWfoyoCY4xch5hRH7zTV3CCUTXs6A4cSTEsXtI4YaHk6fyE3Lyb9RFyc1QrT
	 4pY1gK5kFUfRNfN9vYL4tg3CWGPc9C8ROZ2v4BjxILH4sRjJ3AHNB6qgmeXYww7wwt0Ut
	 ufSdwmNEYLjGVJPtFP6kHIwvIwUmTGWg8YJ+YkG024WfktX6QGFAdvT86AsjrYZzyPRaw
	 BX5Fw9/yg6IaaM4bxvPM5nwM1uWghYjpcNIEyr1GIpZlahdfjmuo867NEn/bnu1vFvZAD
	 eIVxLzG0FVw+cFFmDMD/3Htslu9YDS4WZhjbW8J4eGby80aYvPnUgak4tc3OndGYnjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8VzhVBEZSaOJvLbUHco3UVr6o9Pnq+J1If7C9vRGLAQ=;
	b=tkpltqUmIRF7Ui9EZYH4t2ErPJym+wJM/xpxb5wj/a2ey6AA1k7BGM4Qy1nlnYiC7KNR
	 l5po5DdEPpe4JGz2Fm/Od7YV+wnsB3LvcOdZfII/f8qMe6dHhqgu8KZDwlcm88K7hVP/I
	 oORP/X2lQlWOtv4RGsrxck0aoXuOCwPrxbEp+RWX1folK0sTsKpujBQaMiL+A9n9e8h5A
	 DCG+0ZMrgz1Z/CqlC9Dmh7h0OCj+oX5xqtwJwjL8ZnPHZaHhHbsRBFA9BIQoztIUfmXh2
	 yW0nETlOzzO7E9G8aYJm7IuTQQX9oL6OACBUNSLc0pydl2Eg06LG1B4g5gj3ZgpSUhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QZbW3HoZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB6E606A326;
	Thu, 19 Nov 2026 04:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QZbW3HoZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4841F000C4;
	Thu, 19 Nov 2026 04:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061738;
	bh=8VzhVBEZSaOJvLbUHco3UVr6o9Pnq+J1If7C9vRGLAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZbW3HoZH6+9q4xMrBDOQI12qKs0YThtiUBXbeLq/NtfSx7k3wdZ+WNKLPlkPlQvl
	 MMKS9ukJBXibpP18zj3vGrmNnO0TiZht0c5KO5hNPDyQmgnuGwcV5LtmuSQMEtHvIC
	 9iJGgngKyJrcywCP9y5po9q5lD4//lwLnskWWFUo=
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
Subject: [PATCH 5.10 1660/1848] IB/IPoIB: Cancel normal flush work on device stop
Date: Wed, 18 Nov 2026 16:01:38 +0100
Message-ID: <20261118150029.274550721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6e61c256bb746..cebf84039f9ac 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -186,6 +186,13 @@ static int ipoib_stop(struct net_device *dev)
 
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



