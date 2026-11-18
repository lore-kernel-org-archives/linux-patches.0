Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017749;
	b=uyMfjWQJl+UcfkyyqYRhqCFv1TQJgNnTRm9BoMnmXfMl7qXpYVxXWotblEeo5fjaEzXu
	 LaJ/PPAC7cFB8eZSpaYhG9PSPn6s+/Q0fA9Syao+Ary4ZUKZgSGabtqvwpggrbkyU+iZM
	 7HE5P7SHvcVO6JkZS/R2Mx728HZJZteHCJrZnIJmVsLcIVS0AQCw767OGLRIMNaWov8qI
	 QDMjQjXTetKxzeNaoYVW9iphDZLA1JA3aDh8oUrLLHjq4oEq8hbbpUqfzf4CbXutW9yrK
	 vZ0jHs9+FEnoO74BCwHW3mu7Tt0jXzDrftrgQJVdFfrlGp7yrFlHGNllJ1jLPsI40CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=we0w/DRk6kgpkChW3fwM8UrwyKe2Rorm3njQTQ7fG7A=;
	b=OsfaXUca/wT/DY0AfMgeE+zXVNYJOGsxpK+T1NQI0BdFIpS+CmMBnNTyjFJlLB1r0HmJ
	 7QLuHwNpaH2g+WDWC5FmiSjpx2SWLnKvKj+KVKEh4zV+A2N5re9EGdmSmdhtq/+VzCe3i
	 e895g0mV7I2N/ZNwsGbIb4vfaa6ZcTprMFAp5oUSba6mTSkta5NFsnlUoIEHFsRFmI1CX
	 7ZDb1K4HFXtA7CWauyzxlyIuyHxuxQa0JsoMBgAlUrSystxjYPlGsgOjSmWggNjtdmnss
	 GcRDFXmfSaUtZLE+iRAmZSaTkWZUrGWnchVN2oFiuiYh8oeBfaIhxS4YKgSWQX7dHAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JQPcUWZT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F87606A333;
	Wed, 18 Nov 2026 16:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JQPcUWZT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149711F000C9;
	Wed, 18 Nov 2026 16:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017749;
	bh=we0w/DRk6kgpkChW3fwM8UrwyKe2Rorm3njQTQ7fG7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JQPcUWZTl00AXKg+BhNqPGpEEk9nDAX++JQAhiqSlzhsKQJphO7v4efY/AIMYOMnQ
	 QGGQeWP95jUAdRlwrAhlIhhY3Wza2km6ZeEvoYz3EYD63zf+GSe/2asi78amMvmoxX
	 Y5E10SZdAUlSLORKX9TgrhBxO9eeCZs/+LVOC3Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niko Huuskonen <niko.huuskonen.00@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0958/2651] ALSA: caiaq: Serialize access to the EP1 command buffer
Date: Wed, 18 Nov 2026 15:36:38 +0100
Message-ID: <20261118150322.390329992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niko Huuskonen <niko.huuskonen.00@gmail.com>

[ Upstream commit a718fd03e1e00211cf4662f5ab82d33f4c18e2a7 ]

snd_usb_caiaq_send_command() and snd_usb_caiaq_send_command_bank() copy
the command into cdev->ep1_out_buf and send it with a synchronous bulk
transfer. Nothing serializes their callers. An ALSA control write, which
sets the LEDs on the Kore controllers and several other devices, can run
at the same time as a PCM prepare, which sends the audio parameters
through the same buffer. One caller can then overwrite the buffer while
the transfer of the other is still in flight, and the device receives a
mix of both commands.

Protect the buffer with a mutex. All callers run in process context and
already sleep in usb_bulk_msg().

The problem was found by code review while adding another user of the
buffer, the Kore LCD support later in this series. It has not been
observed or reproduced.

Fixes: 8e3cd08ed8e5 ("[ALSA] caiaq - add control API and more input features")
Assisted-by: LLM
Signed-off-by: Niko Huuskonen <niko.huuskonen.00@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260927003532.289468-2-niko.huuskonen.00@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/caiaq/device.c | 5 +++++
 sound/usb/caiaq/device.h | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/sound/usb/caiaq/device.c b/sound/usb/caiaq/device.c
index f604846ec6e6f..e8619bb743581 100644
--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -212,6 +212,8 @@ int snd_usb_caiaq_send_command(struct snd_usb_caiaqdev *cdev,
 	if (len > EP1_BUFSIZE - 1)
 		len = EP1_BUFSIZE - 1;
 
+	guard(mutex)(&cdev->ep1_out_mutex);
+
 	if (buffer && len > 0)
 		memcpy(cdev->ep1_out_buf+1, buffer, len);
 
@@ -235,6 +237,8 @@ int snd_usb_caiaq_send_command_bank(struct snd_usb_caiaqdev *cdev,
 	if (len > EP1_BUFSIZE - 2)
 		len = EP1_BUFSIZE - 2;
 
+	guard(mutex)(&cdev->ep1_out_mutex);
+
 	if (buffer && len > 0)
 		memcpy(cdev->ep1_out_buf+2, buffer, len);
 
@@ -443,6 +447,7 @@ static int create_card(struct usb_device *usb_dev,
 	cdev->chip.usb_id = USB_ID(le16_to_cpu(usb_dev->descriptor.idVendor),
 				  le16_to_cpu(usb_dev->descriptor.idProduct));
 	spin_lock_init(&cdev->spinlock);
+	mutex_init(&cdev->ep1_out_mutex);
 
 	*cardp = card;
 	return 0;
diff --git a/sound/usb/caiaq/device.h b/sound/usb/caiaq/device.h
index 1c6f34693fa81..822d872c8ad1a 100644
--- a/sound/usb/caiaq/device.h
+++ b/sound/usb/caiaq/device.h
@@ -2,6 +2,8 @@
 #ifndef CAIAQ_DEVICE_H
 #define CAIAQ_DEVICE_H
 
+#include <linux/mutex.h>
+
 #include "../usbaudio.h"
 
 #define USB_VID_NATIVEINSTRUMENTS 0x17cc
@@ -68,6 +70,7 @@ struct snd_usb_caiaqdev {
 
 	unsigned char ep1_in_buf[EP1_BUFSIZE];
 	unsigned char ep1_out_buf[EP1_BUFSIZE];
+	struct mutex ep1_out_mutex;	/* protects ep1_out_buf */
 	unsigned char midi_out_buf[EP1_BUFSIZE];
 
 	struct caiaq_device_spec spec;
-- 
2.53.0



