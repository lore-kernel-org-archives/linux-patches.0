Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591084;
	b=Ow2CbrLGDheacY3haSMfGtfRvcnlvdjPNDokcaIfEpYuzGniMbbGKzHfX8zDh8+Ihkhp
	 HwgRF//F2D3Cn2riV4P9sZ9IaE4lPaMbeMDWpIJkqenzX4ib7KOvGeMJUkSNOXb5UhtPa
	 itOe6143d4g2tdFTkSNUybkyHaU9Okh2QZxhEKAS0Xgz7FVk5zByD8VhsyND3708FxUbw
	 m38ILyARTrWdrwqedIGGk1zWJav9ACvm4WiYhB3Mo55swGDVS9q2TEAdm3fHaN12gUubY
	 4OdHNoGmW3f72uYmmtqTiVPjQNreKu+YNC+npwRS831hg0R5dctKM9BoDSldFlPqqyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=YR7QFqv/iJn8DUy6bt+Sj761RnSEtSKXZNsW4W97oKk=;
	b=bIEJM6HFwTRgs4j+BDGHmrkWA4EWKTbSjXPt713/Qiqpg7tDdfU8O2Bp2ygQYULaAI1f
	 ivxPebemQq+6VPArSi6OUE0Ch4xkwX9hSkRuT00gEu3rdmUwJtDrMo2tfWUkeWXGNoT5n
	 Q/Qf/rBRwCWoIv81lvZGW7GnpckVAUM4IDuk55BCwQIONBE6VE1z137TRErggnAmM+npv
	 FHxMf1wJxTmuPdh8jCdpP2lzvvojf7rqoznJvin1Y9CSUHRQNFTLxTfSbx0vOti+XA35x
	 hl947wn4lfnJrfSZcTSyVpzfGpiHVGglfeHpY0QJvdQjknMTY8GpX6cjFXx5/6lOA9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gB6ByyrL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEC7606B36B;
	Fri, 13 Nov 2026 17:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gB6ByyrL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB33B1F000C6;
	Fri, 13 Nov 2026 17:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591083;
	bh=YR7QFqv/iJn8DUy6bt+Sj761RnSEtSKXZNsW4W97oKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gB6ByyrLqPMbyvo0QzZTrcC9H+E8a/ARHa7BG6SPNXvG4hIcy8J77w8zYASqONt4Z
	 eEajehiI8dU20qJxuHzU1odqGCqnpyFo4VKeUPGFc3xwGHunjuuSRNFYmHqhR4xumC
	 qLD842kIueWb+Y1E8jJKKgJGGdBpow3gVqBNawQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 238/670] drm/v3d: Initialize timedout_batches when running a CSD job
Date: Fri, 13 Nov 2026 10:46:42 -0500
Message-ID: <20261113153819.917320141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 70bd566cf6d42..2dd678fd86071 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -395,6 +395,8 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 		dma_fence_put(job->base.irq_fence);
 	job->base.irq_fence = dma_fence_get(fence);
 
+	job->timedout_batches = job->args.cfg[4];
+
 	trace_v3d_submit_csd(dev, to_v3d_fence(fence)->seqno);
 
 	v3d_job_start_stats(&job->base, V3D_CSD);
-- 
2.53.0



