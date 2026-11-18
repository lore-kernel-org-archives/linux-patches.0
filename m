Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041815;
	b=TRwa1gVKbCSGyy1yKxprHQ7QcOdqeZHVhVfkl2rd2ey7EwyteQ41LwZTQBww2PIQdD8y
	 YBa4ZU+oZ5GuHVida2NEQHunxg4sWYJ0TE9p7xznLMU4bo0WfQ6SLBAIY4xg4JCADr4pM
	 KcvqXRZFtBQbrHG/Hvk2HOwLLtOISoo65qyfHBV5drY0RSfu8GtB9Ch/IGpnkoHfunMMY
	 YkYSMGnGB+WDTmVhdYZWAgmRefbBLLFisfy+CQl5UBf4/SfmZsaNEcmR3BzXLcnHiQrG8
	 MSwxuOaasqGOrZ9+izwlyTpsHWhzDMYiiYk0lb7McvpvxNHn9neGdVhtZBWgn7kX6NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=aGr+KkdF+DMxZ1DnPAcnRhc273bwGkbb2lea26julRw=;
	b=u0KhonfzF//jnAgT0BVSLzsvDpwRgFcDCinHkrpJ9sl5EotRXSd2HVnxeTV5IKpzmpn6
	 T2+Mpg5PA+2olpX6f/eVaz9ebq4uwL5BDfKjqeO6kk5AiOg+ijblnRfCJa21Ll7rRtC0J
	 OpWCNqx5T9i2DkIqji6CR4uyNTzddPNdsca/6z9YSN7RgEBC9e71zltbeegTp9Sq0Lzf8
	 4+D6h46DWYBGS/Rcq9LnRE+vOs27s7pFGhG6diI4COwLwU1/UnDgaGpCp2/9h3VUXespl
	 w+AnEzUCW8p615n/eIltDStcGAwYbqij4AMJr4ohe4G2cNmF0TxlL2YiG+wSd0NGfqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zCT2D5JI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EF9606A31C;
	Wed, 18 Nov 2026 22:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zCT2D5JI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAFC1F000C5;
	Wed, 18 Nov 2026 22:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041815;
	bh=aGr+KkdF+DMxZ1DnPAcnRhc273bwGkbb2lea26julRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zCT2D5JI1lxeYCfUeimKqKRQbVYuK6LjSRGOh+BFnnw1bsd/eGueDCwnZO7y9SdrB
	 BTp+JIRLMnvZ1aEdyZTcV609XvL17tFbh7KQte71tSpWgr5WYDz2tiEOprEF9NVA6U
	 HbVGqJgEexR0nSbU7tNKo7KJxzZ7CQvOGdXj85wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2949/3318] ASoC: soc-component: Fix return type of snd_soc_pcm_component_pointer()
Date: Wed, 18 Nov 2026 15:59:31 +0100
Message-ID: <20261118150448.795639678@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ceca69b46a821..128c8b31071fb 100644
--- a/include/sound/soc-component.h
+++ b/include/sound/soc-component.h
@@ -505,7 +505,7 @@ int snd_soc_component_compr_set_metadata(struct snd_compr_stream *cstream,
 int snd_soc_component_compr_get_metadata(struct snd_compr_stream *cstream,
 					 struct snd_compr_metadata *metadata);
 
-int snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream);
+snd_pcm_uframes_t snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream);
 int snd_soc_pcm_component_ioctl(struct snd_pcm_substream *substream,
 				unsigned int cmd, void *arg);
 int snd_soc_pcm_component_sync_stop(struct snd_pcm_substream *substream);
diff --git a/sound/soc/soc-component.c b/sound/soc/soc-component.c
index 566033f7dd2ea..e9f9050e14131 100644
--- a/sound/soc/soc-component.c
+++ b/sound/soc/soc-component.c
@@ -961,7 +961,7 @@ int snd_soc_component_test_bits(struct snd_soc_component *component,
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_test_bits);
 
-int snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream)
+snd_pcm_uframes_t snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream)
 {
 	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
 	struct snd_soc_component *component;
-- 
2.53.0



