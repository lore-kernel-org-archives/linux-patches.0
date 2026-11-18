Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039200;
	b=Y3A/Yxl/OLlDkqFmmTVguCcsTHMeb00aiVkvEc+zfyKEMwdGvb4A9+sr/zEctCpDR98F
	 G7bo+rFes4YaNBwVNq9TV57vmx7HS9h23bQZY75T8ZDuhqCelYiTDzeccKYgsd9g/s6py
	 ZKQXu6R2m/JXPFAkgNJVUicVbTZTjD0+2rx6hrdA+7cqkqLIuyUYqP7YrRfD3/Rm0Lmwb
	 LuPg5vFCierR/1f+7D79rXZk2JXucq5u1dQgujBmOPQLwPNZnOKfrpSsOjplnHXm9aGNa
	 Cusc3PpZmrzUf59MVJUZXV6lTqZfQS0a2ugEMH0O7Rshtqt9Xs9/yPkiEg4gbmBWHLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lwcMKyxcmwaj3hwyiWvCOQQ3AGFa14fVc/fvVdoMxb4=;
	b=yys1LN6PpdOvr1MZ1RHfCYu60qrlZ9B71Up93WTvAPub2i9gs0ZTLKjLPH7mjVtjhwrw
	 iB64S8QDht3xYUjYAmtCUs+JbpCT3hocLXZcr9szrjrIZp+NRGS2Icf6830VyOqIvK+S3
	 sVo6gZ6MeeumNADjKcBaKtlwUAXoOP1JhWmZcr1xLnQkFdrAnwW5iKviwpQnh+86yAr8n
	 qaI7WVxsA57QOhs1/IEU7pf7kUQoVs/uJceTeaKcCjv1tn5lJ5mYAkrQndvATEvTiDL2f
	 EVBa8B2M/at4LsTxrjgJmLFj+CULyHX9COwZXl7gfn6rWw+FST4x05BFMqn2yi8FRoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CfeDIbdL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC3C606A31C;
	Wed, 18 Nov 2026 22:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CfeDIbdL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3161F000C4;
	Wed, 18 Nov 2026 21:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039199;
	bh=lwcMKyxcmwaj3hwyiWvCOQQ3AGFa14fVc/fvVdoMxb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CfeDIbdL7FGTJ5ITL2bnJ3GnPvdZh8nh3mXyByVt/g/2shfcO4sWN115xEFY49IVo
	 /9kzKjX/0HZmONgiud528FbNAXb8NRDI6RxPdPXf9WTgl/hyCkC5mkUtSLDj7g2tYC
	 6+xAzTHzCPtu4zPRlJQ0AMC/LfD5/k3BsaO6r8zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2016/3318] remoteproc: xlnx: Initialize mailbox work before requesting channels
Date: Wed, 18 Nov 2026 15:43:58 +0100
Message-ID: <20261118150422.518447081@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 5ca7dea7cb2e47f42c15ac7206c5e0cba23d292d ]

zynqmp_r5_setup_mbox() installs zynqmp_r5_mb_rx_cb() as the mailbox RX
callback before requesting the mailbox channels, but initializes
ipi->mbox_work only after both channels have been requested. Once the RX
channel is active, a notification delivered before the late INIT_WORK()
would make the callback queue an uninitialized work item.

Initialize the work item before requesting channels. Also drain the work
before freeing the mailbox state, after the channels have been released so
no new callbacks can queue it. Use the same drain before freeing ipi from
the channel request error paths, since the callback is already published
there as well.

This issue was found by our static analysis tool and then confirmed by
manual review of the mailbox setup sequence. The callback is published
before the channel requests complete, so the work item should be ready
before the mailbox provider can invoke it.

A QEMU PoC modeled a mailbox notification delivered after the RX callback
became reachable but before the delayed INIT_WORK(). DEBUG_OBJECTS reported
queueing an uninitialized work item from the zynqmp_r5_setup_mbox() path.

This is sent as an RFC because the practical trigger depends on the ZynqMP
IPI mailbox provider and firmware delivery timing. If the provider cannot
invoke the RX callback until after setup returns, this is a defensive
lifecycle cleanup rather than a reachable race on current systems.

Fixes: 5dfb28c257b7 ("remoteproc: xilinx: Add mailbox channels for rpmsg")
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://lore.kernel.org/r/20260818101201.1603947-1-runyu.xiao@seu.edu.cn
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/xlnx_r5_remoteproc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/xlnx_r5_remoteproc.c b/drivers/remoteproc/xlnx_r5_remoteproc.c
index 425b905dc86dc..ba7e7b1f4d59c 100644
--- a/drivers/remoteproc/xlnx_r5_remoteproc.c
+++ b/drivers/remoteproc/xlnx_r5_remoteproc.c
@@ -218,6 +218,8 @@ static struct mbox_info *zynqmp_r5_setup_mbox(struct device *cdev)
 	if (!ipi)
 		return NULL;
 
+	INIT_WORK(&ipi->mbox_work, handle_event_notified);
+
 	mbox_cl = &ipi->mbox_cl;
 	mbox_cl->rx_callback = zynqmp_r5_mb_rx_cb;
 	mbox_cl->tx_block = false;
@@ -229,6 +231,7 @@ static struct mbox_info *zynqmp_r5_setup_mbox(struct device *cdev)
 	ipi->tx_chan = mbox_request_channel_byname(mbox_cl, "tx");
 	if (IS_ERR(ipi->tx_chan)) {
 		ipi->tx_chan = NULL;
+		cancel_work_sync(&ipi->mbox_work);
 		kfree(ipi);
 		dev_warn(cdev, "mbox tx channel request failed\n");
 		return NULL;
@@ -239,13 +242,12 @@ static struct mbox_info *zynqmp_r5_setup_mbox(struct device *cdev)
 		mbox_free_channel(ipi->tx_chan);
 		ipi->rx_chan = NULL;
 		ipi->tx_chan = NULL;
+		cancel_work_sync(&ipi->mbox_work);
 		kfree(ipi);
 		dev_warn(cdev, "mbox rx channel request failed\n");
 		return NULL;
 	}
 
-	INIT_WORK(&ipi->mbox_work, handle_event_notified);
-
 	return ipi;
 }
 
@@ -264,6 +266,8 @@ static void zynqmp_r5_free_mbox(struct mbox_info *ipi)
 		ipi->rx_chan = NULL;
 	}
 
+	cancel_work_sync(&ipi->mbox_work);
+
 	kfree(ipi);
 }
 
-- 
2.53.0



