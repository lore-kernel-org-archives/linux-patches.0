Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064371;
	b=j6yQG0U5PXex3cJ01AEjzU2Osj4otEmPMXgVBFlKDZEznTiM6FJNVubM/DpBJu6NgOJF
	 4OQPB9dNasArLkweiEEotbQIxg/hyrScm44+Kap7em5ApZhKHyqZwJUYB/3c6NPq+5K3C
	 S9M56HTSAMDolnGGP50Tlj/ZGBqFu1DBFPhjMRep/EHZvRVxVP147MKyKkajbHhx1GpMb
	 ZNZpUgz9oO/V/aynHqBYRM1LIu6P8xu0fOMg63dy68TnPJ4xAt/fdOBN6u9koVquR9xyf
	 Hl8pFbLjKwgOJ/tB3WJj6nkuEwXwGFFZvg9HSXqtCB+zcaHmhZdoBxm0yfbOI4G8JIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=djqNcpeE99rqUXriovBwJLjGSE9G9FoXktemahMZoyw=;
	b=tqoqtXWeuBVJvVDOBzWinqOF5fq5fN8KE6/1bq31kwnMe/Rvbv3bK9O0vqv6UqMSXEVh
	 +S9y8O/0nL0KNiJ84GAjlxPGErEqLpmZWhE0Z97oDfwkU9SGx/uAHUek7TwPxTckrsaGI
	 57DCuhO+Bb+VLhnDIvn/+uYYORoAu7++5zj7vvKEqpJp4CWvOQvJJiS0fP4snR40xkL4l
	 C1IPHSHzHcj173bg62B6PSeuioy/NIs3E/rovehhwsxfugQloZF9JK6svaywd1MXN3Hbu
	 h7xEv8Jd8AKswlxEeD3aYYTdsCgQAJNtKA4LqA7OFw7PnQbqiipq8QI5OYseEDoJe0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zvT0V9fA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B12606B8B8;
	Sat,  7 Nov 2026 15:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zvT0V9fA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AA91F0089F;
	Sat,  7 Nov 2026 15:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064371;
	bh=djqNcpeE99rqUXriovBwJLjGSE9G9FoXktemahMZoyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zvT0V9fAd/mYtwbEOiO0OI0WU8ypbb4ifsLTjutSdq3SBeTsftfo1wmlErwIHqYVI
	 Sikmhrw7gvZyrGactaHfYXcb6sUmX3068ybkimadHzO7ibhu+Pm62HHSi4sxhMD20N
	 GENrZ/LFoPZNgXhGdw7VhjoT0jwtkW5mr4HDVQNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0450/1257] media: chips-media: wave5: Check decoder qbuf runtime resume
Date: Sat,  7 Nov 2026 08:45:46 -0500
Message-ID: <20261107134951.907935420@linuxfoundation.org>
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
index 6564cf3ec739b..86bc36ee17fd6 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -1302,8 +1302,14 @@ static void wave5_vpu_dec_buf_queue_dst(struct vb2_buffer *vb)
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



