Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA9635C1AD;
	Tue,  6 Jan 2026 17:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721570; cv=none; b=V8nBEbR2WrweSF9IU+pQbialkr4LLpuyosqn0vLuu0+3jLMmhZBJ4UecYfnC9w/Kn09VcOg8zdNaGAB+a/PNW+7EzY+3HPOLkjL4t5Ae4x3fYVbhXW0DxtaXT4PatyyCF7Xh/EY1fNt/B7pvee74Ka5ZxDG7eWlPGUjtXPqnWE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721570; c=relaxed/simple;
	bh=Aosv+cXBwPda67suy+SpR0XMDi5hRqTGplPL+6fGvew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npt9xYrpCqsgdjfnYxwwU4NYXp959enN8Cptgz3+zi8C/A/r3EAK+JPtB61hqttKIVAUZCA2NPQtGSRxzLYWpg2THTti7UmKf4PYjdq1TkyEMRsnpVpmhjMfxI9+gkcQni3JqlQCiTN6tHppWLv7zaV46lbFZ42mhsKeiNqpnYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KV0HsjkG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KV0HsjkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7406DC116C6;
	Tue,  6 Jan 2026 17:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721569;
	bh=Aosv+cXBwPda67suy+SpR0XMDi5hRqTGplPL+6fGvew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KV0HsjkGMGmiEZDIejmxIDaNbjEArqCibg4dK0NmTQVJErdHs5s7ak0vkzkDgQsp2
	 HE2pLnjPEvETTjQy8T8Zp0Jyx2T8BNrGxsD414BWDHmSyadJ3z7pE3KjBrYMHuodKE
	 R5iqSyyxTcXaBuyjQv0+XZugaZbKxSVPajAy49RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Ming Qian <ming.qian@oss.nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 560/567] media: amphion: Make some vpu_v4l2 functions static
Date: Tue,  6 Jan 2026 18:05:42 +0100
Message-ID: <20260106170512.142606848@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit 5d1e54bb4dc6741284a3ed587e994308ddee2f16 ]

Some functions defined in vpu_v4l2.c are never used outside of that
compilation unit. Make them static.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Ming Qian <ming.qian@oss.nxp.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Stable-dep-of: 634c2cd17bd0 ("media: amphion: Remove vpu_vb_is_codecconfig")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/amphion/vpu_v4l2.c |   12 +++++++++---
 drivers/media/platform/amphion/vpu_v4l2.h |    8 --------
 2 files changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -24,6 +24,11 @@
 #include "vpu_msgs.h"
 #include "vpu_helpers.h"
 
+static char *vpu_type_name(u32 type)
+{
+	return V4L2_TYPE_IS_OUTPUT(type) ? "output" : "capture";
+}
+
 void vpu_inst_lock(struct vpu_inst *inst)
 {
 	mutex_lock(&inst->lock);
@@ -42,7 +47,7 @@ dma_addr_t vpu_get_vb_phy_addr(struct vb
 			vb->planes[plane_no].data_offset;
 }
 
-unsigned int vpu_get_vb_length(struct vb2_buffer *vb, u32 plane_no)
+static unsigned int vpu_get_vb_length(struct vb2_buffer *vb, u32 plane_no)
 {
 	if (plane_no >= vb->num_planes)
 		return 0;
@@ -81,7 +86,7 @@ void vpu_v4l2_set_error(struct vpu_inst
 	vpu_inst_unlock(inst);
 }
 
-int vpu_notify_eos(struct vpu_inst *inst)
+static int vpu_notify_eos(struct vpu_inst *inst)
 {
 	static const struct v4l2_event ev = {
 		.id = 0,
@@ -562,7 +567,8 @@ static void vpu_vb2_buf_finish(struct vb
 		call_void_vop(inst, on_queue_empty, q->type);
 }
 
-void vpu_vb2_buffers_return(struct vpu_inst *inst, unsigned int type, enum vb2_buffer_state state)
+static void vpu_vb2_buffers_return(struct vpu_inst *inst, unsigned int type,
+				   enum vb2_buffer_state state)
 {
 	struct vb2_v4l2_buffer *buf;
 
--- a/drivers/media/platform/amphion/vpu_v4l2.h
+++ b/drivers/media/platform/amphion/vpu_v4l2.h
@@ -26,15 +26,12 @@ void vpu_skip_frame(struct vpu_inst *ins
 struct vb2_v4l2_buffer *vpu_find_buf_by_sequence(struct vpu_inst *inst, u32 type, u32 sequence);
 struct vb2_v4l2_buffer *vpu_find_buf_by_idx(struct vpu_inst *inst, u32 type, u32 idx);
 void vpu_v4l2_set_error(struct vpu_inst *inst);
-int vpu_notify_eos(struct vpu_inst *inst);
 int vpu_notify_source_change(struct vpu_inst *inst);
 int vpu_set_last_buffer_dequeued(struct vpu_inst *inst, bool eos);
-void vpu_vb2_buffers_return(struct vpu_inst *inst, unsigned int type, enum vb2_buffer_state state);
 int vpu_get_num_buffers(struct vpu_inst *inst, u32 type);
 bool vpu_is_source_empty(struct vpu_inst *inst);
 
 dma_addr_t vpu_get_vb_phy_addr(struct vb2_buffer *vb, u32 plane_no);
-unsigned int vpu_get_vb_length(struct vb2_buffer *vb, u32 plane_no);
 static inline struct vpu_format *vpu_get_format(struct vpu_inst *inst, u32 type)
 {
 	if (V4L2_TYPE_IS_OUTPUT(type))
@@ -43,11 +40,6 @@ static inline struct vpu_format *vpu_get
 		return &inst->cap_format;
 }
 
-static inline char *vpu_type_name(u32 type)
-{
-	return V4L2_TYPE_IS_OUTPUT(type) ? "output" : "capture";
-}
-
 static inline int vpu_vb_is_codecconfig(struct vb2_v4l2_buffer *vbuf)
 {
 #ifdef V4L2_BUF_FLAG_CODECCONFIG


