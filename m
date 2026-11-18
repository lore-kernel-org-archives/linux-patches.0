Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032124;
	b=X17j+RGTEkOiEpGiL8jpgy+CBKKbXuIawEojQQU8bBsdGHGGAZ92YXo+VzgfcteagU27
	 xrSw85/hA4JpUF/4EpKe1NPlh0yQ3s+r+THKnMwnI7xlGlCsvqOs6xUJtFvUza2FkAply
	 lDuxQY70K5KbYv/FBglPJhopu6e1pl9zzCKEv8mCVn1+KZ+huHCmt5F+7aFESlHVsv49Q
	 iZRkYoWS+GyMBmO3xkDibGgCR4qfOM9sMVj0N8Q0+aROkv0cnCW30glC9KPAAd99tpMjY
	 thCM/Q0YNEwC1lEmIdrbI4zLgZ3yyYKULygDmHrhOY0tYwG+aGGFsbLaIyPGJQE0E8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=p1WTW/MyTg7ILAKzbtK9XtBgQKgc93loopMVQkEshZU=;
	b=urTFJ4XkWsOWMS1IbRMRi28ribar0yJwUbxmA8IxqoFpVv/OT8lcAqtC5tcIwZZNypLu
	 lJVV5GRBZ5w5OkWmYDmmpkAZrzJ6g8o5CeSibuLgUVgbSpmAJKzkavmVkAbIIAS2Y5nHz
	 qa3bkc3TNTzHNIOEss60yD1ERTQLJnlbtBXNfPSzGGTDEmcUi5+yL8V/OfLPI+wIt1xV6
	 x08zkIMXDYUd+604nSyL5NBk2UVgFz7TOQCt9m11/9udyq21jw8AAd3GO9wHbO+n+SqCA
	 mP5T10j3YVnP610ewlsKLgwFHagDRjSUQfBppoJX2YLlWQVPO0FrwOsDEJq53ucB/kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoheIF3L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96112606A325;
	Wed, 18 Nov 2026 20:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoheIF3L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFE41F000C4;
	Wed, 18 Nov 2026 20:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032124;
	bh=p1WTW/MyTg7ILAKzbtK9XtBgQKgc93loopMVQkEshZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OoheIF3LwtnAdVkkZQZq3CT8GM3c5Z+vhBh0yIoBN8Tp8EJ4Dv9cuAdTeD9S9NmWl
	 t6kOem25E9jrjixuX6esHo6vAVYE5qqC9vaZb1du2dJtCqzyG6P+rshMiJJcZIR6zE
	 osn7nerygdZBxHUfqNoP9mm4uEkwz903U0OwSwXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1301/1756] ASoC: soc-component: Fix return type of snd_soc_pcm_component_pointer()
Date: Wed, 18 Nov 2026 15:57:08 +0100
Message-ID: <20261118150101.300924732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 61534ac0edd1d..81987d50f3199 100644
--- a/include/sound/soc-component.h
+++ b/include/sound/soc-component.h
@@ -507,7 +507,7 @@ int snd_soc_component_compr_set_metadata(struct snd_compr_stream *cstream,
 int snd_soc_component_compr_get_metadata(struct snd_compr_stream *cstream,
 					 struct snd_compr_metadata *metadata);
 
-int snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream);
+snd_pcm_uframes_t snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream);
 int snd_soc_pcm_component_ioctl(struct snd_pcm_substream *substream,
 				unsigned int cmd, void *arg);
 int snd_soc_pcm_component_sync_stop(struct snd_pcm_substream *substream);
diff --git a/sound/soc/soc-component.c b/sound/soc/soc-component.c
index b3d7bb91e2949..f578b439464bc 100644
--- a/sound/soc/soc-component.c
+++ b/sound/soc/soc-component.c
@@ -975,7 +975,7 @@ int snd_soc_component_test_bits(struct snd_soc_component *component,
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_test_bits);
 
-int snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream)
+snd_pcm_uframes_t snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream)
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct snd_soc_component *component;
-- 
2.53.0



