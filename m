Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D4922333D;
	Thu, 17 Apr 2025 18:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915279; cv=none; b=Uumeqn5AORQJ4VmteJike4CJ9DBSoH2KXo7lcgH9zbBAiwAMbZQU7wWKb/QQ/XiIUUMCvhYGYp/KuSDnUfNDjfnyni57A/0hr4OaajxHPfuKcm3ergWrQU7ygAGU5H8DOf2iLxIpjPEDPg9LsVpYFBdVGJ7qEKUHcwF57veTmbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915279; c=relaxed/simple;
	bh=ZgTCp04NPfGn7Zvw+afsgX2pMjIOJPfsszIWh48ZgGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPpkhXdYKXrrTeUsLMpYnz6yfUCh1cmxEUZIVIMaVdsX7vnjnwRoVErnxpMcMZ8OE7iOt8Ix8+/8hYAuqFfq3D6gjDsILLKvbEstSje/YyObTaPs8tojMHh0igrpsiLkFoy7ujomqtQDOSZ6tXaTo0MPV5NZptQ43kUbp30jPPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnRXtnNM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnRXtnNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D72EC4CEE4;
	Thu, 17 Apr 2025 18:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915278;
	bh=ZgTCp04NPfGn7Zvw+afsgX2pMjIOJPfsszIWh48ZgGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnRXtnNMkPAA4+AFIVKFUmBiucaf0pK+9SYnXlC6dbPIk/xoDhLn1ZkbLP4383Gt+
	 lleuVGvSvz8xPNRuNrLKqO4I5XsK9C+mLu/uq6jq27HzwUBgq+pimtVQPNzkMvvZWw
	 Hu/AWURgQPAVWLeO1KTUGb6vwt403wEA4uwngBk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Aakarsh Jain <aakarsh.jain@samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/393] media: s5p-mfc: Corrected NV12M/NV21M plane-sizes
Date: Thu, 17 Apr 2025 19:48:05 +0200
Message-ID: <20250417175110.651824841@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Aakarsh Jain <aakarsh.jain@samsung.com>

[ Upstream commit 7d0d0b2342bebc47a46499cdf21257ed1e58c4aa ]

There is a possibility of getting page fault if the overall
buffer size is not aligned to 256bytes. Since MFC does read
operation only and it won't corrupt the data values even if
it reads the extra bytes.
Corrected luma and chroma plane sizes for V4L2_PIX_FMT_NV12M
and V4L2_PIX_FMT_NV21M pixel format.

Suggested-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Aakarsh Jain <aakarsh.jain@samsung.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c
index 73f7af674c01b..0c636090d723d 100644
--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c
@@ -549,8 +549,9 @@ static void s5p_mfc_enc_calc_src_size_v6(struct s5p_mfc_ctx *ctx)
 		case V4L2_PIX_FMT_NV21M:
 			ctx->stride[0] = ALIGN(ctx->img_width, S5P_FIMV_NV12M_HALIGN_V6);
 			ctx->stride[1] = ALIGN(ctx->img_width, S5P_FIMV_NV12M_HALIGN_V6);
-			ctx->luma_size = ctx->stride[0] * ALIGN(ctx->img_height, 16);
-			ctx->chroma_size =  ctx->stride[0] * ALIGN(ctx->img_height / 2, 16);
+			ctx->luma_size = ALIGN(ctx->stride[0] * ALIGN(ctx->img_height, 16), 256);
+			ctx->chroma_size = ALIGN(ctx->stride[0] * ALIGN(ctx->img_height / 2, 16),
+					256);
 			break;
 		case V4L2_PIX_FMT_YUV420M:
 		case V4L2_PIX_FMT_YVU420M:
-- 
2.39.5



