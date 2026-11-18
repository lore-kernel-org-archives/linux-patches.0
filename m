Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054208;
	b=PdFXwcF3oxxScQcNwwFX7+WqfwhbiVqxHkjZrn3y+OpioFVKSwvR9yD5K083FIRW7Ns1
	 raptScj6d69B8X2RNLW+hr5B9pzp3VTrsjopPuWSeGzBA3kZg47PUadmwiGfE9lrpvPzy
	 0HJpfYxfxIyAJNGRTKloIMe8pv5BVFGL1+L0/8kFv6O0d/prj2BifaRcMB5RxF/AKy5pg
	 RRRV5W+2d/kFAuez+3FNN6N3SfZ2aZbs9Zy4I/QksbLHXGfwtKVbSVN0kEaqldl6QO9Uf
	 IlaQo4KXUlV2/nZJMj4wLX2E314BjK4r5MoUli2aU9AnRTyvSV1dAWE9oBZHCuN4Aeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wTdCOYchRLgDkSg81qOvu7VHwVLkTA1DWPVjPxvE+fM=;
	b=HtiBzUDebQNMt2Nfj7oiNM6yTHpLMrFiJHMkYZPsj6udV6SYlX/hbUWaLnx0CYJohjOU
	 lyz1ZV8BWf1UN9widgqjKMgoFYr0L0XYTPjYcx1natoGQLlbprNBkxJj5l+lD4yTh9mEM
	 bVjFD8/r1rjFT+2tNIPHV8uCiB1cnGfn1HEhrUhiXbCpoy4zZrjOwq3LazTEPkz/U23Y1
	 UOdV2QcT+zCHvQgETpW9bFvwblO+pD+jzaZg1m+r9SvvUshC//5CjYaIiCdkjPjw0PlDK
	 DcH1Vwo+aO6M/P9KoFQfhx4CMMgdkf2tp20DrtCeGiShHb8a5Pd5JNmoPc/gOpt7EOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gufozqcv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8442C606A320;
	Thu, 19 Nov 2026 02:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gufozqcv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D604D1F000CA;
	Thu, 19 Nov 2026 02:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054208;
	bh=wTdCOYchRLgDkSg81qOvu7VHwVLkTA1DWPVjPxvE+fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gufozqcv3pIC9wsYaYYMwP0Y3yMqScHmr/44L0Fv+0pe64h7gwuuBdBwzV1DhgoTl
	 wFvLybuAjYKMLrALUp+gg6IcAPb5C7suEpcZBPyCuRXd8k5fpnvVtVzV2Rk6x7CQOA
	 EhYj198MsrydEeDd+XKDlC4SmC2wF4OO/XjhDoYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1192/2214] media: atmel-isi: release unregistered video device on remove
Date: Wed, 18 Nov 2026 15:47:48 +0100
Message-ID: <20261118150059.582181604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: retained the older v4l2_async_notifier_*() calls in the int-returning remove callback ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index 095d80c4f59e7..1f6d28536f726 100644
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
@@ -1329,6 +1332,8 @@ static int atmel_isi_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	v4l2_async_notifier_unregister(&isi->notifier);
 	v4l2_async_notifier_cleanup(&isi->notifier);
+	if (isi->vdev)
+		video_device_release(isi->vdev);
 	v4l2_device_unregister(&isi->v4l2_dev);
 
 	return 0;
-- 
2.53.0



