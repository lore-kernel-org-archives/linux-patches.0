Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062792;
	b=ATMz0C/6lnUbJfTu/7ZQipw9fH4rzmpvkLIluoN89xUnxasdiQsE6dNreZ5mBSDGVHey
	 l7bRIVKxks4DxpwU/JkCF9rhvDH0DwSHOK1CoW76rNipVV180QEBTyeB91gN1kNDYXX4g
	 EUdt9iVF3n9SM6DFg6FpRuEqhlnM2cE6PyspG7yR1eGZd8pOziV7+VfSRApE7ejPxMnrt
	 5Wjm+iQUl1uYOSCwi4S3BzORyYyTcfwwX/q51b2W7peJu3oAUaYEy0nB6/6HRMLsHaJ3h
	 5L/zOEjHvcOB6ItB0H3lFGxL+Ywn2ypNjW77w85fD+pQMZVg7NlMX+y6MhiFNZB0FSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062792;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7muYXOVZ0t2tzldscrCgxxwE6md+XJyRMvxtyZY88M4=;
	b=e1GPDx4TyP0P9EM3IeMIgzC99HrH02+W75PUlGcCaTfp+CaEnrKaf/L2kFBlWXhLcHEi
	 dIDnfWfkeGGl9SvYQB19IppJ30E919Exg75gcOtdIZ/IBS6YgwYIlpAL9OfXHzVJ9s+n0
	 zLjzgtAMV40Vd37dIQpWp2/Xs6ZXGF/mhpKIAlKRbRKRKf7YgDMeHjgtssMsW2KZGUP9b
	 85Hro1wWT0SfLSJgj+hgPZfiuZIKVKpKGGM12w8N3gmthXs+lJe1AQVgxIOSLVtuVnbIA
	 x6C0cNHO+zAMhPw6apjCr2fqLuCiMWkzTvzK5xtloQ8DReWRcjV/asymdW4DXK9MgdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YqACA113;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59658606A33C;
	Sat,  7 Nov 2026 14:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YqACA113
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015461F0089F;
	Sat,  7 Nov 2026 14:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062792;
	bh=7muYXOVZ0t2tzldscrCgxxwE6md+XJyRMvxtyZY88M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YqACA1133jHrLvv9/g/GX5Rw3JYYFALe4ufEfo7MKs2yUoep4SMcvedmjmXJE5pQD
	 xq0O5YqOE7bMFaQ3eojDreNZ4qyBUd34RjgeE5k3EedjV+g5eGVu1SChzUraPHM4xq
	 8X5bkBJlse2qih1kO9hU9sLkPpUEdwFWjoYPKshQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 097/869] media: microchip-isc: disable histogram and flush AWB work on teardown
Date: Sat,  7 Nov 2026 08:46:19 -0500
Message-ID: <20261107134855.961063388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



