Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064114;
	b=UINyV24bdCk07KbqYiKEoshiyEn9W1E2vbAeh7okXfak1xGEe68xzoJrI7yR8uSAKxcm
	 DsS0RfuB7uV0UvIX4xejBZJRTAW/Xj616wdRlkFfS3bXKzE8Jkvnun+V8V59E+IN4+e1z
	 lexQu9nAz5SKz3x4buwcHZQKoGQS5X+6lWX+fIiFBQCK+uLqIhhRPicsbqaf4nBJD3ozE
	 UXOgMOiTpQUFSEfUuyVKdN9cvqyLTqnVXhIuzpp9ddZF6kFGA3Rzv4EwwjaVHOr4LD1TA
	 3sNpyow5LAvwyH78LosKV2j3jwSwdceoZK42jSJFI+od6a1BdbD+JM9R31g9WCDaGOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ufqAdyMaI2Cp1ShCnWeJR3xkSvK1ohTgxX7q7n8DoG4=;
	b=3MFiU2lsWzyyd0EG9xMutFYgFlYK7BkTUqWf9HGbWPq7r7iwg9ENGYmwMkqt1vLw3uDG
	 nvEOMVJEFKeZNaNTpfztGdKbkMbtYL/z9GTuV2qiS7m5aXXOGhfZZ1HgbTS/Mm9k6J+Q/
	 vuoNKzKqxHrztge3ggxqCUEk4RSQDdlXWZqtRlwwRMPaSRzK3HYVlEm4A/aj0t6Ao1Et/
	 RfxLvmPck4MD+UKtbpCZ78anXK/XjnuLrguqSCr4VS7R+ITms1XGNDHPLBTsrfmhIXywA
	 mp+ADBF2nMQu57yDDQs+wtQkt5ybCn47ABUoJEwb50aFlA98bKDU4Ct0DEpyb2sa0LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EdztkU5c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44C3606A33E;
	Sat,  7 Nov 2026 15:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EdztkU5c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E811F0089F;
	Sat,  7 Nov 2026 15:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064113;
	bh=ufqAdyMaI2Cp1ShCnWeJR3xkSvK1ohTgxX7q7n8DoG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EdztkU5cSMmEUXR97GtLuQ4KnKAqKmZTazViWx0ysZmiROamCIY5hqSBLLVzhqO77
	 JlE42HSdJVVtAWc0iPLzcL0fEdjYQgzAG/zbHHZVFn3rYeSjWE459SrjzCm5HpI0QY
	 KU4mKkPpr3T0bRo8SZ69sDUqlP1T9M+gUMSa4tgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0271/1257] media: atmel-isi: release unregistered video device on remove
Date: Sat,  7 Nov 2026 08:42:47 -0500
Message-ID: <20261107134946.972745662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index a05a744cbb756..6a7e240c5b180 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -1121,10 +1121,13 @@ static void isi_graph_notify_unbind(struct v4l2_async_notifier *notifier,
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
@@ -1323,6 +1326,8 @@ static void atmel_isi_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	v4l2_async_nf_unregister(&isi->notifier);
 	v4l2_async_nf_cleanup(&isi->notifier);
+	if (isi->vdev)
+		video_device_release(isi->vdev);
 	v4l2_device_unregister(&isi->v4l2_dev);
 }
 
-- 
2.53.0



