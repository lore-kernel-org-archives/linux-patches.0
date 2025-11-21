Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95473F9D2;
	Fri, 21 Nov 2025 13:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732635; cv=none; b=BxTUCkgf6IUe1etJxCeiBekPz3VGI/oGXnrzJ/gmdI+Q6aH3OP/WQbdSv2KZ78tdwybMbpV0MAXP2oKWBJgFQJboXGMWHKwQk9dR+bkxg+gVT1aJMGqQ+ZGUPhqaqeOBCnvclxquRRU6jId4rWGeTQ95El+Wj6voP7+YDqHQILM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732635; c=relaxed/simple;
	bh=V67JC3lmf81jdEv6WiUEYkaixZT+9YGVvmvs/x5n12k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4KhD3c75QY670C1EhO99ZgM4JCEl9sVRqcA+wSPE+pzzMrabh+bMdOJ5RthsFyppz/sqooZ0htuQYwCddGnt4pSqVhQvrCfikl5fEKei2T7qm8swf9HlkygV//lsfeXtBEYtzhhPYSt+V3gCV9qt7nHPpfj/h62dYZOAsZsmAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpCL2X1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpCL2X1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421AFC4CEF1;
	Fri, 21 Nov 2025 13:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732635;
	bh=V67JC3lmf81jdEv6WiUEYkaixZT+9YGVvmvs/x5n12k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpCL2X1ZFLet4SK8n2MHpjcoI6Yjrm2WuZ9v6PF7+JQhuyBJOiikRSiey4k7EFQ3M
	 jXHxoo2CNhCJFw+MihkfcSAZolLnV+5wdFX7ZDFaAqOcB8w09ySqdk56gUpmZGqgAU
	 gIDEAi5WqdzPv9CxTEB04akHS449hdyQgUpVLQ/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paulk@sys-base.io>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 190/529] media: verisilicon: Explicitly disable selection api ioctls for decoders
Date: Fri, 21 Nov 2025 14:08:09 +0100
Message-ID: <20251121130237.778794791@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Kocialkowski <paulk@sys-base.io>

[ Upstream commit 73d50aa92f28ee8414fbfde011974fce970b82cc ]

Call the dedicated v4l2_disable_ioctl helper instead of manually
checking whether the current context is an encoder for the selection
api ioctls.

Signed-off-by: Paul Kocialkowski <paulk@sys-base.io>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/verisilicon/hantro_drv.c  | 2 ++
 drivers/media/platform/verisilicon/hantro_v4l2.c | 6 ++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/verisilicon/hantro_drv.c b/drivers/media/platform/verisilicon/hantro_drv.c
index 1874c976081f8..35833ee8beb51 100644
--- a/drivers/media/platform/verisilicon/hantro_drv.c
+++ b/drivers/media/platform/verisilicon/hantro_drv.c
@@ -910,6 +910,8 @@ static int hantro_add_func(struct hantro_dev *vpu, unsigned int funcid)
 		vpu->decoder = func;
 		v4l2_disable_ioctl(vfd, VIDIOC_TRY_ENCODER_CMD);
 		v4l2_disable_ioctl(vfd, VIDIOC_ENCODER_CMD);
+		v4l2_disable_ioctl(vfd, VIDIOC_G_SELECTION);
+		v4l2_disable_ioctl(vfd, VIDIOC_S_SELECTION);
 	}
 
 	video_set_drvdata(vfd, vpu);
diff --git a/drivers/media/platform/verisilicon/hantro_v4l2.c b/drivers/media/platform/verisilicon/hantro_v4l2.c
index db145519fc5d3..52009c5b0db4b 100644
--- a/drivers/media/platform/verisilicon/hantro_v4l2.c
+++ b/drivers/media/platform/verisilicon/hantro_v4l2.c
@@ -655,8 +655,7 @@ static int vidioc_g_selection(struct file *file, void *priv,
 	struct hantro_ctx *ctx = fh_to_ctx(priv);
 
 	/* Crop only supported on source. */
-	if (!ctx->is_encoder ||
-	    sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		return -EINVAL;
 
 	switch (sel->target) {
@@ -688,8 +687,7 @@ static int vidioc_s_selection(struct file *file, void *priv,
 	struct vb2_queue *vq;
 
 	/* Crop only supported on source. */
-	if (!ctx->is_encoder ||
-	    sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		return -EINVAL;
 
 	/* Change not allowed if the queue is streaming. */
-- 
2.51.0



