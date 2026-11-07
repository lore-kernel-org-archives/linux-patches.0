Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064326;
	b=TeefULsEjU1rL6w+b+5ezmO5Bpt9mCWOydaQiFe8hKNrYuIQSyQU65sTdsTASIQeZ+gw
	 7ktgwOEV55xJgSLfLuowxoH6tHP9ejRPOVfCnemhIkqqoFp9A+8uuNo8chZQS7N5OtpN6
	 LdGXqgjbz7aEr9z5O6AV0wNrIufi9Jh7zbFW1i4eIdUtoAQ9JOlty0TFp1wrVdY+PBlyM
	 UZ41f4UwDv0MfvNlZa4hXjejNxEE2XSCWOjC8z/AEi9EbUSbkwzawGak/bkZ48PIvUstZ
	 JAXiv5FtJ2zfa9q8S4CvuxQksD3ZiA089Kk5KSNd0JUAlCsBugLYg3IU8ImGlLmor6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V9GH03sjWGgScWE3ikrr29+7Llu1zqqbatx1pOLkVZ8=;
	b=3p+fxVq8OLjCQfnCP7C0+C1yB5WvE9QtFenQiQa/E/VkaZ9glcX6KolZ6kHwmwp8mL0C
	 oSahFvCpPZU7HEGYzBJs6wUcScIDhfZZJR1rsK0VmkPCaF3G/AyfxcZGjkWWwqJHZ/2Op
	 chmGJUribdme7O/JvyANmDP9a+LdOa35V1zrcZH3gy6TeqL3uj7I6hIZ66X2XjSR7sYMp
	 jxcgvlz1hgHnhnCDJEqt2oFuayQtiPuqtLTIS5qUf4l/AXh6IPUUeyPHiOAZyrGMyLruY
	 9jr10ixnsO9A1GJ8ApYRk8sDZ0xw/tgfaqPHz3XD7ModOoMk5MJlP5gK/JDYkcnGOCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uG9oH8Ms;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9885E606B880;
	Sat,  7 Nov 2026 15:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uG9oH8Ms
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4452C1F0089F;
	Sat,  7 Nov 2026 15:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064326;
	bh=V9GH03sjWGgScWE3ikrr29+7Llu1zqqbatx1pOLkVZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uG9oH8MsP5vVpS6zZb9GtlS3u5jby5bdVgI8obKewt13ZP+dyjR0a3turyuQQ/jwZ
	 QeRP5Bw1Z8ztdC+7CTECcn/RwfnCuuMvW6szPYm7AxsK2TKjZxNNeGEsRO6lewqpk1
	 nvWSHIkhA3MC1mHvL3JokVodZ6IAmD7PLluO4bFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0413/1257] media: exynos4-is: Fix a race between s_stream(0) and the interrupt handler
Date: Sat,  7 Nov 2026 08:45:09 -0500
Message-ID: <20261107134950.922622118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
 drivers/media/platform/samsung/exynos4-is/fimc-lite.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/samsung/exynos4-is/fimc-lite.c b/drivers/media/platform/samsung/exynos4-is/fimc-lite.c
index 8be20fd32d1c7..ce3634909c8cf 100644
--- a/drivers/media/platform/samsung/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/samsung/exynos4-is/fimc-lite.c
@@ -1209,9 +1209,8 @@ static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
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



