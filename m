Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DD51547C4;
	Mon, 16 Sep 2024 12:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488418; cv=none; b=ge2PyRcOiiqcEQ7BTRye46/VCmCs1vjAJDU43DZf0MhteGI76JI1IAX+K011UwWwivjcg9uA5Iw+FoxXiKvwWFOLzfIoR96VfNfYIyZEbWaK3jI7AyN0+CtjXSlEznxD0nJUHBGM6UgYhz2P/gyBjHv03SdeDXplpjeYoRXZmAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488418; c=relaxed/simple;
	bh=lNiLQf18oRKbLdCrpKt5NUaQjm03YguoOuNJWig7wck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYqoYcsLv6Q2zxw8e96Nmp0tUspEtYcOZAX61g1BBSDj/QDesH/cKg0wtaHLUu9wKfzRpjUjDt3GgH97buueIGi1R5z6+yTcGdDzXzUyFpdAkiDSmIu6M4DvJUVNciWU689eDxjtHBHUgdno1jFFib7mA9j+rOPWL1TCpwqoT7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1rMaQYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1rMaQYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511D5C4CEC4;
	Mon, 16 Sep 2024 12:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488418;
	bh=lNiLQf18oRKbLdCrpKt5NUaQjm03YguoOuNJWig7wck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1rMaQYqsxasrVRj3fsjvfzAqly0wkw5LvqHClz5mzn69ygUNC5ic5kqGZUOV4UCB
	 0neJa9aBuYal/Vi7MWw6FM6Qru3c3i+eUrirIa3Q8jprh5DBUedUykv2MIcuUXGn/H
	 kQSIP5lGH2rZSRDe55M9mlj9onYuNIHpGvLM5OEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>
Subject: [PATCH 6.10 107/121] drm/amd/amdgpu: apply command submission parser for JPEG v2+
Date: Mon, 16 Sep 2024 13:44:41 +0200
Message-ID: <20240916114232.638049577@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David (Ming Qiang) Wu <David.Wu3@amd.com>

commit 3a23aa0b9c24c682c506121e2e0f6cbcfdae9076 upstream.

This patch extends the same cs parser from JPEG v4.0.3 to
other JPEG versions (v2 and above).

Rename to more common name as jpeg_v2_dec_ring_parse_cs()
from jpeg_v4_0_3_dec_ring_parse_cs().

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 88dcad2d07c8d82e6a097c8e74239eb67333bcf7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c   |   63 ++++++++++++++++++++++++++++++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.h   |    6 ++
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c   |    2 
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c   |    1 
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c   |    1 
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.h   |    1 
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c |   57 ----------------------------
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.h |    7 ---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c |    1 
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c |    3 -
 10 files changed, 78 insertions(+), 64 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -23,6 +23,7 @@
 
 #include "amdgpu.h"
 #include "amdgpu_jpeg.h"
+#include "amdgpu_cs.h"
 #include "amdgpu_pm.h"
 #include "soc15.h"
 #include "soc15d.h"
