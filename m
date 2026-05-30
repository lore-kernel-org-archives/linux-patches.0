Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B022628D;
	Sat, 30 May 2026 17:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163752; cv=none; b=uQ8yPVnMiWhm1hAzd8msdFmmjXp3iXTZfgSKq/j5HnLX2mGZYfX3lHLxDBERmjx7GwtaSjTKN6ei5ZakWqKV26NGHeUiUYodU8qHzd5NW33M4RGAci4vDzKso2bb7ywkVwKAz8Y6ldtMvdJvSoVjX515vMpJrsRDsuWe5iMPVa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163752; c=relaxed/simple;
	bh=yqfoCTlw3CJLOL+ZLDQEvu9ENBKxe4uo5Q0uEJyZz38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfphZW3YAbfjQrWBiZB7b7jB9TK1kl3l5y1/o4sfA+tnx5ztQpgUPb+2zbyUaH2HFuodFzndO81RpvikfeNlMGbAUp8mj9POQnMofWUM4EHj5Zawc1S8UIl9zazwv20nVB0TomZwTSFirvT05FC2h2C2tjvItkGAWlNOxsCPU3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRoPBuR1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRoPBuR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE9C1F00893;
	Sat, 30 May 2026 17:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163751;
	bh=AK7dXAMU/Nw+ZezqPCdT10t8SgVyWObiIB7qTzFiXls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRoPBuR1XIAShI9jt5irOR7N+QVzcjRV6l+8gXnksDrnstD7BcbzNVJ6qf3OoGzAD
	 LXRyMzpSg3UyH08bwZBzHhs+qlseprE0WdyXeg9WmC6ZC3XsdED0DlROrQUCiE0hqL
	 q+TP8Flp5UXOzgo7iyBJFsBd5zvQXJPPSAb0+6RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 351/776] media: uvcvideo: Enable VB2_DMABUF for metadata stream
Date: Sat, 30 May 2026 18:01:05 +0200
Message-ID: <20260530160249.651859180@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit fbac03467e53d8d72e5099c03df26d9adae11416 upstream.

The UVC driver has two video streams, one for the frames and another one
for the metadata. Both streams share most of the codebase, but only the
data stream declares support for DMABUF transfer mode.

I have tried the DMABUF transfer mode with CONFIG_DMABUF_HEAPS_SYSTEM
and the frames looked correct.

This patch announces the support for DMABUF for the metadata stream.
This is useful for apps/HALs that only want to support DMABUF.

Cc: stable@vger.kernel.org
Fixes: 088ead2552458 ("media: uvcvideo: Add a metadata device node")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260309-uvc-metadata-dmabuf-v1-1-fc8b87bd29c5@chromium.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_queue.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -217,7 +217,7 @@ int uvc_queue_init(struct uvc_video_queu
 	int ret;
 
 	queue->queue.type = type;
-	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR;
+	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	queue->queue.drv_priv = queue;
 	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
 	queue->queue.mem_ops = &vb2_vmalloc_memops;
@@ -230,7 +230,6 @@ int uvc_queue_init(struct uvc_video_queu
 		queue->queue.ops = &uvc_meta_queue_qops;
 		break;
 	default:
-		queue->queue.io_modes |= VB2_DMABUF;
 		queue->queue.ops = &uvc_queue_qops;
 		break;
 	}


