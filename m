Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019544;
	b=VedrW6tW/Bclq0v9ENx02wCBrhJ7p3zC+c15ry5uSIviarepOzPeXtffVoIuC5kfH1h5
	 TAAaxosL/YUnJopGanVta22bamLGyjtjJpcuXbPkgz+XVkxDxens4xuuddXUus+2n4Cbp
	 mvH/VAQ4clEm2rmbHtRLXbbLzqMTj8fEL+Av0j4J0+sWgv4zzv5Mgoj69iQkLiJGINrb0
	 zAgIIZwfy0RDh9DvbTjs/AYBxfgIiq0bTbhqsl/6kA4TPDT4RhvFPeVkphroA4rxHH6wp
	 6LCdJFGrgCp+lKWHPGoiJeIQzDht/Exrlhv+EKE94l9gfVpBSjR23F4Npv5XwRtvn9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=u3MzINzeCACiCl0U94SpO87AAjZ2J1wQktbRHYVj8Wk=;
	b=x/tWwrCPFWgtc5dKlsOUQLoLXA71ALIgIXzN+8W+KV1T0WwZTn+dtJpzBQofxCku6tj2
	 HUS+WxtsgWLPYcgcrmG4CAksQD0dTMP+GVMnry5H+3CWBujTuUQCCE/vdh3h7DD8SPONw
	 DW4OsKPHmuDU22mCXuAJfnUp99PSsP4C+gURfvRAiGD0O8DwY+iZWPw2RH68OiNa9Y4Yf
	 oKDg1iHSgmONP5h9+WWhxetm1zgkKOTaGk9jWGiLYA4fcGV21PFY/ScVTFbjTuuY+l2At
	 wP+F/3+rethmntG+TNSNHQFmFIJgpWLPDxWtfo/7Mec8s8WVsgdm46FMZSp/xBrKCuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DVxhofiZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD253606A32C;
	Wed, 18 Nov 2026 16:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DVxhofiZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FC61F000C9;
	Wed, 18 Nov 2026 16:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019544;
	bh=u3MzINzeCACiCl0U94SpO87AAjZ2J1wQktbRHYVj8Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DVxhofiZrLwbd2Pe00CA5gbxrjLIvaV1TkUmXT1OHZ69loA2ocHxizzFhBSr9Eu8o
	 Dk/xDD8mM38rOx36zaxtrCs9osZ8F4B1QLuE0GuDVvh76dRA7FtFTxkzwhZ1Pk92le
	 cEcIkD2QwaF2Y8/ZQS92xWtlFg1be2nfHSqbtyMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1634/2651] drm/panfrost: Introduce a reset lock
Date: Wed, 18 Nov 2026 15:47:54 +0100
Message-ID: <20261118150346.670657362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit 38fb4f01d7ee3a4dd7f8936ff2cb9dc0d0529f1a ]

In order to avoid accessing HW register while a reset is ongoing, a
read/write semaphore that envelopes the reset sequence will help driver
entry points avoid racing with it. For now, the only such racy entry
point is the ioctl that returns the current GPU timestamp.

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20261012-claude-fixes-v15-14-bc0a6c498553@collabora.com
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Stable-dep-of: 9944dd07f3cf ("drm/panfrost: Fix races between perfcnt and reset sequence")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_device.c | 2 ++
 drivers/gpu/drm/panfrost/panfrost_device.h | 1 +
 drivers/gpu/drm/panfrost/panfrost_drv.c    | 9 ++++++---
 drivers/gpu/drm/panfrost/panfrost_job.c    | 1 +
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_device.c b/drivers/gpu/drm/panfrost/panfrost_device.c
index 0b6c38b982194..904d3c61d4221 100644
--- a/drivers/gpu/drm/panfrost/panfrost_device.c
+++ b/drivers/gpu/drm/panfrost/panfrost_device.c
@@ -417,6 +417,8 @@ bool panfrost_exception_needs_reset(const struct panfrost_device *pfdev,
 
 void panfrost_device_reset(struct panfrost_device *pfdev, bool enable_job_int)
 {
+	guard(rwsem_write)(&pfdev->reset.lock);
+
 	panfrost_gpu_soft_reset(pfdev);
 
 	panfrost_gpu_power_on(pfdev);
diff --git a/drivers/gpu/drm/panfrost/panfrost_device.h b/drivers/gpu/drm/panfrost/panfrost_device.h
index 1fe1554f2652b..dec4a7a8bf458 100644
--- a/drivers/gpu/drm/panfrost/panfrost_device.h
+++ b/drivers/gpu/drm/panfrost/panfrost_device.h
@@ -165,6 +165,7 @@ struct panfrost_device {
 	struct {
 		struct workqueue_struct *wq;
 		struct work_struct work;
+		struct rw_semaphore lock;
 		atomic_t pending;
 	} reset;
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index b70de500e134e..cfcf0b042d5eb 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -41,9 +41,12 @@ static int panfrost_ioctl_query_timestamp(struct panfrost_device *pfdev,
 	if (ret)
 		return ret;
 
-	panfrost_cycle_counter_get(pfdev);
-	*arg = panfrost_timestamp_read(pfdev);
-	panfrost_cycle_counter_put(pfdev);
+	/* We should not read timestamp register while the GPU  is being reset */
+	scoped_guard(rwsem_read, &pfdev->reset.lock) {
+		panfrost_cycle_counter_get(pfdev);
+		*arg = panfrost_timestamp_read(pfdev);
+		panfrost_cycle_counter_put(pfdev);
+	}
 
 	pm_runtime_put(pfdev->base.dev);
 	return 0;
diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
index 476c936b54e64..ab83f8f7c8f58 100644
--- a/drivers/gpu/drm/panfrost/panfrost_job.c
+++ b/drivers/gpu/drm/panfrost/panfrost_job.c
@@ -875,6 +875,7 @@ int panfrost_jm_init(struct panfrost_device *pfdev)
 	INIT_WORK(&pfdev->reset.work, panfrost_reset_work);
 	spin_lock_init(&js->job_lock);
 	mutex_init(&pfdev->sched_lock);
+	init_rwsem(&pfdev->reset.lock);
 
 	js->irq = platform_get_irq_byname(to_platform_device(pfdev->base.dev), "job");
 	if (js->irq < 0)
-- 
2.53.0



