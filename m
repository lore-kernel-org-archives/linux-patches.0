Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052422;
	b=WA2WOPSuUbAg7nsCoMhtWcumy7NdGRuYUf713D3eS8G/NYeWMzFjBc99afn2HLlxbCRC
	 jOwWpf7obN1BmzNIW/71T6e8MdktdKVKBhvd1ytzuJGPI+OR7r0iciNxzpjQZ5q0895vB
	 YdfqLgiap9jRo9jHWUDb25n8o9d/33aOK+WAxMALjyC/ULaI/L4wd4LaROUDkWJFqVZ6R
	 mGLv1FB951tv/TJdO4vhr1oFgHRmGI1TL731kPobtGGLqv2ZrG/qs4fKTx74T4VS7gmlF
	 ujCSGNryFDIqTNkAXbMrP/CUMbXvHyImweEgAo6MPphbC3ab7Y0lsxWjmmHUZqhYX6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dy9h/+iSqLYMuyzDqUw0wMxZmcMUuNZmg3Z1w8tIgl0=;
	b=J+csGnvHCOtG7p9j+1pgF1OvX+lLA8S6FSW2UzEw1Y0G/qbm9+S6JwV0LUQ49TfSuFUS
	 lXNxQh8aWwAZHMvEWitCt4+NuO8jh1F2Dda5EWst6N7m1B7vRexlvTs8tEmDujrzRNidO
	 rl4QRUKIG8UFRyOP8q0HnPn6C/2+C8RO14vfoRtLdtbLdnHvcLKYYUgi27qopEeUwGZi+
	 82HZdSDRwc/o1mxCrlo5j5QEg+SpFXKPVdTVFkZuck8gZ/DZ+0/l1LxnDtLtEpl0+8M3c
	 OyYuQVL4LjpA6G27zZQz03bLSDqc356J7Aviz+ZsJJKFexCU5/Lz6IDdOhrFHiPLRnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xC9bp8nl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F06C606A31C;
	Thu, 19 Nov 2026 01:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xC9bp8nl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7811F000C4;
	Thu, 19 Nov 2026 01:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052422;
	bh=dy9h/+iSqLYMuyzDqUw0wMxZmcMUuNZmg3Z1w8tIgl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xC9bp8nlTn1TI1kHIllJpFmqR2K04fzP+rOsiL/aM8CX13GVuBTGhBvad/WnGmRUY
	 bYcBm1wcP0HTfAcD3nloMJnVHne0RBGrGDS1CM/XaakfePOBza5R4IwSj0+znNhTEE
	 guvdwoMVNSrMckvEs2/gmUyRbXglTiMWcmrYxdGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0557/2214] media: exynos4-is: Fix a race between s_stream(0) and the interrupt handler
Date: Wed, 18 Nov 2026 15:37:13 +0100
Message-ID: <20261118150033.295936570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ginger Li <ginger.jzllee@gmail.com>

[ Upstream commit c65eb69f8170975802ddbede84420553eb681d62 ]

fimc_lite_subdev_s_stream(on = 0) sets ST_FLITE_OFF outside of the
fimc->slock protected region, and only then stops the capture in the
hardware.  flite_irq_handler() runs under fimc->slock and clears
ST_FLITE_OFF, so an interrupt can be handled in between: the handler finds
ST_FLITE_OFF already set, clears it and wakes up fimc->irq_queue before the
capture has actually been stopped.  The wait_event_timeout() right after it
then returns immediately and the driver continues as if the capture had
stopped.

Set ST_FLITE_OFF in the same critical section that stops the capture, as
fimc_lite_stop_capture() already does.

Fixes: 6319d6a002be ("[media] fimc-lite: Add ISP FIFO output support")
Cc: stable@vger.kernel.org
Signed-off-by: Ginger Li <ginger.jzllee@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/exynos4-is/fimc-lite.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index aaa3af0493cee..7d94b539eff54 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1215,9 +1215,8 @@ static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
 			spin_unlock_irqrestore(&fimc->slock, flags);
 		}
 	} else {
-		set_bit(ST_FLITE_OFF, &fimc->state);
-
 		spin_lock_irqsave(&fimc->slock, flags);
+		set_bit(ST_FLITE_OFF, &fimc->state);
 		flite_hw_capture_stop(fimc);
 		spin_unlock_irqrestore(&fimc->slock, flags);
 
-- 
2.53.0



