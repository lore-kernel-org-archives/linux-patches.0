Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063112;
	b=ka+r257VvNYd09R10JLjn2rbLMYQUC1L2kdS1HzB96jEI822sLcSjEItO4ExmRZKN6lF
	 FBnieYzLq96g0HNabRBuUtNmZQFK5mMQt412MZvhvu9WuEgdmw7gDLNKlJ3yEx/fHQgwz
	 iy7pCy930JiNuBtkji/oBR6l5/4RIosUb5fAHGYAK5O6OmCy74F8rVGJPOutKPuw6E9B+
	 fF+9JKAwl8qq3HlW87QJaWc6/PQuoxbmYHIDXQ1Imv5+pG2SV3sWgWn6NmtVqq4XlidK/
	 ItbKQuJGz7Lk0vxmbaGfAVS06L/1a1SxSVg7OlLZ0DRp5M4g30FpcEtKO2nBx4kCDTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C+y5pWgyzzLgvKEXVO+FoYZGyJErG/T7zOP9Zbmj+ts=;
	b=N1QycNKZINlKYnOCY7YPRxVyuugYhH6+dG6dmqxPGEOi3ZmWazAJSC0/wKq0xcTezMnn
	 6MlTv8qITfgGHAVTHC4Qsgq0hLeWkP0Ke0aSHZ1HT9PWmXfkcbEQSbklZUtCkj9jcntjY
	 T/RGAtKq3Cdp3rGxMzrdKG3Mo2oiqdyYkuqXoHwKjYOtIEYuUve7N3++xkvzBRovb3+0h
	 YmFoSCzCTtOhU+kUke+HUx8ILHWO7sKZvGuJCjfR5XKfYI0y9kF0Az3aZP6lXUwmzdrJt
	 7m+dqh9sOsO/OntFAAGyCpytglweNUIHUYO46XihSqqP4PjpySon+YcbgyHtB6fxnZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z8uYCT7Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3375606D838;
	Sat,  7 Nov 2026 14:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z8uYCT7Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC201F0089F;
	Sat,  7 Nov 2026 14:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063111;
	bh=C+y5pWgyzzLgvKEXVO+FoYZGyJErG/T7zOP9Zbmj+ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z8uYCT7QA/1g9RagfIeQdT2+Kry9R9gOenMu6q5AFMB95ILO9PyeXaNzRb8xRUwIu
	 7Zk8qvbrPkomDZOfnuZpp9l8+S97pZX03xppfiBcSdtpoNwY+ZGJr2EcsOdOeFM/+S
	 ltRtB7DgazHHLmlH76PQxpAJUS0WOJtCnruaSrb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 343/869] media: chips-media: wave5: Check decoder qbuf runtime resume
Date: Sat,  7 Nov 2026 08:50:25 -0500
Message-ID: <20261107134904.004760530@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 158b39a0f7d198454a1fb34dcca5c25de588d54f ]

wave5_vpu_dec_buf_queue_dst() resumes the VPU before it may clear a
decoder display flag. This is needed because clearing the display flag
accesses VPU registers.

However, the return value from pm_runtime_resume_and_get() is ignored.
If the resume fails, pm_runtime_resume_and_get() returns without holding
a runtime PM usage reference. The unconditional
pm_runtime_put_autosuspend() at the end of the function then drops an
unmatched reference.

The failed resume path can also continue into
wave5_vpu_dec_clr_disp_flag() while the device is still suspended.

Check the return value. If the resume fails, complete the queued buffer
with an error and return without touching the hardware or dropping an
unmatched runtime PM reference.

Fixes: cbb9c0d50e47 ("media: chips-media: wave5: Fix SError of kernel panic when closed")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
index e1ad685a42e52..6f93fdf28ab3a 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -1261,8 +1261,14 @@ static void wave5_vpu_dec_buf_queue_dst(struct vb2_buffer *vb)
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vpu_instance *inst = vb2_get_drv_priv(vb->vb2_queue);
 	struct v4l2_m2m_ctx *m2m_ctx = inst->v4l2_fh.m2m_ctx;
+	int ret;
+
+	ret = pm_runtime_resume_and_get(inst->dev->dev);
+	if (ret < 0) {
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+		return;
+	}
 
-	pm_runtime_resume_and_get(inst->dev->dev);
 	vbuf->sequence = inst->queued_dst_buf_num++;
 
 	if (inst->state == VPU_INST_STATE_PIC_RUN) {
-- 
2.53.0



