Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061939;
	b=uwpGLkbywNAYqcJ8rdRuHQmKwJpLkWqwqTf6tP4DxH7cPpFcC4sdyix1zTJUb2Ds+/42
	 NVwURzB72wN5VaKWS3swq53BGgZOdsWzX+wCnqyOv2tGrYzz8cJv7sn5xc6e7VVjHcfI2
	 9O2o3lxeVUpp2mQAIPTBZdq+Xl6ielGsVmx/CvnQ3a8vJ/0FRrA7rRGi7gzhO6432U6ss
	 5JK169yPFWXuNxblcoSgGoJAwj6kACC+dHwW//KIcDOEi93d+lgb5gXVFH0ta4E/IC0lG
	 1x9yf1ysxEZRPtewooeXMIKU8UPhn7WAjnlY6x+STWh9+UxwmgsbNDxY/M8/aY3aXLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b8qezQjQoKCud1BAcNfEeupB0iTj9PPzNsccAII3EyQ=;
	b=AHQ/95wAY1N3iipU+MhZC1nIzLmW+wqnXuautCdbQxQ3XlPgzPpVjKD+8j07XxMR6g56
	 7koofZ/gY0nus8SmzddKGgEnUOaUegWeXuWjwFfwdgLrg6z1Adj/oXFnpOk1YsrXGiDBP
	 1UQYvoTchitnCEouQkJPZPsynKvuyZvJA2490hl+f6IAPuyUFGIclx2kEgz+D63ye6yuC
	 QnVl3TwPTJusxasFanvxgxHSP+5YHJKKH+ixZSvbXQ76Y417Zf7k+hqPKu46qEW8Wc7p0
	 qNvIUCsieq9OvI6A/2+as/8nAkqaQXWbWsthhqb5uCH0k7hwr+xmlCaOFq4TD0cayMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tCcVd3Yu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCE0606A326;
	Sat,  7 Nov 2026 14:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tCcVd3Yu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445721F0089F;
	Sat,  7 Nov 2026 14:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061938;
	bh=b8qezQjQoKCud1BAcNfEeupB0iTj9PPzNsccAII3EyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tCcVd3YuT5CMh0QkH0hbiahGPqgyb8ey8QtW+q/SLUIIAPnE6xp6QFkpbIQa5s127
	 5bttiB6ShJ/uF6eTBmAdvzpXr35TGUL7ABl6cCk5pagfx+d8fJod0ztIPEKI1jwP5L
	 MDccQd5h4HR3hTmo/lXUhFc/96WLWAoWD53Qzr+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0940/1536] media: vicodec: make encoder CAPTURE dimensions read-only
Date: Sat,  7 Nov 2026 08:49:16 -0500
Message-ID: <20261107135024.053474674@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 161d8449faea7..e7cea1816bb11 100644
--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -891,6 +891,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
 	struct vicodec_ctx *ctx = file2ctx(file);
+	struct vicodec_q_data *q_data_out =
+		get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	struct v4l2_pix_format_mplane *pix_mp;
 	struct v4l2_pix_format *pix;
 
@@ -901,6 +903,10 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
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
@@ -912,6 +918,10 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
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



