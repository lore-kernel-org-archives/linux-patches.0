Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036254;
	b=e6hqDEF2PW8JtjDskKXz8iDFtNhQ3BQo0Lo5qa9rGde8U96OQFNzy5QqcxohDh91zCnu
	 HiaJ9sWjSZGgzdzvUdLtfY8zcZSY14EXDn5NZ33cUrhKrlCbcHlhmk0rPd9zHu/8QVvhF
	 AtX2i+oPqQDi+Kjpx1MQTT5n3G/D5Hdm9x28bQIXyT7DbB5BNZtuE3k0ikAiaBQvfAy3P
	 6/8XwEwcaYjg3Gg5mHdEA9rC3fubcJdI4ZVQrVsQfQuylPyfpkatMT8Qx16N6n1pW1Ffc
	 z39F9tVCCyb1jEVxKYTCy7iTqBy83BMQJoMTS4dz43KxfQKbtvaXDTZ48Qhgd1frSEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y/EcifH2+YiDT/ZJfJg0fkDlTMt9nEmlWDqzajvD9Vg=;
	b=fmI3s3h5c8xpRQgrGFN73aR/yPgePBOyBMDsk436cF1js5knb4j4XsoESV5TiUtJOSH1
	 LnpPn2kWzGhdrbOH6j/GFb1yuumGesIfIcEHn+6XnXNuC94EO7G1goCxVhr5J8BAE2iQM
	 XRK5fExIJYsHu8TaSQntZmU6IoST8T5WycFf39VEfs/6VkfCVpEygfwunMTdSqasf+1CN
	 2dYUgSaMPsyFhbhQJzKttJI76WHvHgxUtHrLqjqB/ARzqYjUPxC7iK4I0hSK4Da6Q3O3k
	 uH7v8Km6rhv4tEEqea8HwjGScgWKjvwPkFxo23ahU0jlq8nymEh+3eRaUS6+lOCCIsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pTJSQuYc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3D5606A32C;
	Wed, 18 Nov 2026 21:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pTJSQuYc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E781F000C4;
	Wed, 18 Nov 2026 21:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036254;
	bh=Y/EcifH2+YiDT/ZJfJg0fkDlTMt9nEmlWDqzajvD9Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pTJSQuYcgPPlHs8zDTbjsMT9AiDFG0eBnV0YnRn68bWfAg6028hk9bACOP9DSqvWO
	 wvtA30Yq8X3uRje+hTvacAJKwyhFI+j8lmc/HLBYrlParvC1KpR/Qtvz92pZvOoZvU
	 PdqrYEht07vwdNu1F3Lj+BDw+OXlvcYXaY+2egMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Freidkin <freidkin@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0994/3318] media: meson: vdec: size capture planes from the aligned canvas
Date: Wed, 18 Nov 2026 15:26:56 +0100
Message-ID: <20261118150349.648706995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6783f6e09a2a5..5dc949db42246 100644
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



