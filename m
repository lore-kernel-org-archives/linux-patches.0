Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AEC35BDAB;
	Fri,  9 Jan 2026 12:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963062; cv=none; b=sIcOTS3zH9OFrMl1ykrjT4nwGY60EyXX4ZmMtrRQThM0SEkCWLnf/f5/VLOjIft3UTam96C1+VfAmLHqSVgpwoSpaw1ECqPxk9JsPZ8IlrAg6L6oKLHqJuF2Ypd6xiBakkb7meVDPUGgA6nTNd/cZRKATXth0o1t7hfiAklvgQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963062; c=relaxed/simple;
	bh=YH5TZKlyT03aN+aiskFf/h1fzPRiPdz1WQMOELmR7yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppFTvjfkj/UgtLHheDNy0T6zvXs/Z1zY+OrLL9YmhNjONF16U6y9wE9hAExCGyePk7pGI9yh1QgoTrRF0x6f1TjB3pRd7zwcn/UvX6EKIA7rSaTdfGv2Zh/e8mp+oYNZsvYMZRMyFX/2MYFUCKANK9aaz7WXhlJy0RUpvobSRE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRp3Wa40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRp3Wa40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD36C4CEF1;
	Fri,  9 Jan 2026 12:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963062;
	bh=YH5TZKlyT03aN+aiskFf/h1fzPRiPdz1WQMOELmR7yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRp3Wa40plmKBgdK0orWG3V881pL5Omx7X5MI54z4uNxi9fKtdOc0MTOnH72KqFmB
	 Bs0JwYxy+Y7WHD0ndHfiYXo6OB5vQLujyUSoKAV3UPoFY9Us8LxXriugRmGOyGlcb+
	 cUBb6nPtQSg7z++GayiWTIBpORYgHwTgeXeM9X6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 583/634] media: amphion: Remove vpu_vb_is_codecconfig
Date: Fri,  9 Jan 2026 12:44:21 +0100
Message-ID: <20260109112139.551412033@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@oss.nxp.com>

[ Upstream commit 634c2cd17bd021487c57b95973bddb14be8002ff ]

Currently the function vpu_vb_is_codecconfig() always returns 0.
Delete it and its related code.

Fixes: 3cd084519c6f ("media: amphion: add vpu v4l2 m2m support")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/amphion/vpu_malone.c |   23 +++--------------------
 drivers/media/platform/amphion/vpu_v4l2.c   |   10 ----------
 drivers/media/platform/amphion/vpu_v4l2.h   |   10 ----------
 3 files changed, 3 insertions(+), 40 deletions(-)

--- a/drivers/media/platform/amphion/vpu_malone.c
+++ b/drivers/media/platform/amphion/vpu_malone.c
@@ -1295,22 +1295,18 @@ static int vpu_malone_insert_scode_vc1_g
 {
 	if (!scode->inst->total_input_count)
 		return 0;
-	if (vpu_vb_is_codecconfig(to_vb2_v4l2_buffer(scode->vb)))
-		scode->need_data = 0;
 	return 0;
 }
 
 static int vpu_malone_insert_scode_vc1_g_pic(struct malone_scode_t *scode)
 {
-	struct vb2_v4l2_buffer *vbuf;
 	u8 nal_hdr[MALONE_VC1_NAL_HEADER_LEN];
 	u32 *data = NULL;
 	int ret;
 
-	vbuf = to_vb2_v4l2_buffer(scode->vb);
 	data = vb2_plane_vaddr(scode->vb, 0);
 
-	if (scode->inst->total_input_count == 0 || vpu_vb_is_codecconfig(vbuf))
+	if (scode->inst->total_input_count == 0)
 		return 0;
 	if (MALONE_VC1_CONTAIN_NAL(*data))
 		return 0;
@@ -1331,8 +1327,6 @@ static int vpu_malone_insert_scode_vc1_l
 	int size = 0;
 	u8 rcv_seqhdr[MALONE_VC1_RCV_SEQ_HEADER_LEN];
 
-	if (vpu_vb_is_codecconfig(to_vb2_v4l2_buffer(scode->vb)))
-		scode->need_data = 0;
 	if (scode->inst->total_input_count)
 		return 0;
 	scode->need_data = 0;
@@ -1503,7 +1497,7 @@ static int vpu_malone_input_frame_data(s
 	scode.vb = vb;
 	scode.wptr = wptr;
 	scode.need_data = 1;
-	if (vbuf->sequence == 0 || vpu_vb_is_codecconfig(vbuf))
+	if (vbuf->sequence == 0)
 		ret = vpu_malone_insert_scode(&scode, SCODE_SEQUENCE);
 
 	if (ret < 0)
@@ -1539,7 +1533,7 @@ static int vpu_malone_input_frame_data(s
 	 * This module is currently only supported for the H264 and HEVC formats,
 	 * for other formats, vpu_malone_add_scode() will return 0.
 	 */
-	if ((disp_imm || low_latency) && !vpu_vb_is_codecconfig(vbuf)) {
+	if (disp_imm || low_latency) {
 		ret = vpu_malone_add_scode(inst->core->iface,
 					   inst->id,
 					   &inst->stream_buffer,
@@ -1586,7 +1580,6 @@ int vpu_malone_input_frame(struct vpu_sh
 			   struct vpu_inst *inst, struct vb2_buffer *vb)
 {
 	struct vpu_dec_ctrl *hc = shared->priv;
-	struct vb2_v4l2_buffer *vbuf;
 	struct vpu_malone_str_buffer __iomem *str_buf = hc->str_buf[inst->id];
 	u32 disp_imm = hc->codec_param[inst->id].disp_imm;
 	u32 size;
@@ -1600,16 +1593,6 @@ int vpu_malone_input_frame(struct vpu_sh
 		return ret;
 	size = ret;
 
-	/*
-	 * if buffer only contain codec data, and the timestamp is invalid,
-	 * don't put the invalid timestamp to resync
-	 * merge the data to next frame
-	 */
-	vbuf = to_vb2_v4l2_buffer(vb);
-	if (vpu_vb_is_codecconfig(vbuf)) {
-		inst->extra_size += size;
-		return 0;
-	}
 	if (inst->extra_size) {
 		size += inst->extra_size;
 		inst->extra_size = 0;
--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -257,16 +257,6 @@ struct vb2_v4l2_buffer *vpu_next_src_buf
 	if (!src_buf || vpu_get_buffer_state(src_buf) == VPU_BUF_STATE_IDLE)
 		return NULL;
 
-	while (vpu_vb_is_codecconfig(src_buf)) {
-		v4l2_m2m_src_buf_remove(inst->fh.m2m_ctx);
-		vpu_set_buffer_state(src_buf, VPU_BUF_STATE_IDLE);
-		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
-
-		src_buf = v4l2_m2m_next_src_buf(inst->fh.m2m_ctx);
-		if (!src_buf || vpu_get_buffer_state(src_buf) == VPU_BUF_STATE_IDLE)
-			return NULL;
-	}
-
 	return src_buf;
 }
 
--- a/drivers/media/platform/amphion/vpu_v4l2.h
+++ b/drivers/media/platform/amphion/vpu_v4l2.h
@@ -37,14 +37,4 @@ static inline struct vpu_format *vpu_get
 	else
 		return &inst->cap_format;
 }
-
-static inline int vpu_vb_is_codecconfig(struct vb2_v4l2_buffer *vbuf)
-{
-#ifdef V4L2_BUF_FLAG_CODECCONFIG
-	return (vbuf->flags & V4L2_BUF_FLAG_CODECCONFIG) ? 1 : 0;
-#else
-	return 0;
-#endif
-}
-
 #endif


