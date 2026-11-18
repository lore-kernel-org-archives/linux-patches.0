Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028521;
	b=VAlp96zcVyjzO7sNO53xinyupuaqKAx0kr5y4uAZ8NZmca5uN2Rq5vlwKzM1hjWNemKA
	 I8VcDrSJg8vLfE7/AV7uudGU4rkX+2BnNSlgNYiNLlGDq/WrEEfoJz9uh4kQv1ipjnVdp
	 pgn8ZV3l634OyApiIm2r8npdm027YsWkyTl1u7XKl2cYVfl6Xwcdv/odDunuDnz9cUTjJ
	 c2MCdhO6W3UAPc2j8f/lKll+8ISk3WJHB0R5FsfDxc9SIH1alQkNigDpDLvPnwryybrxJ
	 uxnY3ZZvTilWm+4bR89RSLcUwLJ65IRsnYSMdJUg5UsDChVEcuVxN0P1+i290rxQAZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=15XOxQ60OU7Qj0k1bzxji2LmJa+dVx7r2401ZmptgIY=;
	b=gGLJHACg5YYzWlR7Z+Rz4EkrD9dBxil21hRvYZccBqdxLSruvMbiOkhyOwjNYudbcRq4
	 Njrhlj4V6fqAFGUqSC7rPWIp/u0cJLZMMkqWMM/W5r7oL9REW7t629i1ETZGF2PMN2WPz
	 7sjT/OVCLeHL15xhlMNeOBuHqmBGo5FkXtPcdL1sXLIbOA8BRTa/FP5fiPbhMkFBLf+NW
	 htVi8MYGf6J4dBbpFwXsZYxrH1vXgXrvbYU0qTvEpeZHRmWDzZE1fk3uldRreiQ7kysrm
	 rGvoet9uASfp+yzMqdk88i0eYXAmcwwqVnrZKx6vDisGgSrfROVeyWwtwHrVx8o0HKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ll8UJsx6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE5A606A31C;
	Wed, 18 Nov 2026 19:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ll8UJsx6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB3A1F000C9;
	Wed, 18 Nov 2026 19:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028521;
	bh=15XOxQ60OU7Qj0k1bzxji2LmJa+dVx7r2401ZmptgIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ll8UJsx6nRnQP/hbHHaKjleVP+C7xjBf0FDm39tBDZTOBhsU0HYnIjwV31Tz33T4Y
	 eYv30ix8Ba8+dc8bf92lKAR2u4LOH/NrigVe71lHYbfjl90c3BIGRn1sDwFuUgHvOw
	 BU3iOTrwLDeyfBU0cf7V/4Uh6wNhIevHko/t1HTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Palacek <William.Palacek@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0012/1756] drm/amdkfd: Validate the control stack of a restored queue
