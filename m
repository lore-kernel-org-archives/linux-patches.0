Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065148;
	b=ogzsrxXk34uBlEaXw2aWwXsEmw21BlJZ+FyqXoSaG5pMMvgMU5VZGpu3YnBkNl0/7/7q
	 O6+WSzJHOVLrTqbPfalPDOcj4K/15y3FPNHzH3m4mPe0fsuprVGbtt4X3JKZH6/5JbB/i
	 sB1jjjGJKCjBD6OVZR/bfAiSSPitkX/wpRSJwR0aCiqcF0Md2h3tYxGa2lERjvQehG0+w
	 hTtgdCZXwMI/ZHo+6XIpHfh94vCzMJ46PYWein6zucc+NLmd+OesUXTnpC2w1GRo6QQk9
	 c5wDCm3jYScb4UPC1qbKLnj1MwbKckYEdjaC+mIqhlm4MMaUc8MlJYEycBqvERNW1Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b/N9raOstToGmcsmeyfQkMaGuezVs8jxsJ3IRZMO/Rw=;
	b=cUwidQqOofmdHBByrjV2puiyFVM2FqeVczmie5GwnSca5giSX3cOuo4dMFjmKWAHoQ9q
	 ebSGCvJ6w0aXTxfaR/nEjiaX/VYxRbcVPdQ5h6x4MGjgFzumzaznHOPjx63G/iyYrBiEi
	 u+lCm12xO0JCtW+BGgjGoV/ZHEgcfp92Uam5CvINxktXkkuFvLRwMitmPX7RGj71/jayn
	 jcE3GoIvNIeTlrzP7hsnb4YAtf3QmG0erGT73wCQCSCccqxhnYf1YVPAvV2lzCV1zo1nH
	 8bGCdJ8F0nN8Hr2/MySS3xxt3GINZhiPoyrIqes6grAsEt/2bwq/HDQD1jTt6wYck+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cC33ewDx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C73606A32E;
	Sat,  7 Nov 2026 15:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cC33ewDx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A85F1F0089F;
	Sat,  7 Nov 2026 15:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065148;
	bh=b/N9raOstToGmcsmeyfQkMaGuezVs8jxsJ3IRZMO/Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cC33ewDxqpGAEysMEHcdEW4MZWn4HnGiMDFfs+3oEQ/EBBf8HrqIOlSN+9TDAHyeZ
	 8BrWfRFLpamweNBiVxK8GVTCW7zcLUgfGXbdvZZ8ycWosBZmUU8cYbS3kvjxzECH5t
	 704kKB13k2UJGt8/nz5lV9tI3XGBFhbjNni49SDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0961/1257] drm/amdkfd: dont drop an SVM CWSR reference that was never taken
Date: Sat,  7 Nov 2026 08:54:17 -0500
Message-ID: <20261107135005.882452382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 15eeaaebbbcd7..910d695bb962e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
@@ -230,6 +230,15 @@ void kfd_queue_buffer_put(struct amdgpu_bo **bo)
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
@@ -343,7 +352,13 @@ int kfd_queue_acquire_buffers(struct kfd_process_device *pdd, struct queue_prope
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
 
@@ -352,11 +367,7 @@ int kfd_queue_release_buffers(struct kfd_process_device *pdd, struct queue_prope
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



