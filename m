Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063113;
	b=v3vR6L8yhWoPTug88gr26r2aUesI6lM8LWCZDeL9I338O8qAjzu2V0iSNWfGe6XWT9JM
	 HYQ+yVvpbN2oKGQo6DB8u8CBq8Jxyn1Qtuo+hUJSVar/ByON+wDcV+9GRcf6m5I3P8Vyg
	 HzKURQkaMUkyulWSRAovOcrbB+DQk1xeltbbg0SM+O3RdNtXCJ45o5iumAy7DrlNM3C8s
	 lFoAl7MwJ/+4kIDRaJnlkVERhyzrX7fuknROc25td08j5fzTTFdOrtU511U9WyqkROkiH
	 ZptB95NqM2vV0Max7f3mTJcqw7NA1k7dIVkMSwlHrwHDHLIN15D8xAl842wkeyHJXrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b4jFoJqHFExEwkpkDc6ubz4MQsxIIYe9MzCIF+DhKLo=;
	b=NufW7Dnr/9H0oHiWIYUtnPdkd+FcNkxOKQjRgrr3iqlWxVxDO9OGzWOagSMjHKyE5mna
	 FyFN6ydfhRcB4Yzxbc+PLK66PsnykmQ820w2YtTh2fOIQ2MAFrj/073bCsaXRZNikscbv
	 oPzgYIUPIW1Pl73yDbXpIct27yWzmSrK2cmNSvJ2/M36TbXBFsbvAG0W89h7UDgOarcr0
	 oCu3NRXQtACr4FbfGcnYHf7LbVXvLIl3Qz2c+xXmlW30iZ+HkyW5Qwp6UK69pHi50Q6P3
	 OVfyKSwcDez8hzNfKZyoo+h1KgpX39ma9Qb3XRHgovz01fIq0p3854IEW17toRCcAFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="p//DJsMX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7DC606A33B;
	Sat,  7 Nov 2026 14:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p//DJsMX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD5F1F0089F;
	Sat,  7 Nov 2026 14:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063112;
	bh=b4jFoJqHFExEwkpkDc6ubz4MQsxIIYe9MzCIF+DhKLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p//DJsMXRf0MCfv0pZZQFiZ6RGQo11HjLlBHqWhQ4OrJPKWcnaOVe2/vj7sfvWal7
	 JwSDhO8Wlw1VtwQ4Ch2J2uK0hPxgc/Xo+lTkw8IBY71CyZQAQPVRWeLs18Jk8jhzKV
	 5maNx9oTAoZ16erovs/+jQoSe3KW9pCZYbOKqUdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Freidkin <freidkin@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 344/869] media: meson: vdec: size capture planes from the aligned canvas
Date: Sat,  7 Nov 2026 08:50:26 -0500
Message-ID: <20261107134904.040229761@linuxfoundation.org>
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
index ccb71de22b0a9..49df5c6398b5c 100644
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



