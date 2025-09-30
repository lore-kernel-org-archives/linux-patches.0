Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C843074BB;
	Tue, 30 Sep 2025 15:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244948; cv=none; b=ewZsxypEFWU7kYM1fFP33uQncH0sdT1GHUOYxw2+LFWTnLQi4We0YxjOCdJwFanb/+ghWBCbhVgvbuGE8mOErlnSFK4wPuOiJR4GBgcEYBjB0sAkoajbTL7WacBSWAlAxVLfUOMO6jbTlkpUwHqwBj1KWCYPZylO1FR8j/P7qK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244948; c=relaxed/simple;
	bh=CGCGg/NsdI/bK/BXVgDUgKX1moWirUCtBCHz6c4YyHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sE7NOx9aogUHn9JBPA1hUPk4qzLOEf6d7wBgYb9NmDA/MLM4nkrlr4PrG+1ImV4Nioqg4kW7V5BxJwdGmM0jWamX4f49vl6AuE8Xnm557JEd+f/1XXAF1uyc28NwUOIsD8s+ly1u3yYoz+pmDT4GHCmpeKCYrLTtMZ9Rqo1ieZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xl9Dn7j2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xl9Dn7j2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D2CC4CEF0;
	Tue, 30 Sep 2025 15:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244948;
	bh=CGCGg/NsdI/bK/BXVgDUgKX1moWirUCtBCHz6c4YyHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xl9Dn7j2OmMJjqG+Km6WDyftrUXIeR/AZq12s7wy9OHB2YD8XerY+HsTc6QurvyE1
	 PbXiZYo74w7AV4M7uupAKnEObqHT9NV2V3gjpW6Ubvf/GdSBg8QgDaRh5+KjCNLfEq
	 sO37Ky/eEO9LE84kY7yCtXzI4HTqWG1IGpzp/MZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Alexandre Courbot <acourbot@google.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/151] media: mtk-vcodec: venc: avoid -Wenum-compare-conditional warning
Date: Tue, 30 Sep 2025 16:45:35 +0200
Message-ID: <20250930143827.803851771@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 07df4f23ef3ffe6fee697cd2e03623ad27108843 ]

This is one of three clang warnings about incompatible enum types
in a conditional expression:

drivers/media/platform/mediatek/vcodec/encoder/venc/venc_h264_if.c:597:29: error: conditional expression between different enumeration types ('enum scp_ipi_id' and 'enum ipi_id') [-Werror,-Wenum-compare-conditional]
  597 |         inst->vpu_inst.id = is_ext ? SCP_IPI_VENC_H264 : IPI_VENC_H264;
      |                                    ^ ~~~~~~~~~~~~~~~~~   ~~~~~~~~~~~~~

The code is correct, so just rework it to avoid the warning.

Fixes: 0dc4b3286125 ("media: mtk-vcodec: venc: support SCP firmware")
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Alexandre Courbot <acourbot@google.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[ Adapted file path ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
+++ b/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
@@ -513,7 +513,11 @@ static int h264_enc_init(struct mtk_vcod
 
 	inst->ctx = ctx;
 	inst->vpu_inst.ctx = ctx;
-	inst->vpu_inst.id = is_ext ? SCP_IPI_VENC_H264 : IPI_VENC_H264;
+	if (is_ext)
+		inst->vpu_inst.id = SCP_IPI_VENC_H264;
+	else
+		inst->vpu_inst.id = IPI_VENC_H264;
+
 	inst->hw_base = mtk_vcodec_get_reg_addr(inst->ctx, VENC_SYS);
 
 	mtk_vcodec_debug_enter(inst);


