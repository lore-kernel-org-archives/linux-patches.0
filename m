Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDEE26B2B8;
	Tue,  8 Apr 2025 12:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114381; cv=none; b=uW/UWIGHuq010NmgbmnPjEvpjki7RuGFfSE1nrRySL63wns+7NE74aEQkmYOAFyWJvS3LGAwaRF26su8MMHvsG+IjHLp0It1L/kr1xhvKRCy422Ela/pGgJRBXeGusUd+jabH12NeVDk7g+eNgru3JOltRGEMI4QTanRdok5gLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114381; c=relaxed/simple;
	bh=EcRT1qmnC2s+qIqOSFrVyN7GSk+E87bkn6PTUh49IP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ecug3c1QLDMDX7/rp1tMtova78lqaRYYdjspb3oojz8kaDQ4rZ45nQu+mboCbsOXY99HQM2gwDQY9OwQcTZMo/eFxCGQiPrViYW0gW9YkCJNtSIROySXHeuQ3hfi2dDlTb/NEInj9hri3nDx/N/9fOY3I0AAyNSzOQsBk8RBrII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7Fbg7rC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7Fbg7rC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19EDC4CEE5;
	Tue,  8 Apr 2025 12:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114381;
	bh=EcRT1qmnC2s+qIqOSFrVyN7GSk+E87bkn6PTUh49IP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7Fbg7rCQ47r5CnLIev44xBt2z80WTePPttZfBBtaBJWdNXGfsX6uqhG9Bq5h2FlE
	 8oPim3l++OPkuGRxLU0kgOfvNcAY4vZV8tkEsjZjbarYHMUBxBqo2Gp19IHhv0ebRH
	 8graOeykC55wvi222KOXt4dil16rXEDtEecYZdRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 045/499] media: verisilicon: HEVC: Initialize start_bit field
Date: Tue,  8 Apr 2025 12:44:17 +0200
Message-ID: <20250408104852.368417031@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



