Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065482;
	b=i1KVd8Uf+tNwWIqxNg7Oguq1mANQPdWf1WX1xog4uxeM/zbZ/3UEc1cvfwjTVULnF1J/
	 KPKa3bfJEVa54IRtcz0Exson2Ggcp3lPJYjjY9a3fWfGXdT7A2arLAcJ3Rlt6OgS/TRq5
	 OzD98HqTv3f+hRJrUTtGWFc99qstaGGpYIqwwNgxzELzyNiucsUelQHAST2YeA/KKN+YF
	 uExt3pW+ggCuwbBnc0LWm+q61J3f4KseN1r/7vahunWbNNloXk+mH/AG5/ujt2Qa2aMaS
	 wmgrgaWwJoB7B8BgS4lWhVoV5VFXx0Z4HQCrGDPIbEtozV1pbhJ2dd6MDseBrROTGxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zBielEFJJZM4HXVpNc7ClYXSjU/CrOup3dGVqsxpFas=;
	b=MYXTBwXsEJRSZHtTAOGjwksImfo0XwH7KgJ+oIlDDysz+qoXnZXDwZ2C+/2cv73615Wl
	 npv5f5mt0hD95Y028vwmN9lXWmKg8ZAvtnaFheH4p5IPYi6yJ4LoUYqSC8wuNPwN6gcn4
	 I4G9HAYxpwgG1i1uPkQv7/CHM/h9p0crvGM7GgteSZ4wzg55YlLyuHa7I08gCRASZey4N
	 Cv8iK2h/zpO0DdY/dmwFKB512lhEM5koNkBnbHknfIV4aRLOTMgjrX5XTSC1GucSKKrth
	 wB8EZbd+xFkqrNLmXUDavPJroU14Wmize8ovnDvJdsyGze8frZ014cMbylrLswwGtCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CwHkQMcg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C88606A33C;
	Sat,  7 Nov 2026 15:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CwHkQMcg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B461F0089F;
	Sat,  7 Nov 2026 15:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065481;
	bh=zBielEFJJZM4HXVpNc7ClYXSjU/CrOup3dGVqsxpFas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwHkQMcgWaDkXGV8LbA8KALYKJMnIH+ghueztNUEE4YQ5mYE0syFg9oR3MniZID2y
	 ztkTNKzH+sQ21tVYOPG5IL3bhXKnCdUeFsbO560B9PqE+bfWbuKlqcy5ExbbKgnPKC
	 W7tVwoGPORVU6etor5LJN7uPUb0PYAnHHnse7uyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Palacek <William.Palacek@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1176/1257] drm/amdkfd: Validate the control stack of a restored queue
Date: Sat,  7 Nov 2026 08:57:52 -0500
Message-ID: <20261107135011.657705266@linuxfoundation.org>
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

From: William Palacek <William.Palacek@amd.com>

[ Upstream commit 90d91a192751cd9a7d9d2286299bc72ec1c28179 ]

kfd_criu_restore_queue() takes the control stack size from the
checkpoint image without the topology check create-queue does in
kfd_queue_acquire_buffers(), which restore stopped calling in
commit 1cafa8b29e02 ("drm/amdkfd: Don't acquire buffers
during CRIU queue restore."). An image size of 0x300000 is accepted and
sizes the MQD allocation, and 0xFFFFFFFF trips a page allocator warning
in kmalloc().

restore_mqd() also keeps the image's cp_hqd_cntl_stack_size,
cp_hqd_cntl_stack_offset and cp_hqd_wg_state_offset. With offset > size
or wave state offset < size, get_wave_state() returns wrapped sizes.

Take the per-XCC size from topology, 0 for queues without a control
stack, and reject larger images. In restore_mqd(), set the size to it
and bound both offsets as init_mqd() does.

Fixes: 626f7b3190b4 ("drm/amdkfd: CRIU add queues support")
Fixes: 42c6c48214b7 ("drm/amdkfd: CRIU checkpoint and restore queue mqds")
Signed-off-by: William Palacek <William.Palacek@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 92249023caee17bfc6f29c71d6aaa5f2298cf507)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h  |  9 ++++++
 .../gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c  |  2 ++
 .../gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c  |  2 ++
 .../gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c  |  2 ++
 .../drm/amd/amdkfd/kfd_mqd_manager_v12_1.c    |  2 ++
 .../gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c   |  2 ++
 .../gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c   |  2 ++
 .../amd/amdkfd/kfd_process_queue_manager.c    | 30 +++++++++++++------
 8 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
