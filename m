Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EB94ADDA5;
	Sat, 28 Feb 2026 17:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301321; cv=none; b=o1alqGI5ScXsU0RwynBubHpgiddyFtlGqIFdUSA7EwJqGPD1KIxtsUZYOJLIx8kUXscvXh2vKZOKg74P6gxYuye6fgNNcO5fv+GsaArjN7O2/vODei0J59mZes6wIrS89JiEDKG7kHr59/dSelKL/TWLj3C0BBwy5rYdgU4GUyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301321; c=relaxed/simple;
	bh=9sarrJusHP7eAiZ0RwmOWlsWxVMbOU+eohGE96VMNH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Et5yr4VAMtHYUvuLrtGjzzDC7qWsWAGjy+97mN3vJl+5wJIKUbP+x8nYgeuHQxYVaBLnvSNgKUtFtc91CFLbvIAzMOMUMRe4lO/fPdhxHrlFL3MeRgtEvZzknNHJRIpVBbJVv/sQZH5rDtug3+keaevDj4CpCwNfdxmNQXI+wo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rf5FrnFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rf5FrnFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247D9C19423;
	Sat, 28 Feb 2026 17:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301320;
	bh=9sarrJusHP7eAiZ0RwmOWlsWxVMbOU+eohGE96VMNH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rf5FrnFgFLApPb/lyRpfQOu5F7wIsuBxUVXl8CjS/A5DPGigtFGgx4BUuQZChX7g+
	 qAYZjdYmys3+M0gteaRr0BbsNn8R2HW+pZwcuBjcyKWJ/ee6lXTvfilSRJzxTQQqF2
	 bCFCyLmako2ZYcWcsCoYiuL2s79tWwv/PjfDk4MIFP37AztLXMzpMxoFoyGpYd+TAP
	 l8QWa+Gz+rqOagoHjlf93veuc6ibxMfW38sVdPKPmauUCggTmm15T1iCGKhllKC3Yf
	 bSPigEuotWQXRg/k40epqOvsahfKzhLCFnpqKr53PMzkfep+rCDOJ9f0VjVx0gXGM1
	 JOaQGM4/BAL0g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ming Qian <ming.qian@oss.nxp.com>,
	stable@vger.kernel.org,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 507/752] media: amphion: Drop min_queued_buffers assignment
Date: Sat, 28 Feb 2026 12:43:38 -0500
Message-ID: <20260228174750.1542406-507-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ming Qian <ming.qian@oss.nxp.com>

[ Upstream commit 5633ec763a2a18cef6c5ac9250e4f4b8786e7999 ]

The min_queued_buffers field controls when start_streaming() is called
by the vb2 core (it delays the callback until at least N buffers are
queued). Setting it to 1 affects the timing of start_streaming(), which
breaks the seek flow in decoder scenarios and causes test failures.

The current driver implementation does not rely on this minimum buffer
requirement and handles streaming start correctly with the default
value of 0, so remove these assignments.

Fixes: 3cd084519c6f ("media: amphion: add vpu v4l2 m2m support")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_v4l2.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu_v4l2.c b/drivers/media/platform/amphion/vpu_v4l2.c
index 47dff9a35bb46..1fb887b9098c6 100644
--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -670,7 +670,6 @@ static int vpu_m2m_queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_q
 		src_vq->mem_ops = &vb2_vmalloc_memops;
 	src_vq->drv_priv = inst;
 	src_vq->buf_struct_size = sizeof(struct vpu_vb2_buffer);
-	src_vq->min_queued_buffers = 1;
 	src_vq->dev = inst->vpu->dev;
 	src_vq->lock = &inst->lock;
 	ret = vb2_queue_init(src_vq);
@@ -687,7 +686,6 @@ static int vpu_m2m_queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_q
 		dst_vq->mem_ops = &vb2_vmalloc_memops;
 	dst_vq->drv_priv = inst;
 	dst_vq->buf_struct_size = sizeof(struct vpu_vb2_buffer);
-	dst_vq->min_queued_buffers = 1;
 	dst_vq->dev = inst->vpu->dev;
 	dst_vq->lock = &inst->lock;
 	ret = vb2_queue_init(dst_vq);
-- 
2.51.0

