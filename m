Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036251;
	b=Kjo6BJ7kUZ4VaScTLTmxbDP+HzH2Br5nkPi5MPV8ikf6KllmZ0IZbeIGha69W0ieV5XX
	 1enPGqo1Hf9mOT0arEEfqs/MmCpMxmWJK3ZtXweQDucoIcNzeVsUeY1rFbahtS4aellPB
	 r27ogKZ1tayER0ltj8xSbQ0exQkuvPM1QyQPLFvi1M9Vd4LwERlRtw538RrTAYttBGBXG
	 LSz5YbqP9FzRUxTdz5gil5neNKSlL9UYCVBd/C7n+/wst7lKtZRIOTOp5XfRVwmiR49nA
	 liUVHiqQYKttsyGBUEzPohwctlRexCqZ5VFs/UkZOuoy0ABAH+IxfsgCKhdR3pHvGlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LM7WvsbS5vRJxRJXIIgBwlZZeGvReYlYfspIanf9aoM=;
	b=4jo2x0aE1M0jZA4zwGSDqW2nRZ9fpyxhBDoOwFOA9E+aFHnPAqwcgtK+f4AE8GBJNzS6
	 FEKQcdxqXe8kiFLtAAxdH6Hv3T8f9xeifiEL7Zr/mjbTaTaBHAAgZFqKtlIYCOaCGl9XI
	 GkWf8mWz5yq3ew81beIvWHYnpXDU4FXoA6grHKBqGcYjhAzYCqgqhgx0b+X4MzAYHJ5mC
	 QW4HXqWTHNsJDqZS2K334clZ0BoJBG6gXeuqC9BV6mew4Qu24QkTpvA/aA2InZCM50k1g
	 wmdQOePznFfTT9QYpDVGyJFZFb07AwiLvh6u+OWqiTLsNTBcXuwwhtcig+cD6UobY9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H9jDw1oU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8AC606A332;
	Wed, 18 Nov 2026 21:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H9jDw1oU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14711F000C5;
	Wed, 18 Nov 2026 21:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036251;
	bh=LM7WvsbS5vRJxRJXIIgBwlZZeGvReYlYfspIanf9aoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9jDw1oUXMNHzKI5OFTc6mLEedmzUB/SbDeMDUcdlbCkwCw94MbMkNUS2XF9UgwH5
	 bKVRhzhbaeWsBkoTj0JnRT06tysK3QWieofOwI0QeFemuAN2QCVGOSgHpWflskK+MY
	 v18BFyN/C0eXnk8aXvoJ5uV+nm7ZbjejtGuizh2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0993/3318] media: v4l2-common: Fix P010 format info
Date: Wed, 18 Nov 2026 15:26:55 +0100
Message-ID: <20261118150349.614724948@linuxfoundation.org>
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
index da6dc7e737ef1..e672b904a7c4a 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -275,7 +275,7 @@ const struct v4l2_format_info *v4l2_format_info(u32 format)
 		{ .format = V4L2_PIX_FMT_NV61,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 2, .vdiv = 1 },
 		{ .format = V4L2_PIX_FMT_NV24,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 1, .vdiv = 1 },
 		{ .format = V4L2_PIX_FMT_NV42,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 1, .vdiv = 1 },
-		{ .format = V4L2_PIX_FMT_P010,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 2, 2, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 2, .vdiv = 1 },
+		{ .format = V4L2_PIX_FMT_P010,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 2, 4, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 2, .vdiv = 2 },
 		{ .format = V4L2_PIX_FMT_P012,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 2, .bpp = { 2, 4, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 2, .vdiv = 2 },
 
 		{ .format = V4L2_PIX_FMT_YUV410,  .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 3, .bpp = { 1, 1, 1, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 4, .vdiv = 4 },
-- 
2.53.0