Date: Wed, 18 Nov 2026 15:35:39 +0100
Message-ID: <20261118150008.447493013@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
[ sashal: Removed the NUM_XCC() multiplier because the existing restore path handles one control stack per image. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c  |  3 +++
 .../gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c  |  3 +++
 .../gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c   |  3 +++
 .../gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c   |  3 +++
 .../amd/amdkfd/kfd_process_queue_manager.c    | 24 +++++++++++++++----
 5 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
index 4a621791da230..99fdbf666c87d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
@@ -293,6 +293,9 @@ static void restore_mqd(struct mqd_manager *mm, void **mqd,
 	addr = mqd_mem_obj->gpu_addr;
 
 	memcpy(m, mqd_src, sizeof(*m));
+	m->cp_hqd_cntl_stack_size = qp->ctl_stack_size;
+	m->cp_hqd_cntl_stack_offset = min(m->cp_hqd_cntl_stack_offset, qp->ctl_stack_size);
+	m->cp_hqd_wg_state_offset = max(m->cp_hqd_wg_state_offset, qp->ctl_stack_size);
 
 	*mqd = m;
 	if (gart_addr)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
index ca90454b01acc..2f4caf637a065 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
@@ -344,6 +344,9 @@ static void restore_mqd(struct mqd_manager *mm, void **mqd,
 	addr = mqd_mem_obj->gpu_addr;
 
 	memcpy(m, mqd_src, sizeof(*m));
+	m->cp_hqd_cntl_stack_size = qp->ctl_stack_size;
+	m->cp_hqd_cntl_stack_offset = min(m->cp_hqd_cntl_stack_offset, qp->ctl_stack_size);
+	m->cp_hqd_wg_state_offset = max(m->cp_hqd_wg_state_offset, qp->ctl_stack_size);
 
 	*mqd = m;
 	if (gart_addr)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index 1e220e8810922..0d22a377f3e33 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -416,6 +416,9 @@ static void restore_mqd(struct mqd_manager *mm, void **mqd,
 	addr = mqd_mem_obj->gpu_addr;
 
 	memcpy(m, mqd_src, sizeof(*m));
+	m->cp_hqd_cntl_stack_size = qp->ctl_stack_size;
+	m->cp_hqd_cntl_stack_offset = min(m->cp_hqd_cntl_stack_offset, qp->ctl_stack_size);
+	m->cp_hqd_wg_state_offset = max(m->cp_hqd_wg_state_offset, qp->ctl_stack_size);
 
 	*mqd = m;
 	if (gart_addr)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
index f0de0893bc597..ae3bd2bb410a5 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
@@ -305,6 +305,9 @@ static void restore_mqd(struct mqd_manager *mm, void **mqd,
 	addr = mqd_mem_obj->gpu_addr;
 
 	memcpy(m, mqd_src, sizeof(*m));
+	m->cp_hqd_cntl_stack_size = qp->ctl_stack_size;
+	m->cp_hqd_cntl_stack_offset = min(m->cp_hqd_cntl_stack_offset, qp->ctl_stack_size);
+	m->cp_hqd_wg_state_offset = max(m->cp_hqd_wg_state_offset, qp->ctl_stack_size);
 
 	*mqd = m;
 	if (gart_addr)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index bf3c7d055fc33..445fba8e4bbdd 100644
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
@@ -984,7 +985,6 @@ static void set_queue_properties_from_criu(struct queue_properties *qp,
 	qp->eop_ring_buffer_size = q_data->eop_ring_buffer_size;
 	qp->ctx_save_restore_area_address = q_data->ctx_save_restore_area_address;
 	qp->ctx_save_restore_area_size = q_data->ctx_save_restore_area_size;
-	qp->ctl_stack_size = q_data->ctl_stack_size;
 	qp->type = q_data->type;
 	qp->format = q_data->format;
 }
@@ -996,6 +996,7 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 {
 	uint8_t *mqd, *ctl_stack, *q_extra_data = NULL;
 	struct kfd_criu_queue_priv_data *q_data;
+	struct kfd_topology_device *topo_dev;
 	struct kfd_process_device *pdd;
 	uint64_t q_extra_data_size;
 	struct queue_properties qp;
@@ -1032,6 +1033,24 @@ int kfd_criu_restore_queue(struct kfd_process *p,
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
+	if (q_data->ctl_stack_size > qp.ctl_stack_size) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
 	*priv_data_offset += sizeof(*q_data);
 	q_extra_data_size = (uint64_t)q_data->ctl_stack_size + q_data->mqd_size;
 
@@ -1058,9 +1077,6 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 	mqd = q_extra_data;
 	ctl_stack = mqd + q_data->mqd_size;
 
-	memset(&qp, 0, sizeof(qp));
-	set_queue_properties_from_criu(&qp, q_data);
-
 	ret = kfd_queue_acquire_buffers(pdd, &qp);
 	if (ret) {
 		pr_debug("failed to acquire user queue buffers for CRIU\n");
-- 
2.53.0



