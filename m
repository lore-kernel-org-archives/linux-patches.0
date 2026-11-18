Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037020;
	b=S1WbH3v+98VidKt9mDwlTsQV/IgNaWTDUCno11mtCTTJpCzNe+kvWdLESeYPp+doz5jj
	 VO7wkCXz9GuQJAM316QWSKZWsYo3McyuFAVyxY9iF7LljOPn/pj9U+GVRFcCjpiR2cOZL
	 S/vPiaCA3+ulct5h9J1UbV81ByE8b6of/iTnlUhQOs9BG+7z/HlsSmb73u7W0uXkKp1ZF
	 5X2Wc1z+KmY+8bWqL+Xlu2gLB1Xf825cac720gVz+diMUV33u86xjLcyjwxVWNFzl5h7p
	 kaJitQ5PQhEC5cJUKUL6OFCqUq/kGXxwW90PFxhOxaua074gJjwxLxr7lnL6NVfrvrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bThsrhnlUR3+Dz6O76NvAEoiMOIfKWvX+b3FsgvqLzg=;
	b=Ayb1TLtFDIM8rv6ZQbilD+yP7lRVQErXJ4RvhgvZiHyi2RT3c06PiOq2T7zOfHGFQtaW
	 gDdlAFIfSv+0s27F4W8SNVHzeHoCCTWQGdosf4YHdI1Lsr5YjoqQS2OIku7zkNHtbpDWY
	 EQNMCGHnZo3IaNlBiUF2uTiD4xkAc4A6SGbeoj9NVhZE7Q6HsJcV2dGC84BfJM6X62mZD
	 2m0MARNXXUa2CWu8qQ6uQn6po4o1U8tmPbmyQbdSiDIuaCVEuVFsOfNzfuVHtAGNBD2sN
	 gYNkMt5pxObo7a7XUV4vpMPktA1djiW2Eqf7DUNJFZbrQ+pj4jcMBirTW9xd5SQ0QZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uvJerhQ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD06606A31C;
	Wed, 18 Nov 2026 21:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uvJerhQ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9721F000C4;
	Wed, 18 Nov 2026 21:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037019;
	bh=bThsrhnlUR3+Dz6O76NvAEoiMOIfKWvX+b3FsgvqLzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uvJerhQ6ttNDJ8iBeUq5rgmadNgtmw7kOFWCQU7qP/lHxW0pHOwE72uwwwuxVxBSU
	 plDa/U/rpqe0u+vpp4FbS6HGtUg3HRQxFgu+yg6NhmYeaAEXq/4EwbR/PZVux5Iop/
	 f9tjQmoaYp6+RWW8fLiUa+aB8tM5SYyomemI+OeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1265/3318] drm/amdkfd: evict the queues only once for CRIU PROCESS_INFO
Date: Wed, 18 Nov 2026 15:31:27 +0100
Message-ID: <20261118150358.168862013@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c5d77b1080a34..57a41ff6ea930 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -2703,6 +2703,7 @@ static int criu_process_info(struct file *filep,
 				struct kfd_process *p,
 				struct kfd_ioctl_criu_args *args)
 {
+	bool paused_here = false;
 	int ret = 0;
 
 	mutex_lock(&p->mutex);
@@ -2713,11 +2714,15 @@ static int criu_process_info(struct file *filep,
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
@@ -2732,7 +2737,7 @@ static int criu_process_info(struct file *filep,
 				args->priv_data_size);
 
 err_unlock:
-	if (ret) {
+	if (ret && paused_here) {
 		kfd_process_restore_queues(p);
 		p->queues_paused = false;
 	}
-- 
2.53.0



