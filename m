Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053156;
	b=yFDQ6qNuxnKZRmBk8HY+xW5UH1bAZT6858IGmbi5+giVa5fsfZtJO/IAKgA1X5SePBXG
	 BJFs3nQe/B2bsexcUfin8QjLy2xG/TmRNs2RH5vxtUeHVs5VtlJLlc1RH6q2rNYQlrRnZ
	 ZHxPNsn3zoti76jI2TLZTnWtKfcYzrr49z36+A+nWO5p90ea5HFmRekE+QaGFSe4FNMv7
	 vQGOPdFidsa5KqA6Gf9xvLF7h3RR0uUnaV9fVxjxOdnB0FxXrOInXThXvci4adQ/UOiYO
	 NQAQQ0WSucTpkZSxhWxqWQWyKJ8njzXgWHz9Wx/cQHEIAfzKMF9SxEo7jqXbYAraBZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y9PwJA1W7mfoiFr6VWR6bTDwa1uDyLGH+vYYWc0Xrxs=;
	b=T03qcckmzAHeq+hcB+05EMEKsiP7tgsnD8MRMs/j/y3JfG82b6E8g775pCQjeVP/y34M
	 AhnDFFabUtdK5P7TZzD3U/yL7awTnoqIbM6MndlL00CpJmLlYMd/KB26R4lhgpxANTHJN
	 ZbnaGYATBiGNUzM2DYBvQxP+VfcP/CYabEmxkBkNZOpN5O8e+W8BVbMXxmFF1QiwajXE0
	 wrMxmZFXI0MuUlXAUSoYksQOQfel6uFVB5Quc9s9JO5nilwS7kxUuqtSFuFijxqKdOtgW
	 hIKN0Ib1oZDdyz1hjh1m+64C5hymd23zvrT47ee8fj1YhbxA0HE0L6vfkJAc0X6F3vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZWMW5vUh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A4B606A31C;
	Thu, 19 Nov 2026 01:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZWMW5vUh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305381F000C4;
	Thu, 19 Nov 2026 01:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053156;
	bh=y9PwJA1W7mfoiFr6VWR6bTDwa1uDyLGH+vYYWc0Xrxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWMW5vUhMYuUsjzptydmYJwka9t9pH2gTYdaQEqI9st1HWUk5cd5Jn8wO7Xhnil5e
	 PX78rXCGY0u9x9ZMZI1hCyY27htmcxGrmJrvEiwC11e7dGwiMiP3NYtmit7pTNQbOm
	 uyDHGEXCvHTe2DHrgbWpL2kUf0qE3IXbqqnegNRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0818/2214] ALSA: usb-audio: Dont try to submit URBs after disconnection
Date: Wed, 18 Nov 2026 15:41:34 +0100
Message-ID: <20261118150044.293492531@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit ab574d1629552b6831cd91b926b38092c15d6142 upstream.

USB-audio driver can still submit URBs while the device is being
disconnected, and it may result in spurious error messages like:
  usb 1-2: cannot submit urb (err = -19)
  usb 1-2: Unable to submit urb #0: -19 at snd_usb_queue_pending_output_urbs
  usb 1-2: cannot submit urb 0, error -19: no device
Although those are harmless, they are just ugly.

This patch tries to avoid spewing such error messages when the device
is already at the disconnected state.  It also skips the superfluous
xfer notification, too.

Link: https://lore.kernel.org/r/20230828101924.27107-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 5219111b79e58..d9025aa7fdf6b 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -519,13 +519,18 @@ int snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
 			return -EPIPE;
 		}
 
-		err = usb_submit_urb(ctx->urb, GFP_ATOMIC);
+		if (!atomic_read(&ep->chip->shutdown))
+			err = usb_submit_urb(ctx->urb, GFP_ATOMIC);
+		else
+			err = -ENODEV;
 		if (err < 0) {
-			usb_audio_err(ep->chip,
-				      "Unable to submit urb #%d: %d at %s\n",
-				      ctx->index, err, __func__);
-			if (!in_stream_lock)
-				notify_xrun(ep);
+			if (!atomic_read(&ep->chip->shutdown)) {
+				usb_audio_err(ep->chip,
+					      "Unable to submit urb #%d: %d at %s\n",
+					      ctx->index, err, __func__);
+				if (!in_stream_lock)
+					notify_xrun(ep);
+			}
 			return -EPIPE;
 		}
 
@@ -592,12 +597,17 @@ static void snd_complete_urb(struct urb *urb)
 		prepare_inbound_urb(ep, ctx);
 	}
 
-	err = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!atomic_read(&ep->chip->shutdown))
+		err = usb_submit_urb(urb, GFP_ATOMIC);
+	else
+		err = -ENODEV;
 	if (err == 0)
 		return;
 
-	usb_audio_err(ep->chip, "cannot submit urb (err = %d)\n", err);
-	notify_xrun(ep);
+	if (!atomic_read(&ep->chip->shutdown)) {
+		usb_audio_err(ep->chip, "cannot submit urb (err = %d)\n", err);
+		notify_xrun(ep);
+	}
 
 exit_clear:
 	clear_bit(ctx->index, &ep->active_mask);
@@ -1641,11 +1651,15 @@ int snd_usb_endpoint_start(struct snd_usb_endpoint *ep)
 			goto __error;
 		}
 
-		err = usb_submit_urb(urb, GFP_ATOMIC);
+		if (!atomic_read(&ep->chip->shutdown))
+			err = usb_submit_urb(urb, GFP_ATOMIC);
+		else
+			err = -ENODEV;
 		if (err < 0) {
-			usb_audio_err(ep->chip,
-				"cannot submit urb %d, error %d: %s\n",
-				i, err, usb_error_string(err));
+			if (!atomic_read(&ep->chip->shutdown))
+				usb_audio_err(ep->chip,
+					      "cannot submit urb %d, error %d: %s\n",
+					      i, err, usb_error_string(err));
 			goto __error;
 		}
 		set_bit(i, &ep->active_mask);
-- 
2.53.0



