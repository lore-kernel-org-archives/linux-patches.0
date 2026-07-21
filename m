Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EBD42F704;
	Tue, 21 Jul 2026 20:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665643; cv=none; b=jFRltelaJ/3T/Xg0tjRuCkQbZU5wHj9BXzkIRfZKUZlrDhb1q3rHxIu5JnYREO7/mXS8gNfRpNqfyywxLL1kG0fPlp+4YNMW6rwymHI2BSX40vUe9BLT07B/kYDVNPA3lAGIffYhCQOV3KtuyUcmMv0UVlEnb27o1kcB8mg8f1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665643; c=relaxed/simple;
	bh=imY8L5c8c8v03y39UMj+AtzYY217YceVrt5z85XWEng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLjaVci7nCzTOcP9/XlsqkKtPaNXG5Emzy59C0hWEB3ljcQofAQlcwjqQdxDLx/jlIfbQhOHtD2KuMfhtf+8u9pbxNZZpB/8URyO8cJwYCXXeYTyqZXTelmUDHU1H+o/l1UhlqovhPYiQAtTOK3soA5yeXdLjAvZIJnjv7MQVA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6iFFDRK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6iFFDRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6876B1F000E9;
	Tue, 21 Jul 2026 20:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665641;
	bh=HidYJR4ozWZ+tNG+kiRuJnmGncgSyOqudqsIXnk8LKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g6iFFDRKBmNyc+aM4RWpS7LyAzD0iO1442uy33BHBUkixa2N+aDRhdF6EESqWKlrc
	 WKJbzxxr/teGsMEV89U5dLFEnWkoH9cbZaz+9588djeW0Wh1HaaTlu4VZ5UpXoUU2j
	 eZvsniBDa8kpEQAf/pli6kWvlndPz4yRu8F2RTNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0382/1266] media: v4l2-common: Add YUV24 format info
Date: Tue, 21 Jul 2026 17:13:39 +0200
Message-ID: <20260721152450.373147687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nas Chung <nas.chung@chipsnmedia.com>

[ Upstream commit 968b741872914a15363af0daf24ed2e82ec355f3 ]

The YUV24 format is missing an entry in the v4l2_format_info().
The YUV24 format is the packed YUV 4:4:4 formats with 8 bits
per component.

Fixes: 0376a51fbe5e ("media: v4l: Add packed YUV444 24bpp pixel format")
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index b37507e093399c..da6dc7e737ef17 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -262,6 +262,7 @@ const struct v4l2_format_info *v4l2_format_info(u32 format)
 		{ .format = V4L2_PIX_FMT_VYUY,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 1, .bpp = { 2, 0, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 2, .vdiv = 1 },
 		{ .format = V4L2_PIX_FMT_Y212,    .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 1, .bpp = { 4, 0, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 2, .vdiv = 1 },
 		{ .format = V4L2_PIX_FMT_YUV48_12, .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 1, .bpp = { 6, 0, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 1, .vdiv = 1 },
+		{ .format = V4L2_PIX_FMT_YUV24,   .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 1, .comp_planes = 1, .bpp = { 3, 0, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 1, .vdiv = 1 },
 		{ .format = V4L2_PIX_FMT_MT2110T, .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 2, .comp_planes = 2, .bpp = { 5, 10, 0, 0 }, .bpp_div = { 4, 4, 1, 1 }, .hdiv = 2, .vdiv = 2,
 		  .block_w = { 16, 8, 0, 0 }, .block_h = { 32, 16, 0, 0 }},
 		{ .format = V4L2_PIX_FMT_MT2110R, .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 2, .comp_planes = 2, .bpp = { 5, 10, 0, 0 }, .bpp_div = { 4, 4, 1, 1 }, .hdiv = 2, .vdiv = 2,
-- 
2.53.0



