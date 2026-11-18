Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025172;
	b=OqaMQySgyYjFBM9eTqeMteyN1XeuPBrM+Zw67UmZM039VL5oxhphhGl5hYW3IFJZ+sZp
	 h9xzcw1I+RkRjCxKkK8Z57gAumO0N4qZcDwjLuCf5BNWd0mhGrPo8PYrQZZOrR4flMzeX
	 vty2NNKR5itIHho7LmY8fZtEspScXWT8bQrLxrbx2VpzXIi06RY0up6w8ObfaxQvfYGqE
	 SsbieS6CgZiVAPP3R+hS/eYW86kboluVA+YcaXyWHe81tw2IT/C6p4YJZU8VB3t3Saboh
	 nuDRVgeVeLgcITHxzF/URqGOXVIK7jGq77DVEIiVl44n6JXCFYPbrn9HZDHZ4PVST/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ek4Hvslma4wEKNAMwSe9Ly5wZdKfjKNwqNTm25O8Eew=;
	b=ZD+3yy7Pax30Hn2f5++sMqoy8tGW6E9415iKfoS2cFsxBTty+e2CSiZGLRl6dyn9+l8z
	 XiudJVnPGBrnejeK7W0dAnvv60lX+SuqrqVrHt9/5F4Rj8o6hcbStMKt+q6POs67KCBeM
	 KwhZLOcnPFxepZqjQRSRPrSgi4xSOMeFk5Vshg9gckH4gO+OfaL0Sgwq2qfg2FGOMK+tI
	 5VhyT+1Pu1jRerZ7w5fN2/2K/GjYC6PYsvVnXi1jmSpcqyCoWx74NOvPPb24hcn4NzefQ
	 cVcUq9Z+3vL+uXR9aIGxbRAtMbekMRHKy1VM7RcXVtqsGVjn4OuxPmVisir33FvHN+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LUeGvV1K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4131606A325;
	Wed, 18 Nov 2026 18:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LUeGvV1K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F18A1F000C5;
	Wed, 18 Nov 2026 18:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025171;
	bh=Ek4Hvslma4wEKNAMwSe9Ly5wZdKfjKNwqNTm25O8Eew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LUeGvV1KMoQOHtGXkxKS0pceUNPafSoi/Qgc7ViNzxvXv9s7yCsiYT3YRcxrcIfjR
	 EuC89x8OuldE9a4BH3FTrm5vAcy5I5Aw7ws/G3z/1PXoA/aPcSqxA9wpPyHbpxzml4
	 7GwU4sPlDH6ax9BH964X8rOUNCc0+ZlVDOnv++T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Joonhoe Kim <26rote@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0986/2151] drm/msm/dpu: disable the slave encoder before the master
Date: Wed, 18 Nov 2026 15:45:21 +0100
Message-ID: <20261118150158.391986358@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Joonhoe Kim <26rote@gmail.com>

[ Upstream commit 32d04280ddebb6eb964990931b0f1001f63b35e7 ]

dpu_encoder_virt_atomic_disable() disables the physical encoders in
phys_encs[] order, i.e. the master first. With a split display (two
interfaces on one CTL, e.g. bonded DSI) the master's
dpu_encoder_helper_phys_cleanup() then resets the shared CTL while the
slave's timing engine is still running, and the source pipe is left
stalled half-way through the slave's next frame.

A power collapse of the MDSS core GDSC clears the stall, so it normally
goes unnoticed. When MDSS stays powered across the disable (a full
modeset, or an active DP controller), the next enable scans out
nothing: black screen with the backlight on.

Disable the slave before the master, as atomic_enable() enables them in
that order. The slave's cleanup still resets the CTL while the master is
running, but the last reset, from the master's cleanup, now happens with
both timing engines stopped.

Tested on a Lenovo Legion Tab Y700 gen 5 (SM8850, bonded DSI video-mode
panel) with MDSS kept active:

  echo on > /sys/bus/platform/devices/9800000.display-subsystem/power/control

DPMS off/on: black 10/10 before, picture 10/10 after. Full modesets were
not retested with this version. Only tested on this device.

Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Fixes: 22cb02bc96ff ("drm/msm/disp/dpu: reset the datapath after timing engine disable")
Assisted-by: LLM
Signed-off-by: Joonhoe Kim <26rote@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/757684/
Link: https://lore.kernel.org/r/20261002130712.50612-1-26rote@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index e21aa5cdbaf29..67a2c796ae544 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1379,7 +1379,6 @@ static void dpu_encoder_virt_atomic_disable(struct drm_encoder *drm_enc,
 	struct dpu_encoder_virt *dpu_enc = NULL;
 	struct drm_crtc *crtc;
 	struct drm_crtc_state *old_state = NULL;
-	int i = 0;
 
 	dpu_enc = to_dpu_encoder_virt(drm_enc);
 	DPU_DEBUG_ENC(dpu_enc, "\n");
@@ -1405,12 +1404,11 @@ static void dpu_encoder_virt_atomic_disable(struct drm_encoder *drm_enc,
 
 	dpu_encoder_resource_control(drm_enc, DPU_ENC_RC_EVENT_PRE_STOP);
 
-	for (i = 0; i < dpu_enc->num_phys_encs; i++) {
-		struct dpu_encoder_phys *phys = dpu_enc->phys_encs[i];
+	if (dpu_enc->cur_slave && dpu_enc->cur_slave->ops.disable)
+		dpu_enc->cur_slave->ops.disable(dpu_enc->cur_slave);
 
-		if (phys->ops.disable)
-			phys->ops.disable(phys);
-	}
+	if (dpu_enc->cur_master && dpu_enc->cur_master->ops.disable)
+		dpu_enc->cur_master->ops.disable(dpu_enc->cur_master);
 
 
 	/* after phys waits for frame-done, should be no more frames pending */
-- 
2.53.0



