Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044490;
	b=4+rmQEHasufV9UcWJO56vDnmHui5NSGtH9v6lfUcbDgJwRtpIJ4Lpfl4ky+kv1qvhhSn
	 OSbIC5FGFvzMUVNavQjpa5sp3v3XIsqPtNMv/KMcPh1C2+9S8p6YIljpvX+p/wHaMRZ8b
	 2Vs2RNsuKn3BEfftvWn2XvjmBZQx/r4SVPQAKmAmeskLcv1tcmnAl4iSSqkzpaUEFrR65
	 iPxtg7Jmuo7HXky0NnxTog9nkIniexFaXAbf0lQVijAsGUaAimfV25Cyx+xB5mk1hMwlI
	 DQxETZ4C3jjlHPxBWb5JqB1V1tmKocpfZUW7UcYva5kxRuccqhR1OJqeVIrSgkmEtKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ErI6ZnYChcgN1deYEeNCuZ7PfE4jkum5TbkL34oF/fo=;
	b=sN9nH/7dhftgVACNEt747oyJAg+R4ZiGvKeT802Tfq81PV5mt3AEpmkS/Uq7KvpnWJBV
	 Fs+58HkmUpMedcD+7/3hqx56AMH6NYAXoY6/sHi95U98iFli66pAbachUQ4wahbZt9mEX
	 28zX5j85pBuufU0s0ERNUGKdghZxJmcrQuWtUBI+zOWdntSOdPvAjZVTExiTQeC3AoXpi
	 w8YKMTpYqoc9z5EbhpiHC6ixAcRVkt2MJjhMyPNOK6IcOfs5RJUwmZmNsgShgxoyIBM1N
	 eIRwqchfvsyDBYyogE//imeHOKTYy0DWoTK2vhiQqIVF3O3IhmB8yM+WDZycTPXjp8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zZXUgZQR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EFF606A33D;
	Wed, 18 Nov 2026 23:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zZXUgZQR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C4A1F000C5;
	Wed, 18 Nov 2026 23:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044490;
	bh=ErI6ZnYChcgN1deYEeNCuZ7PfE4jkum5TbkL34oF/fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZXUgZQRA50iUI8Gmw8RGf/x3o2Jiq18aXpxN6nab6gnvdRFZclQPEne8V5dWfYfN
	 KrlDClRcPIQAXC9pyaGt6mrStZu82PGD7eQITMvoFi2Zix9VxIQrnIpWORLmSK3XGk
	 HpIP/8RFb5YGOg/OfJ4pmF502v/tSTUf94BNAiv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+37a57a84893052ab6071@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0587/2857] media: usbtv: fix null-pointer dereference on disconnect
Date: Wed, 18 Nov 2026 15:27:01 +0100
Message-ID: <20261118150222.619328042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Nogikh <nogikh@google.com>

[ Upstream commit cb705f75d03e946a4514488beb9e3bac9bcdb2e6 ]

A null-pointer dereference can occur in usb_make_path() when called from
usbtv_querycap() (and other ioctl handlers) during device disconnection.

Oops: general protection fault, probably for non-canonical address
0xdffffc000000000a: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
RIP: 0010:usb_make_path include/linux/usb.h:985 [inline]
RIP: 0010:usbtv_querycap+0x9c/0x100
drivers/media/usb/usbtv/usbtv-video.c:612
...
Call Trace:
 <TASK>
 v4l_querycap+0x236/0x470 drivers/media/v4l2-core/v4l2-ioctl.c:1106
 __video_do_ioctl+0x8af/0xc70 drivers/media/v4l2-core/v4l2-ioctl.c:3133
 video_usercopy+0x860/0x1430 drivers/media/v4l2-core/v4l2-ioctl.c:3475
 v4l2_ioctl+0x18d/0x1e0 drivers/media/v4l2-core/v4l2-dev.c:366
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94

This happens due to a race condition between the USB device disconnect
routine (usbtv_disconnect()) and V4L2 ioctls. When the device is
disconnected, usbtv_disconnect() sets usbtv->udev = NULL without holding
the usbtv->v4l2_lock mutex. Concurrently, an ioctl handler like
usbtv_querycap() can be executing under the v4l2_lock and attempt to use
usbtv->udev, leading to a crash.

To fix this, move the usbtv->udev = NULL assignment into usbtv_video_free()
and protect it with mutex_lock(&usbtv->v4l2_lock). This ensures that no
non-queue ioctl handler can run concurrently with the pointer being
nullified. If an ioctl is already running, the mutex will block the
disconnect path until the ioctl finishes. If an ioctl is blocked waiting
for the lock, it will acquire it after the disconnect routine releases it,
but will then check video_is_registered() (which was cleared by
vb2_video_unregister_device()) and safely return -ENODEV.

Acquiring v4l2_lock after vb2_video_unregister_device() avoids
reintroducing a historical deadlock issue, and usbtv_audio_free() remains
safe as it is called before usbtv_video_free().

Fixes: 65e6a2773d65 ("media: usbtv: Remove useless locks in usbtv_video_free()")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+37a57a84893052ab6071@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=37a57a84893052ab6071
Link: https://syzkaller.appspot.com/ai_job?id=5abbe65a-5853-4bc2-9135-5c75f88d51ed
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/usbtv/usbtv-core.c  | 2 --
 drivers/media/usb/usbtv/usbtv-video.c | 4 ++++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index 275b21404dd22..0e1f1a535d714 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -136,8 +136,6 @@ static void usbtv_disconnect(struct usb_interface *intf)
 	usbtv_audio_free(usbtv);
 	usbtv_video_free(usbtv);
 
-	usbtv->udev = NULL;
-
 	/* the usbtv structure will be deallocated when v4l2 will be
 	   done using it */
 	v4l2_device_put(&usbtv->v4l2_dev);
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index f3633448e8b96..8c9f09b56bfbd 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -969,5 +969,9 @@ void usbtv_video_free(struct usbtv *usbtv)
 	vb2_video_unregister_device(&usbtv->vdev);
 	v4l2_device_disconnect(&usbtv->v4l2_dev);
 
+	mutex_lock(&usbtv->v4l2_lock);
+	usbtv->udev = NULL;
+	mutex_unlock(&usbtv->v4l2_lock);
+
 	v4l2_device_put(&usbtv->v4l2_dev);
 }
-- 
2.53.0



