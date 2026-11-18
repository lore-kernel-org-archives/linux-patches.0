Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046304;
	b=xeuK6JORlgf8CzjxFV0mSOln48hhKpwodpIT6p1iQ9zovZWapxGsGfk6BBss1immYnkN
	 PD9zGVLrz2fmV3pk/Y0c3uD9oEMz7WYCp5u1/LrpD1Z3Eh/QyrRhrcg/BEnu2UeuKlFHd
	 ErV7YFonNa5GXbrf2SKgNOJcGTKytszTyJtIGSfaQEzwrwOZQ4FzF4AQ1sH/XZHkx88bE
	 0kdkNQYFwICfBPy51EGM8xdgxu6biGgTO1NOMETF8nPPM8IcE2HOk4yGuR4JFvynUCogy
	 Sl4BMEo6Hpm7fmZh4yaJNp2kuA72dealajyRuq88+Ji0adXIZY/fqT9oLVV3nMoh2kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=cFJyiZPN8NoWhAXA0nCTNobsbMIPwF5JumOfGATHqIs=;
	b=UaAD6hC1AMySNege3piruHEcV8Oo87WInhlfBqHw5gThw5H6qA8glsSPvDpoee5z6GwN
	 Vs0g6fA4p2vbfHgJJ3DitzGOSU4IDagRQxcteWU7wKoWV/s7zy18bFqj7UQ2pPHL4WCak
	 onANXyXjSKGDayvQgssjgBJp7W36+eBL9FXmyQJY8vG1M8GLIhvbIFOTP5xtPiqCWOCbU
	 SsJ/hbitclFTRZLs16gP9wZbIRt0avtZTHiojIyC8f7NwTw13RQnSBDzITHV3s9Jl2ITJ
	 YbqReg/BJd00KfXdgtFLXjvB290zzd2SR6USpqjh9OL6RIt0TXh7WgIbCliQUvoWSIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1/AC2kx4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD5C606A31C;
	Wed, 18 Nov 2026 23:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1/AC2kx4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF921F000C4;
	Wed, 18 Nov 2026 23:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046303;
	bh=cFJyiZPN8NoWhAXA0nCTNobsbMIPwF5JumOfGATHqIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1/AC2kx4vH5aOQqJzkoxDnqhf8SEHkZNtJYXtap5hFacK9mHO8QodQiNo9TKeW0f5
	 AQ/JObhioAH8wgcVuW62GTLUcBvBcmpeHOmN8+ouJzkZ2+dXSmnyeEGQ+vmntWqAUJ
	 2JAJJKv/sA4eLBfd6RvYP/WdJT75Y6mwb0dhryKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1232/2857] drm/v3d: Initialize timedout_batches when running a CSD job
Date: Wed, 18 Nov 2026 15:37:46 +0100
Message-ID: <20261118150245.919583251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e31a3c8ff924f..b44cbcc915039 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -260,6 +260,8 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 		dma_fence_put(job->base.irq_fence);
 	job->base.irq_fence = dma_fence_get(fence);
 
+	job->timedout_batches = job->args.cfg[4];
+
 	trace_v3d_submit_csd(dev, to_v3d_fence(fence)->seqno);
 
 	v3d_switch_perfmon(v3d, &job->base);
-- 
2.53.0



