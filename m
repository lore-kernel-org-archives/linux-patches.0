Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216620;
	b=eHE28xY+qegt9aRRdASufm/FheKtWWgXrwOmaT1sd7w5fmXtnd3podXMINWGAfePSD8P
	 5LHNot8vv12S+iokAXr+r6ShuinwUrojuh6VD4FikZbDiLezCxmmos9xV4X/hhUu4YHkv
	 x6daY3TiezJNh676Cz8bzKLQ7xcH2X60HUK+MTrE9vcjcyiAFtDOn7IEas/dbe1khlaAQ
	 slT1i6jJnLZSyaQOV7jCxQL3CuRu/6XKPZah7AUOWC13vLt4Rso83yXhi5CWcUBOxrzX+
	 uwlI8PtDO9D2I2psPvaNjKNg42+V8/HDH8LFnYhU0OVxNwwyVt75R7zEJHukZ9Hl2Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mgcMIrMRO4bWHJ2rFDvPGfidN2z44AjigNcQZXzTWnU=;
	b=4lH+KwikjDFXC1PMUaG3kLxYrrZ9mZTEZxTpKFCbb6qyLCySCxKjgbnhG729cIANtO82
	 b/J/MpqVLHLEnKNM0FdqzNgumr6hNN+3mCiqYsYJEgJmSBVPciHWoP5MUI/wPL2ISAZmN
	 c50fOz+c1e7SExRso5gRIyJuFcuisCMaZ/+9OJFJ53vsinZwlT8wEBv8FBXoyrfUVvIDF
	 NMJB1i6OoX8oTaMa7ybwHW8pZriHj/v3oJt53kr0tmEJrIc8G3/eODbG7nKkqzB4J/T27
	 c6fcLKjswEc+6z+4otjFcpTpTLPqoiO73u6oNAIX4SolBxI9DgcvmJmvtlRrc2ksy8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rt1DNoUg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE98606A31C;
	Wed, 28 Oct 2026 19:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rt1DNoUg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9241F01828;
	Wed, 28 Oct 2026 19:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216620;
	bh=mgcMIrMRO4bWHJ2rFDvPGfidN2z44AjigNcQZXzTWnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rt1DNoUghkur1de1Lgg6nh8bMVghLvru8DSdna+GxqcEF9Gyju2VIlvv59cV3y3yb
	 1S02uEv6sdmiGH9FEO94J7WT+Erzr+OiPbOxK4a2QFy4hsAoIPBxdosivYQbgculSe
	 N8xB99GyplL7wxcB2cgK9mKI7PorQ64l7L7hk5t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1620/1887] drm/msm: Only fini scheduler after successful init
Date: Wed, 28 Oct 2026 18:01:56 +0100
Message-ID: <20261028170536.334201540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit e2332abed2a4d3caa59052095dc16e4ce44791ea ]

msm_ringbuffer_new() destroys a partially initialized ring through
msm_ringbuffer_destroy() when an allocation or scheduler setup step
fails.

If drm_sched_init() fails before it finishes initializing the scheduler,
the failure path still calls drm_sched_fini(). That teardown path assumes
the scheduler work items, lists, and workqueue state were initialized.

Track successful scheduler initialization and call drm_sched_fini() only
after drm_sched_init() returned 0.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 1d8a5ca436ee ("drm/msm: Conversion to drm scheduler")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/738905/
Message-ID: <20260709062309.4168362-1-ruoyuw560@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_ringbuffer.c | 7 ++++---
 drivers/gpu/drm/msm/msm_ringbuffer.h | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_ringbuffer.c b/drivers/gpu/drm/msm/msm_ringbuffer.c
index 78b0b48b87be3..af9ba8bba445e 100644
--- a/drivers/gpu/drm/msm/msm_ringbuffer.c
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.c
@@ -99,9 +99,9 @@ struct msm_ringbuffer *msm_ringbuffer_new(struct msm_gpu *gpu, int id,
 	ring->memptrs_iova = memptrs_iova;
 
 	ret = drm_sched_init(&ring->sched, &args);
-	if (ret) {
+	if (ret)
 		goto fail;
-	}
+	ring->sched_initialized = true;
 
 	INIT_LIST_HEAD(&ring->submits);
 	spin_lock_init(&ring->submit_lock);
@@ -123,7 +123,8 @@ void msm_ringbuffer_destroy(struct msm_ringbuffer *ring)
 	if (IS_ERR_OR_NULL(ring))
 		return;
 
-	drm_sched_fini(&ring->sched);
+	if (ring->sched_initialized)
+		drm_sched_fini(&ring->sched);
 
 	msm_fence_context_free(ring->fctx);
 
diff --git a/drivers/gpu/drm/msm/msm_ringbuffer.h b/drivers/gpu/drm/msm/msm_ringbuffer.h
index 698b333abccd6..eafaa7cef3242 100644
--- a/drivers/gpu/drm/msm/msm_ringbuffer.h
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.h
@@ -50,6 +50,7 @@ struct msm_ringbuffer {
 	 * The job scheduler for this ring.
 	 */
 	struct drm_gpu_scheduler sched;
+	bool sched_initialized;
 
 	/*
 	 * List of in-flight submits on this ring.  Protected by submit_lock.
-- 
2.53.0



