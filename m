Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030552;
	b=vNDVoc3GoMNi17Je8HSoXRhnBt5HarHnClZ0rt/2kx89NoLi3knAnSlwoRrM4qP6xc49
	 Y5qIrxScfTr/2BVpSpMeM2HnskgpO3oCFEm9P/S/cMXEhACO58iAOmy6sumAJSVTO471o
	 4JgyV/rgWhsbwQuVvXryRGRLTxw6jcwsZH+bLzQurryIZLTn4Fwet59CX+rNSuj2slm0f
	 OpMS7/oNJr6q0Sp5EItj3iiJC4lpmeE0ECv64aHU2ftfg/GDV3aa2iWeIZn+vUuynCjJ8
	 G2T4XU4NFMjLAtjTdzZjxI/Zg8xHYbm0nT8UVv/w1VloxP5Nz/H58Wu39Nnyi6nhqcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d+3A+BjHntEPsMIEVuYeKeT7f9Md8IfTJgGjLK+lnvI=;
	b=pFEDC0rcndf/ajzfLiKx8GQiCaaG5xDi9KhgrZycdpH+nt4G82Jk1excCq/Xc3Jhr0lQ
	 8FGaP0mNXy886TV0J1qtLvV8RTT/QG2dJkadOzVRjLcNWcfkj84hg/jHhTHbs6xIB8otI
	 tNaVAdZ4wFkQ25dI3fhj0H+8lRubLrrPi5lAB0np9nwz0nLxY3BMpNewlMJQzJa7XtgTw
	 8dRW8T+astpLHOhnUytZ1pHs+WdKtKMuZhqS55WlvawUAe9TPbr80j2gwKCkX9fVTF/Zy
	 2RzfY7b7AkfYmTMd6Yj1nPBz5/7Y0gfOIXyTS+O/9MSqD2XEEjNhOyFDij3qhqxe3Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ROENRwBA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08580606C733;
	Wed, 18 Nov 2026 19:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ROENRwBA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6111F000C7;
	Wed, 18 Nov 2026 19:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030551;
	bh=d+3A+BjHntEPsMIEVuYeKeT7f9Md8IfTJgGjLK+lnvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ROENRwBAZWrWHuaElJ2nRFZqzoRZrTaOs3MWxgBbpeBvXKCq5VQXW98aoyFvCy/uI
	 XoXPFTr3YNI5BxU8+033uZN5ZEyePnNppLUPVIHtYVkGbGx0XIWJtPryzq145Fkkkg
	 6IOBSb3FH6cC5RMrdov4ez5Y91mxauAcrZXkbLQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jasper Wise <jaspwise@amazon.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0738/1756] misc: nsm: mark device ready before registering the hwrng and misc device
Date: Wed, 18 Nov 2026 15:47:45 +0100
Message-ID: <20261118150039.007205319@linuxfoundation.org>
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



