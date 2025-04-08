Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5ED2A94A;
	Tue,  8 Apr 2025 11:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113121; cv=none; b=GWZhdOX13Qc8LcgroiyazekZAu3Y0LgQ6nXBuUujvp+5fxh2VT2Z9dGCbRUzuu6AdndkTv2sPU6m0oxjs3MwAZVlNaLGgm62SzlPLEnLdyoRmUooveIuHc+qKNdKltSRqNsY4ioGsKek6UD+IBohQBjMfKaaFyJF2bdA69lTbuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113121; c=relaxed/simple;
	bh=zNM2MYYF86yrlPO02v4HuWdh0f+06DlMVOY2e/aXwSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwo+boPSyyDf2Pdl7n3p0ertVCKOpKlqP6n+RF1FzY/UH5W953IwDZoRUYOnIPg8ZGO+1vFS+2t4Er0MUG3NNfStXZQriTxcQMV1JvyMSbEI7tVJXQZtgq4aUNkhBJ63izoYULEg0+4SkDbTk9oTmn36K+/JbPh2L2IVQBYi9+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDehPF8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDehPF8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7643BC4CEE5;
	Tue,  8 Apr 2025 11:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113120;
	bh=zNM2MYYF86yrlPO02v4HuWdh0f+06DlMVOY2e/aXwSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDehPF8pEAFFJ4Qx/loz6P4rySXRDgjiDZdv4gqcoE3IC/VVDsooLBLm2qkSY/zBa
	 V7tQkh2AFrLLvI56CIoY+Y3bkAToOJZ1qRC9Lbs71wtQaMaJeAWk8olCLvXLZ5F2nB
	 VpEqZSdZ/T8WI5jnJbTxyhz3GHxMZXFC/V8nTmM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/268] media: verisilicon: HEVC: Initialize start_bit field
Date: Tue,  8 Apr 2025 12:47:15 +0200
Message-ID: <20250408104829.160227846@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



