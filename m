Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EABC1F1302;
	Tue, 30 Sep 2025 14:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244052; cv=none; b=ntqIx/UcPNwNr3IQIYTECDyod7bSKrDmndKJPAVawd79MBOfR5/GdlKtT90pq40woalqN3hlxlhsKyah2mGXxYgCG+h2UnqC2+Kg+OmZ4PWmmUUDg/gjvbx5emqgsh6FBZhdZudl3iTFTgBmPFy+kXrg8xzBwufCGeSR/KdH+IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244052; c=relaxed/simple;
	bh=D9YEQeiwG7ZWfHd55QE3hzSbQktPvpDEF5bUs7PD8m0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGW+SpI4+FDTLiOqnYfgYZeior0QwBcW1udM2Tpk4u2vaWyKjSj5HMaAb9ZpI04Hu2PZXYjtaPeLZ2UhH+z/+uxbApipslB3x+8TxnIi8gDbF2EHPLHb572XVf9/ESExW43Fp7B6wKO1lKEEUEg3rvdpitaHRrjjxHIy4EOfLFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlRaUE53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlRaUE53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7047AC4CEF0;
	Tue, 30 Sep 2025 14:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244051;
	bh=D9YEQeiwG7ZWfHd55QE3hzSbQktPvpDEF5bUs7PD8m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlRaUE53o8JzoQMOh17CyzL51F4bWqsDC1HYsKWHZhy9AjR9QugkMonaX3zob1mnH
	 LBTDZzW5lqd8ucmyluvR/MkvHueRBcOJ/kIq7Bfc40mONNeKUE43gfWSG5p49ozWDi
	 fTw6oWGQpeUn8Dc+NVGicrY+encQL4gEOuXwkhhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Alexandre Courbot <acourbot@google.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/122] media: mtk-vcodec: venc: avoid -Wenum-compare-conditional warning
Date: Tue, 30 Sep 2025 16:45:33 +0200
Message-ID: <20250930143823.053259812@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -509,7 +509,11 @@ static int h264_enc_init(struct mtk_vcod
 
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


