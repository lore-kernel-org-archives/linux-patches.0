Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030621;
	b=TKnT4XOKmaC9S2CqEjlAKDVYdjknhzuYeTxXi6LKtyvNqH82RtGnXfj23e/Tp1Lz6dse
	 BQHtLcIIIJNURuOr/TxIFu7gpFzk7qCoD+iBe6QYutJXRuPR/g7JZqaDbOdY64gdQqisN
	 0jOtjJHUpxUTtfdRVegHt2MKshTo2i2bDtNa73m8JLEu5bzHcAcwktL843K59nSir2Ra3
	 P5ReXvPiesqTXjRlpf0z7rnDiAlgX1hVqUEOagBUgCGzZoiA6TcWKBzrkL2Nwcnac8uk1
	 qhKuvPMUQFcMJa0MtZKIQgfImZYujU38kyo3DfCiAo7kikYgBtGNQWtpLX44jpLtRcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TSEPHTS0Y8jf/xVVtzK5W7MEAeigQOSOOlRVps2CB/U=;
	b=qqI8BCuuorBpNGPNHmDXhNxmE0ASKqDMsMTuxoLrOg5pu2Drk3rtta/JwhnjIIH9j13L
	 r7vsKhd0wQRMb6kOb1ltzr42yDtJWW9yGpSfv+2pMbUAWQYWErfdpwHOp+mZBpBy9BLgT
	 0UJETs1VAhHDgBe/aHPc9yP9tCvZPz97xM2yI6fvEX6plTbL8tyRZb9lEFODjBo3RK7mc
	 4gBsmprQqgfvifBncep39wRODkuH2IOv2RvoVRznVD++jTM61mxE7mXd8v5AzIwemSSPK
	 wN8/dng0AXP83GFzifRLNr/0DP4qSJ9AvTBueQmSbBQDc6Rgx3jP2kPTLAxEczdYAsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0n9PgLG6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2304E606E7CA;
	Wed, 18 Nov 2026 19:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0n9PgLG6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4D81F000C7;
	Wed, 18 Nov 2026 19:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030621;
	bh=TSEPHTS0Y8jf/xVVtzK5W7MEAeigQOSOOlRVps2CB/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0n9PgLG6bJJqLUO/3BuMQ5QruYpJcrTaNEOb7sqNDF61YJakOLbIopQ0sbROeApDL
	 v7m29TpeoCFEQDI4xI0Zj6qjoF1hDSn1+mJH+k8eIqE398jlNbPulVWUNWsPrZm21O
	 hlg2QypUyczIMUj7bjSqyg/eAxB0NeHALOJ0dTTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Joonhoe Kim <26rote@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0769/1756] drm/msm/dpu: disable the slave encoder before the master
Date: Wed, 18 Nov 2026 15:48:16 +0100
Message-ID: <20261118150040.240500046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 170d60bb7602d..66759c8a3d8b5 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1320,7 +1320,6 @@ static void dpu_encoder_virt_atomic_disable(struct drm_encoder *drm_enc,
 	struct dpu_encoder_virt *dpu_enc = NULL;
 	struct drm_crtc *crtc;
 	struct drm_crtc_state *old_state = NULL;
-	int i = 0;
 
 	dpu_enc = to_dpu_encoder_virt(drm_enc);
 	DPU_DEBUG_ENC(dpu_enc, "\n");
@@ -1346,12 +1345,11 @@ static void dpu_encoder_virt_atomic_disable(struct drm_encoder *drm_enc,
 
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



