Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064372;
	b=B87Dp6L7F/F/KPmXRPiYLu3/Df6lhZzt6W23Pb7f5JACzVF5rf4/FC8IILnu+bnrlBO+
	 lapYpSDAkPl11rXzl3mgmmzn1PuQysrTyBpwclUzuthQRCeyZR9x7fnlQuS8VQpUOtIRk
	 0b0MMRVms1E4Eo+zgdWQulOXazf6KshWw13IihOYuPjvXYkHjLoVJr62SxjMgkquwMZZT
	 F8xgXasUqcMtCCEfCygXtwdIL4fBWYkbdshE4NV4VB99zbAaWCkdFV7RjD9rPkEBT9l1y
	 iizF6Soua3mTJcfykA3k6eNU5KN8OhjkxYIWGEcGJu0MTmkNOUhv2K6x15EgrY5jciQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=odA/nzmKZeS25Gn8HhTd3l1ldzV1FTD4L0o0nqBumAU=;
	b=CJXnvvvbsJW777YdWR5gBktiBz4cxT3IcMpiuu4v2Tfp1J3EbBdE8QyylmBFIB6O0GMe
	 0S4/V/CHslEPOG+968RAuzjZJAnbA6mphszw14GK1WjBjVB/ocNtKIGWxehjRjfmEvX9j
	 de1dOawy/xJhAD9QtOHrvm8eFjp62I/ScLq6nsLjXTmfG+C3Ay3NNbWSNSEekvNlCMvw5
	 smC+mvBA/HWKoMYJe1Hq6XQSg6Yu1+ax229A70EscTFoF8v2VwJ3p84qVawgZ2m6TmjQf
	 8FMamaOV89HiCx75O6yglClWfwih7gtRrZYgjVNOdxkBcfpaV5aHmvvmYMbEH0bCQPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JL3M52pO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A29F606B8B8;
	Sat,  7 Nov 2026 15:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JL3M52pO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AC71F008A2;
	Sat,  7 Nov 2026 15:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064372;
	bh=odA/nzmKZeS25Gn8HhTd3l1ldzV1FTD4L0o0nqBumAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JL3M52pO2TpwzrdLM4DShVDti+vmz7Rxd2q58FBqkc95aYoStYMoClIIOOz0yDD0A
	 G6l+ezZ5QKHz5wspJbBgdFDPWHgO+YntOn+WJzZ9g+8uD/0TbGd+4IEry0AB8J+urv
	 NgmNOiTuMXFtImE6rPd0dcwgWiHw/s2bKeHoUkL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Freidkin <freidkin@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0451/1257] media: meson: vdec: size capture planes from the aligned canvas
Date: Sat,  7 Nov 2026 08:45:47 -0500
Message-ID: <20261107134951.933704786@linuxfoundation.org>
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
index c18bf352b1996..be29d5a11c2e6 100644
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



