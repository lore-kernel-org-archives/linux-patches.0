Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073663E009A;
	Fri, 15 May 2026 16:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861468; cv=none; b=ShJg47TXiU+DNhi3N7fzibbFbySOxp9IW1GgvMJXxd/LNlQAeL5sJ8YiNJTdF45jjzWCVGpt72jUxiTcOnMQqZqLgk/Uz3ZrvTPgERtf36Bds7y8T77h/GfHuQ7nX3+OiE6AIRrQVTgd57k09958ej6FYPqfqLX02Mcws+/6mQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861468; c=relaxed/simple;
	bh=r6LSGnWqEy8QF7ornnIFUEFSw0JT8Fhmda4SlyD1PZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4e8FcbkX+jStICHxH6flaXxSN0WAmYorac42IFYWP37DcTKJQeguIeCKakQfB1CCtimIcJQUx5VfT8C8TvPKWHzv+xWgvx5t+o+NzuR553aDMlzMt7gGYbPaSlw+QQ5j3QmFgOvdROTlvF069PJ4jXc+HfAMEJR0ZzTntZALdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdY7w0n0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdY7w0n0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB73C2BCB0;
	Fri, 15 May 2026 16:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861467;
	bh=r6LSGnWqEy8QF7ornnIFUEFSw0JT8Fhmda4SlyD1PZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdY7w0n0W2zoiOFFQIeNF7yXQm+Iy1eS4IsStbakKOq3E7LQSdkZGsn6y4+dCHDev
	 BM5NXDq0vCCmt3mUovRcNKI/o2eggFMb4Lfgau2rlq6d36OzDKjGTdrFic/porlawy
	 mzoat3S8PfPnKenV2VVsVL5FMjlw5ksyG2bYRIuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 298/474] media: uvcvideo: Enable VB2_DMABUF for metadata stream
Date: Fri, 15 May 2026 17:46:47 +0200
Message-ID: <20260515154721.450329858@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -218,7 +218,7 @@ int uvc_queue_init(struct uvc_video_queu
 	int ret;
 
 	queue->queue.type = type;
-	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR;
+	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	queue->queue.drv_priv = queue;
 	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
 	queue->queue.mem_ops = &vb2_vmalloc_memops;
@@ -231,7 +231,6 @@ int uvc_queue_init(struct uvc_video_queu
 		queue->queue.ops = &uvc_meta_queue_qops;
 		break;
 	default:
-		queue->queue.io_modes |= VB2_DMABUF;
 		queue->queue.ops = &uvc_queue_qops;
 		break;
 	}


