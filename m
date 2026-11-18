Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052461;
	b=MxUxgZOFcB1E7EeQ1NB1S+2c9iHDRHno36DQPRKMoRTz4TdgbvmeaI5WHlr27BjpMueW
	 GeWY6PfszksKWe2D/ukul70AYFMbtfSyrwdc6aak8snKnb2MNjyJ7Zw1PJ5GpSKoG5VAo
	 2be6WX19/E4dWYLBs0Q34htQPkMoh1/fimVVTIqQIItzZjEFRuJlfIlYCv9DaFiCxTl9j
	 Rn2P9dPyu1pkBP5wsIvSU+Myx5O7wIyOA8SbnEiJ00S4c90/IfvZn37tBhfQqf32u0em+
	 cBgbBddayWrlNWmZrh85URC5xSsbohBsG5jpUN5L/4XHS3BSweESxC8fFCD5YMtqwIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d4KyjKsCabi44QAnrF8lNgEfY2j22tXvLkr6Cqknz+A=;
	b=WbIi3Au3Tu+xy0BQxnnhLITGq9h3rMo+bu7FD4ckA72fXi2BE4YHYX9M980kHmaA58lP
	 265jUmUx7BLYGntbmMVAzUUQmVrXzBtcDVBQm7oAWRGYNAJfs1tZbB1vKsnKLUj4YuDWO
	 oexsMJZ99wVJy7OccZmWGzoayEdbqZW4/Td1uKIh8s/WUv5Sa3NzDHW3umIvLHLdJyxSm
	 +s8petxwqR8w7rrOFBCTGwEAxdpM4EyKbFfW31ij42wpOUjWgoD7sjLjP33sTV2qyySj1
	 6AUgRiEKMGH0DktCIXMTt7RTvfxIDvKKG176KMPAl8jpj1Y/1/Ad6TfOTwMOGm5ZDvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hDyop/VI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21288606A320;
	Thu, 19 Nov 2026 01:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hDyop/VI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9001F000C4;
	Thu, 19 Nov 2026 01:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052461;
	bh=d4KyjKsCabi44QAnrF8lNgEfY2j22tXvLkr6Cqknz+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDyop/VINIHPIZGn8PGtRoEn1otooTozU0PTzLMAc0BVfXbEDySuEVwyhYIcQkxgg
	 NRjdZDpRBw2LrbIYb+CMN1DNOPAXNjRo4ChSZHmKFQcl4LCHK7OYGSiVh23SB65rfA
	 o7waBG+kwhSzvmO6u+wv9fBmhJ3dmLvlNAPXkyto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Freidkin <freidkin@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0570/2214] media: meson: vdec: size capture planes from the aligned canvas
Date: Wed, 18 Nov 2026 15:37:26 +0100
Message-ID: <20261118150033.767783585@linuxfoundation.org>
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

From: Michael Freidkin <freidkin@gmail.com>

[ Upstream commit b3a805dd5a83ba8c85e2085d3411eb9975e0aea4 ]

The decoder writes a whole canvas of ALIGN(width, 32) x ALIGN(height, 32)
(amvdec_set_canvases()) and reports bytesperline = ALIGN(width, 32), but
get_output_size() derives sizeimage from the raw width x height.

When the width is not a multiple of 32 the planes are too small for the
advertised stride: for 720x360 NV12M the luma plane is 262144 bytes while
736 * 360 = 264960 are needed (282624 for the canvas the firmware fills).
The decoder writes past the buffer, and importing the capture dma-buf
into DRM fails: drmModeAddFB2() returns -EINVAL, so e.g. Kodi plays the
sound over a black screen. 1280x720 and 1920x1080 are not affected.

Size the planes from the aligned canvas the hardware actually uses.

Tested on an S905X (GXL p212) board with LibreELEC 12 (6.16.0-rc3):
720x360 and 1920x1080 H.264 play through V4L2 m2m + DRM PRIME with no
AddFB2 errors.

Fixes: 3e7f51bd9607 ("media: meson: add v4l2 m2m video decoder driver")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Freidkin <freidkin@gmail.com>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/meson/vdec/vdec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/meson/vdec/vdec.c b/drivers/staging/media/meson/vdec/vdec.c
index 162a07d753150..a810f8152d774 100644
--- a/drivers/staging/media/meson/vdec/vdec.c
+++ b/drivers/staging/media/meson/vdec/vdec.c
@@ -34,7 +34,7 @@ struct dummy_buf {
 
 static u32 get_output_size(u32 width, u32 height)
 {
-	return ALIGN(width * height, SZ_64K);
+	return ALIGN(ALIGN(width, 32) * ALIGN(height, 32), SZ_64K);
 }
 
 u32 amvdec_get_output_size(struct amvdec_session *sess)
-- 
2.53.0



