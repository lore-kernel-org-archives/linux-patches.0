Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035838;
	b=amyGEjjsLQtQFBUFnAXhI68zfpb8MNoKyDRjz2tQKraMusmUIQHpiUBVQosGjBdpmyLK
	 4NdUfaTD4CDmqbQe6mtfSyIE+CEplIb8ZyeEMRlelGKZa0QkWgOqmxt/ogumihyifLXxb
	 a178PKVZHEXN1FoFGICRv2kXiprYLroUgOIfj1DKp5hnhhrXmJrfNlm3BccLMH1SN90RP
	 bYQorLzGIM6ZjsUHYiY80QTIyEOc7LetEtFh8LQdLAhIQ7jVNWumXkfJ1vpRqcpC0dSKK
	 W/AUHF0R5c6jAohuq6Au0j+P2gcueVtRD+Nq9M/PonnBnqwLRtbVCTBuqjKaB4J10pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UOllwuBHF40crjdxp4EVMYiM2DGurPyrvpDqJutswaw=;
	b=2Ab/JBaJjb+GVxhyI/W9MEUNjGRJIGCEwkes3VTWsD4y/KrIAvguK8KLNfow7j9NUqm4
	 21JFz0ap85gA5Aqbp5+swJFscRrxWE+q/mHRuj+mQs5pCuLk6WBbo9MVNzMHNlh35PxP7
	 Q6Jqc0d4LEl9BMiq/vkj2c5IunILMGvb21hpuvABS1dVmfajTUuGTIiYaa8fCPedw+Sn8
	 EZFkHGbtTf1SaR//vvdpZb1YxMk8ReteubbV7NaxG0HgBkfveptWU+Sme/fT3SiuXWjE9
	 V/dVBM8Rp0ONSpz/RJMaPqaTYFRk2D3891Hed5wGkx2oWmoP1PLKMBp3f6x1cSzwpvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ydCQbjXn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB2460A5BCC;
	Wed, 18 Nov 2026 21:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ydCQbjXn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5231D1F0092B;
	Wed, 18 Nov 2026 21:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035837;
	bh=UOllwuBHF40crjdxp4EVMYiM2DGurPyrvpDqJutswaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ydCQbjXnd0rUQB6N0TcFDj7Nqb6IL1DaX9PuugGr+W00znTZGqYortwGFpIifpTCY
	 WbJ2o579cPHZ8TvlpKaT1j2wi415UJ3quOvvA6H6J6qSnV1zLeHZpeJ8IP0M2BfC9Q
	 3F2/Us/Wnj0nEdlVoDOkIlqWkSlBzwRYr1D59ARE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0846/3318] media: microchip-isc: disable histogram and flush AWB work on teardown
Date: Wed, 18 Nov 2026 15:24:28 +0100
Message-ID: <20261118150344.569542836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 608985499826e..ad21ae52cac90 100644
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



