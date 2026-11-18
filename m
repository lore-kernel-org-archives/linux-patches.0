Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024378;
	b=RCYQWUPDqjPMBnfjoEH98pR94XBIv58HjL6ZxxIE09ZS9IRM0EKLYqTyH07+UycsJZLk
	 h3cwvqbA6LbM5v/Zmm7EA3yH2zapZJoeTDDmPQ0TldBj1/vPzVEvl6AQ6O1gnc8qGWvDU
	 LK0W9PZgtQVOvDbTFRgFPJrinpkCjuThMXAxuCQF/bI+kb8Jyls73ywT3CwkLlDubicor
	 vi1F0qC1uLCYouxDyxMIx6jaWsECpcrAWBtZZVZWl6QFjKB8I3d6yPY7ghKlEovdn/G5H
	 qUVA3x6nn5q5njrkKc+QgvoGZWsNqVXzuKuMsghoUkrFDw7Ms9L78n74CO5+yYxXINQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B09KaHp/xN/z3/6nbiJ2BlG5RVwOnKzdK1S0y58H2aM=;
	b=0y8RCPix59+m6/IQsYfFTHOHsocfDBHpA4+GbkH5T/syHFI3GmuzG9GrgLfML3T3NpDy
	 TlvotptwZIOThOL16/pyI6BkKLO96YPlaQDSQD/NmjPTNAfmFJl0gaFrlxDmg5qbp4+ok
	 eU9LBMxYVZd/ZCe5Dq93kB5AN4qNbmuSVA9jHMVkxuJENJTBpTtURXBYDxJOsjGyQUSTj
	 SzUUg+vII7hewQ9FDVWNrz9Mv15mqAksDIaq6VuqBWvynC+MXAqjNMh50Ydvr3nrIIyHd
	 Xj0AIdCSU5FMnaA8ltv69StETOB6uaydl5meYS4mOa6LA3BGFtL01e7Nt+OAAYBWrIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jddUn8Tb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C039606A320;
	Wed, 18 Nov 2026 17:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jddUn8Tb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C3B1F000C4;
	Wed, 18 Nov 2026 17:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024378;
	bh=B09KaHp/xN/z3/6nbiJ2BlG5RVwOnKzdK1S0y58H2aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jddUn8TbzdZj8UcR0e/SUbKLww6K14LwYbwmQK4TOhUl5Z/+AlyPKd2HNl1d7kSUe
	 G//BP2YR129kTn9SWmE/dnP+CEghlu8yx3qtyUFZmkmijpydDIFUU8U2NtJXRDekom
	 wXppFfNlSuDEuBDtZVAY/DJQtra35J6eLoUv54gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0705/2151] ASoC: rt5616: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:40:40 +0100
Message-ID: <20261118150147.567007597@linuxfoundation.org>
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
index 1ec486707ff94..ab4e70ea89f4e 100644
--- a/sound/soc/codecs/rt5616.c
+++ b/sound/soc/codecs/rt5616.c
@@ -1247,8 +1247,7 @@ static int rt5616_resume(struct snd_soc_component *component)
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



