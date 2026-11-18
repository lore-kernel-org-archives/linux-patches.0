Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043912;
	b=2pRdH/QOOLZxJM6IxHQ+9V1u9yfmwLOlkx6kVtJ7VwFW6DDR1x5ugslSa/jXMdF/S/TR
	 +G9omBZZM9cimYBewqrCtvitOMHYGcidq/+yWrDagYZamYlSmbLVD29xzACwMZHlsWtdH
	 MpBEjtAOuGiIWPbzEnBr/DIGk8vHw5fhpdbWgF2BmoIIhCLc6P6UVMtkFZUZcFFkh+6aj
	 lA3gbZGBGhOyEvxupxjuV6oi7Xb+Ur+u7Ojos4ZHklyDqjAKeOZnhBqkDR5RchgdBuZYN
	 YGxBV2GRVRBWcx4NYuASGCw3izHYe3mrEKq7Y/+VDosPJMKVlIhG/qOfxKKa1/hZ0sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ke9Y/+QNnnqfexqf6kuvaQMoTIgG542QPbkwEhIvq0k=;
	b=N/UtsnFpD161F+I9W6IHcsX/HvUvwRyElnQxMFz2g1CigNKNR9ILQw2XO8mbsL5aSxyD
	 Nh+hR9ebCtgLpoOG5mUVaUEPIeTXV8nqXJ4c+JNFOedynS0WdmjXs/lsgOt//u3m+ShZz
	 qIXphmuCIYS6LdTAtUYOsiLQ9OC2hmL8QBUnA7DWuDMIhWRq+0GkEP4IMwQ7SK2RrUvqG
	 JBDJ73PHmxtRkg85TeHJzchSCjLA4oS+L0FaQATCoGMWoyXrTArR8Cb28vvx5qNg5Pwl6
	 9SOGncWe5IwSpdAvXQOcJcyCN25zDqEYdTBmrnfKWZxRHQ9gZ3nSccPA/HMJmDxcPww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zjy0+c4a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E523606A325;
	Wed, 18 Nov 2026 23:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zjy0+c4a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04EF1F000C4;
	Wed, 18 Nov 2026 23:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043912;
	bh=ke9Y/+QNnnqfexqf6kuvaQMoTIgG542QPbkwEhIvq0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zjy0+c4atH3Fcge4TtGeCi8mEV7aDaV4+8XGcdNdZr79kPh0/K1dL+D8P7mRlBRjX
	 lX2pPsm7Q6ay/CzSv3iLmekJ3XZI+864kVSTo4iiNw1h8kXnUxODhxswT2d5Mu1YDE
	 qYeonGXspLz9Sqm2VTE+JrkdjMq0d2sAx7/UmdGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	Marco Chen <marcochen.dev@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0381/2857] iio: health: max30102: fix NULL dereference in interrupt handler
Date: Wed, 18 Nov 2026 15:23:35 +0100
Message-ID: <20261118150215.122971835@linuxfoundation.org>
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

From: Marco Chen <marcochen.dev@gmail.com>

[ Upstream commit f0ea4824deebf21dacfbe397c4b0a5fd3e745a8d ]

The interrupt is requested in max30102_probe() and stays enabled
for the lifetime of the device, but indio_dev->active_scan_mask is only
valid while a buffer is enabled. When an interrupt arrives while no
buffer is enabled, the handler dereferences the NULL active_scan_mask:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
  Call trace:
   __bitmap_weight+0x64/0x98 (P)
   max30102_interrupt_handler+0x48/0x160 [max30102]

Call max30102_fifo_count() at the top of the handler and return early
unless it reports a FIFO sample is ready. Because FIFO_RDY is the only
interrupt source enabled in max30102_chip_init(), an invocation of
max30102_interrupt_handler() without the FIFO_RDY interrupt status bit
set carries no data to read and can return before touching
active_scan_mask. A negative return from max30102_fifo_count()
indicates a failed interrupt status read and is treated the same way.

Fixes: 90579b69e94b ("iio: health: max30102: Add MAX30105 support")
Suggested-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Marco Chen <marcochen.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/health/max30102.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/health/max30102.c b/drivers/iio/health/max30102.c
index 9a076973acd19..0e613dd746944 100644
--- a/drivers/iio/health/max30102.c
+++ b/drivers/iio/health/max30102.c
@@ -292,9 +292,15 @@ static irqreturn_t max30102_interrupt_handler(int irq, void *private)
 {
 	struct iio_dev *indio_dev = private;
 	struct max30102_data *data = iio_priv(indio_dev);
-	unsigned int measurements = bitmap_weight(indio_dev->active_scan_mask,
-						  iio_get_masklength(indio_dev));
-	int ret, cnt = 0;
+	unsigned int measurements;
+	int ret, cnt;
+
+	cnt = max30102_fifo_count(data);
+	if (cnt <= 0)
+		return IRQ_HANDLED;
+
+	measurements = bitmap_weight(indio_dev->active_scan_mask,
+				     iio_get_masklength(indio_dev));
 
 	mutex_lock(&data->lock);
 
-- 
2.53.0



