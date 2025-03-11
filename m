Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5299925DD06;
	Tue, 11 Mar 2025 15:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706546; cv=none; b=cZ4mvPhwUuH1cZ2ygdkWjI+/LXGCRNuDrsj4y7wsRIbdIV+fpIjxcFmGnKSRpIwafr9R5xH1Ef6laUseGggmmhqPdAOKIdVPOFTqTrDQHo8qSrY8HERFnEnT9GMTFcoR0ox4DZmgh1A4btgINRuhmrFtE/FvwlmIfstFLI3SqRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706546; c=relaxed/simple;
	bh=ZZMaj3Ws8vTaXcXpoI/9vaRL2bmzeVxBdRS7wRwc80c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6faUlVS0oMG8p42Wrhd2KYoyz7ktHcen3hoXa6b8Dkzu5tyDabuQErQpFMbmM1gjZR8Tvtvp+rZp5lFw0i61HFvIa7sjlSgWU1WLBm9SXoJS7J+rMRjAH3hnoJ6zI1342Hz/vN+Vyu5PpOut466ea9B0dBfdGTRbnnaK3nnut0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtlv1Oi0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtlv1Oi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFBEC4CEEA;
	Tue, 11 Mar 2025 15:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706546;
	bh=ZZMaj3Ws8vTaXcXpoI/9vaRL2bmzeVxBdRS7wRwc80c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtlv1Oi0qxIcDFkQDNuCp1dutdea0itvUhGxsnWkp86pqdb1OFLgMdDmA3HIPFrl/
	 jP5puHLBgphqoZ0LyHyMvb9DXh2+luxcsvVLzo4d4Lw36oVAPmWCeNU95MMobZgfll
	 H1Ly1yxVBOr5tmBqKqOVek/0KNQNs8hvif4lpVAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/462] media: uvcvideo: Propagate buf->error to userspace
Date: Tue, 11 Mar 2025 15:55:52 +0100
Message-ID: <20250311145801.749379954@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cd60c6c1749ea..6a9fdd32cfb86 100644
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



