Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058116;
	b=emmSkYP40KtK+BONOMXmvHkjIRguBrNiKFm7MhMNNreHOBQn7lLfA+KeM+6oApfxZ83K
	 cdXiuBzdBgUgSQOZLcJTJNLxoNs8wyNg64Ob4rEdWIkfViOlht0KQ7lurIJgzDsi94p/5
	 uFLorEldvD0QnmdtaOQNsI9gItjJm8PzbgJggPalD/jxWtSrjvhozkNtGIh9OvT1jpAuJ
	 dYbplrKy7CvdhDZBNmmrosweLpox6wuWxKu3xBugHIDGQK/THlRVMlEB9a0HCux2+vwrm
	 9sgiM4afUP23U05PaO1Xb8AyXi1Igieqj/0jNu0CyzN9C/NRQ43jmEQUvO3lw1ifaxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kc6Fsbs76acl5tjmE+fOV1UkMhh+r0zUZ0MjXx6WrbQ=;
	b=nnlQFnM1w54Ig4Meh9GJwLjg2oKQWx06JgoqH5rEUBMu4s/wg9fWJ+o5PnKnw/ExmkaL
	 plt/ZvVCJjRSQG0jWKgfzLRSFF21/9sR5iPHh9dpK1Up1mq2elptea75er5fsZWlxj824
	 OBbnV/Ek/t8EGGBBbEd4ekf4ceg2Ew6knLS8LTIoXrr8wkdY/JTQ1wGUGMiMvRRbLWQp/
	 rjwebNsffrrT7HfdNN7FhJuLKPrf4iDmAWhI39caGkOyALqx0O96flZp7FC0PSfH0QtAu
	 hO5yFLItyb/IF1+7w5aFBpOdJBE5w2EQKR/UB4TSE00/GfKcsUzqXqNltUSvFmf4IJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zq09xr0R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E15F606A31C;
	Thu, 19 Nov 2026 03:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zq09xr0R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BBF1F000C4;
	Thu, 19 Nov 2026 03:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058116;
	bh=kc6Fsbs76acl5tjmE+fOV1UkMhh+r0zUZ0MjXx6WrbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zq09xr0RMMCe8yMLjl6QHqzMqw6IwNJTFbHedm3GO2CmHS6AZPg3wCSCxWLoJvKyB
	 lbUloT25SKMle/pXg7rP63r5bXJsj5aFHyOHMHRc6n9In5/apnqTs/WfK5yB3b5Qhn
	 UMlXd3OqlE3T6S1Bsp2y52nuCm1GhLcTRSoHiI/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0371/1848] media: vicodec: make encoder CAPTURE dimensions read-only
Date: Wed, 18 Nov 2026 15:40:09 +0100
Message-ID: <20261118145928.955614808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 2532e9d2f8ccb330a9c924b1ee34c5629240d352 ]

Setting the encoder's compressed CAPTURE format to a smaller resolution
than the raw OUTPUT format makes the encoder write past the end of the
CAPTURE buffer.

For a stateful encoder the CAPTURE width and height are not
client-settable; Documentation/userspace-api/media/v4l/dev-encoder.rst
specifies them as "ignored (read-only)" on VIDIOC_S_FMT. vicodec only
implements half of that: vidioc_s_fmt_vid_out() derives the CAPTURE coded
size and sizeimage from the OUTPUT format, but S_FMT on the CAPTURE queue
overwrites them. The encoder then takes its geometry from the OUTPUT
queue alone, and v4l2_fwht_encode() gets no destination length.

Overwrite the requested width and height with the OUTPUT queue's coded
dimensions in vidioc_try_fmt_vid_cap(), making them read-only as the
interface requires.

Fixes: efec9c815e5d ("media: vicodec: pass on enc output format to capture side")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vicodec/vicodec-core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/test-drivers/vicodec/vicodec-core.c b/drivers/media/test-drivers/vicodec/vicodec-core.c
index 81fd6ed949517..8a24ee814ff32 100644
--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -900,6 +900,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
 	struct vicodec_ctx *ctx = file2ctx(file);
+	struct vicodec_q_data *q_data_out =
+		get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	struct v4l2_pix_format_mplane *pix_mp;
 	struct v4l2_pix_format *pix;
 
@@ -910,6 +912,10 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		pix = &f->fmt.pix;
 		pix->pixelformat = ctx->is_enc ? V4L2_PIX_FMT_FWHT :
 				   find_fmt(f->fmt.pix.pixelformat)->id;
+		if (ctx->is_enc) {
+			pix->width = q_data_out->coded_width;
+			pix->height = q_data_out->coded_height;
+		}
 		pix->colorspace = ctx->state.colorspace;
 		pix->xfer_func = ctx->state.xfer_func;
 		pix->ycbcr_enc = ctx->state.ycbcr_enc;
@@ -921,6 +927,10 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		pix_mp = &f->fmt.pix_mp;
 		pix_mp->pixelformat = ctx->is_enc ? V4L2_PIX_FMT_FWHT :
 				      find_fmt(pix_mp->pixelformat)->id;
+		if (ctx->is_enc) {
+			pix_mp->width = q_data_out->coded_width;
+			pix_mp->height = q_data_out->coded_height;
+		}
 		pix_mp->colorspace = ctx->state.colorspace;
 		pix_mp->xfer_func = ctx->state.xfer_func;
 		pix_mp->ycbcr_enc = ctx->state.ycbcr_enc;
-- 
2.53.0



