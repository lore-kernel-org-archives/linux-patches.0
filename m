Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045127;
	b=N18+MLd5v/+tn4b01EcAvygyLezk0/rvp93TUH5Uk8IApcMa9gMWtWv72nZ8pBA1uMlD
	 ljODkev5godncQqxlji673noaq4TG1wh3dhcdvfmTenWnIGND7xGH8sdjA9WYECgA8qNg
	 d3CpGXxq0bfBJC4h6rolZXP9We2SQbxv4OmEvG6PkU+/AjTOA24wtIKswdywdCaE56927
	 xs2pQ2RxqxptrqWOyemo9MkZBPrLSy9PsLVXHKUfSZJi4BWtD4MkDrvssl604dlWJC6tg
	 WvR24oZzaJX2Mbd6igojka8xgHjI23jSa+07+e78x3WrqFZQM6+FahAS529DfdkPElQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xLhP7OeZ5GORT+PTcYnmrMG9gQ7W5z0OuZ+DYwIZr14=;
	b=pCx1D7V5iJ1QcMhGhLsJXlDI3YqjPKnAmQ4T6FSPOT1MAfhtskLOgWo0zGTtru2BZvfd
	 akTQUo3izyUYgQ+MmbRp8zCzx8Qtqs7uSuBtlxDMu2u5jva/zNjk7flr1YwjP5YA4Ir+Q
	 zBgdszRpekkJeOYMxUkreHuk1kLRhWhByEdBw/8lnhIgbNyTUQshv7Z77reJ/n3MUv031
	 t7YWk4KpgqE8Vykhp0Mvk2PjllXXHTixKssWya6yL/3pzP0KRXRYzU0N7FFB//aOEF6zE
	 tX/tGVRktAS9Xi5EI723BFwn8qfHeEWacSEXdGzkV8geOJHUovSWlAynyhPVNHZPvfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rXJRQZjP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD566606A320;
	Wed, 18 Nov 2026 23:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rXJRQZjP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE491F000C4;
	Wed, 18 Nov 2026 23:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045127;
	bh=xLhP7OeZ5GORT+PTcYnmrMG9gQ7W5z0OuZ+DYwIZr14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rXJRQZjP5DCZufSN4K8iiy5iAoCz0iptPZlXxyJDeZ6jGWt1MEaT7v8IlHac2WQ7Z
	 ZhNSfwLtnwKqA66K90MEUaHYOev5owT/3lfSLB50r3rh1I8E7pufUlN3X2ijdYve4J
	 TgMrWvsHnLsRmwPBm34BskPSKsR9OW+suq17laL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0812/2857] media: atmel-isi: release unregistered video device on remove
Date: Wed, 18 Nov 2026 15:30:46 +0100
Message-ID: <20261118150230.810590911@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index 4d15814e4481c..b9fb7b59bcd2a 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -1124,10 +1124,13 @@ static void isi_graph_notify_unbind(struct v4l2_async_notifier *notifier,
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
@@ -1328,6 +1331,8 @@ static int atmel_isi_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	v4l2_async_nf_unregister(&isi->notifier);
 	v4l2_async_nf_cleanup(&isi->notifier);
+	if (isi->vdev)
+		video_device_release(isi->vdev);
 	v4l2_device_unregister(&isi->v4l2_dev);
 
 	return 0;
-- 
2.53.0



