Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026991;
	b=XKizVU3uTF//CznpzEvVUiLyz31KTpeqZrV2t4ukaOh51O/Q5CGmG3YAhkrIZrydlz55
	 CmPq9wcxdtpI2xYTMfvRkdcWO8tg3bzHLDWNNck8Zh/V8mOqxpwWaPF57iW0Y1gO8kKSw
	 mE+mJcuuGnGcmEGAMgc21tinhn9rnYkrKSSSD//KMxGMOHPSS4CdMZVLT66bdJiFQSfFu
	 6qf70Ow7JyLK8sFBr6ncJnXIpaVOXDaK65dQPfvRMQXxReBX52Cn9zwYkDmCszQx+zoFv
	 biijvJy+OKVlgtyFw0q+Gtt0kP/mUWeLrqrOch8fk5U/2okcnS31GKKtFy7T5/sbBmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fnKI/JJ2ipV3W0imcCEkPswrYVorNiPaIzMIecODuxc=;
	b=eRJyRaDm/EXNrM3ViA369LrU7t47c/TDAxWhs8ax1aiuPrCwRUh5gAwC9/4J300+FAgi
	 s+3y3vWkzS2HVs3IP1mCWUR8HuoJL72dNZ2BJ7tLjtKNnqQk0thyptCiS5FMx1CgCsl4d
	 oHHuLBpd30XvEYSla0/qk/bm/qX0CYFutajKtVv/NR76mdjZOb46B4BJ4Yqw0K9MlOo8w
	 ZKsL4Iwbhb2Ltdr3HgDebEIIcJfmDlqkuEq4gg6FC+4myf40JwAXzLRm4F2S/sBicNktc
	 ChQhxiV7JqhYgsE2tkg2+y1OCMuy1/u5u0pt76E2OfsRjFm1Ew+bxZJZayuv3BVWOYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axAx8xWw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE3A606A32F;
	Wed, 18 Nov 2026 18:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axAx8xWw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBA41F000C4;
	Wed, 18 Nov 2026 18:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026991;
	bh=fnKI/JJ2ipV3W0imcCEkPswrYVorNiPaIzMIecODuxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=axAx8xWwznOh3Zv30GwDqrFPOVGTUp1pXvKeNCFufl/H0QKmA0ckVDDoXipOEL1yG
	 pwVj27NwJzbTvsLlLPx2qHpYMJ133yd7NcohvpiYcnSVyrEQwZ/zcgprhItFWnZ2VU
	 su9GgR+SKFfdhBpXjQxU/ysu1s7wr9vLquooFxAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1630/2151] ASoC: soc-component: Fix return type of snd_soc_pcm_component_pointer()
Date: Wed, 18 Nov 2026 15:56:05 +0100
Message-ID: <20261118150221.251052646@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amade@asmblr.net>

[ Upstream commit 9df30adce80dd6b0646e58c12a4cf7c6c88d0778 ]

Both caller and pointer callback expect the return value to be
snd_pcm_uframes_t, however it was defined incorrectly leading to
potential truncation of returned value.

Fixes: 0035e2565b93 ("ASoC: soc-component: add snd_soc_pcm_component_pointer()")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Link: https://patch.msgid.link/20261014200608.118770-8-amade@asmblr.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-component.h | 2 +-
 sound/soc/soc-component.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/sound/soc-component.h b/include/sound/soc-component.h
index d78cda8668888..f49fd90191e31 100644
--- a/include/sound/soc-component.h
+++ b/include/sound/soc-component.h
@@ -435,7 +435,7 @@ int snd_soc_component_compr_set_metadata(struct snd_compr_stream *cstream,
 int snd_soc_component_compr_get_metadata(struct snd_compr_stream *cstream,
 					 struct snd_compr_metadata *metadata);
 
-int snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream);
+snd_pcm_uframes_t snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream);
 int snd_soc_pcm_component_ioctl(struct snd_pcm_substream *substream,
 				unsigned int cmd, void *arg);
 int snd_soc_pcm_component_sync_stop(struct snd_pcm_substream *substream);
diff --git a/sound/soc/soc-component.c b/sound/soc/soc-component.c
index c815fd1b3fd19..0c308345a2624 100644
--- a/sound/soc/soc-component.c
+++ b/sound/soc/soc-component.c
@@ -963,7 +963,7 @@ int snd_soc_component_test_bits(struct snd_soc_component *component,
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_test_bits);
 
-int snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream)
+snd_pcm_uframes_t snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream)
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct snd_soc_component *component;
-- 
2.53.0



