Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053282;
	b=MVtVgKqiqjgyfaTHaC3AqqU4pBB+WLi9NLMaOkZ9fjNgnH+4a0K1n3T+yND+wlPge7V+
	 JvyDSF5ppNOwX3EqoefKAbYcdufhTeYpJWtvPNYfUx/CoH4jX2RYsDZxEFtO9KQ8zxW9/
	 il5ynaWRamIBkEUjYOkn9UrY6+zQTBaV3xYD0FdabgOh4abjyvH3qXPIUkRMYqCdJQEEU
	 zfvM77ii43snWw423Vc+nUuggDJQk2+F7A7UomU2c6kJYlw2+JMOjlQDQ7PFoyh7x+IZs
	 uDJ/3i6goq5vXM038SffdcrTCBffpxPuhiH9Qve3kPmpNgqRQ2q6Wqn8dPlyOR4fmxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Bav6t5p7Y0EtnJUGbJy+DM0kYSa3yC9CFFKyhi9/Ras=;
	b=ihzpnB/v6DB6RPx3n7WkWFGluXwvvoxzKkeGqLfiwmiN85KeUF34+yNTTWKS+ToBrcp8
	 UgcvyiDxhx27tzAuzne+NWk1klJZZfri2LMalX6bAw2RwOOKEiONXDZZdfbvMCMBai9D6
	 dtTlgWCAYr5RJXMuNNRN513u1E9xjWtaDpr3X1mohGVklBKVjWMaFXrSbyHX1pzcfnaKw
	 9r91hhx4OFf3yl+NTZ8RkFccIi/HDCqHqGWXXHbVw69XQV327eQl9ASgGKSbnbFEEZ+sX
	 EHolVRwn81fhgeFOMv88D4u0Vw9TzAv1xumF5dsgo0uaBkZG1/gnanh+Lgad/2o60FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hx1AIekv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A10606A320;
	Thu, 19 Nov 2026 01:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hx1AIekv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FEF1F000C6;
	Thu, 19 Nov 2026 01:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053281;
	bh=Bav6t5p7Y0EtnJUGbJy+DM0kYSa3yC9CFFKyhi9/Ras=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hx1AIekvTBjodWNYgnWppqV+KlZg6d/e5whiuVgJRtNmaGmPYTcQnum/8esxOJ3T6
	 qoO9WEXsIPz1HpqHJyYKP7wBKKqVFDWZCnsTBvijKS9/cTZamYCzjxCej34rddo2rw
	 lOPNmk6ypdbnizO7Fniiy9ipVX6ZT9rD9cs9+weU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0864/2214] drm/v3d: Initialize timedout_batches when running a CSD job
Date: Wed, 18 Nov 2026 15:42:20 +0100
Message-ID: <20261118150046.713950182@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 46c52d89cb249..a82b125d0141e 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -279,6 +279,8 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 		dma_fence_put(job->base.irq_fence);
 	job->base.irq_fence = dma_fence_get(fence);
 
+	job->timedout_batches = job->args.cfg[4];
+
 	trace_v3d_submit_csd(dev, to_v3d_fence(fence)->seqno);
 
 	v3d_switch_perfmon(v3d, &job->base);
-- 
2.53.0



