Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062630;
	b=3+Y0DonAeV+qu79+lr0FOBOZpKxunJO6HggYJnSXFVqhhN5Oa3+zwuLrUO7dpkWPB6Q3
	 hwgVl5BPY45dg6o0Z8Y596nk9P0J9IhyvIQnC+I7FH4GXazMLmyKHaILS3GeBwBM1u+i+
	 2owy0VjzCGbYcYA7IvdCInN6owNSyDnnZPNJiJ+Ta9W1a6+vLJM9FxlAgnxCT/fNKzYHG
	 Da63RsALjUeRtuY8RvxXNFng18VBGivu4t0FYnv1PndThapZn4CdK00d+j92UXy+p6d2z
	 kIhM84L3GfJDlQN13OaTVgawmlJj4ISdCkF/adqyq7vwXkpLTpITDABD+KUlZ/+FUlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oUDi8nciHxnajvw/avwGTIZJva0YZiF2DTZ8Y4W/vEQ=;
	b=kEASjBfU7lEXqXKE+PcWRwR1MBH4ihBRlA/VVpuVyOrZExAphYloYz3neRzJZW3XxeF+
	 vISn5Fry2UYJ2o89BL4s83gVptydOf74ZYL/SoeL2L+Lv++epeIZjuDGpcXHgdrAXyAIR
	 SHyqWTFiPQV9TapJhPLbIRr8DhrxEuUdxdWbRxi29hLBdPt6yTci7c/LtEKpNlXzNfElT
	 nly9Cdq2DG/tyHlwWkc2cSSpT+j1vUkxNMgxxbtMQzfXxUk5zIjFOJQeAnQX/IQT6/uRA
	 QdvpQoJqV0TYtKCbUwKVBv1rY+gw6XtRYIJPaOMpFgd1jc0CUr8uGrG2aAlJHO9smxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dEFcBQgw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBE3606A331;
	Sat,  7 Nov 2026 14:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dEFcBQgw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6171F0089F;
	Sat,  7 Nov 2026 14:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062629;
	bh=oUDi8nciHxnajvw/avwGTIZJva0YZiF2DTZ8Y4W/vEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dEFcBQgwJSiXLG7qoPRw2ryC+RQhDbSLf1UdRFCSfmp0tk3+JljFj24TiIoEn/B2j
	 yP5xDGsHozKDAcg098b38Qwt6Xx3RctfB1E+DQu/hpzPm0ms6Hy52Ta3VfeguMuziD
	 D8d2IHsqkISs4SpsV8U17uav7AtEfG8gb93Pzq8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1500/1536] drm/amdkfd: evict the queues only once for CRIU PROCESS_INFO
Date: Sat,  7 Nov 2026 08:58:36 -0500
Message-ID: <20261107135039.994332086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 8f3ecda0ab42fb5ba7310fe848013d3eff31b416 ]

criu_process_info() evicts the queues of the process on every call, and
each kfd_process_evict_queues() increments qpd->evicted, but CRIU UNPAUSE
restores them only once. After PROCESS_INFO twice and UNPAUSE the queues
stay evicted for good. On navi31, a barrier-AND packet on an HSA queue
completes after PROCESS_INFO + UNPAUSE, but times out after
PROCESS_INFO, PROCESS_INFO, UNPAUSE.

The error path has a related problem: when kfd_process_evict_queues()
itself fails, it has already rolled back its partial eviction, and the
kfd_process_restore_queues() in the error path restores once more.

Evict only when the queues are not paused yet, and on errors only undo
an eviction done by this call. The barrier now completes after any
number of PROCESS_INFO calls followed by UNPAUSE.

Fixes: cd9f79103003 ("drm/amdkfd: CRIU Implement KFD unpause operation")
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d79c9e3c32c677fcadf5ca10ab81ee0a4b81f99)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 5224733a1de39..9cdf7a0fbdf84 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -2702,6 +2702,7 @@ static int criu_process_info(struct file *filep,
 				struct kfd_process *p,
 				struct kfd_ioctl_criu_args *args)
 {
+	bool paused_here = false;
 	int ret = 0;
 
 	mutex_lock(&p->mutex);
@@ -2712,11 +2713,15 @@ static int criu_process_info(struct file *filep,
 		goto err_unlock;
 	}
 
-	ret = kfd_process_evict_queues(p, KFD_QUEUE_EVICTION_CRIU_CHECKPOINT);
-	if (ret)
-		goto err_unlock;
+	/* UNPAUSE restores the queues once, so evict them only once */
+	if (!p->queues_paused) {
+		ret = kfd_process_evict_queues(p, KFD_QUEUE_EVICTION_CRIU_CHECKPOINT);
+		if (ret)
+			goto err_unlock;
 
-	p->queues_paused = true;
+		p->queues_paused = true;
+		paused_here = true;
+	}
 
 	args->pid = task_pid_nr_ns(p->lead_thread,
 					task_active_pid_ns(p->lead_thread));
@@ -2731,7 +2736,7 @@ static int criu_process_info(struct file *filep,
 				args->priv_data_size);
 
 err_unlock:
-	if (ret) {
+	if (ret && paused_here) {
 		kfd_process_restore_queues(p);
 		p->queues_paused = false;
 	}
-- 
2.53.0



