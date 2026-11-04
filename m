Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831291;
	b=EB5YKsBXwz610peuJZa3U5rv27o0+ChFe0HBi2qF0HN+SfP/H4gG7wmYsN5CYply5+j4
	 rDWGMB1dOL0IPAsEqNMbVFDm4W8W/6AGPC3XoYRsnyeGAh/ra+Zi6lpYQI2kayrkVQLSl
	 uKk+r1Vh6TzcYnvIwrk5vYpHvIIUFXdpeopFTwzkmtWnwy2bTFZXtB+gamPXPhAGMxuWa
	 Lw3RYl8pDYqg18YcbC5gGcy1y9OWLvIkwmaHI7Y03sRpIieZqfD2UUIp8NpIrOoSBmH9h
	 6Lz6ewwjhQT2eyaLeIxZsuID68HT43orgEWNXrjqSdViUrZVhhDX6AH+p925uVuEo3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7pSVZ51hw46E+L8ffxT4gHw63q/7AQQxTNV6TzpzUlA=;
	b=xtZjTIi66OMh3sT3gXIO1i6IeIb8Kfcv5I5agBV6km0gcJNa0X90kXY6xa4CMS60nGiw
	 4Ck/PI2tj7Pv3UQUogdDK8/Dj734hRwWtDfzO9tJHZzDP7q+yN592+8TMjdtoxPGpGR6w
	 k7t1XiqwPQS5qEt9/S8/BJDvKBeZ4JXbIrvAQLAo/B4i60BTzeekCi1ulDoh2gytU+/bD
	 89C0u42QxbSa8omUSFdNL3nG4wlivIsgLnUr7MRwMMdycbKhgdgu3Wm+5ptNUc7aQEfce
	 5Hk9cxVVGK138Mk8Pb4DS1vzFsTdTjF1xZKdkM6DMlYOFkMfW2BQHTJH+R0MX3qDdEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hwd8Vhv9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5A9606AC1C;
	Wed,  4 Nov 2026 22:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hwd8Vhv9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4643C1F00919;
	Wed,  4 Nov 2026 22:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831290;
	bh=7pSVZ51hw46E+L8ffxT4gHw63q/7AQQxTNV6TzpzUlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hwd8Vhv9SYMg1inlp8lMb9EN4/Du2lmXhZXLms+Zsq+GSNdTNG39uEOzhbdXUTDd9
	 TDGuE/kpwcXSG8s8YbAoX3KIWlZrpfI1xXOXw9DwivSQbKu8pwR2eMt/srs8rxf9vv
	 H087bUQ8tUPOAF8UVzadN9p9zKJl0y2nlwgvVOPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidong Yang <sidong.yang@furiosa.ai>,
	Igor Paunovic <royalnet026@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0614/1005] accel/rocket: search every core slot when looking up a scheduler
Date: Wed,  4 Nov 2026 16:05:47 -0500
Message-ID: <20261104211101.036691926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Igor Paunovic <royalnet026@gmail.com>

[ Upstream commit 89c2c777df17eb0201c8e22afabbf3691f2a28fe ]

sched_to_core() walks rdev->cores[] up to rdev->num_cores, and
rocket_remove() decrements num_cores for every core it removes. Unbind a
core that is not the last one and the cores behind it fall outside the
search, so sched_to_core() returns NULL for a core that is still bound and
still running jobs. Neither caller checks the result:

  rocket_job_run():      rocket_fence_create(core), core->dev
  rocket_job_timedout(): dev_err(core->dev, "NPU job timed out")

Unbinding the middle core of the three on an RK3588 while three clients are
submitting to all of them faults twice, once from the surviving core's
job queue and once from its reset work:

  KASAN: null-ptr-deref in range [0x0000000000000220-0x0000000000000227]
  Workqueue: fdad0000.npu drm_sched_run_job_work [gpu_sched]
  pc : rocket_job_run+0x234/0x838 [rocket]
  Call trace:
   rocket_job_run+0x234/0x838 [rocket]
   drm_sched_run_job_work+0x2cc/0xad8 [gpu_sched]
   process_one_work+0x640/0x14f0

  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  Workqueue: rocket-reset-2 drm_sched_job_timedout [gpu_sched]
  pc : rocket_job_timedout+0xf0/0x1e0 [rocket]
  Call trace:
   rocket_job_timedout+0xf0/0x1e0 [rocket]
   drm_sched_job_timedout+0x188/0x6a0 [gpu_sched]

Both are the third core: the workqueue names are its device and its
core->index, and it was left at slot 2 while num_cores had dropped to 2.

Search all the slots that were allocated, the way find_core_for_dev() now
does. A core that is still bound is then found, and the two callers get
the pointer they already assume they have.

This does not make unbinding one core out of several safe. An open client
keeps an entity pointing at the scheduler of the core that went away:
drm_sched reports it as not ready for every job that lands on it, and the
client waits in dma_fence_default_wait for a fence that will never signal.
Stopping the NULL dereference is what belongs in a fix; the rest wants
more thought.

Reported-by: Sidong Yang <sidong.yang@furiosa.ai>
Closes: https://lore.kernel.org/dri-devel/apwUewaRnoTNXHCt@rock-5b-plus/
Fixes: 0810d5ad88a1 ("accel/rocket: Add job submission IOCTL")
Cc: stable@vger.kernel.org
Signed-off-by: Igor Paunovic <royalnet026@gmail.com>
Assisted-by: LLM sparse checkpatch
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260905150432.7477-1-royalnet026@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/rocket/rocket_job.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/rocket/rocket_job.c b/drivers/accel/rocket/rocket_job.c
index b374d7ee54b68..729b7d6d77d46 100644
--- a/drivers/accel/rocket/rocket_job.c
+++ b/drivers/accel/rocket/rocket_job.c
@@ -283,7 +283,7 @@ static struct rocket_core *sched_to_core(struct rocket_device *rdev,
 {
 	unsigned int core;
 
-	for (core = 0; core < rdev->num_cores; core++) {
+	for (core = 0; core < rdev->max_cores; core++) {
 		if (&rdev->cores[core].sched == sched)
 			return &rdev->cores[core];
 	}
-- 
2.53.0



