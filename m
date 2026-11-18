Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056419;
	b=tfXqfwIJVMet9Vzc2LRLUxJlofmkZFAAcm4/vaH5OEHG2jZkus8vbLswgXjKw44JoE4n
	 bj9kI1ROsxzXAia5wjNyAK6KsVXtEmfWnvVy/Gpn54dXKliMkxXFdqTwyXHXkE228v1rb
	 REfI/s4AscCBYmuOPAH54xnSNQCyVnpcLMDVX9G0liDO3lvnJ5uVANAyCg0j256Yfr9tU
	 rYL1bPnkrCLopcFNyE18aMe9DlqkHZVdX5eYy83LD8DzeVBWi/X/FASvz1lnItmk67PCw
	 OVwjuD+k/XLiG8v3zD27KBySMLWWrwYoziCtLxQIeASxYSHujtEteAKHv6YTsiU2+VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/i0IA1r9d6XrVD+VoVUH+YArkHYCtQGnAUSov1S1YeI=;
	b=kOFQo3+UFk72Jb2IWYSSl2UkEAvP/HYw1ED8VDGb1kSxhZd00wX704CtlActHU0CuEgl
	 Y3w89Dy+olseU4UbQGPAmEX35IFgkDd+jsZwk06NfDrY8IfmUNj5Ee2lCdUQNyzLCHhdU
	 FP+9NRgAwbM2LsnxGTsN4EcuH/PElIxfxkAKwlrDFjrXxv3KmU+yx+iITEH7ATThnHYjy
	 E9p8nyIJwRM0bDaEtKrX5rYJi6HCHNfEEEhDcpm+WTYQIbscxmTzzFHZknmgrzwbYWGNu
	 jNdCfCjCqb5UDmRL8KtD7A8WKO4Wex++g7ImxR0wfPmvm/22oCvKs/ASfEEG79Ur59w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jloVfcVg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2F9606A31C;
	Thu, 19 Nov 2026 02:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jloVfcVg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A321F000C4;
	Thu, 19 Nov 2026 02:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056418;
	bh=/i0IA1r9d6XrVD+VoVUH+YArkHYCtQGnAUSov1S1YeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jloVfcVgCt/12zqqPPWJbdockeRo+wlvctJqeUXRm44EN22L4aknAyY4H8+OH++bT
	 Ekf4C1KBUOL/pIDRNFIoKlq0S7CDYNVwwBwcj6Py91okwczW8zXrBRyEiklG0B63gh
	 6HsJxMcmNkXrKiq0UyexN+F9OGhC3aKXfudjdd4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1980/2214] ASoC: soc-ac97: Fix error handling in snd_soc_new_ac97_component()
Date: Wed, 18 Nov 2026 16:00:56 +0100
Message-ID: <20261118150130.080159352@linuxfoundation.org>
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

[ Upstream commit fc081cdfc6b370f6b6853cdeb4313f92561770d1 ]

If call to snd_soc_ac97_init_gpio() fails, proper removal procedure
should mirror snd_soc_free_ac97_component() behaviour and call
device_del() before put_device().

Fixes: 9bf5c3d11f1f ("ASoC: ac97: add gpio chip")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Link: https://patch.msgid.link/20261014200608.118770-6-amade@asmblr.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ac97.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-ac97.c b/sound/soc/soc-ac97.c
index 5f49e3dec3fc1..cdcbd3f649d3c 100644
--- a/sound/soc/soc-ac97.c
+++ b/sound/soc/soc-ac97.c
@@ -235,10 +235,12 @@ struct snd_ac97 *snd_soc_new_ac97_component(struct snd_soc_component *component,
 
 	ret = snd_soc_ac97_init_gpio(ac97, component);
 	if (ret)
-		goto err_put_device;
+		goto err_del_device;
 
 	return ac97;
 
+err_del_device:
+	device_del(&ac97->dev);
 err_put_device:
 	put_device(&ac97->dev);
 	return ERR_PTR(ret);
-- 
2.53.0



