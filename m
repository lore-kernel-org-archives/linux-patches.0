Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059016;
	b=FEIB+gYOZ0UdaLqxNCfZpUzc+EpSxp9yZTDD+BxjrG3GN1aicQ9uH7r4FjluD/1x504n
	 d3bo5YE4mYf8lhU7aFVWw3M5tJJAlNlL5ii0c8x1RGD4mFrItMk9Q/GgW0oCYjXZGbKmj
	 KxVWu+X6FOSc2TUE6QlRmXX4oaDGXcnWS4u9E+2chq08tq5qUOWtqxf5X3dQqyhGvHR7k
	 StjcYHfGxma7lQuSNmtvaOqiaDwXxnWsnICRTZP9hlH7uDgjWjotEtmV0UdQPb8Rk80bi
	 cRexQRQRvQ9KFIA4w3dxs4XLylvKsDB6QmoSrlE5DlY6dSzeyJ/gjM2DH4qCF27iHsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q+nXGYYZHouYY1feilkwAzM3JoZYh0wUVR6QTxwqflE=;
	b=gpdcHSjX2dOzicTcWfh3ix74fbF+Yu6kNDZ2YaIpKDRGjWExhrh62KV9do+YGL2Yu/Uj
	 qJdIX0NP4SN9QcM7TkVDvgP13/EjJ8DsX0pdf3waDBeUrmaRSQ8sW8t9rf9W8ysXzP1Oh
	 Dy8S0AUVeriUJOurTHWzVK0Xu5wq0e7RRQw7xsQehRnnblJMhBAb1GdmQBnQ6FYIEhNFR
	 NatLgdzCEV2BB4OhXRjbbSKbS7gsCHmgQ+o9r6JTp6oX/qitIB3ou9VbMtLyZSDUs5KMt
	 jWxHBRUWFYRgy8uU6eXhuIEnRYW8XbzMez8G9YBzjf/GsvyAlUKY16FzJXiF5weOHug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zcmRxp+m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597FF606A31C;
	Thu, 19 Nov 2026 03:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zcmRxp+m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2E01F000C5;
	Thu, 19 Nov 2026 03:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059016;
	bh=q+nXGYYZHouYY1feilkwAzM3JoZYh0wUVR6QTxwqflE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zcmRxp+ml5jih0esA4+G9VPZR3eYRJ9o59pbzdy2+4hQfG4mqHZli2yjqdOqZuHzX
	 Xd/4XqXYFizbQP9dMn9wYOW/Q6XLnlEmGgN2q26wIT3Rds7WzmEI/UvJ6GHpY0IgL2
	 bDPXSf4RCeBOuQE9G1PzKRtAzztYo45Y1Dhdi2Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0691/1848] ALSA: us122l: Fix NULL dereference at hwdep open and release
Date: Wed, 18 Nov 2026 15:45:29 +0100
Message-ID: <20261118145944.850217083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0b86dfd5abf9e..ef837d5d8fa04 100644
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



