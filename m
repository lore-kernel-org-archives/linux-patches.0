Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048575;
	b=FOYxF0w4tvoRooET1dggIi6k2STatBDpG7mtWvUHOpuSaM752qZh5vfftRblT7D98WuF
	 owh/tNozsNFNGAjTtp1hyX79+EB6FRVJ+ZQgRKf0930jyNf8faSckB0WTewxz9SmScZgE
	 s5xTy/LDyT+j/+FZKgmprL77vD2GS+KTYFLEGjwwzltpBgb+cwfHKGQn+bwxJb6stOXRJ
	 nBxAg/jqwlJ8KJKZw+8N2Uz927EJkWmI7f79iEHl3NOei9V1uAUn7swikX3TKo90qQty4
	 qihf9pwdMENXFD7C9NnTGBjgg+dqEGTpVxRsou6rE8HFJcFjpPlT9VjKRoMHDOrbm5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qNQ6QrbfEIQW8VGx5+usRF+wJPPkvXCtDUsVAeNblCE=;
	b=ejlGBoeGqAmH8Vkuv7KE7GoEzXzd1jahbB5q7UfAgaioPtYi9AhCz/6FvRzY5vzGC8ci
	 maOX4fxx6guOv48Us9DPexhtFolU+3RtYZ+nw8k6si2TpfetUquMbQwnimeNbSiWKz7pR
	 K1B04dF4m/wkUZktmuRE/5LTfRcyw8AztamBoQrS4u9hzdzTSfAuoWtmrQwF8A9YeiKhS
	 5OiB2on6saP5oiWtPfSFTPcfCoxPZLk4ntl13sUeQ7Q2nO+4yDNbUlMzN88VZdL4PAFr/
	 1wjxch6L6xMH9OFSMEcriVknTKqlMqP25C2I9BG789YuqinOMvkB6Ckrf7nPUMLdrpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZzFxC463;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB58606A31C;
	Thu, 19 Nov 2026 00:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZzFxC463
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F021F000C4;
	Thu, 19 Nov 2026 00:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048574;
	bh=qNQ6QrbfEIQW8VGx5+usRF+wJPPkvXCtDUsVAeNblCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZzFxC463vyIt6fokqUIsf/MVFptA1Ky7w3+SBlp3rwpXfKO3vs+LWErZYSilfIedK
	 ZSWQorSMA33QU1hiN7A8vhSQWYIZwXSQ3o5/81T4aJrDSHVqiUha2hb5gR/IqPrRW5
	 47GTYZCzq//CnGi3DUt7Ya3QTg656W7SL/wpFOfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2044/2857] ASoC: ak4642: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:51:18 +0100
Message-ID: <20261118150315.010136664@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 7142c34ed92fddca7038787b8695d22c661dc6ec ]

ak4642_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: a3a83d9a7cb0 ("ASoC: Add ak4642/ak4643 codec support")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-3-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak4642.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index 914d5b1969f8c..4b75ba4a6238f 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -533,8 +533,7 @@ static int ak4642_resume(struct snd_soc_component *component)
 	struct regmap *regmap = dev_get_regmap(component->dev, NULL);
 
 	regcache_cache_only(regmap, false);
-	regcache_sync(regmap);
-	return 0;
+	return regcache_sync(regmap);
 }
 static int ak4642_probe(struct snd_soc_component *component)
 {
-- 
2.53.0



