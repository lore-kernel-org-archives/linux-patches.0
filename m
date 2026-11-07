Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061984;
	b=3Krv1Hwl6d70HaOWihQShXaH1KKdiXhAGFWFStwb3Y1N7M4TMUvTwEiZur3VzYFM0dWB
	 fieGFBLaDb3q5u+X9f+U5JuFVAy1L+V8x80/rSTSAxfYxalInegChir/X/W6Swl0i/AKo
	 Vq+sxz2ZhgVWlMK/VAdS/+2o0m+9vYqf7Z65y0lf8ZN0iZf85JJ3+hTbepVhJlZBeEddq
	 YBl+j8iz4Mj7HErg/ZCCUDExbQ8vxoUd9u6Qkw8esUbce52S7krcqW29vnbQ3tfmldufi
	 y+8pk2Ooulu+l6+QxEGbCErNaCir7hld4QBKgPlygKV3gtFL3LIBMUV744qeAcizTvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YFla4eCRcw7GMAHzOu2L/JATQNif0IM00f/5rMHY7Os=;
	b=dmTnhsFZQ0bvPH0FiQILMfJicX0rQTX4Q/nA6BSqcHxx4fIvZQGtrVzZSM5LkUVBWcMf
	 FInoKsNurwYUJSdml9s6VqO7uPV4C+C6ml5gO8tcdlMc0oXIEApmrG79L+vT/JMtARtBO
	 iSS1asL36igV3SrXDLux1GMcARCdnr5d35nn+K8zbHIMMmYuUFPHC81k8q9tp8pZUlW8O
	 7Enstt2WMn6c9j7Eqph2R1Wq8jmBeLI3+m4PkvVXW/0OZMnrsu79Qg4hn4LMb5mTg7kYT
	 L/eJBxsbWQRxM1KCdtz1BA1FS47QkjOY0Pb0Savehnxu+kfuAXZ4ORtovE7CtEg8Tow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i3GNvXx+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BCD606A335;
	Sat,  7 Nov 2026 14:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i3GNvXx+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77A51F0089F;
	Sat,  7 Nov 2026 14:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061984;
	bh=YFla4eCRcw7GMAHzOu2L/JATQNif0IM00f/5rMHY7Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3GNvXx+SmJIGCZr8hvQJqf/Vl9zccSJplj2v4hnCE5kkDrTDK34zwm88Y80x3uoP
	 UXpJux7GFUcTjPW3jxFjh0/SlAg8Jm7IkXk8UleSpYFjkVJhCrr/qcheAviMjpb2Zm
	 m57yyDLpRInHRAfbolAYJfMGLA4fwxhpE2TDCPKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0950/1536] media: microchip-isc: disable histogram and flush AWB work on teardown
Date: Sat,  7 Nov 2026 08:49:26 -0500
Message-ID: <20261107135024.338656500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit 00d87c379915a3689b2488bd37f490875d79e20f ]

isc_stop_streaming() and the isc_start_streaming() error path dropped the
runtime PM reference with the histogram still enabled. A HISDONE firing
just before the stop, or a failed isc_update_profile() on the start path,
can queue isc_awb_work(), which reads the histogram registers before
taking its own PM reference and faults on the unclocked device.

Disable the histogram, synchronize the IRQ and flush the work before the
device is left unclocked. isc_configure() is the one enabling the
histogram and then calling isc_update_profile(), so do the cleanup in its
own failure path; isc_stop_streaming() does the same on teardown.
synchronize_irq() must come before cancel_work_sync(), so an in-flight
handler cannot re-queue awb_work after it is cancelled.

Fixes: 93d4a26c3dab ("[media] atmel-isc: add the isc pipeline function")
Cc: stable@vger.kernel.org
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/microchip/microchip-isc-base.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/microchip/microchip-isc-base.c b/drivers/media/platform/microchip/microchip-isc-base.c
index 8223991ae7dda..97506304f2391 100644
--- a/drivers/media/platform/microchip/microchip-isc-base.c
+++ b/drivers/media/platform/microchip/microchip-isc-base.c
@@ -289,6 +289,7 @@ static int isc_configure(struct isc_device *isc)
 	struct regmap *regmap = isc->regmap;
 	u32 pfe_cfg0, dcfg, mask, pipeline;
 	struct isc_subdev_entity *subdev = isc->current_subdev;
+	int ret;
 
 	pfe_cfg0 = isc->config.sd_format->pfe_cfg0_bps;
 	pipeline = isc->config.bits_pipeline;
@@ -321,7 +322,15 @@ static int isc_configure(struct isc_device *isc)
 		isc_set_histogram(isc, false);
 
 	/* Update profile */
-	return isc_update_profile(isc);
+	ret = isc_update_profile(isc);
+	if (ret) {
+		/* flush the histogram work before the clocks are gated */
+		isc_set_histogram(isc, false);
+		synchronize_irq(isc->irq);
+		cancel_work_sync(&isc->awb_work);
+	}
+
+	return ret;
 }
 
 static int isc_prepare_streaming(struct vb2_queue *vq)
@@ -425,9 +434,13 @@ static void isc_stop_streaming(struct vb2_queue *vq)
 	/* Disable DMA interrupt */
 	regmap_write(isc->regmap, ISC_INTDIS, ISC_INT_DDONE);
 
+	isc_set_histogram(isc, false);
+
 	/* let a running IRQ handler finish before the clock is disabled */
 	synchronize_irq(isc->irq);
 
+	cancel_work_sync(&isc->awb_work);
+
 	pm_runtime_put_sync(isc->dev);
 
 	/* Disable stream on the sub device */
-- 
2.53.0



