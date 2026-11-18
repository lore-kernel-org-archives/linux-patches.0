Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045281;
	b=TWm9+f96s+C0woQBbJ/fXin6dWWBaKFExWmRq4vryyVcz2KfmBZv5Z4exTqLpAAaBDdU
	 D2SilDnej52QnXZiN3UpYjOwsfCesZjUftbmtH3jT+VzPg/maY6DUYqSD282bbnutRQLi
	 F0tWDH8WeL9kUeqBngH0vaRQJ6+ZJhUCWtY7XXvzwrA5CO3Z9vs29KtU1sgh2B1wKTCBE
	 rbRIj4RI1H7nVfnIcD35xAo7hKavMwl9j4rY7NW8/w/XI7FSdhTgrsbVwbdsRVn/uEPMY
	 Q4KSQ2kypYY3uu7pFX8mtXnioup1eNMLFJEybWflP/yz5SVHXGOlaL4uWmSHwDzJ9hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j0bWYZka9s9BiOzAKOgvBrblAO8bAtFItACyjri1s/c=;
	b=m48cvKuNP2z6nYVzPt8JKD3qGZDihkll5mLej288BgFI0j72Au/q2T8Tzthmu8n2XafK
	 UOoAKsYeBjCTr3k8X4UujzBTnFJW7rVZWANoQORTLtF9HAZJBya7YsKmjpzL7pTbWUacp
	 xkD112dZ4OFFZFQbbLBJGANDv0PONu3RefRJM6euCSM6VeDbZju/rywIrDwiU2MXQXYku
	 AfQtEZq0eeT+lKVQKy7jcZY3U4GZyHhqsmV72vh+6eW6lssN3sIHXvjn6/0uGcdZ+N7K4
	 bHUEx1hlrnr8u5u1j3kS+jpRu/+4ToEDNDrEBBb3n9o2dezsryrn6a0mB7vJoV2sCrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q6fYbGA4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEA9606A320;
	Wed, 18 Nov 2026 23:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q6fYbGA4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CA21F000C4;
	Wed, 18 Nov 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045280;
	bh=j0bWYZka9s9BiOzAKOgvBrblAO8bAtFItACyjri1s/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q6fYbGA4KPTqJlqKHC6yK/Mee9STgzRHR39oYU2/XEfsEuqv4KRW2bWWDIrOhw72I
	 D53I8L8EQac6WagfZP/3GZlOhNv3ospsjX2ttHRcGjyeyLPSgRLlnIwHu7IvlRmlSx
	 l7t4DuFDM1bwK2PL/Ze0xvuq8KlYO6vVQ//i1KWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Freidkin <freidkin@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0866/2857] media: meson: vdec: size capture planes from the aligned canvas
Date: Wed, 18 Nov 2026 15:31:40 +0100
Message-ID: <20261118150232.743362799@linuxfoundation.org>
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
index 5ea218c1ae682..a280676205fcc 100644
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



