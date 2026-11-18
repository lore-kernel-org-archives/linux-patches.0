Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052172;
	b=fVqpasxGdXg8I1IwWg6ncXhm1AtMzHHaGW/rZGb3WZiyzM0Y/QWyx+79HNJkOlEGCEPX
	 JDWNFXCjqoLLzVjhDotHZqR6qY9HzwN1KuwI76FG1YgEkD7pWOeIK+wvvCoKizHR6oviH
	 vwpBqsyv0+q+BpsALUIq43HF+d3n6fD426I3De5VB+4kapo46ibPjnvh1VDk99b3t3yC7
	 MDkw+dK/32knJW9eH1q5EHnrvr1DalZG1GZwSaKCcuoh+8kiVWrW0MlQe6F8pG3mwMU/Z
	 BGX8Qm8bPreKpGT3zmrK3Rs9XzML7vg6G2kwQr2ntjIKpAEWst8OztWazJq/PSq80mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zrxusnj/Oh1rAlgvOV8bGu0PN81zuJLYaiWwFyAt2M4=;
	b=kJD7xgTdPPB/p22tdzNFSEztRsZVIjaeurjuyhuAPAWhZaII90N7Nbf2aU6tpNmh4cbQ
	 JQNOR3mFFls/wXfTnku3sP6ytKOxe3IyoNZS6XzwxuZxbRD2442PsEPoo3Siua8iogf9Y
	 GUi9L3ruuJQfOeRZh8izG1sZwI3waeaV4zpeiqmHhzYnaAH1Gli84JqdjxvbvZNmOMuHZ
	 fBLMKTVZmjmg3VnsfbK1xVacI/BF8M+Z9ZawakDJmXoqbbso7cn+nfpY9xksGqmt2eh3Y
	 SL2ZssdzvshIOaJtkhKhjtV+hk4WYaSx3nFY6H+qC/g3zh3aINkrhU/wZ2Ar/I3CVzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XdRNOAm8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5677606A325;
	Thu, 19 Nov 2026 01:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XdRNOAm8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4850D1F000C6;
	Thu, 19 Nov 2026 01:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052171;
	bh=Zrxusnj/Oh1rAlgvOV8bGu0PN81zuJLYaiWwFyAt2M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XdRNOAm8jCXVHXNUdkInuhRdUi2jZKytfgfup2oqhXPVIgjNw9DCfUtzeVQQ0Xqsx
	 qrjjQapwLtCn9EyLu4wfJL/JmJrx1SijAc//R6zDdVtuVXQhS/VgEzyFoYcSzAeNdW
	 PFSlHoIKOhW8tOzgQafG3Z6GpLJxPBJVxTZTuHhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0466/2214] media: vicodec: make encoder CAPTURE dimensions read-only
Date: Wed, 18 Nov 2026 15:35:42 +0100
Message-ID: <20261118150029.847272708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 26376feac9e01..7aef1783c5f07 100644
--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -895,6 +895,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
 	struct vicodec_ctx *ctx = file2ctx(file);
+	struct vicodec_q_data *q_data_out =
+		get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	struct v4l2_pix_format_mplane *pix_mp;
 	struct v4l2_pix_format *pix;
 
@@ -905,6 +907,10 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
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
@@ -916,6 +922,10 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
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



