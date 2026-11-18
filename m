Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057998;
	b=0w/2Dpxma4tIiNVA7UlhIxUO9vHGu+u9CxfsiZP5zJDrFWCQsoZ3I/OsIiJFhnsBSH+a
	 PJtaWlNJqTC2I2fJiUnTmv9qWPxNZ+BZGQIch/2UhPrO9NAHOJ/G188+iV46zw8cn6hN3
	 Mx5MCPIZAdIfzSQCldjMmQRwzrOGFPgU+IPOd/ClYole7yrWBTrG+K88X6ayT5HLx0s0t
	 2ZLMSuVZHKYKpJankWnWi6zk1xYgkl+fYBj54uati9TG532i0KocuHKBryD3s3pnEcjod
	 0X9tAJU3Us10Lpx33K/oA95Tmj3eXdkQCMvBtgnOPKZBsNBrDP6wplqGO6dHWty9CPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uWYUTQE476GjAOCM5mt4yVsZS/x0yT3EA7OCx72CO/4=;
	b=xwWYGtYVm9JJn51mgO9MqJkBAZJrrJNN1SAfQeNa+PZpR4uR85/nrX206tLEfbE++p6a
	 4CPy2EgeLvp6vWSdCmuyB7JZL2UAN5gUznXukYoeLai+2Xuq4f+oHlEKy7GVaB4LX99r/
	 K2bluNUJORYBK1EneUOS71Zlag2NaJvIQNf6SJQNEMv/eCTQlaZkysBbLxO7/Gvw8OkDm
	 Z+QJNGqFkQT3+jly5jikhwhj8VyL4bgNsFIw8Kd1bBXvoaqf7oX8QqLzCcgJ2hBWNhC2q
	 UaPJNteLsZeTrUzODBpezMFZAVOKFn1FaPEGtg0RgOl0L/KHNz86qtO+e0OZPON19sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itel9roO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F342A606A31C;
	Thu, 19 Nov 2026 03:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itel9roO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F415C1F000C4;
	Thu, 19 Nov 2026 03:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057997;
	bh=uWYUTQE476GjAOCM5mt4yVsZS/x0yT3EA7OCx72CO/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itel9roO1CbL5G3J4vStF1RrmsdLyt7rJShbAd60Vp8rwGSSmgRLab+2domzStEZr
	 PZCO8JOd8qt5iA9jUDW9vxNeB1RSO4h93cfdppTsPYWOtHT+YO0MeFWIARk84n6qqv
	 1G2H3H/fvDuqY/n+Y0Vdvr7asTD1rRyXA+38SfM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0329/1848] backlight: lm3630a: Cancel delayed work before destroying workqueue
Date: Wed, 18 Nov 2026 15:39:27 +0100
Message-ID: <20261118145925.949697840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 2cf184caab8b406fdd9db126ee40d62418237456 ]

The interrupt handler queues delayed work to read the interrupt status.
After free_irq() stops the producer, this work can still be waiting on its
timer. destroy_workqueue() cannot drain delayed work that has not yet been
queued by its timer, so the timer can outlive both the workqueue and the
devm-allocated chip containing the work.

Cancel the delayed work synchronously after freeing the IRQ and before
destroying the workqueue. This also waits for any running status read to
finish before the chip's resources are released.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 0c2a665a648e ("backlight: add Backlight driver for lm3630 chip")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Link: https://patch.msgid.link/20261003030439.599330-1-mhun512@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/lm3630a_bl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight/lm3630a_bl.c
index 1de26785c3032..3ee04acbc1d9d 100644
--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -593,6 +593,7 @@ static int lm3630a_remove(struct i2c_client *client)
 
 	if (pchip->irq) {
 		free_irq(pchip->irq, pchip);
+		cancel_delayed_work_sync(&pchip->work);
 		destroy_workqueue(pchip->irqthread);
 	}
 	return 0;
-- 
2.53.0



