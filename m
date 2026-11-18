Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024381;
	b=WERi18Ic21KlH2FiiHCNh33uyTiN87FQlDr+BNF3jxNZTjAgoVRI6AzbhG7bD61zNVHq
	 LaSDEjyv1Es5iYcg9kpRE19o88+sAsCvaf+YRjLqDG5OP/HKj5WawXUDzn7xwbRSDGBcH
	 QSO6F7DBdyZWRH1mt9GYxZVEmqD1/+EaGpZkfJVyk890VsDY3+IgAbcKAwow1tprXqMYk
	 gEKk9i4rYk3p6M3gY2XIW2UnirWp91okI3soICckJTQzlh07UEc2Q0LRTtkgEFLpfckyn
	 Me2PlyNlNPR/bJ/A8EJN/4jMc8QboddrlxC6VXLzYhkx32J44qYbCkzxThPGWGOsv/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dEoSh6GITqbD4+7959TneJWlNLIMU9ZAAGQUgGZCpKA=;
	b=kWZvnuTk92zRazeLkgm4c7oxV/i9k03Sy5pVQMQuO0HSaWG7LRnsHaYDqfWMd7sXY79r
	 ypZ0/M46r1p+jAVtExJQG3LOhKz1nfwzsizKwx2ENm57LU7oo1uB1mz6JpRkoYNCJK4SJ
	 6OZ903dD2UiYd12OjWsMB63HPeLZyCL0HbMP7w8uEYDzGXB8LzrOV5D+VawNlUOqAPoeO
	 KmyZOyC1SSDrql8IyfidFJp2PWRzab8Ej9MvxbKkXqRx/Ez84B80asC6ZFn1+FOd1BGMJ
	 74CSI7LKiA28zS4cFTLrKtqR/LdIaDdGGe97OiW5rpLkrn0BlCQuSebiDjCwgKiHWxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CwH5n3S9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC365606A325;
	Wed, 18 Nov 2026 17:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CwH5n3S9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB511F000C4;
	Wed, 18 Nov 2026 17:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024380;
	bh=dEoSh6GITqbD4+7959TneJWlNLIMU9ZAAGQUgGZCpKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwH5n3S951oKWFx39O6iv+v/qh+Ki32iwcWsO6ojU4w/Y6n8t1atbh0dbWt4Yyygt
	 H8HvfU+6j8ghALMxa3OiT9b+9qdEEn1pDVGkvrROC/yr6AInj1S/nGdbpLnBg4leLT
	 33+k4X1ziGigc2o/EQsShuX63BORa+e09RxZju+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0706/2151] ASoC: rt5659: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:40:41 +0100
Message-ID: <20261118150147.601046061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 31b47db7b4f77..805898547025d 100644
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



