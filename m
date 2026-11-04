Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829671;
	b=ahfaTmGCKS86cpQnP3G3paKfxN28ivNes3hNuOhL0yzIO99YgoMwbvrlplFpK13rqDYq
	 asEbLbpAW87L85xemJZcb+Cdz6CEmrVR9ARrk8RrJvSV1EVHVQnzo3DcninPslGS4FhgI
	 DOk+oG9l6SL8KRp/Y2Ub0+/2hs1CBZ0VOHocyYGXp8HqNPppGZehW9ir1eqI3jZOBpAsY
	 l+fq56H7NNyIN7+gDYN15lgbusrNgMGmJXamZoYpDH+U9Y0wZowtz4upMcPmD/Hby8VjS
	 ZsM5g622WGBOV455CAyO2Dzqrs5mdv6xeMPjZXqFeHn+LWpO4S7itF151XDL3VyMCIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9z5ymhvh+Hm7ff64vdie+YY/XMrNeqr9uc6ECTIKVI8=;
	b=2OCC78//z5uPPZ2Q+ItkKJy/ecy0rDWquwzKFVEJxvYa27yENv4Y5ea4RArp8K61QRMQ
	 IOq6gkn04s7YDOijflXNuIpP5ZvcLCBd5TRPHTmHcmmn6npeV0S5qKTvTVeN9DmGSv0IQ
	 a298bmvnr3qmyJRFzhgX8Do2td69K+1DBIbeMK80mabWRcFP9rxN57hPuODOksGBNN1xq
	 KHk2N9s5POMcbQzXWpCKhC7xpAPmzLW6Epk828l7/f8mpuhj9aa6kxmS4jg1kF8rvYd4g
	 6qK0bnOhZXIQA4kLlAYFPOQOQAwC3W0bdKoiZmH+QOMIPkABVBSEwlkcSlBRVrUau/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1nPecOLV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923D5606C587;
	Wed,  4 Nov 2026 22:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1nPecOLV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282B21F000C1;
	Wed,  4 Nov 2026 22:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829671;
	bh=9z5ymhvh+Hm7ff64vdie+YY/XMrNeqr9uc6ECTIKVI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1nPecOLVOA8o/thDfOuV77JHC31C+CU1aLsh3kirffvu2AaVNZV0mFnD82+Fq6ame
	 3LthzwYhBtZVQFDlaC0D87qKtO77raMPjopTGR335Ypic7YUDDu1rRxW1nDRQu1c9d
	 jxPSxxEzLavSFNqC8ahsPfl94LGZmS+gmYgKbpf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amber Lin <amber.lin@amd.com>,
	David Yat Sin <david.yatsin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0271/1005] drm/amdkfd: Fix signal reset event
Date: Wed,  4 Nov 2026 16:00:04 -0500
Message-ID: <20261104211051.470441410@linuxfoundation.org>
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

From: Amber Lin <amber.lin@amd.com>

[ Upstream commit b38f9b6ffdfc86d5aff36881d9e8028c79bc98c9 ]

When a mode reset happens, driver needs to notify the process on that
GPU a reset event is happening. The existing code assumes the process is
using the GPU that is getting mode reset, which is not always true. For
example, on a 8G system, the process may be only using GPU 0~4 but a
mode 2 reset is resetting the all 8 GPUs connected by XGMI. Trying to
find a process on GPU 5~7 will fail, which is fine and should skip the
event signal.

Signed-off-by: Amber Lin <amber.lin@amd.com>
Reviewed-by: David Yat Sin <david.yatsin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_events.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index b033c3a9ce545..aac5bc4d13fdb 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -1287,6 +1287,8 @@ void kfd_signal_reset_event(struct kfd_node *dev)
 	struct kfd_event *ev;
 	unsigned int temp;
 	uint32_t id, idx;
+	int user_gpu_id;
+	struct kfd_process_device *pdd;
 	int reset_cause = atomic_read(&dev->sram_ecc_flag) ?
 			KFD_HW_EXCEPTION_ECC :
 			KFD_HW_EXCEPTION_GPU_HANG;
@@ -1302,17 +1304,14 @@ void kfd_signal_reset_event(struct kfd_node *dev)
 
 	idx = srcu_read_lock(&kfd_processes_srcu);
 	hash_for_each_rcu(kfd_processes_table, temp, p, kfd_processes) {
-		int user_gpu_id = kfd_process_get_user_gpu_id(p, dev->id);
-		struct kfd_process_device *pdd = kfd_get_process_device_data(dev, p);
-
-		if (unlikely(user_gpu_id == -EINVAL)) {
-			WARN_ONCE(1, "Could not get user_gpu_id from dev->id:%x\n", dev->id);
+		pdd = kfd_get_process_device_data(dev, p);
+		if (!pdd)
+			/* no process is using this device */
 			continue;
-		}
+		user_gpu_id = kfd_process_get_user_gpu_id(p, dev->id);
 
-		if (unlikely(!pdd)) {
-			WARN_ONCE(1, "Could not get device data from process pid:%d\n",
-				  p->lead_thread->pid);
+		if (unlikely(user_gpu_id == -EINVAL)) {
+			WARN_ONCE(1, "Could not get user_gpu_id from dev->id:%d\n", dev->id);
 			continue;
 		}
 
-- 
2.53.0



