Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A5B35E533;
	Wed,  3 Dec 2025 16:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779230; cv=none; b=MFcRzU82qEgPyueP1wmV+KrT9dLl03jSr258e0na23YFt7KLFJgOsuVyqym3FGXbv4bfi1oo4YyVshB+cv0+S+8xCi1HFrOmXKex8R8hqzeg55iCvO0zzAHPAcB8qezoUEc+dNA8fg11tYSRh5q6jg8xZxpQCNKeuEeRdgP1tog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779230; c=relaxed/simple;
	bh=yczbnw6GLYbC44TmxzyGwMNp9Ki4slutU+7A+3XtSAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+GITomD3amXSBa74ZIMg0Nvr7HgXWaVHWwK/GSO07pijDC9zSuC10Cae+v4pQ7Kprv2UBLxItvQPFpvDu6mncehl3SOOUb+Z0y2pjrd7+ihE00GyVQQQxe+pDOkaD4LH/pQI0pqJWbTyh/3afB+4p6+Xo+qbVlzvm29dv7HXQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgNbcW5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgNbcW5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75054C4CEF5;
	Wed,  3 Dec 2025 16:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779229;
	bh=yczbnw6GLYbC44TmxzyGwMNp9Ki4slutU+7A+3XtSAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgNbcW5X84qjIHf5j0fYI35Tnn6CsDgBdHC2v9k5GvUE+hZLyhxq5oAyQOPbz0jVp
	 ShwyJW3B5SJRd5wtw25B790SBtfLlO8Ad/cm3UHTUHSk0vc+e3ZYvP4ICKm5BxjL4O
	 kglpLGGeZUpJAebx2dNu7cuD944F6rV6PK7KnrFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paulk@sys-base.io>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 194/568] media: verisilicon: Explicitly disable selection api ioctls for decoders
Date: Wed,  3 Dec 2025 16:23:16 +0100
Message-ID: <20251203152447.831041006@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
index 69a2442f31223..a35b6ae62d585 100644
--- a/drivers/media/platform/verisilicon/hantro_drv.c
+++ b/drivers/media/platform/verisilicon/hantro_drv.c
@@ -819,6 +819,8 @@ static int hantro_add_func(struct hantro_dev *vpu, unsigned int funcid)
 		vpu->decoder = func;
 		v4l2_disable_ioctl(vfd, VIDIOC_TRY_ENCODER_CMD);
 		v4l2_disable_ioctl(vfd, VIDIOC_ENCODER_CMD);
+		v4l2_disable_ioctl(vfd, VIDIOC_G_SELECTION);
+		v4l2_disable_ioctl(vfd, VIDIOC_S_SELECTION);
 	}
 
 	video_set_drvdata(vfd, vpu);
diff --git a/drivers/media/platform/verisilicon/hantro_v4l2.c b/drivers/media/platform/verisilicon/hantro_v4l2.c
index b2da48936e3f1..31ae6750321c4 100644
--- a/drivers/media/platform/verisilicon/hantro_v4l2.c
+++ b/drivers/media/platform/verisilicon/hantro_v4l2.c
@@ -629,8 +629,7 @@ static int vidioc_g_selection(struct file *file, void *priv,
 	struct hantro_ctx *ctx = fh_to_ctx(priv);
 
 	/* Crop only supported on source. */
-	if (!ctx->is_encoder ||
-	    sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		return -EINVAL;
 
 	switch (sel->target) {
@@ -662,8 +661,7 @@ static int vidioc_s_selection(struct file *file, void *priv,
 	struct vb2_queue *vq;
 
 	/* Crop only supported on source. */
-	if (!ctx->is_encoder ||
-	    sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		return -EINVAL;
 
 	/* Change not allowed if the queue is streaming. */
-- 
2.51.0



