Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030067;
	b=eKdRZ3pqqII7lmWuC8kW/AG+6KmbXFvWR3GwQx5PrAddn8StDqMLMKtDRBCvSFBMJ5gS
	 spFIk2e3wczjK2r3X+RliyVgZLVx0OakAOOvPD4dvZ2wLTQz52BSFx13/yRJc8SZeUPAe
	 ivpdkIY1JhxCadL4ch3MHYrUvEdrg5CbJPXBUZO1I1+aZK3iizZoFSouc/wzxJZdZjF32
	 2S5oOpDOjomdDl0jcrVznhcmW4XPGHlWbsyRVQ6IvRCWiRa57INP782QpUShhGqbTt0CZ
	 Lc3Y238ispyJsJEelQcQHqsumlV9HnZNPgkQcpdNspaUVzwkCWJNccuk2n462LxCJgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M9HS6jasgV60p2ngKILeXoVcYx5RM49Wr0rKWm+qIzU=;
	b=qxLOUwsrxd2Pt8zMSNvSpZiNOLECvwufO+sKuzRdresjUVkEh5nXsAB7+btL538oPCON
	 TxKkz7eQMIWgpEWHPr4RikrJPh3JiT7tPpALJ+sOQ0h3/zx4E78P88/6M4whANHkz21di
	 FsL+xjYPwORrpiqZ20h+92eroCqGHgXYF8NFFBfUxovPMBkoqMOIAvsWpBxjr5lKuuA4Z
	 UQoXz8Vc4VC7KjMF4euM2ZTSgLIcpmT7pNumjJ6F7kTLmKQ2klJf4wpgVA1f1bJlEFrSe
	 dpUQhr/7qfx0cwny/qQIPN/7ZhfbdxViA3iD1O/yGUqHsEyPjbGWe/4G6aKVq2U6ijA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kUMki0+3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F9560A260E;
	Wed, 18 Nov 2026 19:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kUMki0+3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065B71F000C5;
	Wed, 18 Nov 2026 19:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030067;
	bh=M9HS6jasgV60p2ngKILeXoVcYx5RM49Wr0rKWm+qIzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kUMki0+3lXFksZym0plHlGHT0O8aASv9Kna0pjmgH2fjTHcBv0a/RrWvwA4HNrYxY
	 XPXSzqszVYfyEpVYoVYfK1aeQn0Krbt339umq5VnqecY2QnxbTU3e+A1AMgI5yyUkf
	 JdvXlGo2zqAEP4ftg4a1/aP8Jox/FlzDqXGQUo9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0574/1756] ASoC: rt5659: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:45:01 +0100
Message-ID: <20261118150031.908377080@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 3a9b5bce85a1baff95463a2bb021efac64bcf83f ]

rt5659_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: d3cb2de2479b ("ASoC: rt5659: add rt5659 codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-13-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5659.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt5659.c b/sound/soc/codecs/rt5659.c
index a2652fa6e1d74..d2944a43c205a 100644
--- a/sound/soc/codecs/rt5659.c
+++ b/sound/soc/codecs/rt5659.c
@@ -3704,9 +3704,7 @@ static int rt5659_resume(struct snd_soc_component *component)
 	struct rt5659_priv *rt5659 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt5659->regmap, false);
-	regcache_sync(rt5659->regmap);
-
-	return 0;
+	return regcache_sync(rt5659->regmap);
 }
 #else
 #define rt5659_suspend NULL
-- 
2.53.0



