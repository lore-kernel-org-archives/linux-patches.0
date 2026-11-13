Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585514;
	b=nC6buBZtKhz63S3iXwq8dxuGuF3gp0gKbXngf3+l2xOgtbZ2W2IiZoBUO2q6ZzICAKuL
	 KvAMn3u0YP5pbKn4HImaK3ml3L1Z72cR6QJuf4xy1E3+AUjo6Z/V9m6cRl9ccyLXHzYpZ
	 REYeTJ8c55g/2Nu4YjAb+RZxQeIrepL3jdXgcXdDDzir87jIkeJgCReaqy5EZpDo0APUz
	 EbkBXqVwAIp1/Z1mXFp7wdh+V2KIo30NMVOZBNCRlLy1fU6i5GS6pLyzxp40WgsAKXcgH
	 FSLLmaQhlCI2RXrhiD6lmcLL3z9Fr08AC7vw7/X1/4QblGy9FS8K5J6faQRN1XFz/qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=E53RiAhDySlSQKMRTN6dYEB92OvoHO1DKpn0T+Owvso=;
	b=3CD/YZarAgBJpEoS3Kz6vnsqsnHbzhiGUtzVTh7JCe+YcxMWfNnr0l3ELvu/b3VK1KPN
	 I/FfZrSyLoJ2BbGJSUiZcVYzi8ZjvPqqINd5cPVc9JYhv6Q6TIYLrIKAG3pO1kN7mJGLW
	 W5/L2ZZy2nmPNM4DFnhME1DfMOnaoU/IuCJuQbz9+EzKJ47NQg656GS1LalpsqmYIi0gD
	 UBQ2nGNCqO4jQJftfCbuUTZZiPYp4lndjAI3ZgVHsUkKoGuLSRwuHPYV8CKKwJ3L6bFsp
	 VAv7peL6Wj4tAmQav7AUN+10MLc2BCAp4FzhiHVdZpExDte21WhJh79T0Nqfc0nwlfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OOYELUow;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A839D606AE1D;
	Fri, 13 Nov 2026 15:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OOYELUow
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548371F000C4;
	Fri, 13 Nov 2026 15:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585514;
	bh=E53RiAhDySlSQKMRTN6dYEB92OvoHO1DKpn0T+Owvso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OOYELUowYBL8Ass/KQp8IQ+gTzO7jpyQvNYlimJT7YvbvNMQvUPW6nMiZ+uoY5BgJ
	 TVs6IBDKn1aqJ7Ji1lO462LM1JrnfzH3BPJ7lD6JAJQUeBk3GnunvylSQPOAVKWt68
	 Grphtw6XPF8uhnXCnXGkpguD5+j1ut3sT/B0dGw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 160/507] drm/v3d: Initialize timedout_batches when running a CSD job
Date: Fri, 13 Nov 2026 10:47:44 -0500
Message-ID: <20261113153759.926483757@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e6283a75bcdf0..002116efc874b 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -360,6 +360,8 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 		dma_fence_put(job->base.irq_fence);
 	job->base.irq_fence = dma_fence_get(fence);
 
+	job->timedout_batches = job->args.cfg[4];
+
 	trace_v3d_submit_csd(dev, to_v3d_fence(fence)->seqno);
 
 	v3d_job_start_stats(&job->base);
-- 
2.53.0



