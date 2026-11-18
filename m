Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040143;
	b=DUnxUrcj8sKF3Gs/KXQjucYDV7TPyGJt3YNbZcNqjRkWVK93Af0esEySS0JQLxFyxqJg
	 YPi8m0uCDap4V7Y1TBNBqW+1wjbL1LOcwgt7rfdfAUo8vItpmUeUJyw6ehpGTDopy9Ves
	 NQ27KKuMwbzQ9FBO0fNMI8h98JvGJQruzHRqRTu1SvHx10SSNQgI+dkV25Lf7tIS62ZSs
	 U8VzmoCh+rp41dPCVcfd1yxcSAvlAdE6TAS3u0Y7B+3tYMm4bRRjzUhUN+9XAtL/5WfMF
	 8uX8+MIIGCHRKp7sHc3ViRG+/pKTKmYsqmf9r/OfKbZLdOSIE/FNkmCf8fm002nJdEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o89Nt0r2Yt71mrxgZx6xsvmSlZpCIlUhlL6uVt+nVhM=;
	b=VbVFgNeC0qUkYZGrS7hi7CkTQyX7LW35G7wnAoZKAAqnogUfJZ6BPo8mbr30zMNbO3ho
	 oGZFF4q6PvDDquizzQVr2Qyb/LOwf+OJX52GmzJtBcUHdNvJvY31COF44smFMS878gOS7
	 pEnZB1NbHIkwshcXqb/fEIV9nwTkX/1Pdq9vug5TXYyCqQ3ozvxLMmkw0RhlrLT3geSnG
	 8bnY6BN+wJUxoEdKhFagwV3UVrhaYPz9NbOo8JMQ8UAVhxgszUm//5j5PowjT+RoBNOpu
	 xHeRZs/5+p5IODittZaFl1adt/f4+/IbVZ8S1Xyl4erKLQTQuZalRoP3Jp3hwAfclfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfx8asQJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D724606A330;
	Wed, 18 Nov 2026 22:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfx8asQJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72B31F000D1;
	Wed, 18 Nov 2026 22:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040143;
	bh=o89Nt0r2Yt71mrxgZx6xsvmSlZpCIlUhlL6uVt+nVhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfx8asQJOg9hxKoMH4EN149jI5fO4drXo6PB7t1+RDoXGOBl80ehgkEUB+bKP7wPL
	 aluAMThdBqSmyJtOAm1WCUw9zCm7dPeH3gJCQ+KMfoP03x5m8DHBjPjMehz1srF2sE
	 w1ilcqQ65Le/yqsVd2wSrXTf8ae6Jp3Ly9ZdmM98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2351/3318] ASoC: rt1016: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:49:33 +0100
Message-ID: <20261118150432.139208519@linuxfoundation.org>
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

[ Upstream commit 98ace05793c7b80a9f49d92b78fcc88e0970f8e4 ]

rt1016_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 79a4b670b4b4 ("ASoC: rt1016: Add the rt1016 support")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-8-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1016.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1016.c b/sound/soc/codecs/rt1016.c
index 919a1f25e584d..2932f38d7f0f5 100644
--- a/sound/soc/codecs/rt1016.c
+++ b/sound/soc/codecs/rt1016.c
@@ -570,9 +570,7 @@ static int rt1016_resume(struct snd_soc_component *component)
 	struct rt1016_priv *rt1016 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1016->regmap, false);
-	regcache_sync(rt1016->regmap);
-
-	return 0;
+	return regcache_sync(rt1016->regmap);
 }
 #else
 #define rt1016_suspend NULL
-- 
2.53.0



