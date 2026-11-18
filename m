Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036165;
	b=cS8vHsCWqthWYoFqJQUzdTWrczfmhFc9tcs2DGhB0YUCVmcy3nohXJffbuYQfGZgXbW4
	 yxPH/ovtfqWJ8rp7r91brNCF1KwZJz26yJbrYt2bbXRZkXN4dpVTTXOfytLLEd7VzHB7e
	 qqKhjZol9/XqyZGwkrfCE5sZG1dQpBAKnwtwol6L6N7JezFCyE4e/bnmPWs0abmy/xuP0
	 UvJ9dDnotgZc2mr+IGgurEBP16mGLk7S43BtcpPsxCLdYvhOkh+zTRgB/3pu8W5Lzmplu
	 P2QuGfX42v/fD7wcIMhiXl+oV3TGgRBNLA1A7Fl8hiI/tNvbAR9yi+yMgfYRmRk1abw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O1vyFEJKmITsUer8DLYc2fSeOflPsKNEeGQkNZLNcQU=;
	b=ONyL3fIXccPzOQ2RstMrlHKUEgqw6vDMzM1F2K8LqOjac8rFkBZnwt3Ps9xhVsslHJQw
	 nIaLvKL+wn55ig6SkKsE8TuzyC7Dc1eDzGDZb1QMdN0vCsRucwVoTNmIpD60qpmLtcljv
	 OzkV/+RaGuD9K9nXxrUQxO6+W8boM2jRzevgoSeH3x1NJm+kPii2Y0OFkei8rxCtKA83V
	 +vDrom4K4cK42ykpvWiF8wFc9YcuUYK5hZCQ9xTlJx23XHmtvEwBYLWoYtdqLkHqI5dxJ
	 gGYStNkLx5B2ufDSFxOwUpLMYIKjTHr5S6QmsWg0+iMf4d474S84ylGL9D8T6C70jRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6PADicP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D29606A31C;
	Wed, 18 Nov 2026 21:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6PADicP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5843A1F000C4;
	Wed, 18 Nov 2026 21:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036164;
	bh=O1vyFEJKmITsUer8DLYc2fSeOflPsKNEeGQkNZLNcQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6PADicP0Z1frHlCFqK9AojiTOoxxHcxGPiyCQKPeruCSZMLLXOcJpRkDpDOOI+6p
	 wuEKF6cAONqpUUY9NTzHAtu6KwOjIXrxsgIdttcrzW5dYNWLnILQTOBWsQOK5z/0Ta
	 VYq7zvqFo9l5YytgXfs9IdERldm+nCtLPUNEU8Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0925/3318] media: atmel-isi: release unregistered video device on remove
Date: Wed, 18 Nov 2026 15:25:47 +0100
Message-ID: <20261118150347.288902196@linuxfoundation.org>
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
index 4046212d48b41..e3c8c616e75a1 100644
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
@@ -1326,6 +1329,8 @@ static void atmel_isi_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	v4l2_async_nf_unregister(&isi->notifier);
 	v4l2_async_nf_cleanup(&isi->notifier);
+	if (isi->vdev)
+		video_device_release(isi->vdev);
 	v4l2_device_unregister(&isi->v4l2_dev);
 }
 
-- 
2.53.0



