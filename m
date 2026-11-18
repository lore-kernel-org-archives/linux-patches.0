Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017179;
	b=jgDoTLnvHZI83744Bo+GqnoAYH3H2/3LfJ5Dny2H4UPKsK8Yju/82uDvfS1At7dsg7wo
	 umTwqeJUCSXGRJ+fpej2OjxFZOA2z+DKyPn2tWG4I88dmzvfL/80djCZRpzRGl0FpIb/B
	 BSKIoaDfh1Z/tMa9lUivStZev3oPKdKrOTxF0hRY7W4rWuR2HyxrLXTj0sqY+GGrSRzEd
	 tOC/qOC8v02orL6girSyRBhebx+sKGA6Em8LRRdtBJZMxwAUVy/2R4UTdWbQDXPylcWG/
	 WYTvg9Ob8lxWaPFBkb1inPNuJVD2zgmZMXf8kPz8PJV5U0MEjPmUuyYLImLj1yycnqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E/GkYfzZT+wQcWaRmojUOI4qZauy0mNrPRG7w9ybiMg=;
	b=MOZ7mflPwErF4xUOigQJrep/iqvpTW09ZRA7Igk+phewZTeij/K5me+MwwiQBFrWUT6v
	 ktgp3jGWNxJyNRn5r+GvlmP9xRvi7tLbcfisd2cTBplQPerdNgODhhRDrPeH/7qPntlFD
	 Ufh2O0Gl0xEgb+AMwcqiBJM29UU6xPFsQj9lCHigx5FoB3HQqwcYvASsALZfud8geFzEQ
	 oyWFe25uLpumFEB/kaUnqyXHRHC9YXZrlwqqmyxHwV+f1s2ZSIqNQzhSHb80+oiW9aRTM
	 GL3PTvyt81JqONwSRj67EfHhNxlV3CQL1hQ9Da9Ga86GD+H6tMBuC6a63pL6+fIE0yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JWe0Zo3S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEFE606A32C;
	Wed, 18 Nov 2026 15:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JWe0Zo3S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281871F000C4;
	Wed, 18 Nov 2026 15:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017179;
	bh=E/GkYfzZT+wQcWaRmojUOI4qZauy0mNrPRG7w9ybiMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JWe0Zo3S7mmfAklfLuZLHexbgz6syo7kWcDWglkYDMNGFok/uEfo1CE+WP6qSIQET
	 wk4YdTMdAKgJSx8epLr5dxGq7wLwVldF2zMbXUQcVLv9ZNu87f6oATepK+BjyIDkT1
	 1C5BnsH2Qf/qGWFbosPk9QuAAHSxvLa+mmvHShyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0793/2651] ASoC: es8323: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:33:53 +0100
Message-ID: <20261118150316.428589825@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit b7c3f95915a9e791fc8721ce1ecc037f7a55d58c ]

es8323_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: b97391a604b9 ("ASoC: codecs: Add support for ES8323")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-5-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8323.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/es8323.c b/sound/soc/codecs/es8323.c
index b926340256be5..03d516d70c435 100644
--- a/sound/soc/codecs/es8323.c
+++ b/sound/soc/codecs/es8323.c
@@ -733,9 +733,7 @@ static int es8323_resume(struct snd_soc_component *component)
 	struct es8323_priv *es8323 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(es8323->regmap, false);
-	regcache_sync(es8323->regmap);
-
-	return 0;
+	return regcache_sync(es8323->regmap);
 }
 
 static const struct snd_soc_component_driver soc_component_dev_es8323 = {
-- 
2.53.0



