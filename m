Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213113;
	b=Htm+rK0wX75jm7Wvtnzu5X8N91NxfR4nbWMwcK3Gt00cVNGKJzA5rtqjQSftztZJjqzO
	 N1oONhE1QlRnTV3XjUMBcXX+vCA0XBZ0sTCPbpir5GtBQFjDQ4qjw3Oi89l0J2y5Jreay
	 iaxkM6DipCen0tJvtR9yMgvst8RKWQrVGz5EQFr2QaLaUNwVbzfJJ3mApykjE//Y+BDzp
	 C8f9AGdpb35wcDAav+e42IV0zpyFlh87ah8Td0hjBYyPQwFKIzyKhMoXlo8lUzQPA75dE
	 ls5FhYtoyUUFeJhR6mGhC01fg8LHfqqCdue+/ZAmjvcv9LGozSOsG4gt4e6YSu56T7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rbx75PnjkoT6iNsyB/bgHp2oe/p8Tr9eANGsjSfBz8c=;
	b=eWBGzYPdndq42F11CuDdhzPRpXe3Y5Vf/5P1FsUDn7GcxWuGfWkcPD7L6+v+Ks6VjO6E
	 RVfs4p773jpljUgdykFsZp+MD6GnxQHc7Qi2BAlnZi5LRpixJt96NdPT/gm9a3RsiKDWi
	 IYzT0xLkK4Xg0WKmYQYtMKI0wfpUdMGRya2+h5XCufBUWihaQObZ/y4J2OZcMiq2ERxS5
	 VTmQfDaGk4dyHjz5dc78c1LShtIP2VkiHqc2hPCN0FQe988L7xJd9c0pXuKyJdZSFZ90k
	 vJ2El+f7ezAlNEOu6zqcpVL0UcmhGuwOPU4ucxVlCeAsWpH71BsA8rjuY5JCF5itG4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P/HLQ5m9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CEC606A320;
	Wed, 28 Oct 2026 18:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P/HLQ5m9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6961F01825;
	Wed, 28 Oct 2026 18:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213112;
	bh=Rbx75PnjkoT6iNsyB/bgHp2oe/p8Tr9eANGsjSfBz8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/HLQ5m9F0RhvwUFsY4wGqBROUhr+Umw3muloPeosUvlmI6oG7EC4OQXqSfnF8H6N
	 GJ3tUhPqvnR3xB12JanHiyW2DG7iiE2idvS8yTvhiEx0BkRN6oFNDz4ewz2jIOmAYC
	 0uvR3KQLkS26lo2WjRqUPWE3CjE88btRpzVhSJlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Ivan Mikhaylov <fr0st61te@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0347/1887] iio: proximity: vcnl3020: fix ISR bitmask check in IRQ handler
Date: Wed, 28 Oct 2026 17:40:43 +0100
Message-ID: <20261028170507.126461063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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


