Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046705;
	b=BEcovWF8x51gUmkJSXL/EPILNki5LOZvq4QUrgYdx+j3ugGBdZz8kJsybgAy066Lg3uI
	 3YasX534buhrlY8D1lxLm+j73YqmP979p0ZSj6uyYz672p71kZZq+/XPYnJj/C/BR4hG6
	 oV23RRDQcaQsEhqWSvCa+KCvAkvipd6nMU3pptdiJ7SvhHe5XJL30QP/cz//uM0j8swAp
	 5/fx2NxFRwL2Fg9IP+aJBiar5j6PGNJGLEru2mLITALEDHxHWOpl3wZbOUrLFYN9HvarI
	 ixZhnuQJNTsJxYFHlDEObxLnitKptktxDLXReLtWfslZ4T74Qqhjp5tp3/tT37yO3yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ag5a2FgdMSbb0i5RU6tFJ6XuVtG6mdfmhTBvQimsrAc=;
	b=nZwZsAD1RkkAGbF9Hy5muE0jI/6fqB1xHPG2wLUg7MjPuJw/7HhYfwn3i3MpQ39ypoUf
	 oTDN2rpPOrNWVmKzHFimm5XFvOiN8792rLb2R5eyqAM0YjQ5+DWc98F+mKJO1grZHlEw4
	 S4QgG4bH3yVCc+Y2WD9vLdYQvRtGZ7zF92BCZ8XOvFAp192VPFMWavOBsmbWf4CNbur1E
	 SccKWOnJ9yuf28Ur4Pe5PuPoEPI8HkyIPXwnLMnnRO3/gGS/3vsffTsc27fi+XaK+yKXD
	 YXEmW9VkJCkhI+Sk5F3VwdYqVh2F+SsfQF6oM+K0jZfk+RxBGi2VRKMQF2bE8mSWfjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gSYgyz9L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC424606A320;
	Thu, 19 Nov 2026 00:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gSYgyz9L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC2B1F000C4;
	Thu, 19 Nov 2026 00:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046705;
	bh=Ag5a2FgdMSbb0i5RU6tFJ6XuVtG6mdfmhTBvQimsrAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gSYgyz9LqRmBFp/fV0tR9ymwXbAwgiZxdkrRWL7sjVGDgC8KKpUrll8SJ765Tl+zR
	 fsy7vg3HpORFDgA0OzahPZJZY0+C7Np3Bh128Gt88xHn21D4VtjW1ZVMQ2aAxL8fw+
	 2tpkPm5bj77DeXFCR/9YkOUD/tB81rcLJzWtfjww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1374/2857] media: v4l2-common: Fix P010 format info
Date: Wed, 18 Nov 2026 15:40:08 +0100
Message-ID: <20261118150250.855560256@linuxfoundation.org>
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

From: Nas Chung <nas.chung@chipsnmedia.com>

[ Upstream commit 8761a87aff8259eab0add8a9428cee2c280fb6eb ]

V4L2_PIX_FMT_P010 is a 10-bit 4:2:0 semi-planar format, but its
v4l2_format_info() entry described a 4:2:2 layout with a half-width
chroma plane. Correct bpp and vdiv to match P010's real layout,
consistent with the other semi-planar formats.

Cc: stable@vger.kernel.org
Fixes: 5374d8fb75f3 ("media: Add P010 video format")
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: Omitted the bpp_div initializer because the target format-info structure lacks that field. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 1c8d36684809d..4dd75dae2484f 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -266,7 +266,7 @@ const struct v4l2_format_info *v4l2_format_info(u32 format)
 		{ .format = V4L2_PIX_FMT_NV61,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 2, .vdiv = 1 },
 		{ .format = V4L2_PIX_FMT_NV24,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 1, .vdiv = 1 },
 		{ .format = V4L2_PIX_FMT_NV42,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 1, .vdiv = 1 },
-		{ .format = V4L2_PIX_FMT_P010,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 2, 2, 0, 0 }, .hdiv = 2, .vdiv = 1 },
+		{ .format = V4L2_PIX_FMT_P010,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 2, 4, 0, 0 }, .hdiv = 2, .vdiv = 2 },
 
 		{ .format = V4L2_PIX_FMT_YUV410,  .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 4, .vdiv = 4 },
 		{ .format = V4L2_PIX_FMT_YVU410,  .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 4, .vdiv = 4 },
-- 
2.53.0



