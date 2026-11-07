Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063183;
	b=RTmNvCNT1YiHBXQONW+Jrn2AjYwtwVAPM4yvpXomGRxZmKanqJkNWRip2aUTDJGv5HJo
	 r0xyHqHkSOoZNW/ALlIuKep9lZWnfR8hcdiNDNi8YPvOyr8KYKanWLivTJjCvwKw6MfUK
	 TCrjTaySpyeWFkKKXmp9YqzIX/AG4V9vktxzBQAr3e8DJ2hlEvXFCVTXA4AATlaU8LmsM
	 Lxd4qJQf3CSc3VIvdqNjOa1sk06V92Y/xXsBxFRC2COPTjjBlcU0yPSt99bBOp+jbWp3T
	 Cm9d+u16b6gi5UiFKPjocdm0jkzZi2Tk6OKw4zqT+XvfM9UTFhWR944pfGfAbcl7srw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GMop+DHyJi9Ufi7+Jgwy4EnI1VjWjw5jfnpQAOYXDCE=;
	b=0336YeYnC5QcyxrCKOWI0DmRZqUjHbP+8+xUfUpdG4tpnRbh2bT8NbCoJjcOCvhm2/+8
	 QZS8Mj+k9GzJjjAYbJIBdA0JMOzhQFSgUZ11yD7MWa3XLQ7a3WPq17AJZabfT3ex/LqQt
	 zfY/WyfC9F7FzpZezgfrNvh4hz99XTJzvJ4MgVFkFRvM2Vx/62FfrgG+ys6HRqhsmMbdB
	 iLLc036jSRSDUHW72GVbNVd1nL7p4AqqF1tXRg+8aYfzdLTp1Ov7fDJ2vGXEsRG+2752a
	 /WvSRYUI5SHzNZXYuKy1UnQAs0YQTgizGsU8hBg1uD1f8tstyRqPBDu6kjkGdfXTjjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="E54/Oniy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C91606A326;
	Sat,  7 Nov 2026 14:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E54/Oniy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B891F0089F;
	Sat,  7 Nov 2026 14:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063182;
	bh=GMop+DHyJi9Ufi7+Jgwy4EnI1VjWjw5jfnpQAOYXDCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E54/Oniyk8XD5r83BVQZS0CYVEBO7scGq7AzgLsFh5O6nZ7hJIaJv6w/1dDMTSF2k
	 n0/ARzhVsvOXqwR+LFNz8sKnRUz9XqyW1gLyUM7b9xiBiaE2IdBSmir1HHnejo3wwc
	 rKde7Zjix5Zyq7uIX/pL4JPef2qOR3ijgtyBy8Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 351/869] media: mediatek: vcodec: destroy core workqueue on remove
Date: Sat,  7 Nov 2026 08:50:33 -0500
Message-ID: <20261107134904.277636134@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit ceb6e96122e1013550f378c738e621a6e82d246b ]

The decoder probe allocates core_workqueue for architectures with a
LAT processor. The probe failure paths destroy the workqueues, but the
remove() function only destroys decode_workqueue.

As a result, removing a decoder on LAT architectures leaves core_workqueue
allocated after the device lifetime has ended.

Destroy core_workqueue during remove for latency-based decoder
architectures, matching the cleanup performed by the probe failure
paths.

This issue was found by manual code inspection.

Fixes: 365e4ba01df4 ("media: mtk-vcodec: Add work queue for core hardware decode")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c b/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c
index 3b81fae9f9135..7fec6b21684f2 100644
--- a/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c
@@ -570,6 +570,8 @@ static void mtk_vcodec_dec_remove(struct platform_device *pdev)
 	struct mtk_vcodec_dec_dev *dev = platform_get_drvdata(pdev);
 
 	destroy_workqueue(dev->decode_workqueue);
+	if (IS_VDEC_LAT_ARCH(dev->vdec_pdata->hw_arch))
+		destroy_workqueue(dev->core_workqueue);
 
 	if (media_devnode_is_registered(dev->mdev_dec.devnode)) {
 		media_device_unregister(&dev->mdev_dec);
-- 
2.53.0