@@ -543,7 +544,11 @@ void jpeg_v2_0_dec_ring_emit_ib(struct a
 
 	amdgpu_ring_write(ring, PACKETJ(mmUVD_LMI_JRBC_IB_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
-	amdgpu_ring_write(ring, (vmid | (vmid << 4) | (vmid << 8)));
+
+	if (ring->funcs->parse_cs)
+		amdgpu_ring_write(ring, 0);
+	else
+		amdgpu_ring_write(ring, (vmid | (vmid << 4) | (vmid << 8)));
 
 	amdgpu_ring_write(ring, PACKETJ(mmUVD_LMI_JPEG_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
@@ -769,6 +774,7 @@ static const struct amdgpu_ring_funcs jp
 	.get_rptr = jpeg_v2_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v2_0_dec_ring_set_wptr,
+	.parse_cs = jpeg_v2_dec_ring_parse_cs,
 	.emit_frame_size =
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 6 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 8 +
@@ -816,3 +822,58 @@ const struct amdgpu_ip_block_version jpe
 		.rev = 0,
 		.funcs = &jpeg_v2_0_ip_funcs,
 };
+
+/**
+ * jpeg_v2_dec_ring_parse_cs - command submission parser
+ *
+ * @parser: Command submission parser context
+ * @job: the job to parse
+ * @ib: the IB to parse
+ *
+ * Parse the command stream, return -EINVAL for invalid packet,
+ * 0 otherwise
+ */
+int jpeg_v2_dec_ring_parse_cs(struct amdgpu_cs_parser *parser,
+			      struct amdgpu_job *job,
+			      struct amdgpu_ib *ib)
+{
+	u32 i, reg, res, cond, type;
+	struct amdgpu_device *adev = parser->adev;
+
+	for (i = 0; i < ib->length_dw ; i += 2) {
+		reg  = CP_PACKETJ_GET_REG(ib->ptr[i]);
+		res  = CP_PACKETJ_GET_RES(ib->ptr[i]);
+		cond = CP_PACKETJ_GET_COND(ib->ptr[i]);
+		type = CP_PACKETJ_GET_TYPE(ib->ptr[i]);
+
+		if (res) /* only support 0 at the moment */
+			return -EINVAL;
+
+		switch (type) {
+		case PACKETJ_TYPE0:
+			if (cond != PACKETJ_CONDITION_CHECK0 || reg < JPEG_REG_RANGE_START ||
+			    reg > JPEG_REG_RANGE_END) {
+				dev_err(adev->dev, "Invalid packet [0x%08x]!\n", ib->ptr[i]);
+				return -EINVAL;
+			}
+			break;
+		case PACKETJ_TYPE3:
+			if (cond != PACKETJ_CONDITION_CHECK3 || reg < JPEG_REG_RANGE_START ||
+			    reg > JPEG_REG_RANGE_END) {
+				dev_err(adev->dev, "Invalid packet [0x%08x]!\n", ib->ptr[i]);
+				return -EINVAL;
+			}
+			break;
+		case PACKETJ_TYPE6:
+			if (ib->ptr[i] == CP_PACKETJ_NOP)
+				continue;
+			dev_err(adev->dev, "Invalid packet [0x%08x]!\n", ib->ptr[i]);
+			return -EINVAL;
+		default:
+			dev_err(adev->dev, "Unknown packet type %d !\n", type);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.h
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.h
@@ -45,6 +45,9 @@
 
 #define JRBC_DEC_EXTERNAL_REG_WRITE_ADDR				0x18000
 
+#define JPEG_REG_RANGE_START						0x4000
+#define JPEG_REG_RANGE_END						0x41c2
+
 void jpeg_v2_0_dec_ring_insert_start(struct amdgpu_ring *ring);
 void jpeg_v2_0_dec_ring_insert_end(struct amdgpu_ring *ring);
 void jpeg_v2_0_dec_ring_emit_fence(struct amdgpu_ring *ring, u64 addr, u64 seq,
@@ -57,6 +60,9 @@ void jpeg_v2_0_dec_ring_emit_vm_flush(st
 				unsigned vmid, uint64_t pd_addr);
 void jpeg_v2_0_dec_ring_emit_wreg(struct amdgpu_ring *ring, uint32_t reg, uint32_t val);
 void jpeg_v2_0_dec_ring_nop(struct amdgpu_ring *ring, uint32_t count);
+int jpeg_v2_dec_ring_parse_cs(struct amdgpu_cs_parser *parser,
+			      struct amdgpu_job *job,
+			      struct amdgpu_ib *ib);
 
 extern const struct amdgpu_ip_block_version jpeg_v2_0_ip_block;
 
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
@@ -664,6 +664,7 @@ static const struct amdgpu_ring_funcs jp
 	.get_rptr = jpeg_v2_5_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_5_dec_ring_get_wptr,
 	.set_wptr = jpeg_v2_5_dec_ring_set_wptr,
+	.parse_cs = jpeg_v2_dec_ring_parse_cs,
 	.emit_frame_size =
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 6 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 8 +
@@ -693,6 +694,7 @@ static const struct amdgpu_ring_funcs jp
 	.get_rptr = jpeg_v2_5_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_5_dec_ring_get_wptr,
 	.set_wptr = jpeg_v2_5_dec_ring_set_wptr,
+	.parse_cs = jpeg_v2_dec_ring_parse_cs,
 	.emit_frame_size =
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 6 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 8 +
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
@@ -567,6 +567,7 @@ static const struct amdgpu_ring_funcs jp
 	.get_rptr = jpeg_v3_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v3_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v3_0_dec_ring_set_wptr,
+	.parse_cs = jpeg_v2_dec_ring_parse_cs,
 	.emit_frame_size =
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 6 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 8 +
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
@@ -729,6 +729,7 @@ static const struct amdgpu_ring_funcs jp
 	.get_rptr = jpeg_v4_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v4_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v4_0_dec_ring_set_wptr,
+	.parse_cs = jpeg_v2_dec_ring_parse_cs,
 	.emit_frame_size =
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 6 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 8 +
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.h
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.h
@@ -32,5 +32,4 @@ enum amdgpu_jpeg_v4_0_sub_block {
 };
 
 extern const struct amdgpu_ip_block_version jpeg_v4_0_ip_block;
-
 #endif /* __JPEG_V4_0_H__ */
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
@@ -23,9 +23,9 @@
 
 #include "amdgpu.h"
 #include "amdgpu_jpeg.h"
-#include "amdgpu_cs.h"
 #include "soc15.h"
 #include "soc15d.h"
+#include "jpeg_v2_0.h"
 #include "jpeg_v4_0_3.h"
 #include "mmsch_v4_0_3.h"
 
@@ -1068,7 +1068,7 @@ static const struct amdgpu_ring_funcs jp
 	.get_rptr = jpeg_v4_0_3_dec_ring_get_rptr,
 	.get_wptr = jpeg_v4_0_3_dec_ring_get_wptr,
 	.set_wptr = jpeg_v4_0_3_dec_ring_set_wptr,
-	.parse_cs = jpeg_v4_0_3_dec_ring_parse_cs,
+	.parse_cs = jpeg_v2_dec_ring_parse_cs,
 	.emit_frame_size =
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 6 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 8 +
@@ -1233,56 +1233,3 @@ static void jpeg_v4_0_3_set_ras_funcs(st
 {
 	adev->jpeg.ras = &jpeg_v4_0_3_ras;
 }
-
-/**
- * jpeg_v4_0_3_dec_ring_parse_cs - command submission parser
- *
- * @parser: Command submission parser context
- * @job: the job to parse
- * @ib: the IB to parse
- *
- * Parse the command stream, return -EINVAL for invalid packet,
- * 0 otherwise
- */
-int jpeg_v4_0_3_dec_ring_parse_cs(struct amdgpu_cs_parser *parser,
-			     struct amdgpu_job *job,
-			     struct amdgpu_ib *ib)
-{
-	uint32_t i, reg, res, cond, type;
-	struct amdgpu_device *adev = parser->adev;
-
-	for (i = 0; i < ib->length_dw ; i += 2) {
-		reg  = CP_PACKETJ_GET_REG(ib->ptr[i]);
-		res  = CP_PACKETJ_GET_RES(ib->ptr[i]);
-		cond = CP_PACKETJ_GET_COND(ib->ptr[i]);
-		type = CP_PACKETJ_GET_TYPE(ib->ptr[i]);
-
-		if (res) /* only support 0 at the moment */
-			return -EINVAL;
-
-		switch (type) {
-		case PACKETJ_TYPE0:
-			if (cond != PACKETJ_CONDITION_CHECK0 || reg < JPEG_REG_RANGE_START || reg > JPEG_REG_RANGE_END) {
-				dev_err(adev->dev, "Invalid packet [0x%08x]!\n", ib->ptr[i]);
-				return -EINVAL;
-			}
-			break;
-		case PACKETJ_TYPE3:
-			if (cond != PACKETJ_CONDITION_CHECK3 || reg < JPEG_REG_RANGE_START || reg > JPEG_REG_RANGE_END) {
-				dev_err(adev->dev, "Invalid packet [0x%08x]!\n", ib->ptr[i]);
-				return -EINVAL;
-			}
-			break;
-		case PACKETJ_TYPE6:
-			if (ib->ptr[i] == CP_PACKETJ_NOP)
-				continue;
-			dev_err(adev->dev, "Invalid packet [0x%08x]!\n", ib->ptr[i]);
-			return -EINVAL;
-		default:
-			dev_err(adev->dev, "Unknown packet type %d !\n", type);
-			return -EINVAL;
-		}
-	}
-
-	return 0;
-}
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.h
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.h
@@ -46,9 +46,6 @@
 
 #define JRBC_DEC_EXTERNAL_REG_WRITE_ADDR				0x18000
 
-#define JPEG_REG_RANGE_START						0x4000
-#define JPEG_REG_RANGE_END						0x41c2
-
 extern const struct amdgpu_ip_block_version jpeg_v4_0_3_ip_block;
 
 void jpeg_v4_0_3_dec_ring_emit_ib(struct amdgpu_ring *ring,
@@ -65,7 +62,5 @@ void jpeg_v4_0_3_dec_ring_insert_end(str
 void jpeg_v4_0_3_dec_ring_emit_wreg(struct amdgpu_ring *ring, uint32_t reg, uint32_t val);
 void jpeg_v4_0_3_dec_ring_emit_reg_wait(struct amdgpu_ring *ring, uint32_t reg,
 					uint32_t val, uint32_t mask);
-int jpeg_v4_0_3_dec_ring_parse_cs(struct amdgpu_cs_parser *parser,
-				  struct amdgpu_job *job,
-				  struct amdgpu_ib *ib);
+
 #endif /* __JPEG_V4_0_3_H__ */
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c
@@ -772,6 +772,7 @@ static const struct amdgpu_ring_funcs jp
 	.get_rptr = jpeg_v4_0_5_dec_ring_get_rptr,
 	.get_wptr = jpeg_v4_0_5_dec_ring_get_wptr,
 	.set_wptr = jpeg_v4_0_5_dec_ring_set_wptr,
+	.parse_cs = jpeg_v2_dec_ring_parse_cs,
 	.emit_frame_size =
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 6 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 8 +
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c
@@ -26,6 +26,7 @@
 #include "amdgpu_pm.h"
 #include "soc15.h"
 #include "soc15d.h"
+#include "jpeg_v2_0.h"
 #include "jpeg_v4_0_3.h"
 
 #include "vcn/vcn_5_0_0_offset.h"
@@ -523,7 +524,7 @@ static const struct amdgpu_ring_funcs jp
 	.get_rptr = jpeg_v5_0_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v5_0_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v5_0_0_dec_ring_set_wptr,
-	.parse_cs = jpeg_v4_0_3_dec_ring_parse_cs,
+	.parse_cs = jpeg_v2_dec_ring_parse_cs,
 	.emit_frame_size =
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 6 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 8 +


