Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062180;
	b=P69WxTkW7G4O7EGd71I9hQUPymyCFPltAU1iS5uiwtD1njKhEpC0mZC6pCZRngABFWrv
	 FAu8LNHE+5PpJoKDzb089rx/8D5nlN/nu0v6qLngbDDfu6TJ1b5S9DVyDJvh4MRFOvz/y
	 WS5tEbew+LO+wUF5Lbr5opHJUnS8M6/awmhyV1UhOXyxd2qx7+QmUue54XASSE8eRcW6y
	 ylpFu305fPJNO+P09wHa4sAq2z6ZTK57Z7iZFmbkEiZbk6PIo8DPth/Y2hv/AvEGTyhoQ
	 DU/NICW6kDc+H8pGIWHcqytU7//nVNQGao5VYlh0EIHXr02rAMlRl1BHGg6dmB/hhag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xxSO1EgEDz2KdDR0rROE7kd1CR0cWosTWSMjKtK9OkA=;
	b=NA6cpHiVeewJ/VHbuTMyJrd6ZqWszj8MIpU6Xffls6RnuIKwlQDStZgjLE1L7IvmMYF5
	 hta3EimehrVgVap7xinpoWrDzjGYLpfXxFxY9vOdIfEqee4vxaijPxRgIrzmYPLb1sddg
	 hEJCjesVWVdRW0kVS/EDNbqSBlljM4Kl7bsMJvaA27aRSWjLAgV2R02uSDx5+ZYvCwBxu
	 35ECpxbGICsCumHvuGTA3aWb5At3q2N+I7JUvo47HodsDg4H6PMlWVV+QlUFsHDS38QkP
	 FYysFDB1hVOYZxHxcrEPDefZtbKWdIU3HVsyv01XznIl9tPR1tJ2GHX5Vq191gdb5FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lZn5g02u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8F3606A326;
	Sat,  7 Nov 2026 14:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lZn5g02u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D031F008A2;
	Sat,  7 Nov 2026 14:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062179;
	bh=xxSO1EgEDz2KdDR0rROE7kd1CR0cWosTWSMjKtK9OkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lZn5g02uw0y5L9ywusozWJolM6ogMn3LTaq4d+RjhivHWshxf7kCsCjl83F5YUEFf
	 2JLZxMgryGk+QkFnQKg4Kssuyq9phD3dKNZxKIVuJa6jUVZq+O1zgiEtMKzNn/2pAw
	 njwebowNgeydoePYR0A+t3+27l3Z1+mVbfHyt9sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1139/1536] media: v4l2-common: Fix P010 format info
Date: Sat,  7 Nov 2026 08:52:35 -0500
Message-ID: <20261107135029.705393067@linuxfoundation.org>
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
index 143ca5284b79a..ce2bf5d83614b 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -282,7 +282,7 @@ const struct v4l2_format_info *v4l2_format_info(u32 format)
 		{ .format = V4L2_PIX_FMT_NV61,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 2, .vdiv = 1 },
 		{ .format = V4L2_PIX_FMT_NV24,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 1, .vdiv = 1 },
 		{ .format = V4L2_PIX_FMT_NV42,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 1, .vdiv = 1 },
-		{ .format = V4L2_PIX_FMT_P010,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 2, 2, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 2, .vdiv = 1 },
+		{ .format = V4L2_PIX_FMT_P010,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 2, 4, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 2, .vdiv = 2 },
 		{ .format = V4L2_PIX_FMT_P012,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 2, 4, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 2, .vdiv = 2 },
 
 		{ .format = V4L2_PIX_FMT_YUV410,  .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 3, .bpp = { 1, 1, 1, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 4, .vdiv = 4 },
-- 
2.53.0



