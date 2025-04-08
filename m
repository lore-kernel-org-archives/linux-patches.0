Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3677A26A090;
	Tue,  8 Apr 2025 12:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115565; cv=none; b=QoWQMZYkLDJdqiE9Q7aVnGAubWKrcmvFiHrDdw/YdLYweljpurKYRlLz/wA2V5T7zRSc8crTlaVomb6Bhht5ZD37+9li0NiUQFFe6boGaJZu3FkVg/PutGnMQ9NWgQY7sSlIHGPM1A0PRgE1T3YFZnXFOuspR0jY7FfBlPv65og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115565; c=relaxed/simple;
	bh=iMdA1poTvw6SYRVBMjSJcGjhbCSp+Mc+kvaKCVdyLng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BR8RAOwoBaVr46eZIyfQksyiAhpgYqm9XaUBp4wGNkNRzIFzoDK6qSv2UDAAYCFg3nOb83Oav0Wmrx7ONDOho4P/arWopGLAS6QZCnVwROzYHcCb0rpOtypJ8U+xdy0oRHHpbUz4voZhyoXHbpFG+GBg1b3AnUxD0tb2+wTp+YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8ShThud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8ShThud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6F7C4CEE5;
	Tue,  8 Apr 2025 12:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115564;
	bh=iMdA1poTvw6SYRVBMjSJcGjhbCSp+Mc+kvaKCVdyLng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8ShThud3iX/CQt7RWuFxGal5jjutwTT/8K9jP8OTegmAKyMSoRaIyBbAE2mTu9Di
	 Ykj5jlHUBhb43Pr14YDa6kYpJ2H5kKW4oB8l+mPNE74/e03CoBpjZgAaWpwnsd7kUS
	 Hqj8GaDBj+O59DKt9EGLat9bFfQK6ckF9UyeQjyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/204] media: verisilicon: HEVC: Initialize start_bit field
Date: Tue,  8 Apr 2025 12:49:11 +0200
Message-ID: <20250408104820.941605476@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

[ Upstream commit 7fcb42b3835e90ef18d68555934cf72adaf58402 ]

The HEVC driver needs to set the start_bit field explicitly to avoid
causing corrupted frames when the VP9 decoder is used in parallel. The
reason for this problem is that the VP9 and the HEVC decoder share this
register.

Fixes: cb5dd5a0fa51 ("media: hantro: Introduce G2/HEVC decoder")
Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Tested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/verisilicon/hantro_g2_hevc_dec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/verisilicon/hantro_g2_hevc_dec.c b/drivers/media/platform/verisilicon/hantro_g2_hevc_dec.c
index a9d4ac84a8d8d..d1971af5f7fa6 100644
--- a/drivers/media/platform/verisilicon/hantro_g2_hevc_dec.c
+++ b/drivers/media/platform/verisilicon/hantro_g2_hevc_dec.c
@@ -517,6 +517,7 @@ static void set_buffers(struct hantro_ctx *ctx)
 	hantro_reg_write(vpu, &g2_stream_len, src_len);
 	hantro_reg_write(vpu, &g2_strm_buffer_len, src_buf_len);
 	hantro_reg_write(vpu, &g2_strm_start_offset, 0);
+	hantro_reg_write(vpu, &g2_start_bit, 0);
 	hantro_reg_write(vpu, &g2_write_mvs_e, 1);
 
 	hantro_write_addr(vpu, G2_TILE_SIZES_ADDR, ctx->hevc_dec.tile_sizes.dma);
-- 
2.39.5



