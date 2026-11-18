Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035840;
	b=0GADOrVqX4BxYrsZayB5IRUU/jUqvzpJopf+Ac7d7LW8/pNLLyi2rIvA2zdzoag0siOK
	 pmsnE+ft3puLTzJlzE113tpspTHZyYJs11S9kjmJNZcjl1R/vbAM2+A/q+SFhq3sVPkl/
	 I8dlg8gNhQqaliF8QxS8+dBiDHaLe5V8NINsBSON04aIrhJYeQZE6yFp/mOkv9X3c8sjN
	 QBRN3CyU422IrsKf2BuDODSqHogyZXYd2bY4EJ70LzvP8sB7tHIkKuv1f4LGfJWLFWC+3
	 SzkoKMNyY/zs+KhJj5is5vyoCMdJGdLx+StlXp9pERTQvmnNW4iuRrnNIBfVftWSeow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eHRW2mwm+5YSiuk//iwKw/ciwiT51a/eCGp2xamYiXk=;
	b=YboaXKkYyX3V0XrujDbRTDaJiRg23gayJe1u0Myzb9O+QmIl2dFdIRAdA3PLrIl+9UfU
	 DHHBNpyJ4xnTgrMvBxCYQky8WfciOPMGIO0JHM2M09rVMK78HdxbeGrvVXaOm627HJRfQ
	 4yeaHx0Zcy5YmXsRyqlc8GD6oWAgMA5uATIYQrv8VMGJeSkZUC2mNPGW8egDTgxgdJj2+
	 lGKBYbG23Nu5PEcyw1xoFQZWydCuyMGaLOX/hUkKMFdF/+s59F55dF+BRbUPS68+crh1V
	 88xjh/vG6uMGTwTNrV4VNm5Ar5y8aWEYLGOt7WDiLg3/jWFWfXC99jq4sltT5fr/vUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t2x/I/h/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4328606CB5C;
	Wed, 18 Nov 2026 21:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t2x/I/h/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2821F00931;
	Wed, 18 Nov 2026 21:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035840;
	bh=eHRW2mwm+5YSiuk//iwKw/ciwiT51a/eCGp2xamYiXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t2x/I/h/jUS1pv0zBI9GN/XnQOS7fDYpllZxFa1rc7YBPW9zWxzTgQGkV2qS52Gzq
	 WZh1RawK1XuIVtTEEaZ0fS3qWslV0Pmze6EwA4O98Gf7GgwM8XxUINzvNPTX7OApry
	 ol/vaNzBPp0YFqcHHf6C2oeOCm6vViqBQxjxN+eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <ehristev@kernel.org>,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0847/3318] media: microchip-isc: do not touch WB registers when not streaming
Date: Wed, 18 Nov 2026 15:24:29 +0100
Message-ID: <20261118150344.606375093@linuxfoundation.org>
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

[ Upstream commit d8983c47d4d95eb1ed889dbb7516d3738fa854d8 ]

isc_s_awb_ctrl() called isc_update_awb_ctrls() unconditionally, writing
the white balance registers even when the device is runtime suspended;
on many ARM platforms accessing the unclocked registers is an external
abort. The write was also done without awb_lock, racing isc_awb_work(),
which holds it so the DMA done IRQ cannot latch a half-updated pipeline.

Write the registers only while streaming and not stopping, under
awb_lock, and update the profile there. The isc->stop check covers the
window where isc_stop_streaming() has gated the clocks but vb2 still
reports streaming. Otherwise the new values stay cached and
isc_configure() programs them at the next stream start.

Fixes: 4e52889f48fe ("media: atmel: atmel-isc-base: expose white balance as v4l2 controls")
Cc: stable@vger.kernel.org
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/microchip/microchip-isc-base.c   | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/microchip/microchip-isc-base.c b/drivers/media/platform/microchip/microchip-isc-base.c
index ad21ae52cac90..6b79d91b643c8 100644
--- a/drivers/media/platform/microchip/microchip-isc-base.c
+++ b/drivers/media/platform/microchip/microchip-isc-base.c
@@ -1553,20 +1553,24 @@ static int isc_s_awb_ctrl(struct v4l2_ctrl *ctrl)
 		if (ctrl->cluster[ISC_CTRL_GB_OFF]->is_new)
 			ctrls->offset[ISC_HIS_CFG_MODE_GB] = isc->gb_off_ctrl->val;
 
-		isc_update_awb_ctrls(isc);
-
 		mutex_lock(&isc->awb_mutex);
-		if (vb2_is_streaming(&isc->vb2_vidq)) {
+		if (vb2_is_streaming(&isc->vb2_vidq) && !isc->stop) {
+			unsigned long flags;
+
 			/*
-			 * If we are streaming, we can update profile to
-			 * have the new settings in place.
+			 * awb_lock keeps the DMA done IRQ from latching a
+			 * partially written WB pipeline.
 			 */
+			spin_lock_irqsave(&isc->awb_lock, flags);
+			isc_update_awb_ctrls(isc);
+			spin_unlock_irqrestore(&isc->awb_lock, flags);
+
 			isc_update_profile(isc);
 		} else {
 			/*
-			 * The auto cluster will activate automatically this
-			 * control. This has to be deactivated when not
-			 * streaming.
+			 * Not streaming: keep the cached values for the next
+			 * stream start and deactivate the cluster-activated
+			 * do_white_balance button.
 			 */
 			v4l2_ctrl_activate(isc->do_wb_ctrl, false);
 		}
-- 
2.53.0



