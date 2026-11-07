Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063902;
	b=nyNyE5Dqw7tTXdrheZYT7dkA2XBw/rvCYP8bOV2fKvlASpKNrEwJ8XdZ3p76kgy4uu8z
	 gy63uP7Y6hs1XvDqN9jNnf7dWi4yvx5W2QyVhLL3h6AsnsahaOZGPv3frcafOHMFoAsnb
	 KBCkDs36YzA3aep2lQ4exCoXB6viWfoI3CkWq+0DRVwZgWAM5TYOuDFzvQsF/9T6rrjbn
	 tXbEtnIcO6sHaj9txKirJ8gj0wQ96DbN49PkAToDNP8HTwNE6tzjLz4szKMRkniRH5R0u
	 fknfb4IZOSc4h908JQ+A5wMj6QABhxAMeRd0eQVb/gPk5/5rDTN4eXaL/DfWX6ST/aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+HOMdV9mTziS6plf812KJuE+J2upw/CIDV3uMhQ27c0=;
	b=nfOpsEVVcBHQpBxfqvf3HH+MCzSOCKo7ul6Yj3UwJE8evWXsJLIVrAwX2eYIU9TEX/WJ
	 Fbmz3X7Kry2XPPAT0i2DG10j278LzfpTWnAJgUWb8odMGIvCdgsbmvHO4GZL1JzvxlKrI
	 mxhAMRxkkdVLA48tx8e38gyhbEnBf/qb4qQq0JpM6pHGNLraScXChW8Q7erHoyK67Rv6k
	 N1AQHobwntZchi/lwkzhHehYuMqUZMZo7ijJbAnXIGsv9XbvdromImK27VkP4ZxM2U9ee
	 2poMKgMuYqDAmrTz1qOh4IaSc9/q01m0LoyxhGDa1XMDhagDHiwM9bJw1R9AiysYqHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZJmIYqB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594CD606B8BD;
	Sat,  7 Nov 2026 15:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZJmIYqB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C3D1F008A2;
	Sat,  7 Nov 2026 15:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063902;
	bh=+HOMdV9mTziS6plf812KJuE+J2upw/CIDV3uMhQ27c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZJmIYqBUuHuq8kPnqRwsX+sY7bxVzpej787gdcI2dQwPOYIIIJsnLjrwwZ/Y3Qfu
	 9wmY/VNhb4oRDyq301N4w+GUDKW36reT8M5v7dnubGX83g1wUf1medoul4+rDJ1S5F
	 gSwy2/zqIJQPF3wkgb5k9oge1WEvF04jpTaIOz2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hoff <hoff.benjamin.k@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0085/1257] media: hws: report measured colorimetry
Date: Sat,  7 Nov 2026 08:39:41 -0500
Message-ID: <20261107134941.715761439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hoff <hoff.benjamin.k@gmail.com>

[ Upstream commit 4d28f97400376d4064c69e2c194ce18eeb69f3e5 ]

At 1920x1080, the driver advertises V4L2_COLORSPACE_REC709 with
V4L2_YCBCR_ENC_DEFAULT. The default maps to a Rec.709 matrix, but
controlled A/B captures using the in-tree and baseline drivers show that
both produce YUYV samples using a BT.601 matrix and full-range
quantization. The captures differ by at most one code value, whereas a
601-to-709 conversion would move primary luma values by roughly 11 to 33
codes.

Set the Y'CbCr encoding explicitly to V4L2_YCBCR_ENC_601 at every
resolution. Keep the resolution-based colorspace so HD retains presumed
Rec.709 primaries and transfer characteristics while SD continues to use
SMPTE 170M. Refresh the colorspace on detected geometry changes so an
SD/HD transition does not leave stale metadata.

The decoder mode register is undocumented. Stop claiming that value 0x13
selects BT.709; both drivers use that value while producing the measured
output.

