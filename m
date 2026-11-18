Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059350;
	b=ylfoq9nD6UZtWdObMAAxuxF30q7PVgXTNYCYjxtQwbKorKTcAfSFNoot2mtKCnpaawD5
	 EoZRGCXPVffKK9IS5Nm6GyzbMywXtgfRzVyklpHYqfoOMyMvfCqu8C03w8XBgUUsNh04S
	 KQK2v12IVNvqamQeJr2kaINv8mlZf/+vYrquI3E7EORXYZ51KTeUXiu7UkW5ZjVpik5bX
	 cvC9nlodB136lhHJ+GWNqo40KYq8TBIRg3yBO4sn+3FjCPhq9jSj/NuY8MtvvhbzXKSDn
	 IpwYY/95mTKy41w9+05QxLZALsWE8BEBDcHMbBp4YhwAzfpjXfhCQkOknMOOi2VwLoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VRl1FIATmgihgHJqxo8QwCJuVyg9HYg7gjahsvhviXE=;
	b=Cf3FO4cFqhTUdKGq3yFgQDrOyAPqe3Q3rIyHfZ+R+nNtNQnQ15dHr1KfTWA0moHt2Ksj
	 QBDpYBAXbZrF67UcS5koOcClqBipDDGALkyq2/+2YKoM3Q7nqSIx0If8KRv18XYnzYMq2
	 k6PZhvCoKXBWnZ5XQJCnMzDTC0S6uAUNK4MB3HvGQYQCoWLQ6N2brIDSmbGRImD6wWTtx
	 JnTaS+IcD46gIR5unCnIpfUB6YLTyX0hmwYAlDUvDRMmcBXopuSOn27upRREoA/m66S6A
	 oZ5SgZVaYgj39UhDGT3xqDhZXtNUFD+KwKwvBPmU0alGZWexVJx3VtCHe9uguKmzfIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2uG+nZu3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F57606A320;
	Thu, 19 Nov 2026 03:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2uG+nZu3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386CF1F000C4;
	Thu, 19 Nov 2026 03:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059350;
	bh=VRl1FIATmgihgHJqxo8QwCJuVyg9HYg7gjahsvhviXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2uG+nZu3oHsXxAMKV7FRbK/pN8DLhVhfkAFIXrcdlLuGP+7WbpUFRpprWDIHO+XdM
	 hf21D1U5rinSXHakRmp3irWUPsdeVG0X2nI0CgZuo4k9JiQ5L4etp3jYQvUSLwptIS
	 IomaUqA+AuxhzH1pMiubga3LwTiB+XBbcigz/8sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0811/1848] media: microchip-isc: synchronize the IRQ before disabling clocks on stop
Date: Wed, 18 Nov 2026 15:47:29 +0100
Message-ID: <20261118145950.255689369@linuxfoundation.org>
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
[ sashal: adapted Microchip ISC changes to the older Atmel driver layout lacking SAMA7G5 support ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isc-base.c    | 3 +++
 drivers/media/platform/atmel/atmel-isc.h         | 1 +
 drivers/media/platform/atmel/atmel-sama5d2-isc.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/media/platform/atmel/atmel-isc-base.c b/drivers/media/platform/atmel/atmel-isc-base.c
index a05716e0e6c2c..20de76b3c74b0 100644
--- a/drivers/media/platform/atmel/atmel-isc-base.c
+++ b/drivers/media/platform/atmel/atmel-isc-base.c
@@ -871,6 +871,9 @@ static void isc_stop_streaming(struct vb2_queue *vq)
 	/* Disable DMA interrupt */
 	regmap_write(isc->regmap, ISC_INTDIS, ISC_INT_DDONE);
 
+	/* let a running IRQ handler finish before the clock is disabled */
+	synchronize_irq(isc->irq);
+
 	pm_runtime_put_sync(isc->dev);
 
 	/* Disable stream on the sub device */
diff --git a/drivers/media/platform/atmel/atmel-isc.h b/drivers/media/platform/atmel/atmel-isc.h
index 24b784b893d62..7c4956cf5a4af 100644
--- a/drivers/media/platform/atmel/atmel-isc.h
+++ b/drivers/media/platform/atmel/atmel-isc.h
@@ -194,6 +194,7 @@ struct isc_device {
 	struct isc_clk		isc_clks[2];
 
 	struct device		*dev;
+	int			irq;
 	struct v4l2_device	v4l2_dev;
 	struct video_device	video_dev;
 
diff --git a/drivers/media/platform/atmel/atmel-sama5d2-isc.c b/drivers/media/platform/atmel/atmel-sama5d2-isc.c
index a3304f49e4997..9a63c447aa325 100644
--- a/drivers/media/platform/atmel/atmel-sama5d2-isc.c
+++ b/drivers/media/platform/atmel/atmel-sama5d2-isc.c
@@ -163,6 +163,8 @@ static int atmel_isc_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
+	isc->irq = irq;
+
 	ret = devm_request_irq(dev, irq, isc_interrupt, 0,
 			       ATMEL_ISC_NAME, isc);
 	if (ret < 0) {
-- 
2.53.0



