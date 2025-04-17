Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E6B257424;
	Thu, 17 Apr 2025 18:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913080; cv=none; b=aFMlzrAvd45GmYX6NsUmh404Sykh2fBllhC2lIKmdiHCiE6PpOMDfLXqZxBm0qUYllEeNuBlpaC2MuQq9Gklt6tejtV00Gpro9mEEMda0956+5xnuqAxX7vPLaf3Sbb46+l4ubEsMsWbcmlF61vYhHnwIl4H/4SMDlkKvBaHzYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913080; c=relaxed/simple;
	bh=71xHpXDQmfEy8t4tmkAmoCMv77qL7fDONiX/S/piC+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sffnmUvn4n+29pqameQHzrvKZzDLHk+eai97FxzJNg9rDvf5N08/WRawTTK/FZ0EtHzDdjP9bxaDDTAVJOqnyd4TrbeRyN7bpHiiaKHZcOZUePZEG3Iw+PTSLP6nN0omtpPOAVoEww5rpfknz4FZnk3JxXva18paArdaRDkOs2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWkFmMVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWkFmMVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E16C4CEE4;
	Thu, 17 Apr 2025 18:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913080;
	bh=71xHpXDQmfEy8t4tmkAmoCMv77qL7fDONiX/S/piC+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWkFmMVZu2omNpcc8Lk+FDFDYh9OIzx+byAHRLtSNq20iSs4fESm9Bmr3rVmpBpqH
	 EhzITFgvSAp/pQEgip9H01nIMMHoSugaAlg+CH0ExVG2gBn3zPRLXg2YeY4QfjH8Ae
	 TrsSmpLhp+tHkPcgk8payUY19EfNu8dzqIOBLWGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Alexandre Courbot <acourbot@google.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 220/449] media: mtk-vcodec: venc: avoid -Wenum-compare-conditional warning
Date: Thu, 17 Apr 2025 19:48:28 +0200
Message-ID: <20250417175126.824848313@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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


