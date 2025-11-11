Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59AA1FDA92;
	Tue, 11 Nov 2025 00:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822191; cv=none; b=rvVFvS7GBj5VWCFvunJ7Znc+eQrUfNMbOB/60sTcYUBaE3wdl43MYmf9iUAwLlpVBFJrezek44EjDaacl+FrtzGgfpRwqYFB/JQJPF0w0Dc7yMo9dswP4waOYPTt8xYBStM5DKaoCoVjDBJOVgQa3E45/svclBD9JtConcERryA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822191; c=relaxed/simple;
	bh=eV+S3k90sKckHpVPly8OL8ApzvJ+69dsVWLI7e+UiA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTOtNmh6dipuZ7NCuv5In/nf+eUiZv7jOOwBqa4TjqzC5jhZ8ks01NVkhJ89pV01q5YTzT2mkIfZ3k7HWpq6kjn+WMmZPrNWxjRTFz/K9ilEhEGEsM4F00t4iKLpzA3jH1V+Ilcx+hYpB6uK7+ZGSC2Rgu6x/WoCRf48kcEDM5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzdJjfCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzdJjfCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87727C4CEFB;
	Tue, 11 Nov 2025 00:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822190;
	bh=eV+S3k90sKckHpVPly8OL8ApzvJ+69dsVWLI7e+UiA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzdJjfCTKl+tRGyv18DG6s4aCRJtXy1QZ3Q1sOhUFA1mCQs+D5R8SSHBaGJwVzMF8
	 vrEZf8bvcQTUKdkCiJqNGEeI7/F9tu3yzZpxN8XVEKHcv9Umi1bVRPovyqFjzAs1pR
	 XXswNeu7sBKDSTvQb58q/ICkHY0uDYN68IVpOx3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 053/849] ASoC: fsl_micfil: correct the endian format for DSD
Date: Tue, 11 Nov 2025 09:33:43 +0900
Message-ID: <20251111004537.719151937@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit ba3a5e1aeaa01ea67067d725710a839114214fc6 ]

The DSD format supported by micfil is that oldest bit is in bit 31, so
the format should be DSD little endian format.

Fixes: 21aa330fec31 ("ASoC: fsl_micfil: Add decimation filter bypass mode support")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://patch.msgid.link/20251023064538.368850-3-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index aabd90a8b3eca..cac26ba0aa4b0 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -131,7 +131,7 @@ static struct fsl_micfil_soc_data fsl_micfil_imx943 = {
 	.fifos = 8,
 	.fifo_depth = 32,
 	.dataline =  0xf,
-	.formats = SNDRV_PCM_FMTBIT_S32_LE | SNDRV_PCM_FMTBIT_DSD_U32_BE,
+	.formats = SNDRV_PCM_FMTBIT_S32_LE | SNDRV_PCM_FMTBIT_DSD_U32_LE,
 	.use_edma = true,
 	.use_verid = true,
 	.volume_sx = false,
@@ -823,7 +823,7 @@ static int fsl_micfil_hw_params(struct snd_pcm_substream *substream,
 		break;
 	}
 
-	if (format == SNDRV_PCM_FORMAT_DSD_U32_BE) {
+	if (format == SNDRV_PCM_FORMAT_DSD_U32_LE) {
 		micfil->dec_bypass = true;
 		/*
 		 * According to equation 29 in RM:
-- 
2.51.0



