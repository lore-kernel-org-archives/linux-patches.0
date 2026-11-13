Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590272;
	b=ljbjlKRg4WoBsvR7XjLRhoStfctxIhARwoQZYyC98elYffgsDibRWesv7q/sRY6DBN37
	 IPFXc4CGtgsLUJlk3djF82Jysa4NpyiOX1ntYG+LxfBdOt2MayWKcnoDb8+WnZ9A262jZ
	 emSZRk83CqJp5TIJ6VrNOHZZZGcO3089YXeBb1bsJZ6pIJ7dOZZnm0M2DdVjjhgwKyncu
	 R0ahuJ0KkyeYPOb57b6UadgIXbi76Ab6BJSLJ8E9M6MsF4L7sao/5A/iGjRVKenAK60WX
	 PFkzXSDuJ79pv1QOFhCOF3Bj+fPlip+lD/HIvZp/Vkxis0V6MjOnPVmNxJf0YP2N+Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=61xF2ly0dzkoJcN3n83wisiUHRj5NaQd14O3a72YR84=;
	b=Ko6+VYJU28bw6679rF14GxhldyGlh2BMU0OuDIU/zKRdfPBx0FKq6+RgZapb+c+ToZ4W
	 qTpRMxFmVdmxZz8c9aPus300yXHOLrjNGfqf0NyWSR+gwLg39r1jDwLrMK/3TUi0RjkGM
	 qNjkEAkXQcg4NKy7Wy32xM7r8U7QlAZ7KcG6dU12N0QheNIirfx/EzNyLhtYRug8UpywH
	 SaHsIyXtVqEN8YPPfiiMNp35lnqoTFfawJX1jkfAzDbJBJUBNyliY3stEcDQOn6Wg8vRY
	 CviJXsJ2dLrOsKVBIvzpLrxzph0Zb/c8urTd3c6n/mF32rOUsVl5B7+NPJPl+cjkm8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RFsXBegc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DD4606B204;
	Fri, 13 Nov 2026 17:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RFsXBegc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AF61F000C4;
	Fri, 13 Nov 2026 17:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590272;
	bh=61xF2ly0dzkoJcN3n83wisiUHRj5NaQd14O3a72YR84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RFsXBegcyk/G4943xuUqiiC5ETwdeUs1h9uKvku3m1kCg7zl8RiC5y1cODTxzaOra
	 xJdj6+4MHd95wi7Bk4z2x/G665K4Tqxk7xJb8QsI/6KbbnzQS3MvbRnVTbGalvGxlS
	 CUVFBB5F9cPeZg+qDm9NO9eoLy3TXltqnOKxnoSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 263/686] drm/v3d: Initialize timedout_batches when running a CSD job
Date: Fri, 13 Nov 2026 10:46:36 -0500
Message-ID: <20261113153829.941770857@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Maria Casanova Crespo <jmcasanova@igalia.com>

[ Upstream commit 0afdbdd5b1af729108de8f893d179c3b99eac29d ]

v3d_csd_job_timedout() decides whether a compute job made progress by
comparing CSD_CURRENT_CFG4, the number of batches the dispatcher still
has to start, against the value saved at the previous timeout. That
saved value is never initialized, so it is zero on the first timeout.

On V3D 7.1.6 and later, CFG4 counts down to zero once the dispatcher has
started the last batch, but the dispatch keeps running until the batches
in flight complete. If the first timeout fires in that window, the
handler sees no change and resets the GPU while the job is about to
complete. For example, this happens with long dispatches that only keep a
single supergroup in flight.

Initialize timedout_batches to the value programmed in CFG4 when the job
is started. The register does not return to it once a batch has started:
it counts down to zero on V3D 7.1.6 and later (CFG4 holds the number of
batches), and to 0xffffffff on V3D 4.2 (CFG4 holds the number of batches
minus one).

Cc: stable@vger.kernel.org
Fixes: d223f98f0209 ("drm/v3d: Add support for compute shader dispatch.")
Signed-off-by: Jose Maria Casanova Crespo <jmcasanova@igalia.com>
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patch.msgid.link/20261101125619.2465064-1-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_sched.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/v3d/v3d_sched.c b/drivers/gpu/drm/v3d/v3d_sched.c
index 9b98386965796..5cdfc107a012d 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -403,6 +403,8 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 		dma_fence_put(job->base.irq_fence);
 	job->base.irq_fence = dma_fence_get(fence);
 
+	job->timedout_batches = job->args.cfg[4];
+
 	trace_v3d_submit_csd(dev, to_v3d_fence(fence)->seqno);
 
 	v3d_job_start_stats(&job->base, V3D_CSD);
-- 
2.53.0



