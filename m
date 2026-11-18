Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018132;
	b=B06QDkjLv0PmhnM1KgBaAiLbD+Qw91Ivucmoqer4yXbfdk8Q7dTBqLPqjJkx6sj6KjVi
	 3iDdJwnAIVrCOOYKJRhxR4pGWgzT2FHLRq/H5DHtl2+Mmpe43iabmDqUMI+M4otTCE+XS
	 dXelfIh88QWLaEoycRmdImKvZeaCvZx52w/5AkfUXmuPbBGmgxcDjBuVrXoo7BuyTU8X1
	 FudomexRHvAQq2/0NlK7piF0HBbnmduVxVYnYmL2d1T9uUosw7CeCvPvPsAYaxJql1o5k
	 u8oYXDQtFebuuhwemsv8W71rcQJTK80ICFcj5U1PIT+4OTxbXKnaop9BWJSTtnAv7RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0DbTNAeQqayb34d3ejkNTA/SFnxHll8cZ22eSzm6Ei4=;
	b=pCuVlIAOC9BGby3uXbrBqq7Q246dY5hBDbh1iK20haQbFsMgw5Sw8OBNrdPPwbuN7tLA
	 nJsBjSjEBiYicg91tCEiA7jB5qdM/xZpyPJQA04b08MmY0vW6YHTuGpUQgILeHNcI5UyN
	 hD6txBu/kxIHKNdcU8Va1Tcky/Wh5cV/txs5pkrIOzvOZXlC2ZqCidTewYz2O2phQvNX0
	 69cx2vo+MToPGfNj+0yxK6sdQU3kkj9/JGsTCvG1qv0BGbmFHCQRFH5Kj3bL9tRzLzc/9
	 ksOZCs+Wg0gdmQ+fsqa1Mhs/1pVq+uvo06ttOtE12AnEzs1aQtgWqrVwY0m2yp0ow7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZqF6tYv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDB7606A31C;
	Wed, 18 Nov 2026 16:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZqF6tYv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A3A1F000C4;
	Wed, 18 Nov 2026 16:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018132;
	bh=0DbTNAeQqayb34d3ejkNTA/SFnxHll8cZ22eSzm6Ei4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZqF6tYvVA3u47DzzjTfSma9NouvjVqOU8lELapEhJeCsNe5HU/wBbo2res0e1DrD
	 nAGRoualu137o36dFng+1Ha6T+YBRc1ZoSWqlf6MjMkoJyD/qiwrUjFjbXAmjxgYTk
	 v6TU0pBTdMAVhFUCuTJlE8T2pZM7qfbS+P3TpUDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jasper Wise <jaspwise@amazon.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1117/2651] misc: nsm: mark device ready before registering the hwrng and misc device
Date: Wed, 18 Nov 2026 15:39:17 +0100
Message-ID: <20261118150328.221005388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Jasper Wise <jaspwise@amazon.co.uk>

[ Upstream commit e15596e84c818a2b727d2a7cf742a29331e44c43 ]

nsm_device_probe() registers an hwrng provider and /dev/nsm.
hwrng_register() can make this the current RNG, and the hwrng fill kthread
finds it through the RCU-protected get_current_rng() rather than under the
rng_mutex that hwrng_register() holds, so it can be in nsm_rng_read()
offering buffers and kicking the queue before probe has returned.

The driver never calls virtio_device_ready(), so DRIVER_OK is set on its
behalf by virtio_dev_probe(), only once probe has returned. The virtio
spec is explicit about that ordering in 3.1 Device Initialization:
  |  The driver MUST NOT send any buffer available notifications to the
  |  device before setting DRIVER_OK.

A device that waits for DRIVER_OK before servicing the queue therefore
leaves that read unanswered.

Set DRIVER_OK once the virtqueue exists and before either interface is
registered, so that the queue is usable by the time anything that can reach
it is published; commit f5866db64f34 ("virtio_console: enable VQs early")
and commit 1d774589f924 ("i2c: virtio: mark device ready before registering
the adapter") do the same for the same reason. The err_hwrng and err_misc
paths then unwind a device that is live, so reset it before deleting the
virtqueue - the core only adds VIRTIO_CONFIG_S_FAILED to the status when
probe fails, it does not reset.

Fixes: b9873755a6c8 ("misc: Add Nitro Secure Module driver")
Signed-off-by: Jasper Wise <jaspwise@amazon.co.uk>
Link: https://patch.msgid.link/20260813083752.581981-1-jaspwise@amazon.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/nsm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/misc/nsm.c b/drivers/misc/nsm.c
index a3a9f9bfc6b71..f1bdde2b77e13 100644
--- a/drivers/misc/nsm.c
+++ b/drivers/misc/nsm.c
@@ -439,6 +439,8 @@ static int nsm_device_probe(struct virtio_device *vdev)
 
 	mutex_init(&nsm->lock);
 
+	virtio_device_ready(vdev);
+
 	/* Register as hwrng provider */
 	nsm->hwrng = (struct hwrng) {
 		.read = nsm_rng_read,
@@ -471,6 +473,7 @@ static int nsm_device_probe(struct virtio_device *vdev)
 err_misc:
 	hwrng_unregister(&nsm->hwrng);
 err_hwrng:
+	virtio_reset_device(vdev);
 	vdev->config->del_vqs(vdev);
 err_init_vq:
 	return rc;
-- 
2.53.0



