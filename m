Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040134;
	b=OfKow6T2UivGnzWJ3qWjtg00Tid8WQ/pGyjeS6ix/dh7nh+Tf0RsbooQLiF4H98yGq4s
	 tas7eiHOhXOpCMEP/lXnslCLaxQmIhKqjMMpic+cxm+H7l8lLXc2Nch/3K/rD0fLahgd7
	 DE9AB8ijLVGypTos5bebM/ERoluRBRqw2F2W44bp5Hw4NamuRuqIIO3xwNufidfnTU93Q
	 GxfKTWCgDDGyBtOqJZtGVvO6293wcYfZNLRFL+Kwpl1pVaJPoGZ4v1PPD0HOxM4F+iHO2
	 1XSAysSsSHrbAVIQjoLR/8KrAh4lc7zJKtuZn28Em0jghO/9Fm50/qydS5YQ5AGQ2Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iVQBYuI0f321DG7t1TJaLPFQGFI/BJCVYJx+vT5GKMA=;
	b=YdBz9tmZ2Gge4TqF5TsPZdMNMhxdVABFVL2k+tuNc82NZkyKDVHL43NSIA5LXBVTsoht
	 jN77MwvsfXIH+1Rx/uuMSNJQ7PfMRjinBGNQ3tnIhMnqH0eNgxSQInGQQ5+cmDP8uECM7
	 iEogm72s84zb7jBxcaJa87vvc+N6+qjmaD7gYt7u0X0pAymlbpT+bk4Yi5wi4isuG1mvf
	 tEsLQtoFmgV8JGfWSua5UJfg9PLZJUrkIoEwC3rFyPMBZRjrMkGB2ZUL6lke2B7tMn09H
	 X7tgoe56y/+gY8QMMLuY0hQoTXn1sQ1XojbeWuK0nyIvlmQs9jwkVR/vT0n2VBIgl8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D4Eohl7H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0058606A32C;
	Wed, 18 Nov 2026 22:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D4Eohl7H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7B71F000C4;
	Wed, 18 Nov 2026 22:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040134;
	bh=iVQBYuI0f321DG7t1TJaLPFQGFI/BJCVYJx+vT5GKMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D4Eohl7H+Xe8R34adslbtA/6zvF3qrZl8aWSQ0nopoOtSzUO/7eaZHS0mBLuC2+Bk
	 3MbH/cZNNdR9r1TXX0f+f2iqt6aqvPE9CFlPiRj4QYOhdOqMfvW2qytcf2N7PWx1+v
	 qLEng94M2e1jEkBwScgDCP7ypRa0N49oK9AZkskc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2348/3318] ASoC: es8316: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:49:30 +0100
Message-ID: <20261118150432.057573677@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 243d0c47e57a6af89d95aa451ef5fbf453983b1c ]

es8316_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 4bac47a7b2f9 ("ASoC: codecs: add suspend and resume for ES8316")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-4-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8316.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/es8316.c b/sound/soc/codecs/es8316.c
index a8f347f1affbd..65a6cbd220ef6 100644
--- a/sound/soc/codecs/es8316.c
+++ b/sound/soc/codecs/es8316.c
@@ -778,9 +778,7 @@ static int es8316_resume(struct snd_soc_component *component)
 	struct es8316_priv *es8316 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(es8316->regmap, false);
-	regcache_sync(es8316->regmap);
-
-	return 0;
+	return regcache_sync(es8316->regmap);
 }
 
 static int es8316_suspend(struct snd_soc_component *component)
-- 
2.53.0



