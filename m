Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050091;
	b=moSaCqYekuJ/PmdXU8W0H4RPGVkz5cgPEp8VLKXwI6RzJngJTJ9Vfk+WevKEnqyXTShp
	 sz8fFwKAcbzNVAtXj6qbgyDbP+ktTOf4/bbgym7jGBRXpmwIqbHIVsNh8iQ0ZJw55ygOq
	 QvXodWXbP5tDlZMA6dfoVS2s4PGGE+9d28804XEHaw1578x+EtHX1LP6jT5r5ahte0BZc
	 BKvcrHbJd5hZe6RniRscxxiNM2uSNyQCBquGrfBuZUPtz0UCvke48I9G1mpBd+y+tvK2d
	 d16WBHQ1Y52+cJflIZF1hN8pXqxFLovWsYRS8gXB4KLq4YASV3YrreR+p4/tKHi5fbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=b16O7NWpG6+ohxCCavMCzWA1xVOy7x1WRzw7K5RfrKo=;
	b=huaIE+poA7SlUkVM8QY/myo8wdmPhX3MQRszQFgIhAf4jcCrvb0Jv+NuWYXE8blEA5Up
	 jvRYC83WPQJldasunSFpu9IMkCpI04Q8aUQdDAaVxfzgBKLLYo5MtzeNXYPEM6ZYy1Gjt
	 rWBrNPuanilbUB47MXNfnB0mp5avhx9EQdwksZyVPvIbHgBJoDweIciYrhPp0f/5q6tpR
	 NvJbHBJf3oNnu7PtptDyZYkSm+bw/E2hQN3u/H/VGLGKdGRXG+Frly/uXdxPg0NtAB8dY
	 QVF7KRptJ/x0hFYzor0H2Z/YiyA1N9hG/4yzFF8FTtckQQ2/s5GjOCGjX6yy0CWqq0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mAOZy0S2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6572F606A332;
	Thu, 19 Nov 2026 01:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mAOZy0S2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2D01F000C4;
	Thu, 19 Nov 2026 01:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050091;
	bh=b16O7NWpG6+ohxCCavMCzWA1xVOy7x1WRzw7K5RfrKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mAOZy0S2b2Q72/NE8WLcoBFgfjFZDJdsBQWolJ/3qpMCbuzU0TDY7uz2DjEQNytKE
	 mgu+8UtbIfJUcUHd68YIziHLvZUqrDoH/NcL1jnjKPjKdFCca2skT3YQM5kyloJwfN
	 O8W7rYrHfMAMOf8Qpja+QXHZ7iJfvrnlsrp2HXbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2544/2857] ASoC: soc-component: Fix return type of snd_soc_pcm_component_pointer()
Date: Wed, 18 Nov 2026 15:59:38 +0100
Message-ID: <20261118150333.114247822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c26ffb033777a..901704912c350 100644
--- a/include/sound/soc-component.h
+++ b/include/sound/soc-component.h
@@ -490,7 +490,7 @@ int snd_soc_component_compr_set_metadata(struct snd_compr_stream *cstream,
 int snd_soc_component_compr_get_metadata(struct snd_compr_stream *cstream,
 					 struct snd_compr_metadata *metadata);
 
-int snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream);
+snd_pcm_uframes_t snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream);
 int snd_soc_pcm_component_ioctl(struct snd_pcm_substream *substream,
 				unsigned int cmd, void *arg);
 int snd_soc_pcm_component_sync_stop(struct snd_pcm_substream *substream);
diff --git a/sound/soc/soc-component.c b/sound/soc/soc-component.c
index e12f8244242b9..35691c158e906 100644
--- a/sound/soc/soc-component.c
+++ b/sound/soc/soc-component.c
@@ -918,7 +918,7 @@ int snd_soc_component_test_bits(struct snd_soc_component *component,
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_test_bits);
 
-int snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream)
+snd_pcm_uframes_t snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream)
 {
 	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
 	struct snd_soc_component *component;
-- 
2.53.0



