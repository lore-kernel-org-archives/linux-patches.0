Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13D025DD02;
	Tue, 11 Mar 2025 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705515; cv=none; b=KVl0ke2jl5vrfitovQ/RbFHrXFDgZehWLhPhHsUtiU0kQaModojq8g298jy/LDXYcHGHxnJlzdN5XSB0GBYLbO35sS/roVNQgLyOed6DG4HqJ+4jlAlub2JGtQrZ0K2veUDhQOaoQ/SXSa+8Lulxj9hVfm0PdWhq0dwl+QBH3hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705515; c=relaxed/simple;
	bh=RUk56bMGXmTlHJFC9mRV6Zdd5n93xG44uM7dUnPYpOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+W0CSGEDeqedBgBgn08quiqKpzmE6buDMd+2fVAppgrqmMnn8lRastu76/o1BK8HmbkEW9E0YuU6HqkthW4a6GCEbv5C+l7j3oVTaUYWtf1tyX8t9rR7vUCBU0QA9ZdH14VYBIk7YUp6TwJwqvyk7k9WoOteqLGCM3arpFae7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZ7fVqTW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZ7fVqTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD83C4CEE9;
	Tue, 11 Mar 2025 15:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705515;
	bh=RUk56bMGXmTlHJFC9mRV6Zdd5n93xG44uM7dUnPYpOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZ7fVqTWYnlZwECyXq9pLFCl0wz+ijFceXM8AMvMJCA3hpb+3Ak3YS+WEFfPRxdOe
	 Iv7ZIP2tpeBzKhsShoqoCm2EVsdBS0X8pOHwgNfWfoMxXhRTwyF7xQS2AJtoWm07ow
	 Tau9GzMZvnmv9zcVg+lLfoyAU+H8yOM81TCd6wGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/328] media: uvcvideo: Propagate buf->error to userspace
Date: Tue, 11 Mar 2025 15:57:04 +0100
Message-ID: <20250311145717.045753103@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 87ce177654e388451850905a1d376658aebe8699 ]

Now we return VB2_BUF_STATE_DONE for valid and invalid frames. Propagate
the correct value, so the user can know if the frame is valid or not via
struct v4l2_buffer->flags.

Reported-by: Hans de Goede <hdegoede@redhat.com>
Closes: https://lore.kernel.org/linux-media/84b0f212-cd88-46bb-8e6f-b94ec3eccba6@redhat.com
Fixes: 6998b6fb4b1c ("[media] uvcvideo: Use videobuf2-vmalloc")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20241218-uvc-deprecate-v2-1-ab814139e983@chromium.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_queue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index da72577c29986..d7c81e205e8bb 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -486,7 +486,8 @@ static void uvc_queue_buffer_complete(struct kref *ref)
 
 	buf->state = buf->error ? UVC_BUF_STATE_ERROR : UVC_BUF_STATE_DONE;
 	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
-	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->buf.vb2_buf, buf->error ? VB2_BUF_STATE_ERROR :
+							VB2_BUF_STATE_DONE);
 }
 
 /*
-- 
2.39.5



