Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6CF2135CD;
	Tue,  8 Apr 2025 11:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110426; cv=none; b=j5s78OvKmKupb0mn7MhObfMrGMGDklDfWDlIvtCTNA9XMz5Ck2AQqXo5ELBvwyHOqeJYWQcF6kM6FMfelH14LKCVDhzeaTxKfV0hpYt7LYAOkGqwwhXLBn9OWsHfAnipvz5AcvgAdGFyBhWA1Q63iNhqMX0gkFoevbsFG1o07kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110426; c=relaxed/simple;
	bh=L3x9ecEmpX4H/GzwSDH7Hfg0qXWEQAK4GeE2WB6BJJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzXCFHMud9Ut4Pcjtxl7NSfT49CItyuYnFVbrDwBj5ZHNeo/LjaPjn8yorCGTj6I7+Mp7lUUraSs3p9vb2msJFbImtyHTzX0FecmR10874TbLkHBADrDUcff5ODUIYGTZInTz68DBb+vuybBegPQ/a+7ObZzmVzxhJOLpYw21i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDlZ0ljt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDlZ0ljt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92D0C4CEE5;
	Tue,  8 Apr 2025 11:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110426;
	bh=L3x9ecEmpX4H/GzwSDH7Hfg0qXWEQAK4GeE2WB6BJJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDlZ0ljtmKTTE83BZ5fl6SQNIcxHRlv7j5M+axMDy3HtSfFDPdZNLI+gOZ51rbjlA
	 g3eYxwIiFdGCbTr96OLUf2ITxbPtYqeQcMngLlLFnkpk+OSMBMLa1q3+qAL6k9ubBZ
	 vcqEJ/oAdvoClQq9hBKfcZnyQzg4I3GCl06EEU9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 059/731] media: verisilicon: HEVC: Initialize start_bit field
Date: Tue,  8 Apr 2025 12:39:16 +0200
Message-ID: <20250408104915.644896685@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



