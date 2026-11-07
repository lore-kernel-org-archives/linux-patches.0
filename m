Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062183;
	b=Q2/SVXoEpEL2LVjUmQK4tI7ONODAefDtxFul+Nu3gwo8X93cOHInRnSZWOhqjxgZAOm4
	 MhMIy7A0B9J1Qrd1hQAcwEuV2UlcXOpL5O6yTqsg4X3MQSX/N6gmjGEDgPjsr3elZjaN0
	 0rcBHqiWIvmIt6sUCLJCO4+Ll/qIrLVG+KP+N4v44V2dI3U6yTUYs3RhUXDvFJrOQOzBj
	 XwQz+dGOi1Ukfb3Fgn2k17G3uT7WbadPCnkfFVuxayfRbHpiZMwU8foGQU8hJ/lla+mfB
	 nhnFQEpGRcURlvgm0oomKzASEyZEuSf166c0R9KKWmYSt6KLKLvLA4jjs62yoL3LoRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L0tjN9oV5KhyKqDo90nGoj9zQgvyPsBOzM25UhquyM4=;
	b=xV94UC3FkjmXGrETudIpu4ap9AJ8lbbmI3YK0wJ2AJ4oBrDeWG+DdVGN0N7ZYjq7QJ7Q
	 brz9atshm9ZBHNaYGppGThjmY9BwZDY6LyAzIMIZnCqea3Y7nCNvOeZdZnVgK9lcpJWfM
	 DQnDMnZRR/7yMeJ/U0kAPudB0oEhL48beRKHdVuWjkt5C82RZT+Jc90gsvzqmWCOdTJqc
	 tXdAE+ezSUPH1v2q6eKvNYuE0oWSNsWNHbW1SLPVIKK96wnXaHvtBOkFMcotKToXdHmtr
	 TJZ6YN+J8ePcuFtl6oVc5aC4bu9Vl9eAF9t0/Ptt1095AfH1MxlE0JiGdPEqhVJOZmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WBbBpJN5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82685606A326;
	Sat,  7 Nov 2026 14:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WBbBpJN5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5891F0089F;
	Sat,  7 Nov 2026 14:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062183;
	bh=L0tjN9oV5KhyKqDo90nGoj9zQgvyPsBOzM25UhquyM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WBbBpJN5xFSOKYMmGmycp2sdWmlkmNrhsV36dXdwNysk1al7oqPvgJfpV5Z1lKjTk
	 4U5vbfgykJkLUp3XOG6AM8dynrhXOLnf9/Z0H79B7Mi5d7Z0onIM0hsL59prA6bK1P
	 9oAoVs1hPpVMVZmv4KtknQ77CkoG8V54RqLxEB9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Freidkin <freidkin@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1141/1536] media: meson: vdec: size capture planes from the aligned canvas
Date: Sat,  7 Nov 2026 08:52:37 -0500
Message-ID: <20261107135029.763549516@linuxfoundation.org>
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
index fffafc77c8b6c..b52b5221c4d19 100644
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



