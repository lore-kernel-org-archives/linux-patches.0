Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061783;
	b=r1qe7LR4dsRfWxXwy/BOKeA9MUdT2keNuFyrSHe1PEvKBRz4lV4n2v8ZzBHj7Sdj5pRK
	 x3X5P2duZ3+RHzM2KAAHYRtKUfnLYl56vbBeYqWGQYZRjko7n1NC9n9CImt8kIkB33abu
	 awD8PPvaSaiinUnHCNv5qRZxw9O8+o07OdzJnZL4A8j57UBy/KzZhYYyy0IAKJMydeVn/
	 ml2GT8bCDCpmqez8/NEpVQ8Yffa5UrH5dGhhjwLBtZVQJx3KkMYCY5P1UMzciFGwFUyoh
	 dG9Qwj2FcFBuhm0LVJS4Rx76KtLPCRefcput6stOngTM8poDgLTZf1EEZ6A9vZi4bQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9FO0/y9su1MEPQVVkp5QAjAS5saFoqMphq12OwZ9cos=;
	b=CFH6l4/X8dbyhEybkXELTAci6aO2821lmO59BYRDDPVOGWiKqi+YYD02OVst13Jpa74n
	 KDPtiSJdP5e1Y8AGlPq+kDiIG40WpuTcVa7SSG1BmVW0JKYo43msAZ9sKrBHRjHp8QsZs
	 6LsW6i5dthaBE8F9ex6WwB7BJDWXYfY+JJ2Rd3aJsmoGJxTIBRPscSGV/oqrCR+gRQZ1N
	 SMmxTevJjmx9bZTh7OM3EDTvU4pd3d9ryGS9ubayzwhT6KeP1Jeh0oDyrWEVYw82CQt4o
	 VzeuTbl619mg+8obFlVNbD1AO5kmGOvGUTnWGwDklMRRIlMkC6tMnfnmss7+ZQ5uH/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ieQHvlHf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3389A606A320;
	Thu, 19 Nov 2026 04:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ieQHvlHf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A2C1F000C4;
	Thu, 19 Nov 2026 04:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061783;
	bh=9FO0/y9su1MEPQVVkp5QAjAS5saFoqMphq12OwZ9cos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ieQHvlHfTJMoxS1O5mmv5bvgiG5IEdfUPzU7i+uIkvrN1f+e0yAsptSmnuCLwLZFU
	 cclTAEe3jWrvo5FNv0XGYnilcTBG4fW06HSRkVOM2e9bf1uaxWdUEGPYjM2BERg05z
	 m5Qh7LGewiKvGd+xFWHkdttp62qH2ypjyUU3cYu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1675/1848] ASoC: soc-component: Fix return type of snd_soc_pcm_component_pointer()
Date: Wed, 18 Nov 2026 16:01:53 +0100
Message-ID: <20261118150029.931260511@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2c790ce952597..2d0b5a1150ef4 100644
--- a/include/sound/soc-component.h
+++ b/include/sound/soc-component.h
@@ -444,7 +444,7 @@ int snd_soc_component_of_xlate_dai_name(struct snd_soc_component *component,
 					struct of_phandle_args *args,
 					const char **dai_name);
 
-int snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream);
+snd_pcm_uframes_t snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream);
 int snd_soc_pcm_component_ioctl(struct snd_pcm_substream *substream,
 				unsigned int cmd, void *arg);
 int snd_soc_pcm_component_sync_stop(struct snd_pcm_substream *substream);
diff --git a/sound/soc/soc-component.c b/sound/soc/soc-component.c
index 4295c05929016..23ecd3c88afde 100644
--- a/sound/soc/soc-component.c
+++ b/sound/soc/soc-component.c
@@ -613,7 +613,7 @@ int snd_soc_component_test_bits(struct snd_soc_component *component,
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_test_bits);
 
-int snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream)
+snd_pcm_uframes_t snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream)
 {
 	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
 	struct snd_soc_component *component;
-- 
2.53.0



