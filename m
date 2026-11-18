Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044272;
	b=G4W2GLaBAnihpcxqLbI1KyvoDBKmYVFT+2Ov1ExLIeg4+LaZ+S7T2XUFrIee1r2XCpNF
	 88xZYbzluQ/4sIvaNTPr4wzxUWZXtXzM5jQ1HxFR/zijivUzWt74awPf3TUACQ+61qvWh
	 uB09sJvJ999LeEsEIoynbL4j+hDwsfKEbClbMEcRkaWPd/3Tswa1ru7DvdczA9irgPzZu
	 XKN7+9IOOv7whTRvuOKZ9VOUPw6DC9K+H8s7fVVuhnhuEUgtymGpzkvODjFURwxuJxYMW
	 sGyiaKcM3EbrinSq9NfADN+My6QYrFhN2A380mL71BjahB1jWm/+QLn+pNQbQmXroTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nVwQwZfzCzoji5ktzlclfm1ba71bMoiCKQpeWHZF050=;
	b=d7NES1ajeSaKEm4bf8RLqwiuJYujtgb3G+23L+nT8Xk520TsjoJZEfvVpvsWcQv9UbPv
	 nDcIzXR7CVXuS5O5azjolLyrkG+bDUVW7JLHWHdlx3N+UEkw8od9lyTDO3lhC3msTKmwg
	 nWVg2gla8pXdEjrXtXXebDhdOn4T/6YA6IoHvQPKLGYi+BC9ktkpgmb+6sToodvjy4epz
	 +xXGxo5HYWfD6fmUs5NUUxfWXj9M8qDlivrZ0vRiiRE8E9KkWueLszn/hkU1ynORXylaN
	 IASbuG7DJc6S6XiF3m0CDnb4WlZDHukHsggw5JcL6VfQOUJk5NTFwyTvwaEok26fDdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AEySiecm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B77A606A332;
	Wed, 18 Nov 2026 23:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AEySiecm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5B11F000C5;
	Wed, 18 Nov 2026 23:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044272;
	bh=nVwQwZfzCzoji5ktzlclfm1ba71bMoiCKQpeWHZF050=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AEySiecmFcNrPPWAJl4VG4BL0P45XferTc0kcGiYPtNzofsXVZI4gdVV4v3E4/uaz
	 QIjyF01tOdXsmyLC54Kch4jYPwcwUBJ94psJzZU27bIq+isIkRijAdtpNoGq6/IdXK
	 LBlK3JcGEfK+MyOGj/v/BGD91uIU/GerVrCacAxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 0506/2857] backlight: lm3630a: Cancel delayed work before destroying workqueue
Date: Wed, 18 Nov 2026 15:25:40 +0100
Message-ID: <20261118150219.679124976@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 2cf184caab8b406fdd9db126ee40d62418237456 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/backlight/lm3630a_bl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -589,6 +589,7 @@ static void lm3630a_remove(struct i2c_cl
 
 	if (pchip->irq) {
 		free_irq(pchip->irq, pchip);
+		cancel_delayed_work_sync(&pchip->work);
 		destroy_workqueue(pchip->irqthread);
 	}
 }


