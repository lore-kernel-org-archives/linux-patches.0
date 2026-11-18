Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050854;
	b=XhM0crAdluakxANeXOQw1N84nxazJT1NyDjafHB7hTKis5/jvtDfVWniZ9lenkN7VzWb
	 0+765IylMc5Pjzc/hbI8NtRS8uu6fOHRZnYxM85cKj7aFOPeNxX9HNrsH2IaUVVc0sj6z
	 2WmdZHGqSsUDQ3Sz28KEFrqbZUkrZHMp8x8SUjuNdBkiqAm79IPT4xd3WMqjrr13BrRUG
	 2dScjsZ3Bxu10UWVqdhAhj9EQUXnwcTcvzAc84rKBZJVgxZAzazVAkZpqf1oIhb2kRC8V
	 /sUPF10l0g9zEw7k3rYRfJBXufTY9vXxkXi3lME0dWhp5JK1MjYxel1Lb/JV2d3ODxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G0T5fz91c92aqjwVqrDMnUhn7qheMkuZJU0TfbLXMHE=;
	b=qsxIlfxJ46Ptm5hOZFtlGUwG+kzrH3fTraA9XXhJ5SEKABHfIWOF3Lpplj1MLrws0oMZ
	 Q/7i78wHiezYaopfZYvA3PHwfJ6z5wd6rASm6PgeEmXhtLfHUtw6k/StZR/SOPwOqyvt+
	 UU2ZYUe3ys82eH7JmFJU+KD48OyXncHKkO5hbTSslJq9Wj/4sSAiu45V2wkq8bBPXK/OE
	 QzIN9DUpKZoiIyW1C0SugftZ4ttzLq0g5vZCC5K0bLM7TyVeoRnygH3r7E9Y6DrT5QUdM
	 3sqe0ENY+azJM85LaqLH+LDrCUgA1gutPgUsezKgkOiC6rCJSHcaHAPc4CD/qlFkDZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oGgFD8wY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11917606A320;
	Thu, 19 Nov 2026 01:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oGgFD8wY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6175A1F000C4;
	Thu, 19 Nov 2026 01:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050853;
	bh=G0T5fz91c92aqjwVqrDMnUhn7qheMkuZJU0TfbLXMHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGgFD8wYBO2LIJL+m6GV0o3iaAR/PcLlm4Q4eY2ovQ3/YTFxWcMnoXmIm0P/SkwrZ
	 UFL+RiMGyaJ7RnCZLzvkJ5hyR+xs+tcY1M1TrbvK6dyLwjwfkxAr6xPG+Du9qiAi/e
	 g05kgip1/M7Brjx1sxAsD125QGLnoLv6g7dROuNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+14ce1b05b7d5a989abbe@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 2857/2857] Bluetooth: hci_core: Fix race condition during device registration
Date: Wed, 18 Nov 2026 16:04:51 +0100
Message-ID: <20261118150344.446976737@linuxfoundation.org>
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

commit 57938bbdb9bf7fd41cbd5cd509ec10c4b22bec18 upstream.

In hci_register_dev(), the power_on work item is queued to
hdev->req_workqueue before initializing hdev->adv_monitors_idr and
registering the MSFT extension via msft_register(). For devices marked with
quirks such as HCI_QUIRK_RAW_DEVICE, the HCI_UNCONFIGURED flag is set on
the device. When the power_on work item runs concurrently on another CPU,
hci_power_on() detects that the device is unconfigured and immediately
invokes hci_dev_do_close(), which calls msft_do_close().

Concurrently, msft_register() allocates the msft structure and exposes it
to hdev->msft_data prior to calling mutex_init(&msft->filter_lock). If
msft_do_close() executes while hdev->msft_data is already assigned but the
mutex has not yet been initialized, mutex_lock(&msft->filter_lock) operates
on an uninitialized mutex, triggering a DEBUG_LOCKS warning:

DEBUG_LOCKS_WARN_ON(lock->magic != lock)
WARNING: kernel/locking/mutex.c:625 at __mutex_lock_common
kernel/locking/mutex.c:625 [inline]
WARNING: kernel/locking/mutex.c:625 at __mutex_lock+0x12d8/0x1550
kernel/locking/mutex.c:821
...
Call Trace:
 <TASK>
 msft_do_close+0x308/0x7b0 net/bluetooth/msft.c:693
 hci_dev_close_sync+0x86b/0x10a0 net/bluetooth/hci_sync.c:5522
 hci_dev_do_close net/bluetooth/hci_core.c:499 [inline]
 hci_power_on+0x32c/0x750 net/bluetooth/hci_core.c:937
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0x92d/0xe10 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Fix this by moving the queue_work() call in hci_register_dev() to after
idr_init(&hdev->adv_monitors_idr) and msft_register(hdev) so that device
structures and extensions are fully initialized before asynchronous tasks
can access them. Additionally, assign hdev->msft_data in msft_register()
only after mutex_init(&msft->filter_lock) has completed.

Fixes: 9e14606d8f38 ("Bluetooth: msft: Extended monitor tracking by address filter")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+14ce1b05b7d5a989abbe@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=14ce1b05b7d5a989abbe
Link: https://syzkaller.appspot.com/ai_job?id=2bc9e8aa-ca6d-43e2-be2c-fd5d9f649d7e
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |    4 ++--
 net/bluetooth/msft.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2683,11 +2683,11 @@ int hci_register_dev(struct hci_dev *hde
 	if (error)
 		BT_WARN("register suspend notifier failed error:%d\n", error);
 
-	queue_work(hdev->req_workqueue, &hdev->power_on);
-
 	idr_init(&hdev->adv_monitors_idr);
 	msft_register(hdev);
 
+	queue_work(hdev->req_workqueue, &hdev->power_on);
+
 	return id;
 
 err_wqueue:
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -782,8 +782,8 @@ void msft_register(struct hci_dev *hdev)
 
 	INIT_LIST_HEAD(&msft->handle_map);
 	INIT_LIST_HEAD(&msft->address_filters);
-	hdev->msft_data = msft;
 	mutex_init(&msft->filter_lock);
+	hdev->msft_data = msft;
 }
 
 void msft_release(struct hci_dev *hdev)