index 38b46b696243c..d63f7e9fae303 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
@@ -138,6 +138,15 @@ struct mqd_manager {
 	uint32_t ctl_stack_size;
 };
 
+/* Keep offset <= size <= wave state offset, as init_mqd() and CP do */
+static inline void kfd_mqd_restore_ctl_stack(u32 *size, u32 *offset, u32 *wg_offset,
+					     u32 ctl_stack_size)
+{
+	*size = ctl_stack_size;
+	*offset = min(*offset, ctl_stack_size);
+	*wg_offset = max(*wg_offset, ctl_stack_size);
+}
+
 struct mqd_user_context_save_area_header {
 	/* Byte offset from start of user context
 	 * save area to the last saved top (lowest
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
index 4f8a8a1a61860..6c9bafa3962ea 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
@@ -305,6 +305,8 @@ static void restore_mqd(struct mqd_manager *mm, void **mqd,
 	addr = mqd_mem_obj->gpu_addr;
 
 	memcpy(m, mqd_src, sizeof(*m));
+	kfd_mqd_restore_ctl_stack(&m->cp_hqd_cntl_stack_size, &m->cp_hqd_cntl_stack_offset,
+				  &m->cp_hqd_wg_state_offset, qp->ctl_stack_size);
 
 	*mqd = m;
 	if (gart_addr)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
index bf015dc5b8684..5709949de2eb2 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
@@ -340,6 +340,8 @@ static void restore_mqd(struct mqd_manager *mm, void **mqd,
 	addr = mqd_mem_obj->gpu_addr;
 
 	memcpy(m, mqd_src, sizeof(*m));
+	kfd_mqd_restore_ctl_stack(&m->cp_hqd_cntl_stack_size, &m->cp_hqd_cntl_stack_offset,
+				  &m->cp_hqd_wg_state_offset, qp->ctl_stack_size);
 
 	*mqd = m;
 	if (gart_addr)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
index 6ea09b031caf8..aea80266d254e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
@@ -393,6 +393,8 @@ static void restore_mqd(struct mqd_manager *mm, void **mqd,
 
 	memset(m, 0, AMDGPU_MQD_SIZE_ALIGN(mm->mqd_size));
 	memcpy(m, mqd_src, sizeof(*m));
+	kfd_mqd_restore_ctl_stack(&m->cp_hqd_cntl_stack_size, &m->cp_hqd_cntl_stack_offset,
+				  &m->cp_hqd_wg_state_offset, qp->ctl_stack_size);
 
 	/* Update MQD base address to the newly allocated location */
 	m->cp_mqd_base_addr_lo = lower_32_bits(addr);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c
index c709db0210ced..3c335d24492a3 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c
@@ -663,6 +663,8 @@ static void restore_mqd_v12_1(struct mqd_manager *mm, void **mqd,
 	memset(m, 0, AMDGPU_MQD_SIZE_ALIGN(mm->mqd_size) *
 		     NUM_XCC(mm->dev->xcc_mask));
 	memcpy(m, mqd_src, sizeof(*m));
+	kfd_mqd_restore_ctl_stack(&m->cp_hqd_cntl_stack_size, &m->cp_hqd_cntl_stack_offset,
+				  &m->cp_hqd_wg_state_offset, qp->ctl_stack_size);
 
 	/* Update MQD base address to the newly allocated location */
 	m->cp_mqd_base_addr_lo = lower_32_bits(addr);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index 6e6bc1ec0b645..fca43017ee7e6 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -462,6 +462,8 @@ static void restore_mqd(struct mqd_manager *mm, void **mqd,
 	addr = mqd_mem_obj->gpu_addr;
 
 	memcpy(m, mqd_src, sizeof(*m));
+	kfd_mqd_restore_ctl_stack(&m->cp_hqd_cntl_stack_size, &m->cp_hqd_cntl_stack_offset,
+				  &m->cp_hqd_wg_state_offset, qp->ctl_stack_size);
 
 	*mqd = m;
 	if (gart_addr)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
index 029572548c149..5ead0d5613b6d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
@@ -317,6 +317,8 @@ static void restore_mqd(struct mqd_manager *mm, void **mqd,
 	addr = mqd_mem_obj->gpu_addr;
 
 	memcpy(m, mqd_src, sizeof(*m));
+	kfd_mqd_restore_ctl_stack(&m->cp_hqd_cntl_stack_size, &m->cp_hqd_cntl_stack_offset,
+				  &m->cp_hqd_wg_state_offset, qp->ctl_stack_size);
 
 	*mqd = m;
 	if (gart_addr)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 4fe40e9fcfc8b..87fb42d3c7139 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -26,6 +26,7 @@
 #include <linux/list.h>
 #include "kfd_device_queue_manager.h"
 #include "kfd_priv.h"
+#include "kfd_topology.h"
 #include "kfd_kernel_queue.h"
 #include "amdgpu_amdkfd.h"
 #include "amdgpu_reset.h"
@@ -981,7 +982,7 @@ int kfd_criu_checkpoint_queues(struct kfd_process *p,
 }
 
 static void set_queue_properties_from_criu(struct queue_properties *qp,
-					  struct kfd_criu_queue_priv_data *q_data, uint32_t num_xcc)
+					  struct kfd_criu_queue_priv_data *q_data)
 {
 	qp->is_interop = false;
 	qp->queue_percent = q_data->q_percent;
@@ -994,11 +995,6 @@ static void set_queue_properties_from_criu(struct queue_properties *qp,
 	qp->eop_ring_buffer_size = q_data->eop_ring_buffer_size;
 	qp->ctx_save_restore_area_address = q_data->ctx_save_restore_area_address;
 	qp->ctx_save_restore_area_size = q_data->ctx_save_restore_area_size;
-	if (q_data->type == KFD_QUEUE_TYPE_COMPUTE)
-		qp->ctl_stack_size = q_data->ctl_stack_size / num_xcc;
-	else
-		qp->ctl_stack_size = q_data->ctl_stack_size;
-
 	qp->type = q_data->type;
 	qp->format = q_data->format;
 }
@@ -1010,6 +1006,7 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 {
 	uint8_t *mqd, *ctl_stack, *q_extra_data = NULL;
 	struct kfd_criu_queue_priv_data *q_data;
+	struct kfd_topology_device *topo_dev;
 	struct kfd_process_device *pdd;
 	uint64_t q_extra_data_size;
 	struct queue_properties qp;
@@ -1046,6 +1043,24 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 		goto exit;
 	}
 
+	memset(&qp, 0, sizeof(qp));
+	set_queue_properties_from_criu(&qp, q_data);
+
+	/* Per-XCC control stack size from topology, as create-queue requires */
+	if (qp.type == KFD_QUEUE_TYPE_COMPUTE && pdd->dev->kfd->cwsr_enabled) {
+		topo_dev = kfd_topology_device_by_id(pdd->dev->id);
+		if (!topo_dev) {
+			ret = -EINVAL;
+			goto exit;
+		}
+		qp.ctl_stack_size = topo_dev->node_props.ctl_stack_size;
+	}
+
+	if (q_data->ctl_stack_size > (u64)qp.ctl_stack_size * NUM_XCC(pdd->dev->xcc_mask)) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
 	*priv_data_offset += sizeof(*q_data);
 	q_extra_data_size = (uint64_t)q_data->ctl_stack_size + q_data->mqd_size;
 
@@ -1075,9 +1090,6 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 	mqd = q_extra_data;
 	ctl_stack = mqd + q_data->mqd_size;
 
-	memset(&qp, 0, sizeof(qp));
-	set_queue_properties_from_criu(&qp, q_data, NUM_XCC(pdd->dev->xcc_mask));
-
 	print_queue_properties(&qp);
 
 	ret = pqm_create_queue(&p->pqm, pdd->dev, &qp, &queue_id, q_data, mqd, ctl_stack, NULL);
-- 
2.53.0



