Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C288372EF6;
	Wed, 20 May 2026 16:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295420; cv=none; b=A3fsmzykwglbR+axT8i5veocyjb6Cot+yRdwCWqZQHW7/bpOqgc91vgelHPiwNS3EOX6/KEJmpNI38OG8t6reqjl56bamV7suD18F0g2kotQIM9vWKZkXA2ojUAitug1pao+QSvJrEE2cc3/UneG8X00dTmlNzi0bTrmpz2acLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295420; c=relaxed/simple;
	bh=QdoN0ZCqG5pgR01/A5evmGWZwemoRMIEExYTq0/sveA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3kLveeLF0XaamMffyKtF9eDQCQblXB4gdps6nifbvKnb2icMSG77XIjDwGKJEaC0QMn9xepyVSqilMuPJ3BY54tMn6lp8Jdd+/vvEtBpJJrGdfmtHKZf12s+6fqWIKgpiF8KLERwwU00cqkIxLz81Uw5eGwII4pfW8DrHJkmM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLbtylgP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLbtylgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09641F00893;
	Wed, 20 May 2026 16:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295419;
	bh=LFORT/lnrQUKXOPqpav+G8Ix7QRzjuPnyDAbHbKFDFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLbtylgPUp6teMqvRi36roqpn4++07YcIVSi922mILIFBMsaTBiIZsEAiRjT/Kqkn
	 8nEyYYpSMwAJ2oZmMjiZ0mQUiNjEHjfT3+Wx1b4JOEZsLKMGoU2M5JWwA0pmOoE21B
	 C39CCNNMLY6hxlBTyHyAUrMH27MjIx9OYmDSeqoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0412/1146] ASoC: amd: name back to pcm_new()/pcm_free()
Date: Wed, 20 May 2026 18:11:02 +0200
Message-ID: <20260520162157.523494044@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit fe33a69681e343999e18893f97bb6cd99b883992 ]

We have been used pcm_new()/pcm_free(), but switched to
pcm_construct()/pcm_destruct() to use extra parameters [1].

pcm_new()/free() had been removed [2], but each drivers are still
using such function naming. Let's name back to pcm_new()/pcm_free()
again.

