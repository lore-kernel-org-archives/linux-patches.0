Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213600;
	b=DrT6g/QK5ZDixooPNypE0IzTkkWapulrocjayxCGacSzaCO5v9f5yetw4ka+N2b0MZ02
	 SoD4acqXQ+pvuMrmyKzn2qvEWq/IX3+SKHLV82xpgdmPIoc3SJH8w5Al/1RLH114XTjqh
	 bUGSMfc0TNSPj0/pGB2XUNvT0YxcYLhA0aaw6lgYPtbo+R2cvwoP90Y+bhAq6+FFvrM/V
	 cxbb3lf9PWmlzbuv9xx+WAMT5dwV8mujvwalzgNkDdcQtcvgkI7+wdhhmB83eo62n7xYo
	 T7JpPn6iGRO2PQe0rzMeZYMMZiG4G7/nP+9H+tLYOLZrY/Gy6+bv9MBP/JobgDCkxqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vkGhinbNbX0IkfHo3rs6c99SG+f3d7ozyS1PFxXIQFQ=;
	b=YIa/6Oam7FZUEwRTpkD/K/xTr9rGnANfVNS4ZhcIFbnhs0yVgQY0eaO72bKTD0G4GdhG
	 0akdSFHOazQCJWkYsFyYgKtsDNDjPzyvOlkl5XBmLGoqWX79GvxjVFPiQeDYQOrZIKNGO
	 20R7sDbznRVJmHFdraSFTDxL/VeP1l6INuCKtI+rp/fgcQc3gZfWMj0Syk1IwmeUXaHLV
	 /vL5pqAvCLYCk47rfBGjB5Ohs7DxoeKd/OVkwxn3MyxnrOxqdQXsEEh9LmVrZhVMbUrVE
	 9SxuCNO5AfFs2Dfri8RH/2hGzi79RNvaTA6Jv05wBqgZ+fzq71NihQmwa63Tkt9MdTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AA2YnzXX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EC3606A31C;
	Wed, 28 Oct 2026 18:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AA2YnzXX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58B81F01825;
	Wed, 28 Oct 2026 18:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213600;
	bh=vkGhinbNbX0IkfHo3rs6c99SG+f3d7ozyS1PFxXIQFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AA2YnzXXItJwOJmg0G0DmNLcPzQ/JCFa8RlZ9XaPFBV3rF2h6wTiOXLzJbaj+PJ+2
	 wlJilGfHesQ8Ltr97sRWHb9flZnaJLyqbsDJP+RfeOiojp6Qys652UMgGJS2VCp0uo
	 BrP/b4SxsL1PMfICIuKpeEcDt36o9nSd6hUNmYcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0562/1887] media: mediatek: vcodec: Only free buffer VA that is not NULL
Date: Wed, 28 Oct 2026 17:44:18 +0100
Message-ID: <20261028170512.178208884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fei Shao <fshao@chromium.org>

[ Upstream commit eb005c801ec70ff4307727bd3bd6e8280169ef32 ]

In the MediaTek vcodec driver, while mtk_vcodec_mem_free() is mostly
called only when the buffer to free exists, there are some instances
that didn't do the check and triggered warnings in practice.

We believe those checks were forgotten unintentionally. Add the checks
back to fix the warnings.

Signed-off-by: Fei Shao <fshao@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/vcodec/venc/venc_h264_if.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/venc/venc_h264_if.c b/drivers/media/platform/mediatek/vcodec/venc/venc_h264_if.c
index dc35ec7f9c049..e070bd258ce6f 100644
--- a/drivers/media/platform/mediatek/vcodec/venc/venc_h264_if.c
+++ b/drivers/media/platform/mediatek/vcodec/venc/venc_h264_if.c
@@ -304,11 +304,12 @@ static void h264_enc_free_work_buf(struct venc_h264_inst *inst)
 	 * other buffers need to be freed by AP.
 	 */
 	for (i = 0; i < VENC_H264_VPU_WORK_BUF_MAX; i++) {
-		if (i != VENC_H264_VPU_WORK_BUF_SKIP_FRAME)
+		if (i != VENC_H264_VPU_WORK_BUF_SKIP_FRAME && inst->work_bufs[i].va)
 			mtk_vcodec_mem_free(inst->ctx, &inst->work_bufs[i]);
 	}
 
-	mtk_vcodec_mem_free(inst->ctx, &inst->pps_buf);
+	if (inst->pps_buf.va)
+		mtk_vcodec_mem_free(inst->ctx, &inst->pps_buf);
 
 	mtk_vcodec_debug_leave(inst);
 }
-- 
2.53.0



