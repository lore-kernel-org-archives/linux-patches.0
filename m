Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211109;
	b=JtCMyJfzGzpbSzzQtMP0PkFDw95jsjEB6DT9F9QWiyYSq3XVG+4UiBj+7iRudG3xI+vB
	 EvvP6mr+SrTfziAGjt+Es2FDQdI7feb2eAiQ0g0K3xZS83REBp1YRbynHXOI1gywbd2rD
	 5HoVp63C+dEPietQGa7lFR4ftEFFxeI69+YY5uhm8tRmBDNjCae1F+xK5sZwMyy9Fj90w
	 /kXR/RVPJrCqpuq4QxqSKqq6s0U38QKyEdYE7ahCjzDPTOvUyNl7/cxXVaOjsp/XLhaaa
	 RTIlFSfjOB2981pXpDpUXWVrASIxJV2pj2ffQAILbn/oLieyk+A0ghh7OCDJGFzRFTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WwS/i9hVyoo1suXPy6HKzmD35bv7HZ1HNPAFx46DJQ4=;
	b=tfYSPJWkMjadwNQwt77hZquOI9nRgYRUDdRXBQ1qSpBc7SvKFQMWH0WO/nXwZnsy3wtP
	 VWdeTeMaudCSgo6MeLk9ZCVDkYSpwKVHMIDZdpOfBV52Bk3qgmkzPwnLbV2LVU5sBQNep
	 qZ4HODQcMa8Mbo4yDo/T1YX8PM7xUAKYN6803AtZn0RYm2dexSrmhBKcxxaXniszkYsPg
	 hbwuy9HTC/KuKElxOJZMtTw7bzsYEdoOjtUe0YURpf0uTMoPqfEjD8dd5v7nd7dUwbea1
	 ++itjUN0fI/azNcWQN1H4H0FfL6TgUmM7SJrHyy1ptZ6/Uz18MvxJDLJuJpuflJtvjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILMjXDNR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3838860A5BD7;
	Wed, 28 Oct 2026 18:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILMjXDNR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4471F01825;
	Wed, 28 Oct 2026 18:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211109;
	bh=WwS/i9hVyoo1suXPy6HKzmD35bv7HZ1HNPAFx46DJQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILMjXDNRfX8s4U6kx1m3HEmAqNQyBFlunibr0nZqsqTFhU0mCCTlzANfT7QHxsflb
	 Kh1VPfA3PlgplMQiY2Comr4HJ9kiYsi3/WHXNbfImOnod/CEyzlwmvxMRuog2PLOUd
	 sHCqxkWgeWVdoIKdWcua+NBj2/1HlWS24zQrT2t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Ivan Mikhaylov <fr0st61te@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 261/571] iio: proximity: vcnl3020: fix ISR bitmask check in IRQ handler
Date: Wed, 28 Oct 2026 17:56:48 +0100
Message-ID: <20261028170014.199089198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Salah Triki <salah.triki@gmail.com>

commit 7d38af8f20239a66e90de7632a79c9425256c574 upstream.

The threaded IRQ handler contained multiple issues in handling interrupt
events and clearing status flags:

1. ISR bit check: The handler incorrectly checked the Interrupt Status
   Register (VCNL_ISR) against VCNL_ICR_THRES_EN (BIT(1)), which is a
   bitmask meant for the Control Register (VCNL_PS_ICR). In VCNL_ISR,
   BIT(1) corresponds only to low-threshold interrupts. A high-threshold
   interrupt (VCNL_INT_TH_HI, BIT(0)) on its own was completely ignored and
   returned IRQ_NONE.

2. Event direction & channel index: The handler unconditionally pushed a
   RISING event code on channel index 1. The driver only registers a single
   proximity channel (index 0), and low-threshold interrupts should be
   reported with IIO_EV_DIR_FALLING.

3. ISR clearing: The write-back to acknowledge the interrupt only preserved
   BIT(1) instead of masking against both valid status bits.

Fix this by checking both VCNL_INT_TH_HI and VCNL_INT_TH_LOW bits in
VCNL_ISR, pushing separate IIO events with the correct direction and
channel index (0), and properly clearing handled status bits.

Fixes: 3363fbbe19e5 ("iio: proximity: vcnl3020: add periodic mode")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Ivan Mikhaylov <fr0st61te@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/vcnl3020.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/iio/proximity/vcnl3020.c
+++ b/drivers/iio/proximity/vcnl3020.c
@@ -584,16 +584,26 @@ static irqreturn_t vcnl3020_handle_irq_t
 		return IRQ_HANDLED;
 	}
 
-	if (!(isr & VCNL_ICR_THRES_EN))
+	if (!(isr & (VCNL_INT_TH_HI | VCNL_INT_TH_LOW)))
 		return IRQ_NONE;
 
-	iio_push_event(indio_dev,
-		       IIO_UNMOD_EVENT_CODE(IIO_PROXIMITY, 1,
-				            IIO_EV_TYPE_THRESH,
-				            IIO_EV_DIR_RISING),
-		       iio_get_time_ns(indio_dev));
+	if (isr & VCNL_INT_TH_HI) {
+		iio_push_event(indio_dev,
+			       IIO_UNMOD_EVENT_CODE(IIO_PROXIMITY, 0,
+						    IIO_EV_TYPE_THRESH,
+						    IIO_EV_DIR_RISING),
+			       iio_get_time_ns(indio_dev));
+	}
+
+	if (isr & VCNL_INT_TH_LOW) {
+		iio_push_event(indio_dev,
+			       IIO_UNMOD_EVENT_CODE(IIO_PROXIMITY, 0,
+						    IIO_EV_TYPE_THRESH,
+						    IIO_EV_DIR_FALLING),
+			       iio_get_time_ns(indio_dev));
+	}
 
-	rc = regmap_write(data->regmap, VCNL_ISR, isr & VCNL_ICR_THRES_EN);
+	rc = regmap_write(data->regmap, VCNL_ISR, isr & (VCNL_INT_TH_HI | VCNL_INT_TH_LOW));
 	if (rc)
 		dev_err(data->dev, "Error (%d) writing in reg (0x%x)\n",
 			rc, VCNL_ISR);