[1] commit c64bfc906600 ("ASoC: soc-core: add new pcm_construct/pcm_destruct")
[2] commit e9067bb50278 ("ASoC: soc-component: remove snd_pcm_ops fromcomponent driver")

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/878qbslddx.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 3666dc0c47c3 ("ASoC: amd: ps: fix the pcm device numbering for acp pdm dmic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp-pcm-dma.c           | 2 +-
 sound/soc/amd/acp/acp-platform.c      | 2 +-
 sound/soc/amd/ps/ps-pdm-dma.c         | 2 +-
 sound/soc/amd/ps/ps-sdw-dma.c         | 2 +-
 sound/soc/amd/raven/acp3x-pcm-dma.c   | 2 +-
 sound/soc/amd/renoir/acp3x-pdm-dma.c  | 2 +-
 sound/soc/amd/vangogh/acp5x-pcm-dma.c | 2 +-
 sound/soc/amd/yc/acp6x-pdm-dma.c      | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/soc/amd/acp-pcm-dma.c b/sound/soc/amd/acp-pcm-dma.c
index c76a4bcc96459..6ad70aa0ea837 100644
--- a/sound/soc/amd/acp-pcm-dma.c
+++ b/sound/soc/amd/acp-pcm-dma.c
@@ -1252,7 +1252,7 @@ static const struct snd_soc_component_driver acp_asoc_platform = {
 	.pointer	= acp_dma_pointer,
 	.delay		= acp_dma_delay,
 	.prepare	= acp_dma_prepare,
-	.pcm_construct	= acp_dma_new,
+	.pcm_new	= acp_dma_new,
 };
 
 static int acp_audio_probe(struct platform_device *pdev)
diff --git a/sound/soc/amd/acp/acp-platform.c b/sound/soc/amd/acp/acp-platform.c
index 88613569fd64f..6b1e18b31c1c6 100644
--- a/sound/soc/amd/acp/acp-platform.c
+++ b/sound/soc/amd/acp/acp-platform.c
@@ -321,7 +321,7 @@ static const struct snd_soc_component_driver acp_pcm_component = {
 	.close			= acp_dma_close,
 	.hw_params		= acp_dma_hw_params,
 	.pointer		= acp_dma_pointer,
-	.pcm_construct		= acp_dma_new,
+	.pcm_new		= acp_dma_new,
 	.legacy_dai_naming	= 1,
 };
 
diff --git a/sound/soc/amd/ps/ps-pdm-dma.c b/sound/soc/amd/ps/ps-pdm-dma.c
index 7c529fc6ba997..c6cd844d458c8 100644
--- a/sound/soc/amd/ps/ps-pdm-dma.c
+++ b/sound/soc/amd/ps/ps-pdm-dma.c
@@ -351,7 +351,7 @@ static const struct snd_soc_component_driver acp63_pdm_component = {
 	.close		= acp63_pdm_dma_close,
 	.hw_params	= acp63_pdm_dma_hw_params,
 	.pointer	= acp63_pdm_dma_pointer,
-	.pcm_construct	= acp63_pdm_dma_new,
+	.pcm_new	= acp63_pdm_dma_new,
 };
 
 static int acp63_pdm_audio_probe(struct platform_device *pdev)
diff --git a/sound/soc/amd/ps/ps-sdw-dma.c b/sound/soc/amd/ps/ps-sdw-dma.c
index 366d7c4bb07e9..f27ebbd213798 100644
--- a/sound/soc/amd/ps/ps-sdw-dma.c
+++ b/sound/soc/amd/ps/ps-sdw-dma.c
@@ -634,7 +634,7 @@ static const struct snd_soc_component_driver acp63_sdw_component = {
 	.hw_params	= acp63_sdw_dma_hw_params,
 	.trigger	= acp63_sdw_dma_trigger,
 	.pointer	= acp63_sdw_dma_pointer,
-	.pcm_construct	= acp63_sdw_dma_new,
+	.pcm_new	= acp63_sdw_dma_new,
 	.use_dai_pcm_id = true,
 
 };
diff --git a/sound/soc/amd/raven/acp3x-pcm-dma.c b/sound/soc/amd/raven/acp3x-pcm-dma.c
index 4529404ebd935..37ea5c572eb94 100644
--- a/sound/soc/amd/raven/acp3x-pcm-dma.c
+++ b/sound/soc/amd/raven/acp3x-pcm-dma.c
@@ -363,7 +363,7 @@ static const struct snd_soc_component_driver acp3x_i2s_component = {
 	.close		= acp3x_dma_close,
 	.hw_params	= acp3x_dma_hw_params,
 	.pointer	= acp3x_dma_pointer,
-	.pcm_construct	= acp3x_dma_new,
+	.pcm_new	= acp3x_dma_new,
 };
 
 static int acp3x_audio_probe(struct platform_device *pdev)
diff --git a/sound/soc/amd/renoir/acp3x-pdm-dma.c b/sound/soc/amd/renoir/acp3x-pdm-dma.c
index e832c7c4b96fa..e60e3821703cc 100644
--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -376,7 +376,7 @@ static const struct snd_soc_component_driver acp_pdm_component = {
 	.close			= acp_pdm_dma_close,
 	.hw_params		= acp_pdm_dma_hw_params,
 	.pointer		= acp_pdm_dma_pointer,
-	.pcm_construct		= acp_pdm_dma_new,
+	.pcm_new		= acp_pdm_dma_new,
 	.legacy_dai_naming	= 1,
 };
 
diff --git a/sound/soc/amd/vangogh/acp5x-pcm-dma.c b/sound/soc/amd/vangogh/acp5x-pcm-dma.c
index 6ce82cd8859b8..831e30e9b0426 100644
--- a/sound/soc/amd/vangogh/acp5x-pcm-dma.c
+++ b/sound/soc/amd/vangogh/acp5x-pcm-dma.c
@@ -357,7 +357,7 @@ static const struct snd_soc_component_driver acp5x_i2s_component = {
 	.close		= acp5x_dma_close,
 	.hw_params	= acp5x_dma_hw_params,
 	.pointer	= acp5x_dma_pointer,
-	.pcm_construct	= acp5x_dma_new,
+	.pcm_new	= acp5x_dma_new,
 };
 
 static int acp5x_audio_probe(struct platform_device *pdev)
diff --git a/sound/soc/amd/yc/acp6x-pdm-dma.c b/sound/soc/amd/yc/acp6x-pdm-dma.c
index 1c8aad8499164..710db721ffa48 100644
--- a/sound/soc/amd/yc/acp6x-pdm-dma.c
+++ b/sound/soc/amd/yc/acp6x-pdm-dma.c
@@ -346,7 +346,7 @@ static const struct snd_soc_component_driver acp6x_pdm_component = {
 	.close			= acp6x_pdm_dma_close,
 	.hw_params		= acp6x_pdm_dma_hw_params,
 	.pointer		= acp6x_pdm_dma_pointer,
-	.pcm_construct		= acp6x_pdm_dma_new,
+	.pcm_new		= acp6x_pdm_dma_new,
 	.legacy_dai_naming	= 1,
 };
 
-- 
2.53.0



