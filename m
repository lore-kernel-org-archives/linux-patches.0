Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209142;
	b=j/Ht4wOvYTg1zVI/sZnkx6md294AnY5YgnppTcN2qdw/AJVO6N6sdlZ/gcP6HJL/jCV0
	 gkibJ7NlkLmX+NbWw0feJLAmkXTEzu0RSBg7EFu549d/gQacgU1x8pvwqkFMdfvFk9mUJ
	 gMAmYN66mHZcnum1RU59uA9ps0OP7k8CI92Wa2PZynRRbr95///cMJZ7L3wvMr3Ugd0zG
	 pV8pdQHgyV70nS6ryRlC7675q5/HyHEDwBb61Cxucj33C/IkVJqhTvVsE5bRW7hCY55Ay
	 3CNJ4a1tGKDUB1x1zNyskIvBFUk1nhKTuJ1DWjzgQmChCtZ0YLmhnGNRbDKxtlhbRXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AEaDTk430S/zPISKL01WA0oWai8FsbFnJJOePDh4Xuw=;
	b=Xp8Sz7pTm4BSfR284wx3bcYSvFtro+qIKsUK4U6I8Zq8QOCYDIqAOtygpfCW7cKVeGYz
	 qmmKa0XJESgTwdqP43ULEgGRehEwCNLX2HULm+XeBItz+nzEEky9LJdIZZljAlpGsEKog
	 eUwQjWJIHSit9XvbmT21yFZDtAmvGm7i7puJbzszqJWx6qYynZlMZfVPleOubbhrmYjBI
	 xfu/Nfzm4aBCE20Jjz0YcrTz7enk+6uQHfYvgnhn+EF4GVij5nRif7YS2gA10FIE6d3tw
	 bXvuLimB9DmnbLwuQcjyvwREFwhNjy8FwZRI/uJo+M/lMq9VRTNWAz8TOQvNEW75h/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U53iUzOD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E12606A321;
	Wed, 28 Oct 2026 17:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U53iUzOD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17EF1F01825;
	Wed, 28 Oct 2026 17:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209142;
	bh=AEaDTk430S/zPISKL01WA0oWai8FsbFnJJOePDh4Xuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U53iUzODTNKPL/Blh+JArEOtPv7ov5CWPDg89gOrZ5DdxTEZVNXRh+ICKFuj/rvVJ
	 bG1gPH6+INMydZewmIkOO/D8yGfb6iQ4XVnoU9aeJwILyBv0kbCBRnthDmqaKYIwMG
	 lfOAQ3ptSOVM6ZCmgWMLJuB8pi+NC3QCPiFhtJqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 330/516] memstick: rtsx_usb_ms: complete requests after eject instead of dropping them
Date: Wed, 28 Oct 2026 17:58:02 +0100
Message-ID: <20261028170011.305319318@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

commit c96ca94425b076dc398d929366e378d1e22ec794 upstream.

memstick_check() can pass its host->removing check just before
rtsx_usb_ms_drv_remove() sets eject/removing. Its next request is then
silently dropped: rtsx_usb_ms_request() skips schedule_work() once eject
is set, and drv_remove's cancel_work_sync() can also cancel a queued
handle_req before it picks the request up. Nobody completes
card->mrq_complete.

Once memstick core waits for requests without a timeout ("memstick: core:
wait for request completion before freeing card"), this hangs removal:
memstick_check() never returns and memstick_remove_host() blocks in
flush_workqueue():

  INFO: task kworker/u10:3:65 blocked for more than 20 seconds.
  Workqueue: kmemstick memstick_check
   __wait_for_common
   memstick_check

  INFO: task kworker/1:1:33 blocked for more than 20 seconds.
  Workqueue: usb_hub_wq hub_event
   __flush_workqueue
   memstick_remove_host
   rtsx_usb_ms_drv_remove

Never drop a request. rtsx_usb_ms_request() always schedules handle_req,
and handle_req fails requests with -ENOMEDIUM once eject is set, without
touching the device. drv_remove flushes handle_req instead of cancelling
it, and cancels it only after memstick_remove_host(), when no new
request can arrive, so it cannot run on a freed host.

The host_mutex drain in drv_remove is removed: handle_req always leaves
host->req NULL when it finishes, so the drain never had anything to do,
and it would now race with handle_req.

Fixes: 99451dceeb5f ("memstick: Add realtek USB memstick host driver")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260924204142.607-1-rajojha047@gmail.com/
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memstick/host/rtsx_usb_ms.c |   31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

--- a/drivers/memstick/host/rtsx_usb_ms.c
+++ b/drivers/memstick/host/rtsx_usb_ms.c
@@ -27,7 +27,6 @@ struct rtsx_usb_ms {
 	struct memstick_host	*msh;
 	struct memstick_request	*req;
 
-	struct mutex		host_mutex;
 	struct work_struct	handle_req;
 	struct delayed_work	poll_card;
 
@@ -511,6 +510,13 @@ static void rtsx_usb_ms_handle_req(struc
 	struct memstick_host *msh = host->msh;
 	int rc;
 
+	/* Fail requests after eject so their waiters are released. */
+	if (host->eject) {
+		while (!memstick_next_req(msh, &host->req))
+			host->req->error = -ENOMEDIUM;
+		return;
+	}
+
 	if (!host->req) {
 		pm_runtime_get_sync(ms_dev(host));
 		do {
@@ -544,8 +550,7 @@ static void rtsx_usb_ms_request(struct m
 
 	dev_dbg(ms_dev(host), "--> %s\n", __func__);
 
-	if (!host->eject)
-		schedule_work(&host->handle_req);
+	schedule_work(&host->handle_req);
 }
 
 static int rtsx_usb_ms_set_param(struct memstick_host *msh,
@@ -778,7 +783,6 @@ static int rtsx_usb_ms_drv_probe(struct
 	host->power_mode = MEMSTICK_POWER_OFF;
 	platform_set_drvdata(pdev, host);
 
-	mutex_init(&host->host_mutex);
 	INIT_WORK(&host->handle_req, rtsx_usb_ms_handle_req);
 
 	INIT_DELAYED_WORK(&host->poll_card, rtsx_usb_ms_poll_card);
@@ -809,27 +813,12 @@ static int rtsx_usb_ms_drv_remove(struct
 {
 	struct rtsx_usb_ms *host = platform_get_drvdata(pdev);
 	struct memstick_host *msh = host->msh;
-	int err;
 
 	host->eject = true;
 	msh->removing = true;
-	cancel_work_sync(&host->handle_req);
+	flush_work(&host->handle_req);
 	cancel_delayed_work_sync(&host->poll_card);
 
-	mutex_lock(&host->host_mutex);
-	if (host->req) {
-		dev_dbg(ms_dev(host),
-			"%s: Controller removed during transfer\n",
-			dev_name(&msh->dev));
-		host->req->error = -ENOMEDIUM;
-		do {
-			err = memstick_next_req(msh, &host->req);
-			if (!err)
-				host->req->error = -ENOMEDIUM;
-		} while (!err);
-	}
-	mutex_unlock(&host->host_mutex);
-
 	/* Balance possible unbalanced usage count
 	 * e.g. unconditional module removal
 	 */
@@ -838,6 +827,8 @@ static int rtsx_usb_ms_drv_remove(struct
 
 	pm_runtime_disable(ms_dev(host));
 	memstick_remove_host(msh);
+	/* No card, no new requests; wait for the last failed one to finish. */
+	cancel_work_sync(&host->handle_req);
 	dev_dbg(ms_dev(host),
 		": Realtek USB Memstick controller has been removed\n");
 	memstick_free_host(msh);


