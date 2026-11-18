Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053624;
	b=0g6aVNlFyO/WHY3k9lIswGiywF4rxD7zNYWbUTOc42JTcbB4tmgIclCTyD0zn2A1arYA
	 wyYiUQSeJkrc+iNcR0JcZgiVi+bCrXluAQ7sqtdTXtBrZtfxSHts35x0L2FYx/M+dLVGx
	 MQltbm8mjCKYLRzDqG/bshE3hDCKAVODtJql5CgRK8U2CL2R9DRgR/wiL6cYyXYzxFY3L
	 Vq7owJ94n8l7Myq7FIAUJLpjJmfBs2PqhBKsgAQnLlPRSbbhR1YEeRzRkcvlwF9XPM/qE
	 32Ok6FMHcM+dyWU/VXx94a6wfhYlS4e9aa20yxXPmYHzPbaWCuQLjKblVETjeAL3X7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R2q+CYe5dIUxnETOiJZQnrs0Mutq/O5h+TBXOVM/FJ0=;
	b=pDK3q0BZiCQqCn7MICqJNh5Tf0K0Rr/1zqNEvHPlOMOeLDUMZKVD1cbdKd9N3WiQQkI+
	 JyvbE/8cBVGXD7+05x3eTneWkWTv0YCV1NHbajOVqKKmVm8qQNlyjRNfk97wmSfCMkVw8
	 GMPSVIiV3nVtNcGSkPtBFBmm8RKClh+LSWRipyAtYWCw90fqQ/NpTjxd7AkJqiWNnxLMa
	 ainkczzDFdnK4hM8JHwe13x7wiY1yT1CK5uK2yyzSOiZIYL9bWi3pTafbivJnYZCffzh9
	 ivYJmmUoKGPbLN1HuORjOfYw9bu7M+u55wDiRswVKDn4zeo3mwkWDbm69O0nyYv/KhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mSOGf83W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A81606A31C;
	Thu, 19 Nov 2026 02:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mSOGf83W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776D81F000C5;
	Thu, 19 Nov 2026 02:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053624;
	bh=R2q+CYe5dIUxnETOiJZQnrs0Mutq/O5h+TBXOVM/FJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSOGf83WA9d1SVWFx/gS8kL0BL6vw7a6HdiiHnbqjaSvd1alQjUn90UuSaXGO9iIm
	 vigJEOB9o3v0XT9Sc8Bj6Izjx63/PIJ9HeLGXLHCMmINtJHHRvSPuu+jmU1i4s0XzL
	 9lTHu1iSGjgrMx311s7wHC+mD//rhriepmYChiT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0978/2214] media: microchip-isc: synchronize the IRQ before disabling clocks on stop
Date: Wed, 18 Nov 2026 15:44:14 +0100
Message-ID: <20261118150051.375391371@linuxfoundation.org>
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

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit 19fa5407da5ef3e605cacfcd90f70d8b2c121cd7 ]

isc_stop_streaming() masks the DMA interrupt and then drops the runtime
PM reference, which disables the ISC clocks. microchip_isc_interrupt()
may still be executing on another CPU at that point; it reads ISC_INTSR
over regmap, and touching the unclocked registers triggers an external
abort.

Store the IRQ number at probe and call synchronize_irq() after masking
the interrupt, before dropping the PM reference.

Fixes: 106267444f12 ("[media] atmel-isc: add the Image Sensor Controller code")
Cc: stable@vger.kernel.org
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: adapted context to the older Atmel ISC driver naming ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isc-base.c    | 3 +++
 drivers/media/platform/atmel/atmel-isc.h         | 1 +
 drivers/media/platform/atmel/atmel-sama5d2-isc.c | 2 ++
 drivers/media/platform/atmel/atmel-sama7g5-isc.c | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/drivers/media/platform/atmel/atmel-isc-base.c b/drivers/media/platform/atmel/atmel-isc-base.c
index c856891adf99e..8e3b264ce8851 100644
--- a/drivers/media/platform/atmel/atmel-isc-base.c
+++ b/drivers/media/platform/atmel/atmel-isc-base.c
@@ -709,6 +709,9 @@ static void isc_stop_streaming(struct vb2_queue *vq)
 	/* Disable DMA interrupt */
 	regmap_write(isc->regmap, ISC_INTDIS, ISC_INT_DDONE);
 
+	/* let a running IRQ handler finish before the clock is disabled */
+	synchronize_irq(isc->irq);
+
 	pm_runtime_put_sync(isc->dev);
 
 	/* Disable stream on the sub device */
diff --git a/drivers/media/platform/atmel/atmel-isc.h b/drivers/media/platform/atmel/atmel-isc.h
index 2bfcb135ef13b..f958da504dad3 100644
--- a/drivers/media/platform/atmel/atmel-isc.h
+++ b/drivers/media/platform/atmel/atmel-isc.h
@@ -257,6 +257,7 @@ struct isc_device {
 	u32			dcfg;
 
 	struct device		*dev;
+	int			irq;
 	struct v4l2_device	v4l2_dev;
 	struct video_device	video_dev;
 
diff --git a/drivers/media/platform/atmel/atmel-sama5d2-isc.c b/drivers/media/platform/atmel/atmel-sama5d2-isc.c
index cf96d40828ab5..5faa1c775f7c6 100644
--- a/drivers/media/platform/atmel/atmel-sama5d2-isc.c
+++ b/drivers/media/platform/atmel/atmel-sama5d2-isc.c
@@ -415,6 +415,8 @@ static int atmel_isc_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
+	isc->irq = irq;
+
 	ret = devm_request_irq(dev, irq, isc_interrupt, 0,
 			       "atmel-sama5d2-isc", isc);
 	if (ret < 0) {
diff --git a/drivers/media/platform/atmel/atmel-sama7g5-isc.c b/drivers/media/platform/atmel/atmel-sama7g5-isc.c
index 3183ab2345c8b..7f0f635479bf1 100644
--- a/drivers/media/platform/atmel/atmel-sama7g5-isc.c
+++ b/drivers/media/platform/atmel/atmel-sama7g5-isc.c
@@ -408,6 +408,8 @@ static int microchip_xisc_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
+	isc->irq = irq;
+
 	ret = devm_request_irq(dev, irq, isc_interrupt, 0,
 			       "microchip-sama7g5-xisc", isc);
 	if (ret < 0) {
-- 
2.53.0



