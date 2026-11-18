Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026485;
	b=ed4lHl3EdqZiK75rvImMigYiLg5xavcO0Dd9/ATWCauTlXQMuwUpTa2c7Cfl9pzCVedl
	 QmI8kV4CETKrp5zK4DXf15tHpHZTwoSYU3BH9wtw/6QONjB7Kaicl4Ym2K39HRRLh43fT
	 fHOSW7JSlp+EqQk5G9sCONTRWwo/iDmYl2QXs7dofBkZ+zTImwwTmf3dWxvWh+WXu6RnE
	 SLrYNOUvvU5t2w3L2svY8u0oLMirpiQNaGnOUAmKpRAc+H5hZlPd5EaLosAXWfs26iTXk
	 0ec+IQRfwu+J2pCCz6OOKrbnzk0ZIZDpRXSfw2PPxUcA2pBrY8FZkVqMYaQ+BxD2EOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E/0j1jh9DfsHPwD3l2QcGAV2Ke00BTZR1bjBjLs8Ryc=;
	b=nwCQJ+hcONRWJnRwguktqbNpF88y4tFjFRffgYeAXjxLwxqtJijCS7JpzJLCLpubMz7Z
	 P/iQ6oAOoTYH37zgdNQAaRBzlVRze7++fuEsxcW4LV71H/yE9PET6KobHUkFuM7UhD/R8
	 aLOkpKZREFbpZeqPcSetVBFuM3JOpmf5+ILas+xM6alqhwCUuEy+iQqqtcR/6suVid+Nr
	 h3UgyT0rbYOPIn075P8c6QQhDGQYjPx1WvYiLA9+2Q1bSzdwadIkb0lgAc8w9yNgsiSaS
	 3T1OpGKYAIOLSGwLRahjOVDWdXy7YYqD3eWDTj0wr9cTuDKAkzS43CffVoEn6y1Pf7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDrpy4U4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1E6606A31C;
	Wed, 18 Nov 2026 18:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDrpy4U4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919A61F000C4;
	Wed, 18 Nov 2026 18:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026485;
	bh=E/0j1jh9DfsHPwD3l2QcGAV2Ke00BTZR1bjBjLs8Ryc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDrpy4U4pwwDbJ10MFI5NpSf08l3Qer1XO5liNp10gMAWtpKzBew+z+Z7n4Qm7wpj
	 hlK/z9LJBQ+mX1LXsaUZDto0d+X2XOGosuRExpA50yk4XrBXObxwVMwuEHxlF5Xng5
	 Avy2dxAKsPLnV9UR5bT/Z52sM82z+auCrENvhRCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1451/2151] ASoC: amd: vangogh: Fix acp5x_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:53:06 +0100
Message-ID: <20261118150214.776376448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 38559fcd1c518a33055ef0a2cf7c04b57bfa9215 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp5x_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: cab396d8b22c ("ASoC: amd: add ACP5x pcm dma driver ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-7-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/vangogh/acp5x-pcm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/vangogh/acp5x-pcm-dma.c b/sound/soc/amd/vangogh/acp5x-pcm-dma.c
index aa47268994345..bd260634f4e49 100644
--- a/sound/soc/amd/vangogh/acp5x-pcm-dma.c
+++ b/sound/soc/amd/vangogh/acp5x-pcm-dma.c
@@ -231,7 +231,7 @@ static int acp5x_dma_open(struct snd_soc_component *component,
 	}
 	i2s_data->acp5x_base = adata->acp5x_base;
 	runtime->private_data = i2s_data;
-	return ret;
+	return 0;
 }
 
 static int acp5x_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



