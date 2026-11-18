Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025096;
	b=Lq1hUJSSV5TBpZZWH502HQ/cfK52MXvLUk5mFt7nX7t3jk8Mru11qpUHQNqSplmuL3P+
	 E2hHrjObDwsEIIqpgo9bk5/neIvoLzgGPM4UtYwf0/UXGSLEMQuJVdT1pk2Y0zJsjVf58
	 36NDSt3o2TGhElqZJT1eX/HRbpB0FVNiXKXb1H2ArpihoaadfUVY3M9mpGGUYHhQicUx0
	 LaGB41Qnxe0XHldrAqVV8kMsI3owuF3b7yVpvX3dh8/aVOx+CysleTSVgJO/MuIN7ltXX
	 7FnIEkEQ8lztug/3UCyKmNntoQxqFwXXHRUPdTH4zrkMMP7052SCFGik5Ppn4lEb8pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SFrRHshpC9nJFtkfSEY7mgQZwv3nRuycaNVFkdbtTTg=;
	b=wyr/wdtEs99gag7DhikS4nNDsG3ToaQ6nS01joGIy73q4V0Jx06MPdPsAcioimcYbW5t
	 +y4UlluQ26iSRgliU5X5IixBVWU1vAi/vRQjx7hjpqkCZOw2dRV7j5SJ3pm9K4lljNEoE
	 42i5LYYl6Gxe80LPmcSXt6nnPmg/5um6SEg0FpB23iZaOWYxWjaF6ZXPzvJ+0Lhf7tggB
	 APcXzPk6eCSQ+JMEGbIpfg7HFzJzSJDxtjOqQRcMnh1G0vkxojz6WuA18cicFMXJHE9fN
	 GurWv+SkwoKUqSXA0LI7Wp2RIAKkmxdtjaXGQNi5SiclMUAuAf88QZ7YVfYOsdE/ctg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xknhw6mA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450BD606A31C;
	Wed, 18 Nov 2026 18:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xknhw6mA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C0E1F000C5;
	Wed, 18 Nov 2026 18:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025096;
	bh=SFrRHshpC9nJFtkfSEY7mgQZwv3nRuycaNVFkdbtTTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xknhw6mAcLo4xy1a8R5wHHw2FvWxCq7wmE4MMsjuMp8ZFczqBh0nIT7NQMHwHgLkv
	 vU5ShxnuXRDuaZvRnzKzeketbZXPAs3+5ilM6GTPvDwOj4qpNtZO6nGKd7KdTA8Oy4
	 98CS1LjJAmMlGboH24OFIKgGhMpjmiOetb+LbFys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jasper Wise <jaspwise@amazon.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0931/2151] misc: nsm: mark device ready before registering the hwrng and misc device
Date: Wed, 18 Nov 2026 15:44:26 +0100
Message-ID: <20261118150156.409542086@linuxfoundation.org>
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
index c3b474450d159..ba43946b9e39a 100644
--- a/drivers/misc/nsm.c
+++ b/drivers/misc/nsm.c
@@ -440,6 +440,8 @@ static int nsm_device_probe(struct virtio_device *vdev)
 
 	mutex_init(&nsm->lock);
 
+	virtio_device_ready(vdev);
+
 	/* Register as hwrng provider */
 	nsm->hwrng = (struct hwrng) {
 		.read = nsm_rng_read,
@@ -472,6 +474,7 @@ static int nsm_device_probe(struct virtio_device *vdev)
 err_misc:
 	hwrng_unregister(&nsm->hwrng);
 err_hwrng:
+	virtio_reset_device(vdev);
 	vdev->config->del_vqs(vdev);
 err_init_vq:
 	return rc;
-- 
2.53.0



