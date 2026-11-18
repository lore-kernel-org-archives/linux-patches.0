Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017202;
	b=0Z+sFgFKuALTr7eyOjFO+4py5g2855V69Hh9BgwbiLu1wae2quUjbVs7j8lh0k9UWn6T
	 xeJQNHEjAjKTDDgajVOIus+BP1hmfJQL3PccyNlZ5W9bwb2flg58smgKKlXPz74/iE46a
	 Lx/EbitU5d/EEEs4xLlBAU03xu/MSduzzSdlWFjn5fB4f6irMQ6ZFMlqzfwKNF0cZQnNU
	 Pq1cVG1sz7zsTkS65qrVCi8p7pQA0t2ZLdirnGUOndp9zEndIhv5MvEqh0jQUuXeawVgL
	 RHdoW+XTLOSskiE9MDTU1RGtLGWGsggYouoJ/iPZsxCvWpzFHoW294PQTAJjQCsUL2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kc/DLPhL2+hQ1dQiOwUyNzJSB6oYeCFK4LCV1GGN7ws=;
	b=2XGXMmHuQa9SSoVaofT3q+KerBpZ9fxn5d7qpze8UsCZfdj6S42rZ+d8zuGFiAfkXhu7
	 3c8IdhLSVdLdZotIjUVLL02uiPWpOG8EnOn8qGijIoel193EeyJmrrGaaODSiWR5hPgku
	 6yb6Yn3wixMpiecuiAky0rUHNuI3+QSgnxsSPAyb8f7O+zVKWvpvF7MpCKNiHiFwsm+o6
	 ikHoG8uVvOoPgIZlMOeX7uUZCVB0WOz1hv2042L3AWl1rk7Utu6lujBzyO1w8eZkVimib
	 /wBlvkAR3tfcKQc05pupGv0gkuyO4tp88V2GixPXtAeC+OdMF8GCNvF4gqqyJ5RdqCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ELuSoiRv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4212D606A31C;
	Wed, 18 Nov 2026 15:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ELuSoiRv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FFA1F000C4;
	Wed, 18 Nov 2026 15:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017202;
	bh=Kc/DLPhL2+hQ1dQiOwUyNzJSB6oYeCFK4LCV1GGN7ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ELuSoiRvUbl7GGykeHEqIVGL1B0bMdyZV33SSRD/b62fyXmWPnK4qaPSQYY4BIKEC
	 AEPzvQyDdz9B7Xi2Cdofrq3YUZ3jj1CML6WyHvFwSq8iIHPe2B/JMXGq7iNDy+ImLB
	 N0GMKT04swUJ2QVRC8Xn5tV+Kzg6UozjmETDZDy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0800/2651] ASoC: rt5616: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:34:00 +0100
Message-ID: <20261118150316.684166075@linuxfoundation.org>
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

[ Upstream commit 8fc9d353d5371a946d9a9952278b96c09070374c ]

rt5616_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: b1d15059957d ("ASoC: rt5616: add rt5616 codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-12-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5616.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5616.c b/sound/soc/codecs/rt5616.c
index 46ee412dc81db..73a3d1d008f41 100644
--- a/sound/soc/codecs/rt5616.c
+++ b/sound/soc/codecs/rt5616.c
@@ -1248,8 +1248,7 @@ static int rt5616_resume(struct snd_soc_component *component)
 	struct rt5616_priv *rt5616 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt5616->regmap, false);
-	regcache_sync(rt5616->regmap);
-	return 0;
+	return regcache_sync(rt5616->regmap);
 }
 #else
 #define rt5616_suspend NULL
-- 
2.53.0



