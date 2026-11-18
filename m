Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060855;
	b=KpT6lJYlYwsrYzhfuJsL40bW7XDNFShmsKkJfhddtqr6DzPky10+8eeEjRhy1gifI2IV
	 pIlGtXnaDHAWRcRFLgxj0sF256H4O8zfCOav4BRLdPg0R4T+CuiPW1fVBREhb9TH8FHEc
	 ezkkiB8AfqaMqdhP+91+EUjTdoLfQJIOYluAuD21uvmoVDUJE7bmIn+1xeqMj5Errgg1g
	 AXwiDd+5tfhHaaVbsJNmvtyJw7xsnGWdWTFZanCw+GCU/MPypAKbmIxyAoRZZhpiYA4cP
	 lTWwRn4gW/itiG8OSMU1DzjTvoLYToyZ7Q14nbhFYrOeVUlntcH4uAg7KBHaTz0AMUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IsZ24esqGmQJ/e9iKMSd9H4siDVXSujKJeCYAJCz/BM=;
	b=Tok0hJdrMmCdG/e/M6OTdnrA4muKKqZoNCEFYKY5kIvM4k+BPO12traF/YdYlg77yhOl
	 9X2K6a+QagfVIZpCnrUrINAfHTSwt61EKhXsJcN8HKUVU8RBACPTThS2OndfZ2+Mb2fJW
	 4lW2EXPAim9AjlLmJ0GOHgMrVYvlYd/ZntVMc2ZbPOym15vfu2LMNcaTJMVVNf832drx8
	 edEIDpnbzDp6FJOfvZr+z+rEu2VzGSmFsIUYxXv1DQ2uRnjKuRQ+47/fV7ny34axRvf6k
	 OlWLkloHhTMl6tCpimUtkLphLLf2HF/dxHu7TTsP2JS5+9f8xkKqrt3ymacvfG1iAcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZUMSNi60;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20433606A32F;
	Thu, 19 Nov 2026 04:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZUMSNi60
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AA41F000C5;
	Thu, 19 Nov 2026 04:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060855;
	bh=IsZ24esqGmQJ/e9iKMSd9H4siDVXSujKJeCYAJCz/BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZUMSNi60IK5tQ4bK8I+AQ3PWxQyAJu7a5+1rKooSxGwR/853BQ1soNuoBsrz7mjxC
	 S7hmD8BtyDLiM3thSYsgHozZSx9alFUdPd+ieyS510HHkKU9USDsjJyipMZPQ6cmbj
	 ADtsgJzKnAgmLoCxXKN1obXAMKRTXyAFllHAVm08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1348/1848] ASoC: rt1308: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:56:26 +0100
Message-ID: <20261118150016.089070243@linuxfoundation.org>
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

[ Upstream commit 3db3289178b94056753f7a8c6ee4ab4b232ee6a5 ]

rt1308_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 2b9def8c0d92 ("ASoC: rt1308: Add RT1308 amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-10-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1308.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1308.c b/sound/soc/codecs/rt1308.c
index b75931a69a1cc..26cc262dd14ce 100644
--- a/sound/soc/codecs/rt1308.c
+++ b/sound/soc/codecs/rt1308.c
@@ -717,9 +717,7 @@ static int rt1308_resume(struct snd_soc_component *component)
 	struct rt1308_priv *rt1308 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1308->regmap, false);
-	regcache_sync(rt1308->regmap);
-
-	return 0;
+	return regcache_sync(rt1308->regmap);
 }
 #else
 #define rt1308_suspend NULL
-- 
2.53.0



