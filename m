Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061168;
	b=Kwg9YfFSSjYLHEBSSRs2QQsK/W3C0FqDSIzvbHt6OoFCRryFTlo0GPIskTw05TZn81Vi
	 MjKxXEqReWd4wLSTna5QnDiMsrz5n4slkBNPNhcH0Bk3PctlSbF7gv3fv9IpFdzBwlQDv
	 VG/nxqaZSBk2jbR9l2i7a1x2hL4xCyCYwXXCvieQOHKcqsBOMhT45oGOycpA9n+8tipxY
	 a5ExYCJ9WbMLArLMeJMCrVJI/1RTHOOxE4HhdgkQ91sM8HbrLlX6yK/mlRdPmP4kfwGIa
	 J8U7QAdi+GPGMv39XUh+mtwE89N/zT/JYH8jTy+Bnk42ACCnIpioPLfCbPjrzwjQCPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=V7Tn7+Zx+fWVTakR5ZTqf9OmMYmGkKcWJDP/mX87s88=;
	b=BXELn+kqh/EHY09ud1VGtBRhd2KXaNWUnSnH/1GQyUQJtQpi71ys/YrPwwOqi9p5/nWE
	 8xCk6nvOgrPZDA/GpH1b4WWziqyh9DJsM6qGyBL9fPQojG5/Sf2/sF1XvFdqC7jLRfujb
	 MpX6qGGBqVlXkQN3Z0pkqkFU5IOCAtJSO2hWF40XrJLxg1UY/wFYmiHcCTckyzjrXpPVH
	 ZaFDLmNzcP/wCsuIzkejylU8r2sqvI4ewktnZOhYbQb8MEZpcBmVG8+avFCN/5CmGZI/p
	 KDuC2eBSz66j9+z1QAjvIV9AGP9CMbj5+ZOalWZFBi43TaxSoVWZtjBfBjoKD377Wrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TfdE017x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297C6606A33A;
	Sat,  7 Nov 2026 14:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TfdE017x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E761F0089F;
	Sat,  7 Nov 2026 14:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061168;
	bh=V7Tn7+Zx+fWVTakR5ZTqf9OmMYmGkKcWJDP/mX87s88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TfdE017xka0F0iX6pk8yAzV/AaXFcffUOCMwX0VENjDiT2xeFkTBMbFnzXAXP+BWA
	 d8dy9aSUzvfTbruicWZXNspjr9lXN038PszQ8Ywqeb73yTgbSsE8JC5QnPqrDG89Ii
	 oHfqKEe4CeDd+QewzWemVxj0GsmjO9h6KVifC0Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0455/1536] media: chips-media: wave5: Set inst->std during default format initialization
Date: Sat,  7 Nov 2026 08:41:11 -0500
Message-ID: <20261107135010.309389770@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackson Lee <jackson.lee@chipsnmedia.com>

[ Upstream commit cfcefc5a996f6a00b310c963b5f811430f28a30a ]

When the encoder is opened, wave5_set_default_format() sets up the
default capture format (e.g. H.264) but does not initialize inst->std.
As a result, inst->std remains zero, which does not match any valid
encoder codec.

If STREAMON is called before the user explicitly calls S_FMT on the
capture queue — as v4l2-compliance does in testBlockingDQBuf — the
codec/product check in wave5_vpu_enc_init_seq() fails with
"Unsupported encoder-codec & product combination" because inst->std
is neither W_HEVC_ENC nor W_AVC_ENC, returning -EOPNOTSUPP.

Fix this by setting inst->std via wave5_to_vpu_std() in
wave5_set_default_format(), so that the codec type is always consistent
with the default capture pixel format from the moment the instance is
opened.

Fixes: 9707a6254a8a ("media: chips-media: wave5: Add the v4l2 layer")
Cc: stable@vger.kernel.org
Signed-off-by: Jackson Lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: Adapted wave5_set_default_format() to the older function body (fixed 416x240 format setup) and dropped the conf_win context lines this tree lacks, keeping the added inst->std assignment unchanged. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c b/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
index 917264348b554..bcbd128da250b 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
@@ -1424,7 +1424,8 @@ static const struct vb2_ops wave5_vpu_enc_vb2_ops = {
 	.stop_streaming = wave5_vpu_enc_stop_streaming,
 };
 
-static void wave5_set_default_format(struct v4l2_pix_format_mplane *src_fmt,
+static void wave5_set_default_format(struct vpu_instance *inst,
+				     struct v4l2_pix_format_mplane *src_fmt,
 				     struct v4l2_pix_format_mplane *dst_fmt)
 {
 	unsigned int src_pix_fmt = enc_fmt_list[VPU_FMT_TYPE_RAW][0].v4l2_pix_fmt;
@@ -1441,6 +1442,7 @@ static void wave5_set_default_format(struct v4l2_pix_format_mplane *src_fmt,
 	dst_fmt->flags = 0;
 	dst_fmt->num_planes = 1;
 	wave5_update_pix_fmt(dst_fmt, 416, 240);
+	inst->std = wave5_to_vpu_std(dst_fmt->pixelformat, inst->type);
 }
 
 static int wave5_vpu_enc_queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
@@ -1697,7 +1699,7 @@ static int wave5_vpu_open_enc(struct file *filp)
 	inst->v4l2_fh.ctrl_handler = v4l2_ctrl_hdl;
 	v4l2_ctrl_handler_setup(v4l2_ctrl_hdl);
 
-	wave5_set_default_format(&inst->src_fmt, &inst->dst_fmt);
+	wave5_set_default_format(inst, &inst->src_fmt, &inst->dst_fmt);
 	inst->colorspace = V4L2_COLORSPACE_REC709;
 	inst->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
 	inst->quantization = V4L2_QUANTIZATION_DEFAULT;
-- 
2.53.0



