Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062072;
	b=2Qske51i/fqFyCnZ5cDqsZSXljyHp4Ax4dbgpGbw2oqPoARNjva8bYA6e8nH1OnmDaCp
	 MkisglZsSlGONNxaWbNTOdi5MTwbEw4LOIUGOjISewe5B/73PF2D8qn18H2SK94AhFSTB
	 /e+nFOo28QSRYDX396stevC1M0YDY+tpwUXP00Nri+smeVAz0Kq2d86sLtygOUeifBpc1
	 NzeUmf+Nm4OccgKlQnuBXnjesJxqWPVaxo2cARLfF3gDZykShLnrfSNqhfNggoRg8i6EQ
	 fXy6nCd8z3HmyQ4rBSnQP6SeQzmjd9vYYWAPO7cFNULckbR6S+C127crdCu4GoVjYCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5T8qe00kG0jlpHcs0YiR1BotehkfJ1qVhJUYJHOLW14=;
	b=hNfMRTavzjT9LSIhcfTcjhy9wfep6fHPtst/YV5OB9B6iNMoMR4FJFlKn1WgtfVXne8r
	 WrK9/XrOr4iBGrjhLNMqQ7Vo5skyEsqKwnhnaWUv98Wu+8+misguxjlXY+O4I7fhd9gLD
	 zU0mF9jpJdcVDYFtaBab1fJs+4LUhsdqDIfzEHnqxPz7lWx2DVzVc5dGcuah/Cdndro5i
	 6Zlf29JUGbBq5ke2EnsG8lzVkIaOutk2yn7L2GK+L47JMdaEeg4Eujc4xuUmnZReyh3jI
	 LJ+TR/QfYKVGbit23AC8LZ/qq+qh0FiT/Lr42UiOsEcK41t2ag9Ifl6IW0oOftc3vzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u8shnk2I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED65606A33E;
	Sat,  7 Nov 2026 14:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u8shnk2I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B54A1F0089F;
	Sat,  7 Nov 2026 14:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062072;
	bh=5T8qe00kG0jlpHcs0YiR1BotehkfJ1qVhJUYJHOLW14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8shnk2ItSNlaoHtMRCEviGmAxCJAthTOWy0tLhSblCCZWerHmFIlCbkn8fJgqsS1
	 iDM207i2nXIcVMQKD2y+oo5y/NBT/M2BaqPgXQo5VtLRi1crw7cm0J/J9X1ku2rhkN
	 V5HbBQ/DIm9+dQQCAy/vCTkdn83NyHXG/8jncCmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1050/1536] media: atmel-isi: release unregistered video device on remove
Date: Sat,  7 Nov 2026 08:51:06 -0500
Message-ID: <20261107135027.170981853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 5c823d3f9cc0c..7a760d2b24159 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -1127,10 +1127,13 @@ static void isi_graph_notify_unbind(struct v4l2_async_notifier *notifier,
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
@@ -1329,6 +1332,8 @@ static void atmel_isi_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	v4l2_async_nf_unregister(&isi->notifier);
 	v4l2_async_nf_cleanup(&isi->notifier);
+	if (isi->vdev)
+		video_device_release(isi->vdev);
 	v4l2_device_unregister(&isi->v4l2_dev);
 }
 
-- 
2.53.0



