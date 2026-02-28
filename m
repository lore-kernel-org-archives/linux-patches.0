Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A8147CC62;
	Sat, 28 Feb 2026 17:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301323; cv=none; b=rVu7pnaO7CSxFyoEc/ycncePCfHaWoQcbBjma2k8HNheHZWGlAgvNnWqKAdKvuITMLsfY3fKGmGZyjfhp2JvNg8QpCJAzATSNvn1xZvtoRsJamfETP0Wc/bOINpcfjDJ4W7fi25gmhl7xcyPAGRx3N+fmhYl1ELNY+hTsRDypmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301323; c=relaxed/simple;
	bh=IS53KTBMWo9ydqeW1BFesdWD63Lb5PcC6ZpjJOHuW68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uB5OcbSMBHPaytKLHnwBGprVrdDBtJ3nXCiVDuFaBc1BxoJnLVsNz3ffD6tAC1t7C0EQi/uelYxyi7csog4XQT5uBUefmRhBr3n/Jftgugo0Gumu9oOXW8CZGYQj5DOKgDEEH7mfY9XSy9e9OTMSgd/ZyHdTKcHRVF9NJp+Mgf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d3R9EbRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d3R9EbRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D197C19423;
	Sat, 28 Feb 2026 17:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301322;
	bh=IS53KTBMWo9ydqeW1BFesdWD63Lb5PcC6ZpjJOHuW68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3R9EbRrCdMjt+QhsqLB1GOqXEFbZTqFiIp3excH4ynEy+3ZchoNbQAZOc6XGdLjJ
	 +u+2ln+uA5gRy/u7Jizyoqjrqk73ccZOLTqazVHdbGffb1/P4CVNL7+y3atYbxnhZe
	 O3EZA4Ox31cUG5nYIgQ0BRPtSTPncfcwXvGR4ZX8ydoyi8hwXWWO6bF54wT0jjmv3S
	 3O+K1i3YnkhPrqqL63c/Okq7CntSMxloTZnE8uJS1yt+M3fo2argYLGeNqTpDmzuSu
	 fB698oGYfYnbQmMOt67vVnSwiRISjr06Wk7mu0eNzEHIm/CCyRxRfuZHC5x7n5srUR
	 H3NShPPdVhQcA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Jianfeng Liu <liujianfeng1994@gmail.com>,
	stable@vger.kernel.org,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 509/752] media: verisilicon: AV1: Set IDR flag for intra_only frame type
Date: Sat, 28 Feb 2026 12:43:40 -0500
Message-ID: <20260228174750.1542406-509-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

[ Upstream commit 1c1b79f40ee4444fa1ac96079751608b724c6b2b ]

Intra_only frame could be considered as a key frame so Instantaneous
Decoding Refresh (IDR) flag must be set of the both case and not only
for key frames.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Reported-by: Jianfeng Liu <liujianfeng1994@gmail.com>
Fixes: 727a400686a2c ("media: verisilicon: Add Rockchip AV1 decoder")
Cc: stable@vger.kernel.org
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c b/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c
index f52b8208e6b93..500e94bcb0293 100644
--- a/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c
+++ b/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c
@@ -2018,7 +2018,7 @@ static void rockchip_vpu981_av1_dec_set_parameters(struct hantro_ctx *ctx)
 			 !!(ctrls->frame->quantization.flags
 			    & V4L2_AV1_QUANTIZATION_FLAG_DELTA_Q_PRESENT));
 
-	hantro_reg_write(vpu, &av1_idr_pic_e, !ctrls->frame->frame_type);
+	hantro_reg_write(vpu, &av1_idr_pic_e, IS_INTRA(ctrls->frame->frame_type));
 	hantro_reg_write(vpu, &av1_quant_base_qindex, ctrls->frame->quantization.base_q_idx);
 	hantro_reg_write(vpu, &av1_bit_depth_y_minus8, ctx->bit_depth - 8);
 	hantro_reg_write(vpu, &av1_bit_depth_c_minus8, ctx->bit_depth - 8);
-- 
2.51.0

