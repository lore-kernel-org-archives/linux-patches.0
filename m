Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063912;
	b=V+jHQ91ZOOa4LzQCdL2M6LJh/6eHIjdfDIgf5wpVoCWpzwVRPRXehH2kxJrAj1c8xyCD
	 oWTkIa5VR//gogp+hOuqWGFpMcBaKcXg85Doq1psbAJbSjdaGPG9DQjRGqDKzx7RxO2Lc
	 polFAcCsB+jgn9BqQFs2KRy24raFvL0ojVMnBiNZ6yvrhAIyB8ruUy5nGRQtO5y9XdLXL
	 Ag9xoaNeYao8Nm7qxwYbbXmR6X7/S5pqjOXjh8ha6RmHr72nlM/ZtSGsn2Z6Y01aZ0p1O
	 mZM1AEuLw9LeMzKHiQdKNoQWEwNlSlqnDzUfcPe2g5clghh0RDrkdz/+EA+7Dj5OcSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b92n5wr+e5H62EG/VQOtwykwcULFlnN4kxEe3MU2dpo=;
	b=QtWq/7/TVYi3c74RHPt0HXNBFwlI9gsiGg7+JxHVyIjbH70CwhakFWXxfh8xV+pvS9YX
	 VU/m4XLETzctImULD2dfmXhN8qaeD8iRIYPvcsKeg322+sWMlEyb1deEqkDEoe7vNoIpQ
	 WsC36Fj0VHMAK38Tp9vQyLE4HBNPkcB48CroF6ezcQPxFf3IRY1ftfsm7J/+AG+b31dXb
	 M/bXcUMDeBGL3HPpAWnEpKa7gu5U+SU1IlH3KQGkKI7JXAI+Hpf7udcnK69U46YtmZoD1
	 qPnyTZvYt31XXa21/BoJq5hNdiFEuCcVnd1KcsPwBolQzVZa/lACQsj74mWtyd2D1Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ef9+Tbtd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9B7606E8E9;
	Sat,  7 Nov 2026 15:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ef9+Tbtd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D58E1F0089F;
	Sat,  7 Nov 2026 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063912;
	bh=b92n5wr+e5H62EG/VQOtwykwcULFlnN4kxEe3MU2dpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ef9+TbtdxCR9SmuBGrxThf9h6KNdGNvqoq8zNjhOV7IQ6W+icC3HzwqE6f9nubPoN
	 SOIppn5+tTObeW3NAldjmxgrst+5YRjjlsF9Y8HTH0oLhFRobhbs1EiY2XqtMWA1q8
	 lWLRACz+m70hFDA+r6iIuTCOeZEcXhZWYnB0c4g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0110/1257] media: microchip-isc: disable histogram and flush AWB work on teardown
Date: Sat,  7 Nov 2026 08:40:06 -0500
Message-ID: <20261107134942.391437890@linuxfoundation.org>
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
index debbc38717de1..0f486dd5bd82c 100644
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



