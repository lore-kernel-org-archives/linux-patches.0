Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052469;
	b=3SS2UQhgaCaBUTnbHt2HNB7ajH9XUbwmtJj+WjsQfbrj9TtLcwcE4cLXsAFs1IJq4xqq
	 2DGQxU2Kc5Vj6i9+Q5dV35h+V1uNJnRYRH5xKUaCaLwZIZLIoGkMXeWtB2QynR2+gW512
	 S3U33Pd1OnU5f0Cxk9qNM4o0gsJy/JjOS+XSzKx0ObZOFkA4ZcYLe79MDtcVI0ORaxeDa
	 nT3ySLuvHegisCNSoA/UQSB/xyvt20MxqhkqIbaFeCwzw3FjiHN4Ts3LVNZr2YzoQpBAi
	 Cjgxn8uDEq705B9ik9Gfch5M+Gw2H5WxndBjnndDGUP4kFHPWfuie7H+x1GYYgh64Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XmsguiUP+VUdD7uMo1PmEe8Bwhgon1JGxc/P4de0ho0=;
	b=OKEvUqvOAr+3dGuQW9G3WdAhLd3fL4RYGbqYxnHotefyuDMU8tmsFiHORS/ByBDl6jcR
	 6WIvpJjJpasG6Z/6HxpXjJU+Bd0Yqj2jlOdXIBHJ7DYCl0pxfZ6YD6dG94DW/TUZrL90S
	 k9aYaIBb86+jmMEF60gSH613+HPPoNtN4sw8fxbrjlge5RO3tbT4uGdNCxC0wgDACC11f
	 B8ZAtUFNY1id6PMnoz4cDzdQAGmdft3sNisG+hHXf7bG/R4oPMPqtYkTeE3tPeUd3lGyJ
	 8ICz59a3VTLN4OjVlgzHRpogDfTTivrQp5USn3sB1k2xbD+D7B1LHy/AAK4y+wr15fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wN0jE3er;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1035606A320;
	Thu, 19 Nov 2026 01:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wN0jE3er
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC40D1F000C4;
	Thu, 19 Nov 2026 01:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052469;
	bh=XmsguiUP+VUdD7uMo1PmEe8Bwhgon1JGxc/P4de0ho0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wN0jE3erlbfwWxKe2OkjqYT7b/sb0MsBhMCT0S19R7VqNrqFhoZtG6veyJGAuKU0L
	 kkH8lw6zswN0OyofF+uSkykkkTqKyvpJouOuSR0e+4XDhinSVw0QrsIE5ig/qRPdVE
	 GGTbxsddJ09Z2uC27UrUZHMjYcX39kjsvXU57zWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0572/2214] media: vicodec: fix NULL deref on oversized frame
Date: Wed, 18 Nov 2026 15:37:28 +0100
Message-ID: <20261118150033.842741154@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit c657eb609197e289b054bc2c4e86a0fc32dd7ebe ]

job_ready() only honours the is_header_valid() verdict when
ctx->comp_has_frame is set, and comp_has_frame is only set once
comp_size reaches the full frame size. Since the copy is clamped to
ctx->comp_max_size, a header advertising a larger size leaves comp_size
stuck at comp_max_size, so comp_has_frame stays false and the failed
validation is discarded.

Control then falls into the resolution change branch, which calls
update_capture_data_from_header(). That function re-derives info via
info_from_header(), assigns it to q_dst->info and dereferences it as
q_dst->info->sizeimage_mult, with no NULL check of its own.
is_header_valid() does check that same info_from_header() result --
if (!info) return false which is precisely the false verdict
job_ready() discarded above. info_from_header() returns NULL whenever the
header flags resolve to no supported pixel format.

Drop the comp_has_frame conjunct so an invalid header always bails out.
The resolution change path is unaffected, as it is entered with a valid
header. Oversized frames are then rejected by device_process(), which
already returns -EINVAL when comp_frame_size exceeds comp_max_size.

Fixes: 3b15f68e19c2 ("media: vicodec: Add support for resolution change event.")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vicodec/vicodec-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/test-drivers/vicodec/vicodec-core.c b/drivers/media/test-drivers/vicodec/vicodec-core.c
index 3ffd57053d110..90455a189863d 100644
--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -654,7 +654,7 @@ static int job_ready(void *priv)
 	 * if the header is invalid the device_run will just drop the frame
 	 * with an error
 	 */
-	if (!is_header_valid(&ctx->state.header) && ctx->comp_has_frame)
+	if (!is_header_valid(&ctx->state.header))
 		return 1;
 	flags = ntohl(ctx->state.header.flags);
 	hdr_width_div = (flags & V4L2_FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
-- 
2.53.0



