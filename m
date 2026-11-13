Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585438;
	b=P4IuOaL7uvBA6/MA7mZ+Bm8lTkP0tLgsUEFOCA8cl6kkzdf3z9ZGRg5aVYPZ7SrN5mdr
	 iO3JWI9yO5oWmgf1t0vC1wNeQz7Fl17utp/yCqGojizQMWZhUkqX3grNsFd4V6Cio74wz
	 Cdz2xYVf5D3jL188FkfvgFTY6WEOkXhlwlE/vVFr4ImzzohyV2h6aSnpsvMH0BdGe1RWt
	 Uyem3EiMlSiqjuitndmfcBerG3+wo31In+7n86IfhOst9lUWmr1Yj9OOTUrSLE7PfB3fV
	 Hmk6jU4UQaPgekssQTE0bsXs3NqM6AuW24Cl1dnLGvxYYgDVkphAxY+nCMOzUKB6THQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jstOs4WMVycmWYunuewtPBFuxwsWk+/YTAJt6zzBFJM=;
	b=Hdjh8BSz5ReFc2yNKAFWyMigoP2ez/5aeGOxf6GetgT0E1+Gv/fgVG4cTJ9g2kZdbPd8
	 zapnPZlP0GbJt8tR0IgqrQ/Sb6eCmM3WQXB4OT/hdTuye0SSfv8TnUbY09kxk2Z2tyTk7
	 zKsxe+BG/VwZ8qJsdorkdM0Z94lqbRE7ruyzc8JWhdE0ULxgMnf6pZp0+7/yhxwbTlhw+
	 FX0HjMw8sUxe53USCCj2zzBmmwsk5mDpu3mVhRp7iwJQ2g+O1nhenUM9hxOEhG3TNy8BF
	 z6R0nFIlLpZQIf1c7rwymnH/ngVhSCJCYOZmpAPcvowrdGCVV32ESdyBu25laGBqXCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2V11fxA/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66243606A8A3;
	Fri, 13 Nov 2026 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2V11fxA/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C471F000C4;
	Fri, 13 Nov 2026 15:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585438;
	bh=jstOs4WMVycmWYunuewtPBFuxwsWk+/YTAJt6zzBFJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2V11fxA/8X/lS3Hd000U3SeSQC57Mgh242xC30LVKcsbM3nOFAD8lGhBDhJ/1k7fD
	 gZR0TB8QzWpFa98asm2dpcO/GajpSFN5IejT/Xcs6zfjCiXstOxz8MnJoR37BEzvZJ
	 8hTi8oVptUAVNkQsXQaQ1gwr3u+Clz1GH5VMqHFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 056/507] net/9p/usbg: remove bogus context initialization in alloc_requests
Date: Fri, 13 Nov 2026 10:46:00 -0500
Message-ID: <20261113153755.465166213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Michael Grzeschik <mgr@kernel.org>

[ Upstream commit bbdb38b2e543ffa72dca5450f2535cf998ef1cdd ]

alloc_requests() initializes usb9pfs->in_req->context to point at the
struct f_usb9pfs instance itself. usb9pfs_queue_tx() later overwrites
this with the real struct p9_req_t pointer before every transmit, and
usb9pfs_tx_complete() clears it back to NULL after each completion, so
in_req->context only ever holds a valid p9_req_t once a request has
actually been queued.

usb9pfs_clear_tx(), however, can run at any time (mount close, gadget
disable) independent of whether a request was ever queued. If it runs
before the first usb9pfs_transmit(), it reads the leftover sentinel
value, type-confuses the struct f_usb9pfs pointer as a struct
p9_req_t, and both writes through it (req->t_err = -ECONNRESET) and
hands it to p9_client_cb(), which manipulates req->wq and req->refcount
at bogus offsets inside f_usb9pfs. This reliably corrupts memory or
panics whenever the transport is torn down before any 9p request has
been transmitted, e.g. mounting and immediately unmounting, or a cable
disconnect racing the very first request.

usb9pfs->out_req->context is set the same way but is never read by
this transport (usb9pfs_rx_complete() identifies the instance via
ep->driver_data instead), so it serves no purpose either.

Both endpoints' ->driver_data are already set to usb9pfs in
enable_endpoint(), which is what the completion handlers actually use
to recover the f_usb9pfs instance. Just drop the leftover
->context assignments; usb_ep_alloc_request()/alloc_ep_req() already
return zeroed requests, so in_req->context correctly starts out NULL.

Fixes: a3be076dc174 ("net/9p/usbg: Add new usb gadget function transport")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Michael Grzeschik <mgr@kernel.org>
Message-ID: <20260922-usb9pfsfixes-v1-6-9d8dcc52904c@kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_usbg.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/9p/trans_usbg.c b/net/9p/trans_usbg.c
index af01323db69c0..2be5abae03aea 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -314,10 +314,6 @@ static int alloc_requests(struct usb_composite_dev *cdev,
 	usb9pfs->in_req->complete = usb9pfs_tx_complete;
 	usb9pfs->out_req->complete = usb9pfs_rx_complete;
 
-	/* length will be set in complete routine */
-	usb9pfs->in_req->context = usb9pfs;
-	usb9pfs->out_req->context = usb9pfs;
-
 	return 0;
 
 fail_in:
-- 
2.53.0



