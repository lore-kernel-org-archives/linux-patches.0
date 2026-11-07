Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063107;
	b=wlzBFYvtlkz8HKkPlSDYq6nVLnXRwtdG/yJvCNUS9zuXxJjjge4DaNIfSIyl6HEny8yC
	 K42t4AJpl7+1tIccUU2HTSU1z7TkRmZSy1r2hMTbn4k6IiBDWUu/6xkw4qDq2voWwaOdz
	 EdMlmle3TdtVlU1f0xdeMxrQF7u85Fq+TgrOXiWBbF9qtR98vXRVnYAW8fv7gvtEh1v2K
	 1lLVTovtnapMQlcHLU0m4uUSXic/JC3IDeuC3zQyUWF7EF1hITOMXTGSL6tu9PkYRPMr5
	 /aCJItAvKjSrS5d0mc9/JxxrI5F4mHSEMIM92IJVg5c2++FTkny7sOZ2uTEpCemdHvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D4NV2anmyJzzJQvtGW4Q0GOFBdJ5O6vkbVoQRvhqFAg=;
	b=qoYmw86IAk6dn9lJp/djnWPTlgsG0ouMO8VYpraeOJS1AIB/UDXW/4LYsFoRHhyz67de
	 jLgCSQml6cfdLq3gMGaJTBaNUWT/sBT1CsG1Q0gfen2QxDZBfOEtzAGCbzC2pNwipohb3
	 F/8V6tubYTpqQmbVIS8pCPaf9/lWol/lGWYZbsyaw/oY3Vq7Xk1PVc2nvJBpukfAedFGT
	 rhvlQtzhDxRG5aaTbJAy5yagUN0dr+g1ubWm6ILtlS+++atPWiAppPyu+geYom/kynv5o
	 H4uebZbbvV06dJ72K1PFA7R1N5cuDtEgbyZjZ9+CzFeEw34K38RL3Amj3SU5E0jbJQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A1cxXv2Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4C6606EE8A;
	Sat,  7 Nov 2026 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A1cxXv2Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6251E1F008A1;
	Sat,  7 Nov 2026 14:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063106;
	bh=D4NV2anmyJzzJQvtGW4Q0GOFBdJ5O6vkbVoQRvhqFAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1cxXv2QNgLnDacY8ulo8d+VD/WIzPDMTpsjz7N32hRrOrLgHFRKUjsJGY4kH6KaD
	 3WuifrGXRSLQsJz/t7f3fxAg51G+5dpZbRDpcouCdIkv5ooCYaATUxsUIXcq3e1gST
	 s7bsmJ/Nf/dg8T14K9OPot6dy15tBDfVwhID8KNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 339/869] media: v4l2-common: Fix P010 format info
Date: Sat,  7 Nov 2026 08:50:21 -0500
Message-ID: <20261107134903.890792345@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 524c11e92aec5..0ca98df9e60b5 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -296,7 +296,7 @@ const struct v4l2_format_info *v4l2_format_info(u32 format)
 		{ .format = V4L2_PIX_FMT_NV20,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 5, 10, 0, 0 }, .bpp_div = { 4, 4, 1, 1 }, .hdiv = 2, .vdiv = 1 },
 		{ .format = V4L2_PIX_FMT_NV24,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 1, .vdiv = 1 },
 		{ .format = V4L2_PIX_FMT_NV42,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 1, .vdiv = 1 },
-		{ .format = V4L2_PIX_FMT_P010,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 2, 2, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 2, .vdiv = 1 },
+		{ .format = V4L2_PIX_FMT_P010,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 2, 4, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 2, .vdiv = 2 },
 		{ .format = V4L2_PIX_FMT_P012,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 2, 4, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 2, .vdiv = 2 },
 
 		{ .format = V4L2_PIX_FMT_YUV410,  .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 3, .bpp = { 1, 1, 1, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 4, .vdiv = 4 },
-- 
2.53.0



