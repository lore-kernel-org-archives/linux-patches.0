Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060841;
	b=pdGzVIQ7JfOGlVAVQ1OBnc3SkSh2PyFjzbyOLpM47C01bHb5ezjJ5Gb9ggCjSoeVjirD
	 ONg/cPnYU4so60rMIccxHSlVXdjP5DOX4++MKbEJ1+5x8TznOLpKfhlsNWP+OhW4O6ocQ
	 vYYEamjfSyXfYvURi6gVqmC5NrtSEUuHTuRVxWajc1XxKnNyqrcefgWppIo94wKuyue4L
	 06AxB51hFhKSFYcI98RdqpWsoPR9zBcVS7pzl1Ta2+EeVkqSLZtrORYusrzB4DDozdJ6I
	 7SAq7v+Jvgcg4kK/RdW3V1vSfsmlPEKvqOmEzqylUUjAVzbh1/jMWzA5R5Adt4cglxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2SN1AaAUGEklfpuI/9GuKy44cxNhw4GXfbWj12/dZCM=;
	b=E4pqdQb/ayEwgfbSQ7FzmgveRWnSFO0MhFXQan245IuVW8O7wN6gYKt9UBqXKH7BbDiB
	 tPEwz7PAIDry+HmsFNInUxZCR3eLgl7zX2vbJelKYeJ/kMFOpzIGL01eP/L9TNXX91H1K
	 v9bIamg/KXsShtVcdWeoITefmP3FEg85G0JiSUVu/ZTaMHgvxEARjS0J7ga6rTOQLmNfh
	 I6NDNM4MS+8XhWNmGQp0pOVFZKJVYhk/smeNqadztUItyfezKGkFH5YITPzoIEtWK6Pop
	 TE8rZupbFLI1vwmF+HPmxi5UoH18jRfkJDdozZ2EbBnUWs0fvd0EyHeS5c8CkWOCkTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IuETZuCx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A274606A32A;
	Thu, 19 Nov 2026 04:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IuETZuCx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F021F000C5;
	Thu, 19 Nov 2026 04:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060841;
	bh=2SN1AaAUGEklfpuI/9GuKy44cxNhw4GXfbWj12/dZCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IuETZuCxTWVnpYCXfYfSmHnhoRxXyjN/W8HKs4FcoGohnM4lVQn5ogcQgp0WVEGke
	 6+GRNe/ARlnlLlvQxSNGw37+HDjHNrw7l/cUsAPBXMPTx/0n9Nsd2UpG+3k7lwUdDg
	 GIz0bqH7ZXRVVPLYQ6AEwD6J0hNoPR2CQibXJLp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1344/1848] ASoC: nau8540: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:56:22 +0100
Message-ID: <20261118150015.942249642@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 0bf2b3411537e8e4d9c03702646a9fc87198d4b1 ]

nau8540_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: c1644e3de45d ("ASoC: nau8540: new codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-6-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8540.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/nau8540.c b/sound/soc/codecs/nau8540.c
index ace96995fedc4..5c5f62b477332 100644
--- a/sound/soc/codecs/nau8540.c
+++ b/sound/soc/codecs/nau8540.c
@@ -786,9 +786,7 @@ static int __maybe_unused nau8540_resume(struct snd_soc_component *component)
 	struct nau8540 *nau8540 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(nau8540->regmap, false);
-	regcache_sync(nau8540->regmap);
-
-	return 0;
+	return regcache_sync(nau8540->regmap);
 }
 
 static const struct snd_soc_component_driver nau8540_component_driver = {
-- 
2.53.0



