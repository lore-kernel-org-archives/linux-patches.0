Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823B21170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D0BC433C7;
	Mon, 11 Sep 2023 14:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441604;
	bh=DBw4hxpdAQwaDF7Vs6exqp4HTlT/LL7Z2lNIymlye9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAyXCatERQZNFk7RZ91t+jDLacV/iTGX96LHmN5iMp3ozFFn4KdD8Jjq/NB2cUqBA
	 RDDxHqDFNuA8uasUqO+9WtgpTxaLyi5HEbGBsBCteAf8Rtp2Jd8q0MvHTjPSyYsIH9
	 CQZp0n1Y6rTI1RAaf9Q4A5cFnUoQgJplpBD0QI40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 472/739] media: amphion: fix REVERSE_INULL issues reported by coverity
Date: Mon, 11 Sep 2023 15:44:31 +0200
Message-ID: <20230911134704.328940244@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 79d3bafaecc13bccab1ebbd28a15e669c5a4cdaf ]

null-checking of a pointor is suggested before dereferencing it

Fixes: 9f599f351e86 ("media: amphion: add vpu core driver")
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/venc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/amphion/venc.c b/drivers/media/platform/amphion/venc.c
index 58480e2755ec4..4eb57d793a9c0 100644
--- a/drivers/media/platform/amphion/venc.c
+++ b/drivers/media/platform/amphion/venc.c
@@ -268,7 +268,7 @@ static int venc_g_parm(struct file *file, void *fh, struct v4l2_streamparm *parm
 {
 	struct vpu_inst *inst = to_inst(file);
 	struct venc_t *venc = inst->priv;
-	struct v4l2_fract *timeperframe = &parm->parm.capture.timeperframe;
+	struct v4l2_fract *timeperframe;
 
 	if (!parm)
 		return -EINVAL;
@@ -279,6 +279,7 @@ static int venc_g_parm(struct file *file, void *fh, struct v4l2_streamparm *parm
 	if (!vpu_helper_check_type(inst, parm->type))
 		return -EINVAL;
 
+	timeperframe = &parm->parm.capture.timeperframe;
 	parm->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
 	parm->parm.capture.readbuffers = 0;
 	timeperframe->numerator = venc->params.frame_rate.numerator;
@@ -291,7 +292,7 @@ static int venc_s_parm(struct file *file, void *fh, struct v4l2_streamparm *parm
 {
 	struct vpu_inst *inst = to_inst(file);
 	struct venc_t *venc = inst->priv;
-	struct v4l2_fract *timeperframe = &parm->parm.capture.timeperframe;
+	struct v4l2_fract *timeperframe;
 	unsigned long n, d;
 
 	if (!parm)
@@ -303,6 +304,7 @@ static int venc_s_parm(struct file *file, void *fh, struct v4l2_streamparm *parm
 	if (!vpu_helper_check_type(inst, parm->type))
 		return -EINVAL;
 
+	timeperframe = &parm->parm.capture.timeperframe;
 	if (!timeperframe->numerator)
 		timeperframe->numerator = venc->params.frame_rate.numerator;
 	if (!timeperframe->denominator)
-- 
2.40.1



