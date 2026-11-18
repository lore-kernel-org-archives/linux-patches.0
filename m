Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044926;
	b=5dYC2Ym1p03gnJL/NrjKqaeerJdHkIhlZgUmqWf2k1m3opvmPknBbnfbIi6WAuOvT2JT
	 1DwASRyNfgNWOjvqFzF3FsVCvgGziCCoGxqa1K0jlMX4aIiZ7bMuFhArrFFAvDO9qbxYI
	 t3lUh1vUwZkwCFHwp0e3R6MRb/OdXPFVMryTJsb0tDd1VG7c/WdULAW00/i/i8KyVt0B5
	 rgYEEnusepIXG3BaS76X5ADHhrRUXhln4CrMwIjQiIOrHLZZ2yoMeHdFUpHY/txnh9caE
	 PEC6pLiFYqJebyxKqsARVUfgXRfjTtrtNHDLZ+3TQj7zo05LgMq831O6xjuKssAFuzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MnFOxdP6qj8/8JDflk7dhJrsdT7JnqKVkqUSJcEHow0=;
	b=yh3ChGOJfTiZGE/n2b88W9HvO4REwjM3stRQB93Q3L4c7klKnje86NjMMdDTgbW2m0MD
	 yP4d5zGD5l35fwpan+GLJ88WwNaSZ1py0uWRzrItGvP2OrqgL8pWWCLYJT2oBebpuId/h
	 rgiZR9zK8iVlXfjGL1F9gT9hSrmMuV5VgaRx3W+sgYIJ75m8oOeDNG7F3yej+Rkg6KOVd
	 36OWeGXc+TeeSQLzDzqGmTEdQCIdAZKRgdXcL1Y2MZDNJvu0vOQ48Or76zAv30aTnqx4q
	 8A+RVci+rwiuUtRsJzFSdkEHtzFA+3G8ZwznjtwazrJPD409fuGxhGGVIBbAYFEOCgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RPU6di8z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596BA606A334;
	Wed, 18 Nov 2026 23:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RPU6di8z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB071F000C4;
	Wed, 18 Nov 2026 23:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044926;
	bh=MnFOxdP6qj8/8JDflk7dhJrsdT7JnqKVkqUSJcEHow0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPU6di8ze9aCjD9XFCksfZ1TUWFziyp7OxHZ4kSeHyKS7/I9QuNdZlPvBjweeKz/O
	 9/QmVvNtgnf9SuKxcyx4vyB/3HQ+kClA+o4qYoCox2OrVmSqiw9xBYR6fLbRtGWsm2
	 R4DdLxnGXjeKK00qykIb3D+r7AY13Nr0DTFEcLqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0742/2857] media: vicodec: make encoder CAPTURE dimensions read-only
Date: Wed, 18 Nov 2026 15:29:36 +0100
Message-ID: <20261118150228.268726047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 96a0d63cadb1e..4a1c57b48e203 100644
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