Fixes: ba07fd2f5742 ("media: pci: add AVMatrix HWS capture driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Ben Hoff <hoff.benjamin.k@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/hws/hws.h            | 4 ++--
 drivers/media/pci/hws/hws_reg.h        | 3 ++-
 drivers/media/pci/hws/hws_v4l2_ioctl.c | 5 +++--
 drivers/media/pci/hws/hws_video.c      | 4 +++-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/hws/hws.h b/drivers/media/pci/hws/hws.h
index 8fbe1fe27844d..d87d52674b692 100644
--- a/drivers/media/pci/hws/hws.h
+++ b/drivers/media/pci/hws/hws.h
@@ -33,8 +33,8 @@ struct hws_pix_state {
 	u32 sizeimage;		/* full frame */
 	enum v4l2_field field;	/* V4L2_FIELD_NONE or INTERLACED */
 	enum v4l2_colorspace colorspace;	/* e.g., REC709 */
-	enum v4l2_ycbcr_encoding ycbcr_enc;	/* V4L2_YCBCR_ENC_DEFAULT */
-	enum v4l2_quantization quantization;	/* V4L2_QUANTIZATION_LIM_RANGE */
+	enum v4l2_ycbcr_encoding ycbcr_enc;	/* V4L2_YCBCR_ENC_601 */
+	enum v4l2_quantization quantization;	/* V4L2_QUANTIZATION_FULL_RANGE */
 	enum v4l2_xfer_func xfer_func;	/* V4L2_XFER_FUNC_DEFAULT */
 	bool interlaced;	/* cached hardware state */
 	u32 half_size;		/* hardware half-frame size */
diff --git a/drivers/media/pci/hws/hws_reg.h b/drivers/media/pci/hws/hws_reg.h
index e4fb4af444340..f6027a16a1938 100644
--- a/drivers/media/pci/hws/hws_reg.h
+++ b/drivers/media/pci/hws/hws_reg.h
@@ -70,7 +70,8 @@
 #define HWS_CTL_IRQ_ENABLE_BIT BIT(0)   /* Global interrupt enable bit */
 /*  Write 0x00 to fully reset decoder,
  *  set bit 31=1 to "start run",
- *  low byte=0x13 selects YUYV/BT.709/etc,
+ *  low byte=0x13 is the vendor baseline capture-mode value; its individual
+ *  bit meanings are not documented,
  *  in ReadChipId() we also write 0x00 and 0x10 here for chip-ID sequencing.
  */
 
diff --git a/drivers/media/pci/hws/hws_v4l2_ioctl.c b/drivers/media/pci/hws/hws_v4l2_ioctl.c
index 0303e311ee4a8..ce396b7225d22 100644
--- a/drivers/media/pci/hws/hws_v4l2_ioctl.c
+++ b/drivers/media/pci/hws/hws_v4l2_ioctl.c
@@ -511,8 +511,9 @@ static inline void hws_set_colorimetry_state(struct hws_pix_state *p)
 {
 	bool sd = p->height <= 576;
 
+	/* Captured samples use full-range BT.601 Y'CbCr at every resolution. */
 	p->colorspace   = sd ? V4L2_COLORSPACE_SMPTE170M : V4L2_COLORSPACE_REC709;
-	p->ycbcr_enc    = V4L2_YCBCR_ENC_DEFAULT;
+	p->ycbcr_enc    = V4L2_YCBCR_ENC_601;
 	p->quantization = V4L2_QUANTIZATION_FULL_RANGE;
 	p->xfer_func    = V4L2_XFER_FUNC_DEFAULT;
 }
@@ -736,7 +737,7 @@ static inline void hws_set_colorimetry_fmt(struct v4l2_pix_format *p)
 	bool sd = p->height <= 576;
 
 	p->colorspace   = sd ? V4L2_COLORSPACE_SMPTE170M : V4L2_COLORSPACE_REC709;
-	p->ycbcr_enc    = V4L2_YCBCR_ENC_DEFAULT;
+	p->ycbcr_enc    = V4L2_YCBCR_ENC_601;
 	p->quantization = V4L2_QUANTIZATION_FULL_RANGE;
 	p->xfer_func    = V4L2_XFER_FUNC_DEFAULT;
 }
diff --git a/drivers/media/pci/hws/hws_video.c b/drivers/media/pci/hws/hws_video.c
index 18e4bc6901d30..09cfb5a909f9c 100644
--- a/drivers/media/pci/hws/hws_video.c
+++ b/drivers/media/pci/hws/hws_video.c
@@ -327,7 +327,7 @@ int hws_video_init_channel(struct hws_pcie_dev *pdev, int ch)
 	vid->pix.sizeimage = vid->pix.bytesperline * vid->pix.height;
 	vid->pix.field = V4L2_FIELD_NONE;
 	vid->pix.colorspace = V4L2_COLORSPACE_REC709;
-	vid->pix.ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+	vid->pix.ycbcr_enc = V4L2_YCBCR_ENC_601;
 	vid->pix.quantization = V4L2_QUANTIZATION_FULL_RANGE;
 	vid->pix.xfer_func = V4L2_XFER_FUNC_DEFAULT;
 	vid->pix.interlaced = false;
@@ -895,6 +895,8 @@ static void hws_video_apply_mode_change(struct hws_pcie_dev *pdx,
 	v->pix.width = w;
 	v->pix.height = h;
 	v->pix.interlaced = interlaced;
+	v->pix.colorspace = h <= 576 ? V4L2_COLORSPACE_SMPTE170M :
+					 V4L2_COLORSPACE_REC709;
 	hws_set_current_dv_timings(v, w, h, interlaced);
 	v->current_fps = fps;
 
-- 
2.53.0



