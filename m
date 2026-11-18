Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059875;
	b=b90m3MjQO7KTxXxU+akA+LyFZlEV3ZWXN1WIS48TL/I2re/kWyEgglJCSBkDVuXSJxk7
	 47W/XahdA0UKey3KZTOY9W2OhQgTeHtLOAvATgWg3N+NsgiqyJiuoi2zhu+SntP9Ngx7P
	 AnJGTydfoKwjcjGbxqkEH4LCVGJ8w2RUbTrvZgEMVyLtlZ6c41Zmy8U74HcyuIYwuXzT5
	 Tta8h/x7E80/8ecEndT2L6z/zI+RRvlMc/c2XUMHsbcdCXv2HoRe6uxG1jDZ6QnnSRwqe
	 kl+aLKxABY17plWNgSFDO4uKTg47lyHSZQJ9HtcxnUm277f0jXSn9EwZRSLyXKgk0Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JnuIFHVI/0Hp6lEJQMJZJriYQvNfoWSdhvj/tS5L3Wg=;
	b=m0BEjoJIvUx07Yh4eVEvZvyGiFmo7lZ9ckvRWcmKLXmm8Z/XOH8x1O3YjXy8GBANDXtz
	 9Rgg8MX0aMhUthjdjkx+Xv80Zsuy9Ewpm6Y9HIQh8Z1ty+LhoGznCzdbBg+x8kav2Ncrb
	 H7ZXOER4ndWrclVn1Tl+gzcRqoG3F5Bzk+aW+DJivY9aJzY9/n0+N66yxBKY7+DP8uoog
	 210N8nMYhsazMwsxqdj+X8nCpsrklK+dILOsyr1cLUPkwvsV1sdGQiNgKQUjeljxIH0EN
	 J3d5TqhEES9yH+zu2ZMfAZk+75gneXcv7H1vFyClA1CKmvlPtuI0lHkqRZ5dt0v5nEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fjEDtxoQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734B8606A326;
	Thu, 19 Nov 2026 03:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fjEDtxoQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1491F000C4;
	Thu, 19 Nov 2026 03:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059875;
	bh=JnuIFHVI/0Hp6lEJQMJZJriYQvNfoWSdhvj/tS5L3Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fjEDtxoQSqOfYgs4tDsWMksMyj8oIlIwHi0ysgQRhQePldbvjbY/wSIv8x+VWUKeo
	 zXiXg02w1tlFtPmOHVytkTGt7p3S2QVm9AK31a90m/5j/CKxOksjr18hvdwvHuo1PG
	 27rFEyTAICwDm+aIPGBb3DiZ7QXIIsQm1V0afq5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0998/1848] media: atmel-isi: release unregistered video device on remove
Date: Wed, 18 Nov 2026 15:50:36 +0100
Message-ID: <20261118145958.611180180@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit c0a6d78dad3af1def80f04df82bfd70456ec406c ]

atmel_isi_probe() allocates the video device before registering the
V4L2 async notifier. The video device is registered later from the
notifier complete callback once the remote subdevice has been bound.

The remove path relies on the notifier unbind callback to unregister
the video device. However, if the remote subdevice is never bound, or
the complete callback fails before video_register_device() succeeds,
the video device remains unregistered. In that case the unbind path
does not release the object allocated by video_device_alloc(), and the
remove path leaks it.

Only unregister the video device from the unbind callback when it has
actually been registered, and clear the driver pointer afterwards.
After unregistering and cleaning up the notifier, release the video
device directly if the pointer is still present. This covers devices
that were allocated but never registered while avoiding a second
release of successfully registered devices.

This issue was found by manual code inspection.

Fixes: d12c9088c0b2a ("[media] atmel-isi: remove dependency of the soc-camera framework")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
[ sashal: adjusted context for the int-returning atmel_isi_remove() callback using older V4L2 async notifier calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index d74aa73f26bea..925dcb30818fb 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -1111,10 +1111,13 @@ static void isi_graph_notify_unbind(struct v4l2_async_notifier *notifier,
 {
 	struct atmel_isi *isi = notifier_to_isi(notifier);
 
+	if (!video_is_registered(isi->vdev))
+		return;
+
 	dev_dbg(isi->dev, "Removing %s\n", video_device_node_name(isi->vdev));
 
-	/* Checks internally if vdev have been init or not */
 	video_unregister_device(isi->vdev);
+	isi->vdev = NULL;
 }
 
 static int isi_graph_notify_bound(struct v4l2_async_notifier *notifier,
@@ -1335,6 +1338,8 @@ static int atmel_isi_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	v4l2_async_notifier_unregister(&isi->notifier);
 	v4l2_async_notifier_cleanup(&isi->notifier);
+	if (isi->vdev)
+		video_device_release(isi->vdev);
 	v4l2_device_unregister(&isi->v4l2_dev);
 
 	return 0;
-- 
2.53.0



