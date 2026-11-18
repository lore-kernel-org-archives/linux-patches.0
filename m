Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044406;
	b=uQXub4cIsNzWDCdlzU6xp0tyy+1MgK4YtUkNu68xul1eg4kD1dFhmqQQj8qhMmIWk+b7
	 p/aP3D6vPCNnhITsT+QdJ7RmKTJBAJC9dP25Foo4WNRv8jxA2kWuFoewZVvLSeSRu3YRy
	 8IqbZipJyHAfywqg9y0eI9i16HfdQQiRbCp9zMVd0Gb2+nvM757dUvuDxOBxDKGqfTAMM
	 1Fg2orAgf0eT1j/tjXoJ4pViyzwpHDW0Wn9yLYw9A+z2ADdUORuIDF2iuPy/8b+MJe4Ek
	 s5paiaPapxiMdxnFU+vU5qufZk/ybOkfYZZmK+/NzXc3aO373ZCfVorM1siifYgfV6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KRSUDDjI84ePS7v0yhO0oqHOiOBjwOf73HEVVbo7Jhw=;
	b=TO4N3mKSsPujSCqOJS+4ZLPReMqJlKOwdfpaizvto1EF+2hZCglZfytUQmb9g4oWcmR5
	 Tin9nWQ6SMDOXD/KEThWex7Fv/SYESiTBYds/9X8MuFpiW6kV1KUxMyV+EjQxKSRLvDFN
	 8K83M355Ha8DiLL9jW4B01jb2weG/tYK+7VzvnxDjkQJ1Khj/RCoqvYiU5dqb5qbVx3jK
	 TjbopOyeYDXCYJWSlWtt0JpvUY7/tq2LzPVUfC3tbLMj1tdKKNrNJKn396jTlGp8WlDq3
	 JQ8vhWMOwQN+wxSYDSqWjNP5S2/lDtkkfxSihDL0SdUK/WK9gL+T/leFnLwMymbNEHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=esE9osPk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B46606A31C;
	Wed, 18 Nov 2026 23:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=esE9osPk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6811F000C4;
	Wed, 18 Nov 2026 23:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044406;
	bh=KRSUDDjI84ePS7v0yhO0oqHOiOBjwOf73HEVVbo7Jhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=esE9osPkb0h2DIBIM7QrSenWRCLa75EYghvcagEiGUz8UKEssJ6TvUd/3ZWSXfoqj
	 +Yh78J6oEkj/f5v1htKQezqziMkP4m++JW3sJiTlXkiPkTQW3lr85KkzLN8kyRANJj
	 NbLjwjvexROkIXfPQaeCJDiDo4cwhs2aCYqwwN04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+563191a4939ddbfe73d4@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 0555/2857] HID: hiddev: keep state alive through disconnect unlock
Date: Wed, 18 Nov 2026 15:26:29 +0100
Message-ID: <20261118150221.474159658@linuxfoundation.org>
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


