Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022901;
	b=K5jf92bYrfvY5JTBcO0Y5MnII7eGma9wjrUxL/xMxdC9r1+IWJ3OAC8sp8wVla2Nduyx
	 Y2XwjBdkxY5K22P7TirBUWIQoFNjnS7jvM6GmnkxcPaCuW65QjLIh31CT9QlI1XvU/7dz
	 i+n0c4vmpIceMJCpYu3L9LnVuWBf//Nl88zf0nBj9sfr34fpz628Yu53nK8Eu0dwvDN1G
	 bDRj3Xq5JgiWcgpxJk3nwmOiHQCiOwDxyB1mE9hPgRhFjpGwy68tMqH2yK7dZvqWM2xfy
	 pEy5y5YiJp1Y7JmrlljFBVLGb60crqbAc1owbpW4rxixsoQdOTVfKGblQZICh6X+h4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XZHuwPGDYx4ZdD3A3pgfqu9WWJMxsWIcYwmpin9FEfM=;
	b=TpLwI5ryf9vdUJWg56KBguKwdlTlXfPMZHUtL2jUiHP9W5EJ/CeXi62XiALvfH4vDQkE
	 yE/E+++uyDbyL6wfV/pbuNqvWC6PLhmYDsE3aZiTIzEJcMSAsQV28D9m3RA5ZyOVWtczm
	 3Yg83+b0QJ+BPihBfzaUoatMnjc3T4Xxdc3JHgSQ3vsp9DBj+4tpSPERTzsCATUXw+ZWA
	 rE7xanQQqhlWJHW7yghV+W1cmo5k1vLtzIHz6AEybtjdFU4LrVNyCic5fWLjLt7HCZBlc
	 PhVlgADzG/9R7lEYJLjW2ScPYc6GISH1mHV+abjjXwUzwucvTpg3nLgs2QPk94h11gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IWT2JQ1/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401EC606DA9B;
	Wed, 18 Nov 2026 17:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IWT2JQ1/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927D21F000CB;
	Wed, 18 Nov 2026 17:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022901;
	bh=XZHuwPGDYx4ZdD3A3pgfqu9WWJMxsWIcYwmpin9FEfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IWT2JQ1/FERi18OHnK6a8MevPqSXeYC+rZj5q1wmkKb4FjVBADyq2uy9i/bCpMGzT
	 pqH7DecAdeRpHtYEbZ5AtKvTKzGX1ySuzBHR1jRS7iDM5kg9utpkPCJ9S9RK5iLBHf
	 fahswuuWglHTXXN4w37lCGO6oaE7ULweo3oT2YKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0176/2151] remoteproc: xlnx: Initialize mailbox work before requesting channels
Date: Wed, 18 Nov 2026 15:31:51 +0100
Message-ID: <20261118150128.144755909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index a238b45bf2f2c..3e4364f35cd02 100644
--- a/drivers/remoteproc/xlnx_r5_remoteproc.c
+++ b/drivers/remoteproc/xlnx_r5_remoteproc.c
@@ -271,6 +271,8 @@ static struct mbox_info *zynqmp_r5_setup_mbox(struct device *cdev)
 	if (!ipi)
 		return NULL;
 
+	INIT_WORK(&ipi->mbox_work, handle_event_notified);
+
 	mbox_cl = &ipi->mbox_cl;
 	mbox_cl->rx_callback = zynqmp_r5_mb_rx_cb;
 	mbox_cl->tx_block = false;
@@ -282,6 +284,7 @@ static struct mbox_info *zynqmp_r5_setup_mbox(struct device *cdev)
 	ipi->tx_chan = mbox_request_channel_byname(mbox_cl, "tx");
 	if (IS_ERR(ipi->tx_chan)) {
 		ipi->tx_chan = NULL;
+		cancel_work_sync(&ipi->mbox_work);
 		kfree(ipi);
 		dev_warn(cdev, "mbox tx channel request failed\n");
 		return NULL;
@@ -292,13 +295,12 @@ static struct mbox_info *zynqmp_r5_setup_mbox(struct device *cdev)
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
 
@@ -317,6 +319,8 @@ static void zynqmp_r5_free_mbox(struct mbox_info *ipi)
 		ipi->rx_chan = NULL;
 	}
 
+	cancel_work_sync(&ipi->mbox_work);
+
 	kfree(ipi);
 }
 
-- 
2.53.0



