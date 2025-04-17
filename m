Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E228185920;
	Thu, 17 Apr 2025 18:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915727; cv=none; b=MDj9fA1/LVBWL0WNIgEWjf40wwFeKVwBmnK5eZpJHkTLXX4eCpViL6Oay63Bm2pK0XhCSkXDHwIsMZrJ3B+a3bbcCicnW5Gtnz/+yWeoN4mRhldDnc4BlX0mdEOOTtFlm33csCmQWg9lvMvoJ2rQGKT5RwDbpmpTmBVQSXmvRpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915727; c=relaxed/simple;
	bh=Ixelf/7irSgnWBI4ay/YPXJdQgYq1IdZMpAcarMm09Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ricO4tFFXDfQ8WOH//wNVPjZfPRyT+GKhFrUy+aXvfrxcEWDsEyrkoOwbB7xJbKFeGfP1oJKg3KjUdvufDUM1KMSdcyFzbhflkslp7Y1Bv2E8lUuUEbJyxgBBwJNCfkF5cr+g372k9W7+szGQIMdErn5VxoH5/A9HPUS4NKr6ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdCKYu30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdCKYu30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB0DC4CEE4;
	Thu, 17 Apr 2025 18:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915727;
	bh=Ixelf/7irSgnWBI4ay/YPXJdQgYq1IdZMpAcarMm09Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdCKYu30MPDwBe4E+PyKRyiWKGRes3ajWhyiVYriKHvnszI5jbzVYfy97pAtI7dIt
	 EiQidn4Qavz7z0uD1Hdt7ptJ/i4LcJFkocFiClh3w/BKYcdLZOu6wju1ogG2cfe2l2
	 dE4PxJ0V9Sa768dHz5PuWYg9pGvC5wwf+exCd134=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Alexandre Courbot <acourbot@google.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 190/393] media: mtk-vcodec: venc: avoid -Wenum-compare-conditional warning
Date: Thu, 17 Apr 2025 19:49:59 +0200
Message-ID: <20250417175115.228040270@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit 07df4f23ef3ffe6fee697cd2e03623ad27108843 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/vcodec/encoder/venc/venc_h264_if.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/mediatek/vcodec/encoder/venc/venc_h264_if.c
+++ b/drivers/media/platform/mediatek/vcodec/encoder/venc/venc_h264_if.c
@@ -594,7 +594,11 @@ static int h264_enc_init(struct mtk_vcod
 
 	inst->ctx = ctx;
 	inst->vpu_inst.ctx = ctx;
-	inst->vpu_inst.id = is_ext ? SCP_IPI_VENC_H264 : IPI_VENC_H264;
+	if (is_ext)
+		inst->vpu_inst.id = SCP_IPI_VENC_H264;
+	else
+		inst->vpu_inst.id = IPI_VENC_H264;
+
 	inst->hw_base = mtk_vcodec_get_reg_addr(inst->ctx->dev->reg_base, VENC_SYS);
 
 	ret = vpu_enc_init(&inst->vpu_inst);


