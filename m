Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B8F269802;
	Tue,  8 Apr 2025 12:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116154; cv=none; b=BSRmTAAS5LUE106V96ovOu5LTsN09RhjXkI+AU6qbDqKPFbjpCyOi/uAKT+U5zkr8M98+sYGpiINPsx2sYs3jLieu9jzHOdOl89CByWek+Ahu6ets7Ku/ypzAZtvQj+b0xYzDIBbU8CkODihVPiHKaGh/u/ilo2TRZnJX8cUCsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116154; c=relaxed/simple;
	bh=iPW/C6L6IQi7Px1JyAAaFVrHXCVU+a307uXCSAnfeS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efPM9g2hJnYvjBcFr7M4XLuO0BUdVYTs+4I8DkTQbZ5Vfa/R5O+K4qjsNFtIBGIxCv3vwwIrXGZOEk/U4bTLDR6++OySRQigOZSMrG2pCoH/hAd0OF3KKSqUMfqdEfeud4cTeRvJM97TEazPGz3SQe68Ttab7XCVyLExUHINVI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8DnW/t5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8DnW/t5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76359C4CEE5;
	Tue,  8 Apr 2025 12:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116153;
	bh=iPW/C6L6IQi7Px1JyAAaFVrHXCVU+a307uXCSAnfeS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8DnW/t5FNI8mDTWOfHE/zmucxYSMzmZZeC2C15LAP0Pzi2Ty60aF2+bxT4Gj0UKg
	 XJLkoGbmOgNRhmG62yy74k89+ey7BekcAlK8F6KZP9JyTmaXncZ8xL0IOvtju8TnOm
	 KAxs+R2W4L4ub2+R1iPuoHf5U0nuRNqVcFHsYHso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/423] media: verisilicon: HEVC: Initialize start_bit field
Date: Tue,  8 Apr 2025 12:46:00 +0200
Message-ID: <20250408104846.540600117@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 85a44143b3786..0e212198dd65b 100644
--- a/drivers/media/platform/verisilicon/hantro_g2_hevc_dec.c
+++ b/drivers/media/platform/verisilicon/hantro_g2_hevc_dec.c
@@ -518,6 +518,7 @@ static void set_buffers(struct hantro_ctx *ctx)
 	hantro_reg_write(vpu, &g2_stream_len, src_len);
 	hantro_reg_write(vpu, &g2_strm_buffer_len, src_buf_len);
 	hantro_reg_write(vpu, &g2_strm_start_offset, 0);
+	hantro_reg_write(vpu, &g2_start_bit, 0);
 	hantro_reg_write(vpu, &g2_write_mvs_e, 1);
 
 	hantro_write_addr(vpu, G2_TILE_SIZES_ADDR, ctx->hevc_dec.tile_sizes.dma);
-- 
2.39.5



