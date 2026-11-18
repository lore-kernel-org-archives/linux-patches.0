Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056421;
	b=UnVh0SS0eBRYb1VnBMBhT0R/pwVxJ7ZamCWWtEO2gNJacDCHnxjflk8Ikxn9DyO3l9iA
	 PRehRouN9JtEmSq0p8TaI7fvLaJo4oewms93IiOQeq8LkvDeMNGlWWT1jj4Tnp7RHnaLu
	 8hf4ucl20QXgwCwLvfi9KRv3UoK9AsztWBel79KXr+eQSdFPt3Fmyv2aryuXPBygUZyEM
	 nNuE4MYzhBz/s9p6nCWTMrZSdpDb00XaF7+9doHQeAFNtbIjMLOIxHH7ymgyWy9qPVCZ4
	 /cUO9ydK70IJCvmg2MDTabo2zm0ZftfrWbGGnUaL6V+pXz0iiV/5P9Gp9f1sPzS3ztA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=IwoK8FSY+ufQ0x+EadOdjbfGSIHbQxe4W7eXNZWuNRk=;
	b=TYt32jfI1nApfkozw6/So0paHcLRjcvRCgSJoksl4TeOkRFqMGQVmUra97jMphs/7MfV
	 wZaXPQK1cFj0WBTViIGXBRgqF9qwdu4XCR51I24ET7DaIhx7K6t+BxOhrSYsITNoIiKLe
	 U+9Psfrmmob+EujOvasAK0sIKezEHOuQesVGISos0EowO48GBgcDOQVDnmL/Wy6ez2WZi
	 KwM1lS+PutSKhIQnpaaD/3yMH2WOYtzqp/pU5Azn/cb5Rm8Z43NkpLd/tzEux4anKHBIf
	 NMGl2ega6Y87vV58rIifxWBEnaqOC/ZGv/3d/ipcOW4hWTUortXctIZdpm1pb2RB+sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wvgT71Jk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22E4606A32A;
	Thu, 19 Nov 2026 02:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wvgT71Jk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F611F000C4;
	Thu, 19 Nov 2026 02:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056421;
	bh=IwoK8FSY+ufQ0x+EadOdjbfGSIHbQxe4W7eXNZWuNRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wvgT71JkAmC5q/hajZ1dpG1PQcSXDag8AJi4YYO0b46/5To7ogRTmApKav82O5c0H
	 wVAn/klVzLHs8EjytQdPtAf4d4Ocgq3zG+mIj2vsn1eArsKxq/zrnJqO8bR4gk+K2B
	 kgdJnr7apTZDMh/6E/QqSkLKC+tP0q8Ib3rc4LZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1981/2214] ASoC: soc-component: Fix return type of snd_soc_pcm_component_pointer()
Date: Wed, 18 Nov 2026 16:00:57 +0100
Message-ID: <20261118150130.114049427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8c4d6830597ff..94c8460756dd2 100644
--- a/include/sound/soc-component.h
+++ b/include/sound/soc-component.h
@@ -477,7 +477,7 @@ int snd_soc_component_compr_set_metadata(struct snd_compr_stream *cstream,
 int snd_soc_component_compr_get_metadata(struct snd_compr_stream *cstream,
 					 struct snd_compr_metadata *metadata);
 
-int snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream);
+snd_pcm_uframes_t snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream);
 int snd_soc_pcm_component_ioctl(struct snd_pcm_substream *substream,
 				unsigned int cmd, void *arg);
 int snd_soc_pcm_component_sync_stop(struct snd_pcm_substream *substream);
diff --git a/sound/soc/soc-component.c b/sound/soc/soc-component.c
index 8e8d917d22f8f..e6fb36fea18e9 100644
--- a/sound/soc/soc-component.c
+++ b/sound/soc/soc-component.c
@@ -921,7 +921,7 @@ int snd_soc_component_test_bits(struct snd_soc_component *component,
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_test_bits);
 
-int snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream)
+snd_pcm_uframes_t snd_soc_pcm_component_pointer(struct snd_pcm_substream *substream)
 {
 	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
 	struct snd_soc_component *component;
-- 
2.53.0



