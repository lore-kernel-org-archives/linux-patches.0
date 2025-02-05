Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B219D1662EF;
	Wed,  5 Feb 2025 14:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767372; cv=none; b=eRaRaBmC6KqUwrIMlcHtXle5E4BM7rd6ihcxmyIlnIRd5zjuJ1owabAbxQp6DY8vPuEdl8DV9e+rTgvzSIbXX3L9b/DRpAm/YPaFHMpukTDoORSPCKXbUt7bGKWfKnLimRLZVkrduS1l9Nx31frbTqmc6jrjfJxC2Z/17632Lwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767372; c=relaxed/simple;
	bh=FfHM+ILN3Gn5C22gUaUrMLAS9dPYLNHvyAGXlaGjS7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCjV42HsSgMY61xTQKp3pbzrb/YJ7gbG/En0550zNoL0PxuLstqavRaE/lMaZTG9lPwtjICFPpx/4e5OY0rQULbX9zm6pgSIcqUSnU9o1loSwjieOKg1erw33WbztHGY9Fb28lyGv3nRVldMFzwjZOTZR3adq7BAd3FCcMgxpm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUbHyTvi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUbHyTvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967BCC4CED1;
	Wed,  5 Feb 2025 14:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767372;
	bh=FfHM+ILN3Gn5C22gUaUrMLAS9dPYLNHvyAGXlaGjS7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUbHyTvitlgXA61ShuuW7bjDKH8K7oen/H73eUy/Q8T4LvzCqhLpX5vBvY56Uxb22
	 7vl3/hfhHPbAFy/SiwEhYzfMPU/jcxbcwuXF+MxWFopJTYg2DQRd60BV3coDJuEhkA
	 b9RHmW21KM3Cp2YcxuJZTexygbbgvhh62P+vWkQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 417/590] media: uvcvideo: Propagate buf->error to userspace
Date: Wed,  5 Feb 2025 14:42:52 +0100
Message-ID: <20250205134511.219251848@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 16fa17bbd15ea..83ed7821fa2a7 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -483,7 +483,8 @@ static void uvc_queue_buffer_complete(struct kref *ref)
 
 	buf->state = buf->error ? UVC_BUF_STATE_ERROR : UVC_BUF_STATE_DONE;
 	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
-	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->buf.vb2_buf, buf->error ? VB2_BUF_STATE_ERROR :
+							VB2_BUF_STATE_DONE);
 }
 
 /*
-- 
2.39.5



