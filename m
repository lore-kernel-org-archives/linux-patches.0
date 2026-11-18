Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020552;
	b=HQ0GhVHJ3Gdjgq7t0BXBz7GkD04lLIzqIvMq39U/v+galQfZotaHcB/aNSw4O1J8Np7z
	 x5xt3gfRTvwWe3PTuoOwDpQSYtc7sqgA9m8zlA3zku8QxzGfha4GklRZKssNfLE19Gxum
	 s2iPiS3AZq4MjyMdcPn+t5esVO0wzGRqsBxinrJMatsMu3PIwmUb49IgMvByy40ieFDK6
	 PoZg73kOm/hEhlUJxaD8NNA6ePNY0eAbapcS7dTOxurWjs2ENhFL2jHIRue7qQD6+LQq9
	 CZE3eRwMChsEcv6A0d4Yhbxz8kvTO77lek3DXu2vv698JNGMXn6V76CB0S+h+nNdsBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=yRIyCkbC6KC2ktNAlpUjVatdvNsGOpOB3o/I80kgYKY=;
	b=HfXYJmQkLgkqbHchj+vjnZmKAOnICWhlWApCb+ZB2M07TJREH3R+8bHxNdTR1UTytae+
	 BnrUOWO463pbWaGpFHqH5t4QkzbqO+H7Gu0q/g/sn9g+K5x9TQJiA30bK8El1ybYfN7QI
	 +YZQKRcWK7o0bSDjEej0VOZw9y64g9hOptQ3rIMzp4lJ1v0+3jN2LdgZmpZt5Hm7KieOY
	 BKlbpVfJU5XsrVqyF3Fh4QmDr5xvGE4Q5N3RB35IBu4mR57r9ZLoy/rfZkhPBsOFwOO6C
	 coe1rRuRUpmo92pJvBqr3+ltMqTlwcpXCg0AYf/25l2xFl17Cqh9hhIY8DMg6MMVv+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="p/NfJyH+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CA2606A32F;
	Wed, 18 Nov 2026 16:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p/NfJyH+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2199A1F000C6;
	Wed, 18 Nov 2026 16:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020552;
	bh=yRIyCkbC6KC2ktNAlpUjVatdvNsGOpOB3o/I80kgYKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p/NfJyH+4jlzAsYyn9MHNWbycTQVtA/Rd70pTuEymFRj+S5SZOBWKbj6ncBB31WW4
	 cyNhT+NSbeXx6igGeyXVuF4Bb4cMfCpn1VEH6mFlj0y4oDrQSTpcCzvHk1CL8Iopxn
	 VUoEft7G25TMDY6mqzTdJKyFlSrAXc3wNBd4/DVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1992/2651] ASoC: soc-component: Fix return type of snd_soc_pcm_component_pointer()
Date: Wed, 18 Nov 2026 15:53:52 +0100
Message-ID: <20261118150358.064154911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c49b59630101f..bd64ebf2379b5 100644
--- a/include/sound/soc-component.h
+++ b/include/sound/soc-component.h
@@ -423,7 +423,7 @@ int snd_soc_component_compr_set_metadata(struct snd_compr_stream *cstream,
 int snd_soc_component_compr_get_metadata(struct snd_compr_stream *cstream,
 					 struct snd_compr_metadata *metadata);
 
-int snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream);
+snd_pcm_uframes_t snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream);
 int snd_soc_pcm_component_ioctl(struct snd_pcm_substream *substream,
 				unsigned int cmd, void *arg);
 int snd_soc_pcm_component_sync_stop(struct snd_pcm_substream *substream);
diff --git a/sound/soc/soc-component.c b/sound/soc/soc-component.c
index dc7d203cb76af..c4d9e80a9d851 100644
--- a/sound/soc/soc-component.c
+++ b/sound/soc/soc-component.c
@@ -935,7 +935,7 @@ int snd_soc_component_test_bits(struct snd_soc_component *component,
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_test_bits);
 
-int snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream)
+snd_pcm_uframes_t snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream)
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct snd_soc_component *component;
-- 
2.53.0



