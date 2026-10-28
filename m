Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214581;
	b=RDhfHU2vj6IYOFMu0Jwrh+yP9fz1FRTNL5VRY5cs3XNKg7g811TfIvO7HYNOLlJENNtW
	 uzOS7DpwP55XGpalCZlhP6ddIfge/Ln4VOKHqnA7pClwOciFIlc/4tv3eIFdpVfMSPGY2
	 PE9yQOmW8OeR+I4TtgPFWYAd6T46nxb2CfaI+hGM7Lb6/YydfrP/S9J/I0BMrT3E5HGPM
	 PfrNurp0rwxc2zpaq0JH52kSrvitG7uVx6+TWgp/g7JW/q4Xz6R/O4n0hju+B/YvOdzp1
	 ezd3rZ6Bawo8sJ6WoXu+Hau0slYIZZlGZRRfFobJqiILyf8LtCALoWK5Gzq7cc/orXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=15bwe3DJf6ZN+2Jl+aKx2iNyWOpBwEM1z6TRni8/dNE=;
	b=S5VWdL913ZoUFXiizeWoOYJsHnmWbklrj1+vp7stZ02cS/E4nydrAM7ZActzykSLnujH
	 ugQlNMUX4334GQCCpBt+GhzBLoiuJ1l/+XKmKiCISkLtPitiSfl1RIvNXHSPZNVHMkQRB
	 sJB5pXTdkU0r4TCq4V1msRltywasut6FkXZh2/0WgsubZ7GNv+YpOlivJe65e1a6J1GGw
	 OO0uqEqaRoPCeRrxX7B/ZwW+JS1E9O0Rm0T0YAYbb6naqHoy7fllSviFUUSPE1rIIZUdV
	 xzNfLFX7f10UrmoOZiU0NF3jI8wiqa/G8UzJYLEfHF3I9vnlJu4hBA/cC9r/M7/U2Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WgYZ6wxo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4303E60A3813;
	Wed, 28 Oct 2026 19:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WgYZ6wxo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4F51F031E0;
	Wed, 28 Oct 2026 19:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214581;
	bh=15bwe3DJf6ZN+2Jl+aKx2iNyWOpBwEM1z6TRni8/dNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WgYZ6wxoxm7N7xGJkAHwKtkGAXVo9znxj3oBuOkbV/BUoy9QXTIL8DwarVV843It0
	 OmEeJPUqvoawVzzNZBGYhz32Y9th2G+5n7QsHwVOXWcMI+6J2LJTL4lAP+U0nJNHag
	 OQ2yrPE8wiiZKaZ+FjFeD+sUwPmOip4yVWvRoxTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0910/1887] drm/msm/dpu: Add missing NULL pointer check for pingpong interface
Date: Wed, 28 Oct 2026 17:50:06 +0100
Message-ID: <20261028170520.124650041@linuxfoundation.org>
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

From: Nikolay Kuratov <kniv@yandex-team.ru>

[ Upstream commit 88733a0b64872357e5ecd82b7488121503cb9cc6 ]

It is checked almost always in dpu_encoder_phys_wb_setup_ctl(), but in a
single place the check is missing.
Also use convenient locals instead of phys_enc->* where available.

Cc: stable@vger.kernel.org
Fixes: d7d0e73f7de33 ("drm/msm/dpu: introduce the dpu_encoder_phys_* for writeback")
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/693860/
Link: https://lore.kernel.org/r/20251211093630.171014-1-kniv@yandex-team.ru
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
index 462fa58c660df..d76c7a2e44bf2 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
@@ -212,14 +212,12 @@ static void dpu_encoder_phys_wb_setup_cdp(struct dpu_encoder_phys *phys_enc)
 		if (mode_3d && hw_pp && hw_pp->merge_3d)
 			intf_cfg.merge_3d = hw_pp->merge_3d->idx;
 
-		if (phys_enc->hw_pp->merge_3d && phys_enc->hw_pp->merge_3d->ops.setup_3d_mode)
-			phys_enc->hw_pp->merge_3d->ops.setup_3d_mode(phys_enc->hw_pp->merge_3d,
-					mode_3d);
+		if (hw_pp && hw_pp->merge_3d && hw_pp->merge_3d->ops.setup_3d_mode)
+			hw_pp->merge_3d->ops.setup_3d_mode(hw_pp->merge_3d, mode_3d);
 
 		/* setup which pp blk will connect to this wb */
-		if (hw_pp && phys_enc->hw_wb->ops.bind_pingpong_blk)
-			phys_enc->hw_wb->ops.bind_pingpong_blk(phys_enc->hw_wb, true,
-					phys_enc->hw_pp->idx);
+		if (hw_pp && hw_wb->ops.bind_pingpong_blk)
+			hw_wb->ops.bind_pingpong_blk(hw_wb, true, hw_pp->idx);
 
 		phys_enc->hw_ctl->ops.setup_intf_cfg(phys_enc->hw_ctl, &intf_cfg);
 	} else if (phys_enc->hw_ctl && phys_enc->hw_ctl->ops.setup_intf_cfg) {
-- 
2.53.0



