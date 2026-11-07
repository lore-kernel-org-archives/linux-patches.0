Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062481;
	b=ulAMf+0EnmgQkSZxQDqt9l9ipo5GH7y8Q3m2OesNDxHt7fK0F1USUOZd2E6MlWTitdxu
	 yoV1ECvQO4S8B/sl7SaZFwQPZB0obV27kbJHNgzQkdgR9uQgATLtAg+4BDf4KV9fDGkCr
	 wdQ1Nr++QraJaXs98hRRWfCA0WgQogp15P6P2jAO2DfTpPt6a4wQYDOfF3L5nkFBIzcbK
	 iu0X0eDQcq1tBLe/9QYB0shl5FsyXqYZDGm/M0u86yVisdUdmlWFswwpDjD0Tt7P3mI2G
	 F6AiefoM6ka/B7d9BETuq/zFWE5Pz1o+n+xLRNXncdP5OkIdKJeEof6LvWy7ZpQSo1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fYNSyzUGQNzRUJ+a0mqmh53Our77+YgVKMTagQbnehY=;
	b=o+F6nQ5GR8Hgy5TPvtAcK6+sSEu4X9S6Guaj7ZQ7asNobkZGZ8n19auRfFdt32NGexb+
	 Z0Ve7EcL+yanw6pv4UOLFSWb1HX3YrLetSU/8b6GFy3+KViOjH+z4u01iQS8lxIx4Mot9
	 iQEfdxTuUyV78g5g8GBTQMxYqyTWQWwbL17jjQkj9wTVwF1PQJfMsW/zQALGZy1B4jxW/
	 GJ5Gpx9IP4G7Tf+07gGW0cWqlItCnyOXIE4XOJrRuYCwJJJAjhq4pQMpSclyCaoqoNKBZ
	 YF1uzRrWGpD+pZMHyOrzpZPHyhCytQUNPKsmwmgJ9jPsxCJlt3CVM95bvSRkilcyklA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Hh9M7Xv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93394606D837;
	Sat,  7 Nov 2026 14:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Hh9M7Xv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4035F1F008A1;
	Sat,  7 Nov 2026 14:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062481;
	bh=fYNSyzUGQNzRUJ+a0mqmh53Our77+YgVKMTagQbnehY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Hh9M7XvtTf9xd8ckzzg+EvlsC+3W9JgaBdofaV1tfrHSHYcPlmqqXyFAALw9efs/
	 SVNb+3TUE14yZnlXqbrHYKJUkoh/E+JxijeKa3M+ffJBPgj9TjIN1cf+sPLREzEF/A
	 krnmKtmYvKjCEHxj6xSCLMLDF7nezkMNB5POk3NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1383/1536] drm/amdkfd: dont drop an SVM CWSR reference that was never taken
Date: Sat,  7 Nov 2026 08:56:39 -0500
Message-ID: <20261107135036.678047213@linuxfoundation.org>
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

[ Upstream commit 030d47cc6720e0f07b502876cdbd266e309f9461 ]

When kfd_queue_acquire_buffers() fails, its error path calls
kfd_queue_release_buffers(), which also drops a queue_refcount on the
SVM range at ctx_save_restore_area_address. The SVM range is the last
buffer acquired, and kfd_queue_buffer_svm_get() takes no reference when
it fails, so on every error path this reference was never taken. If
another queue of the process uses that CWSR range, its reference is
dropped instead, and unmapping the range no longer evicts that queue
while its CWSR area is unmapped from the GPU.

On navi31, with queue A using an SVM CWSR range: munmap() of the range
logs

  Freeing queue vital buffer 0x..., queue evicted

but after a CREATE_QUEUE that reuses A's CWSR address with an unmapped
write pointer (-EINVAL), the same munmap() leaves A running without the
message.

Only put the BOs on the acquire error path. The warning and the eviction
are back after the failed CREATE_QUEUE.

Fixes: b049504e211e ("drm/amdkfd: Validate user queue svm memory residency")
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9a08122e6361ef73f4b512d5db9596d561305519)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
index 3efbe67734877..e64eba0a92631 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
@@ -231,6 +231,15 @@ void kfd_queue_buffer_put(struct amdgpu_bo **bo)
 	amdgpu_bo_unref(bo);
 }
 
+static void kfd_queue_put_bos(struct queue_properties *properties)
+{
+	kfd_queue_buffer_put(&properties->wptr_bo);
+	kfd_queue_buffer_put(&properties->rptr_bo);
+	kfd_queue_buffer_put(&properties->ring_bo);
+	kfd_queue_buffer_put(&properties->eop_buf_bo);
+	kfd_queue_buffer_put(&properties->cwsr_bo);
+}
+
 int kfd_queue_acquire_buffers(struct kfd_process_device *pdd, struct queue_properties *properties)
 {
 	struct kfd_topology_device *topo_dev;
@@ -341,7 +350,13 @@ int kfd_queue_acquire_buffers(struct kfd_process_device *pdd, struct queue_prope
 	 * dropping the VM reservation.
 	 */
 	kfd_queue_unref_bo_vas(pdd, properties);
-	kfd_queue_release_buffers(pdd, properties);
+	/*
+	 * The SVM CWSR range is the last thing acquired and a failed
+	 * kfd_queue_buffer_svm_get() takes nothing, so only the BOs are held
+	 * here. Dropping the SVM reference would drop the one of another queue
+	 * using the same CWSR address.
+	 */
+	kfd_queue_put_bos(properties);
 	return err;
 }
 
@@ -350,11 +365,7 @@ int kfd_queue_release_buffers(struct kfd_process_device *pdd, struct queue_prope
 	struct kfd_topology_device *topo_dev;
 	u64 total_cwsr_size;
 
-	kfd_queue_buffer_put(&properties->wptr_bo);
-	kfd_queue_buffer_put(&properties->rptr_bo);
-	kfd_queue_buffer_put(&properties->ring_bo);
-	kfd_queue_buffer_put(&properties->eop_buf_bo);
-	kfd_queue_buffer_put(&properties->cwsr_bo);
+	kfd_queue_put_bos(properties);
 
 	topo_dev = kfd_topology_device_by_id(pdd->dev->id);
 	if (!topo_dev)
-- 
2.53.0



