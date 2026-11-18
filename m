Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020667;
	b=G69Y90iT7x/yf7KDW8RYunZhIVImjoNW4ZMcWG8iLFZKA8a/LX2RTFOfkZg4DUDGZQud
	 7qedLRQsXB2KHIa9jFbvH7qy8nb2WA+54sG/840EKyNbjQlgT7J/OWf83pU/eQojQlyXJ
	 ftUPtfE7IFXEGXbkfRoM4qYNLWe8vw2pykJFOFerX6GZEP0yVnhQRDgUrzWat6nRlbyaS
	 Zr87VwVAur2RONT1M3r696aAsS8TN0KouAMJDC/a94b97vu88ytjTTTbo9PQeYFDi9J7q
	 dch5pEyzbWjQXcKAG1Q1wOQAvn1TRT/SUp04tmYhmNUcrodqDCy5ABPj2teB/mfw0hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uvvNlQBwGJV5GIrUToGm8QmALSpy9BfKvVEMPs+wEXs=;
	b=AslUKJDUhVTp5vTcYPoCGv6bCBbzYAdnrUg80RbbTAM2seXfSLH5Qgey3G+HsAuPU7Up
	 JtNR+93YlO9HGZ6z7eyc0xK+Rg32Wg+C1FTFjqwbpcQNH4L4T/Q0a6G7n7RTMSLTPp03C
	 Dza8CxEM2OzvxgtuBO9uCTtBFPGHJ+v6q/9BCGJoGtqIVAVzXDp859R5Fx6IlVXhGurmw
	 dbosnNjkIj9MTMJsz+djupnqD4c++IYn4fxJMYNJqgGs/fsizJo23R+kfoq5LyIz+A3jl
	 9zPeMZYPEAgUP00qjSgPLbxlSDWDyhJrmrZ1iFAkBx/ssJZvnCc0RxyaRrCC7sQYmVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dCcpsjLK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7514960A263F;
	Wed, 18 Nov 2026 16:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dCcpsjLK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEAC1F000C4;
	Wed, 18 Nov 2026 16:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020667;
	bh=uvvNlQBwGJV5GIrUToGm8QmALSpy9BfKvVEMPs+wEXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dCcpsjLKCvpXoP0kz22k9rhHjMQJa9Rb02SuZhQNd1IwRBDxXVzBhJ1EHSO9lZ4eB
	 e7IiRgJ2Em4bR5PnazOLOuxDvC650NUhxoG9v5Y3onmjIt+HSV5ZjpcOsJceUnHJMJ
	 bDHGflg2wWz+8rOuca4VHz+izudVpKSboDvmf5Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2033/2651] HID: asus: document and harden the worker teardown
Date: Wed, 18 Nov 2026 15:54:33 +0100
Message-ID: <20261118150359.325374523@linuxfoundation.org>
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

From: Denis Benato <denis.benato@linux.dev>

[ Upstream commit 6f2204e35a164cb593929918112bb3f217f7ae84 ]

asus_work() executes actions against the device: they send feature
reports with hid_hw_raw_request() and, for the Fn+F5 fan key fallback,
re-inject the raw report into the HID core with hid_report_raw_event().

For this reason the worker must be quiesced before hid_hw_stop(): after
the low level driver has stopped, the transport is gone (usbhid_stop()
frees the URBs and the I/O buffers) and re-injected reports would race
against the input devices being unregistered by hid_disconnect().

Make so that the teardown cannot race to a use-after-free: every site
queueing an action holds worker->lock across the .removed check, the
list insertion and schedule_work(), and asus_worker_stop() sets .removed
and drains the queue under that same lock before calling
cancel_work_sync(). An action that passed the check is caught by the
latter while any later attempt is discarded by asus_worker_schedule().

Closes: https://lore.kernel.org/all/20260908180032.34C2D1F00A3A@smtp.kernel.org/
Fixes: 47669bec44fe ("HID: asus: refactor the two workqueues and init sequence")
Assisted-by: zcode:glm-5.3-flash
Signed-off-by: Denis Benato <denis.benato@linux.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 7dc6417fe2622..baa8589d45ae2 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -765,9 +765,14 @@ static void asus_work(struct work_struct *work)
 	struct asus_work_action *action = NULL;
 	unsigned long flags;
 
-	/* Save the action to be performed and clear the flag */
+	/*
+	 * Dequeue the next action, if any. Once teardown has begun .removed
+	 * is set and asus_worker_stop() drains the queue: leave the queued
+	 * actions alone, they are dropped instead of being executed against
+	 * a device that is being removed.
+	 */
 	spin_lock_irqsave(&worker->lock, flags);
-	if (!list_empty(&worker->actions)) {
+	if (!worker->removed && !list_empty(&worker->actions)) {
 		action = list_first_entry(&worker->actions,
 					  struct asus_work_action, node);
 		list_del(&action->node);
@@ -817,6 +822,25 @@ static int asus_worker_create(struct hid_device *hdev, struct asus_drvdata *drvd
 	return 0;
 }
 
+/**
+ * asus_worker_stop - quiesce the worker
+ * @worker: the worker to quiesce
+ *
+ * Once this function returns no more actions can be queued and no instance
+ * of asus_work() is running or pending.
+ *
+ * Callers must do this before hid_hw_stop(): actions are executed while the
+ * device is fully operational, since they send raw requests to it and, in
+ * the fan-key fallback path, re-inject raw reports into the HID core. After
+ * hid_hw_stop() the transport is gone (usbhid_stop() frees the URBs and the
+ * I/O buffers) and the input devices have been unregistered.
+ *
+ * The quiescing is race free because every site that queues an action holds
+ * worker->lock across the .removed check, the list insertion and
+ * schedule_work(): anything scheduled before .removed is set here is caught
+ * by the cancel_work_sync() below, anything after it is discarded by
+ * asus_worker_schedule().
+ */
 static void asus_worker_stop(struct asus_worker *worker)
 {
 	struct asus_work_action *action, *tmp;
-- 
2.53.0



