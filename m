Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061547;
	b=P6F0ATAnxRx4Rflkpyfot8Cjojho1aD7H3y9UU5lwnQyU8wK2XGjf1/GyNOFGx/o/f63
	 DBZhFRAI6JzIb8sc90i3oMqxucVOiVenohwHHQnRJUdC9qTUkekpSxHw9On8qMhGM6Yc2
	 Fh3go4LSyf7rjY3Yo9VxZolSgH9zp5otm+pkuMWIivtBVtGDgNw0zJyB5Yr9BDvtdWFzJ
	 ASha7F7OFcHrS+7kz3N1WU08RgjETSg7SB+i6lcMjumvp20+rxgwh6UatuW4ug+kJc8Xt
	 1y2bWfo46U9i2rbIrjTd6Fi+vbp+t+fVM+3ntjlwkPlc6VXjyvlZhFRKjs9ERTADRwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cYlZC3XwETs3l7fM4Vv7t03z7nQaYwG6afSYiuDyum8=;
	b=ZrDPlwJIMFetOE6AYvLljRhwEoZXshPsoQoW55azD6ObSqhecLbrQQjAD6Vwjz6sMhM5
	 3MPeSZWFoeF/iXMF3gmt44sBCknJqf6IUW0ZYQcmViXuOS5cMlV8rmCl9Hk8xD/SVrzF/
	 DRHlIZa1HeeT1D5Ggr0qw+09C3zrARZoeLj+zAWyQi5hhSUaC+6n5PZsKTsvVYKRlJEZJ
	 PwA4mVPnGbFKz7WqGsyy3jUTRdu+GVUMs7UNFbkoGisv71LxkVqp9atVWRHMnuephhrPY
	 WQNhs/WQ6xNiETnD/HhRanrDC8LAEKNemBleCAp4qfRozxJLzOGVGTGsnZ95KSDvUnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLu7kE0H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9F0606A326;
	Sat,  7 Nov 2026 14:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLu7kE0H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917471F0089F;
	Sat,  7 Nov 2026 14:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061546;
	bh=cYlZC3XwETs3l7fM4Vv7t03z7nQaYwG6afSYiuDyum8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLu7kE0HtTcAO93hHH1V0UchLZHbDW7CWj7ffkGS5/aykKXXk66ZKM/hltsMKSqR7
	 t5gxFerOL6K9b0LxsHCT+NCV9Oi72nDdr9Y4MqF+vnpNJzk6vIAwRi3GmeM3hquYsX
	 Cfr9jn9wSlL+w1Zje7WTU+6khNwrOcgXNu8kyp9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 0631/1536] ALSA: control: Fix UAF in snd_ctl_elem_add() on card disconnect
Date: Sat,  7 Nov 2026 08:44:07 -0500
Message-ID: <20261107135015.257964996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit d4febca239be3c91498762dd0535a87d4af1eabc upstream.

A use-after-free can be triggered via SNDRV_CTL_IOCTL_ELEM_ADD when a
USB audio card is disconnected while an ELEM_ADD ioctl is in flight.

The reproducer parks the ioctl thread inside copy_from_user() using
userfaultfd, then tears down the USB device.  Unlike every other
ALSA control _user handler (ELEM_INFO, ELEM_READ, ELEM_WRITE, TLV_*),
snd_ctl_elem_add_user() never calls snd_power_ref_and_wait(), so the
parked thread holds no power reference.  snd_card_disconnect() therefore
cannot observe it via snd_power_sync_ref() and proceeds unimpeded:

  1. card->shutdown is set to 1
  2. device_del(&card->card_dev) drops the kobject reference on the
     parent USB interface device (card->dev = &intf->dev)
  3. The USB core drops its own reference and calls device_release(),
     freeing the struct usb_interface, including the embedded struct
     device that card->dev points to

When the userfaultfd is resolved and the thread resumes,
snd_ctl_elem_add() acquires controls_rwsem without checking
card->shutdown and calls __snd_ctl_add_replace().  Because the
reproducer pre-registered the same control, the CTL_ADD_EXCLUSIVE
path calls dev_err(card->dev, ...) on the freed USB interface:

  KASAN: slab-use-after-free Read in __dev_printk

Add a card->shutdown guard immediately after acquiring controls_rwsem
in snd_ctl_elem_add().  At that point card->shutdown is guaranteed to
be stable: snd_card_disconnect() sets it before freeing the parent
device, and it never transitions back to 0.  A thread that acquired
the lock before disconnect sees shutdown=0 and holds the write lock
through the rest of the operation, preventing concurrent disconnect
from proceeding past its own controls_rwsem-less shutdown=1 store
(which happened earlier, outside the lock) from racing with dev_err().

Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260929125346.1478631-3-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/control.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1676,6 +1676,8 @@ static int snd_ctl_elem_add(struct snd_c
 	alloc_size = compute_user_elem_size(private_size, count);
 
 	guard(rwsem_write)(&card->controls_rwsem);
+	if (card->shutdown)
+		return -ENODEV;
 	if (check_user_elem_overflow(card, alloc_size))
 		return -ENOMEM;
 


