Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053257;
	b=LgPFPbyHOjIOpeCldEFN6NItgSpOLUeCq/YRRaSPJNOasruiUzqYwHrdQcZG9eh9dy1Q
	 TIB/aeXSXOjP1RV4Op0alMaUwC4KxcpLGRXvxPpgyPkSCOc/J/Ev48G8QXu6lvgtS7Kiq
	 /3tGBtzx/yFx6ZFziaH2G9V79iZZULCaxvKrD5rnD6gpKF1rmWCuqjqToAtWIwh+e3Qux
	 dVuchBZ1iFOPpzuxiwmv9UFadnDfteS6JdXCvHrwe0lQF/mTCnrWVIKBIFXQmRq8rlwM7
	 0y7J/xabdjAMsWFy8WsxBKVPlX+FSKJ79e9eyasnX/xsVHmmsYPeLxFqNumpBa6cQ8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lq+J7vmPkzOYXC9+BqObxDWGQDiQnAmQHU1oWsc+Y24=;
	b=Vdassgtkbc37VcfnPzave465DPUoQ/VNHAwWCddTs7jmzZUoLEPV4dFxhM+mVJZ7oK9E
	 SHz62+Ge9ZaFU9Zr/RQyIsVh/ftsK98nOV46Di+Danof+HKeZJJ43bA5fcJGhf8tT8/eq
	 SD6J9/65nubwH0/zuQg3TG0ZtJbhZiSoateko0RFxZJNontzNZAWtbPtNaCQUgGcTN1Wl
	 SnTqBZ+5o7VCJyQjU3wJ/SMS/hxRdWEFlHymWHf97CnWB2JjI4xQVKcWwX9TloCj919iF
	 rJWeyRgP+8Ue9CyjP4YPiid/NTpFeFItmFelWF9RAK+Efm19OnI5se525Sf8TCozZpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fq3AIxnA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8A8606A33B;
	Thu, 19 Nov 2026 01:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fq3AIxnA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8891F000C4;
	Thu, 19 Nov 2026 01:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053257;
	bh=lq+J7vmPkzOYXC9+BqObxDWGQDiQnAmQHU1oWsc+Y24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fq3AIxnAptnMgAaerb2142MrOLzhTHukVcK3erYvoMY4A3XDc+SBOVxQ4QFn21BrR
	 eWwseNTTlJeczZX6G7BpkBwkGei414/bQMfGRmoNcByLnTuSbwiJ8eTFhkACMpmfgA
	 9GYAsXFYUZf6G7QDUsOP3t7FBDgVI15Knm0VQJXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0856/2214] ALSA: us122l: Fix NULL dereference at hwdep open and release
Date: Wed, 18 Nov 2026 15:42:12 +0100
Message-ID: <20261118150046.413447450@linuxfoundation.org>
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

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

[ Upstream commit 820e0050866942b5498488496462d12c6ce1c7a9 ]

usb_stream_hwdep_open() and usb_stream_hwdep_release() pass the result of
usb_ifnum_to_if() straight to usb_autopm_get_interface() and
usb_autopm_put_interface(), without checking it for NULL.

usb_ifnum_to_if() returns NULL once the device is gone, since
usb_disable_device() clears udev->actconfig on disconnect.  The hwdep file
can outlive the disconnect: the card is released with
snd_card_free_when_closed(), so a process that keeps the character device
open reaches the driver's release callback after the USB configuration has
been dropped, and interface_to_usbdev() then dereferences the NULL
interface at offsetof(struct device, parent).  The open callback has the
same problem when it races with the disconnect.

Check both lookups and fail the open with -ENODEV; in release, skip the
runtime PM put when the interface is already gone and still run the rest
of the per-file cleanup.  Move the us122l->first bookkeeping after the
checks so that a failed open no longer leaves a stale file pointer behind.

Fixes: 030a07e44129 ("ALSA: Add USB US122L driver")
Cc: stable@vger.kernel.org
Co-developed-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Bin Yu <byu@xidian.edu.cn>
Co-developed-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Link: https://patch.msgid.link/20261028074143.14440-1-25031212351@stu.xidian.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/us122l.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index 1e90c183761d7..a92755e6a7fd2 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -153,20 +153,27 @@ static const struct vm_operations_struct usb_stream_hwdep_vm_ops = {
 static int usb_stream_hwdep_open(struct snd_hwdep *hw, struct file *file)
 {
 	struct us122l	*us122l = hw->private_data;
-	struct usb_interface *iface;
+	struct usb_interface *iface, *iface0 = NULL;
 
 	snd_printdd(KERN_DEBUG "%p %p\n", hw, file);
 	if (hw->used >= 2)
 		return -EBUSY;
 
-	if (!us122l->first)
-		us122l->first = file;
-
 	if (us122l->is_us144) {
-		iface = usb_ifnum_to_if(us122l->dev, 0);
-		usb_autopm_get_interface(iface);
+		iface0 = usb_ifnum_to_if(us122l->dev, 0);
+		if (!iface0)
+			return -ENODEV;
 	}
+
 	iface = usb_ifnum_to_if(us122l->dev, 1);
+	if (!iface)
+		return -ENODEV;
+
+	if (!us122l->first)
+		us122l->first = file;
+
+	if (iface0)
+		usb_autopm_get_interface(iface0);
 	usb_autopm_get_interface(iface);
 	return 0;
 }
@@ -180,10 +187,12 @@ static int usb_stream_hwdep_release(struct snd_hwdep *hw, struct file *file)
 
 	if (us122l->is_us144) {
 		iface = usb_ifnum_to_if(us122l->dev, 0);
-		usb_autopm_put_interface(iface);
+		if (iface)
+			usb_autopm_put_interface(iface);
 	}
 	iface = usb_ifnum_to_if(us122l->dev, 1);
-	usb_autopm_put_interface(iface);
+	if (iface)
+		usb_autopm_put_interface(iface);
 	if (us122l->first == file)
 		us122l->first = NULL;
 	mutex_lock(&us122l->mutex);
-- 
2.53.0



