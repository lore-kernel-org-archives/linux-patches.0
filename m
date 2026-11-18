Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035129;
	b=HrmfFQf6FwwIqhbojygkDWFoq3pUxJnd05JM8z/3jiBUxezdsAahYnibgmACO4sBdZXQ
	 NPt+3hV8RU2udNFC49YbVZEUrlRWi1yOElf2PBkPlsl4Y0LjWVSHG5nJjjka/WTrmF8P2
	 8+cH1UFjGfZQoUB9ggCe1LSasbrQx9kmgt39zw87UHOS+IMbv2QhFUUcKorxJhwEt0FPU
	 wAeCQ4kQg5TZ5pR3dNEL+MoHoXqKVMZo6nd6hGMwyoU+Bsw7U/mK4iFiV0G2Xm1Ux304C
	 oh4Jpom7NJQNuNzRsUXEcZCIHpXo7ra/r+QW22P8e54u98JM9bys8jozMPQmSQCd+6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=beyy4Hr4qElTssN1KqYMWyqGfIuoNGVp86pjOoXP0TA=;
	b=iZzMOi9wzbRfvmj5U0zYxiKKbReFJwT4ZBTHqODv7ILLKVQdRffjirPTtJP8iCC+QCXz
	 DE23vvuPgvn2VOoI40fVwyn2M8iVDy399L9PL1A7YkqlP1UDhIfHjk1IqSMHAPQUqT2UB
	 o4Yq0MCnbyPeLjT1xEmYKQb7c0/1Z9n/A2tpy8lDkYF2ieoGueKoCSV6HjkkwpedExFEj
	 zh2x10rT0dmgayYLLssis5KChx8jNc3qu/r9Q8GerqNHtzyNLxhAxjqGJsxAAsk0lB1/B
	 EVSIPcVfaELYPHNC8CFG1NtS3YLHf3OlApPY3BP3X2qU7ZwLxa9JLRXqAE2QLaymFXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Pwvi0JE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C012E606A320;
	Wed, 18 Nov 2026 20:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Pwvi0JE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C911F000C4;
	Wed, 18 Nov 2026 20:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035129;
	bh=beyy4Hr4qElTssN1KqYMWyqGfIuoNGVp86pjOoXP0TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Pwvi0JEPYhmQr32tNywnzGsmRaKejbk9ofSL52jd+W+cOO0JoYU+6KsqExZ+g0Me
	 oi1xphga0RbrSeYRLvXUtK6QemjZjicedO9QyULcPULfVGFuqGItDELgFTVQBhrJhU
	 dsJhm/DoFna1alNFXtb1UVAsshhcmHWflbgBAQDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+563191a4939ddbfe73d4@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0616/3318] HID: hiddev: keep state alive through disconnect unlock
Date: Wed, 18 Nov 2026 15:20:38 +0100
Message-ID: <20261118150336.278794993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

commit 03f449b5de36a25fc5eba7dabf2b4494389bdb91 upstream.

mutex_unlock() clears the mutex owner before taking its wait lock. A
thread spinning in the final hiddev file release can acquire
existancelock after hiddev_disconnect() clears the owner, then free
hiddev before the disconnecting thread reaches the mutex wait lock. This
causes a use-after-free in the mutex slow unlock path.

Give the connection and each open file an explicit reference. Drop each
reference only after its existancelock critical section has completed,
so neither unlock path can free the mutex while the other is still using
it.

Fixes: 079034073faf ("HID: hiddev cleanup -- handle all error conditions properly")
Reported-by: syzbot+563191a4939ddbfe73d4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=563191a4939ddbfe73d4
Cc: stable@vger.kernel.org
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://syzkaller.appspot.com/bug?extid=563191a4939ddbfe73d4
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/usbhid/hiddev.c |   37 +++++++++++++++++++------------------
 include/linux/hiddev.h      |    2 ++
 2 files changed, 21 insertions(+), 18 deletions(-)

--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -46,6 +46,12 @@ struct hiddev_list {
 	struct mutex thread_lock;
 };
 
+static void hiddev_put(struct hiddev *hiddev)
+{
+	if (refcount_dec_and_test(&hiddev->refcount))
+		kfree(hiddev);
+}
+
 /*
  * Find a report, given the report's type and ID.  The ID can be specified
  * indirectly by REPORT_ID_FIRST (which returns the first report of the given
@@ -216,26 +222,21 @@ static int hiddev_fasync(int fd, struct
 static int hiddev_release(struct inode * inode, struct file * file)
 {
 	struct hiddev_list *list = file->private_data;
+	struct hiddev *hiddev = list->hiddev;
 	unsigned long flags;
 
-	spin_lock_irqsave(&list->hiddev->list_lock, flags);
+	spin_lock_irqsave(&hiddev->list_lock, flags);
 	list_del(&list->node);
-	spin_unlock_irqrestore(&list->hiddev->list_lock, flags);
+	spin_unlock_irqrestore(&hiddev->list_lock, flags);
 
-	mutex_lock(&list->hiddev->existancelock);
-	if (!--list->hiddev->open) {
-		if (list->hiddev->exist) {
-			hid_hw_close(list->hiddev->hid);
-			hid_hw_power(list->hiddev->hid, PM_HINT_NORMAL);
-		} else {
-			mutex_unlock(&list->hiddev->existancelock);
-			kfree(list->hiddev);
-			vfree(list);
-			return 0;
-		}
+	mutex_lock(&hiddev->existancelock);
+	if (!--hiddev->open && hiddev->exist) {
+		hid_hw_close(hiddev->hid);
+		hid_hw_power(hiddev->hid, PM_HINT_NORMAL);
 	}
 
-	mutex_unlock(&list->hiddev->existancelock);
+	mutex_unlock(&hiddev->existancelock);
+	hiddev_put(hiddev);
 	vfree(list);
 
 	return 0;
@@ -270,6 +271,7 @@ static int __hiddev_open(struct hiddev *
 	spin_unlock_irq(&hiddev->list_lock);
 
 	file->private_data = list;
+	refcount_inc(&hiddev->refcount);
 
 	return 0;
 
@@ -897,6 +899,7 @@ int hiddev_connect(struct hid_device *hi
 	INIT_LIST_HEAD(&hiddev->list);
 	spin_lock_init(&hiddev->list_lock);
 	mutex_init(&hiddev->existancelock);
+	refcount_set(&hiddev->refcount, 1);
 	hid->hiddev = hiddev;
 	hiddev->hid = hid;
 	hiddev->exist = 1;
@@ -937,9 +940,7 @@ void hiddev_disconnect(struct hid_device
 	if (hiddev->open) {
 		hid_hw_close(hiddev->hid);
 		wake_up_interruptible(&hiddev->wait);
-		mutex_unlock(&hiddev->existancelock);
-	} else {
-		mutex_unlock(&hiddev->existancelock);
-		kfree(hiddev);
 	}
+	mutex_unlock(&hiddev->existancelock);
+	hiddev_put(hiddev);
 }
--- a/include/linux/hiddev.h
+++ b/include/linux/hiddev.h
@@ -13,6 +13,7 @@
 #ifndef _HIDDEV_H
 #define _HIDDEV_H
 
+#include <linux/refcount.h>
 #include <uapi/linux/hiddev.h>
 
 
@@ -24,6 +25,7 @@ struct hiddev {
 	int minor;
 	int exist;
 	int open;
+	refcount_t refcount;
 	struct mutex existancelock;
 	wait_queue_head_t wait;
 	struct hid_device *hid;


