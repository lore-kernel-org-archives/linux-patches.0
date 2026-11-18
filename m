Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044353;
	b=zRhlopceCvl1fvudtwAh2NavjERa5UHC8CvAJH7pTblI9GlOc3fPG+8HjbtL5w9lIR8a
	 /Px7pmWugKkaHfQPjPGf9fvfFwOMl62Rnq2d+yckbeFDQ+fxeIzE159Xll7Bby8zl/8oO
	 inO644FjvAKWIAT+3llI2a/mOZ5cJteuizLI3kyK0gJTP433YfamUQ1BsHp35RI/VnOe5
	 qbgdfOD7zo7ofFUnTOmvb/72v4oEwnDRBbuslE71NSWkBcaQdEilHzEprWqcMdWSVWuUp
	 biYB9z5Bm1ZuBNbIuOKvCqGlcFvHMqTjWbW9Sgi1Jy1lsL3ZBjSMWixPGfewSIdB/8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nPwD2FkLaBfrcnADy0b10v9QUUzj0Kld5CyKbFQ9Rk8=;
	b=EMcyUPYdhxMaW/ArckvxTYQ56TjVMy9zhOP85X8Zcic4biCb9k0FpQk+O+dBaAswDLXo
	 naLPX7jzPJlSuLl+jYLLUqsE/g2BSmxu2Juu1kSOk+2P2M+h1hZ67q6rAuT2VUPIAsk3M
	 8pmI3JOr0pJH1dlqSzHQnH3clUmuw9yzlIUaFGiIk1ME6CepeKYvvHQylFV4EuDtoq2PT
	 urXvwnsX22XfkSjlFv9NVkpgAw2NDpTDcmeDBXcFEnMfyb3bBXw/CKUNs7BUzDkgGhkQY
	 YbhiW8VZ2nu9caVaZJppEtUbFyRMfbw3EF85guUjZ95ncfduf++3wnNKHQHtRkxZkXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EpRb0eCO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2BB606A325;
	Wed, 18 Nov 2026 23:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EpRb0eCO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBA01F000C4;
	Wed, 18 Nov 2026 23:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044353;
	bh=nPwD2FkLaBfrcnADy0b10v9QUUzj0Kld5CyKbFQ9Rk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EpRb0eCOUYfZ+nFAzbaZaVN6wOaINKKBE4DaiXfYKw/SxY1lvXnje4TQFjngISKHV
	 9CfBAY/07Gob+nfxBhLDPY1z3hvgZSnGmeLW+e8gbqAdUiHQV0o1zTsWyTYb5UbXdj
	 thmILlQ1dExrraoIPPYSLw6nT2+xWM3XJwMRogUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+832ce9fa3face1b7d44d@syzkaller.appspotmail.com,
	Anuj Bolewar <bolewara@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0537/2857] media: hackrf: fix use-after-free in hackrf_alloc_urbs() error path
Date: Wed, 18 Nov 2026 15:26:11 +0100
Message-ID: <20261118150220.821597170@linuxfoundation.org>
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

From: Anuj Bolewar <bolewara@gmail.com>

commit 6802ad4b6b267dda02209b5811edac7825c8a5f6 upstream.

hackrf_alloc_urbs() frees the URBs it allocated so far when one
allocation fails, but leaves the entries in dev->urb_list[] and
dev->urbs_initialized untouched. The caller, hackrf_start_streaming(),
then calls hackrf_free_urbs() on the error path, which walks
dev->urbs_initialized entries and calls usb_free_urb() a second time on
the already-freed URBs, causing a use-after-free (slab-use-after-free
Write in usb_free_urb()).

Drop the redundant cleanup loop inside hackrf_alloc_urbs() and let
hackrf_free_urbs(), which the caller already invokes on error, own the
cleanup of the successfully allocated URBs.

Reported-by: syzbot+832ce9fa3face1b7d44d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=832ce9fa3face1b7d44d
Fixes: 969ec1f6bd92 ("[media] hackrf: HackRF SDR driver")
Cc: stable@vger.kernel.org
Signed-off-by: Anuj Bolewar <bolewara@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/hackrf/hackrf.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -665,7 +665,7 @@ static int hackrf_free_urbs(struct hackr
 
 static int hackrf_alloc_urbs(struct hackrf_dev *dev, bool rcv)
 {
-	int i, j;
+	int i;
 	unsigned int pipe;
 	usb_complete_t complete;
 
@@ -681,11 +681,8 @@ static int hackrf_alloc_urbs(struct hack
 	for (i = 0; i < MAX_BULK_BUFS; i++) {
 		dev_dbg(dev->dev, "alloc urb=%d\n", i);
 		dev->urb_list[i] = usb_alloc_urb(0, GFP_KERNEL);
-		if (!dev->urb_list[i]) {
-			for (j = 0; j < i; j++)
-				usb_free_urb(dev->urb_list[j]);
+		if (!dev->urb_list[i])
 			return -ENOMEM;
-		}
 		usb_fill_bulk_urb(dev->urb_list[i],
 				dev->udev,
 				pipe,


