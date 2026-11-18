Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017188;
	b=Vh17ycTIQ9J/vn+0qL6Mx1ImZx6ZeCdytQv/XAgOwta+vCgWaedW+VpkRnqqGkgmnwA6
	 iVUpimx4IV2XGPui01/HHXxD+V4tm9+pteSo8d8MwHbvx3H1+vlwXDIxKmxSLG5IP0KBj
	 5Abu453W3ZabqNb8HiMQdVr9vrRIZSD8rC+i2lR1EzjEJGRcxSUfkMNrWF4y5Vc3wjxOL
	 9t+dfZgrXT84EoqhZ+r1jiSp9Zbo6S5WatKVjMiULpdbQzo9HXUgcNF7ZKlUgLgHxa/oP
	 id2y2bNPF6tb74QfrKv1nXTQtp04LA2RdZ3sTJwNqNbTdgVA/IeQtnCCIbz8aqezymA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xvxPJYEujCq+Wh29YZc/f88rNPu+Vnsr+pEphqvxmAE=;
	b=AH504QqwS/BTFXYIHwXjPJmTdpu8YuYMKQyRgktZWOhoUOJgtzZ/qNg/9Pjj7NZephpB
	 +Vnfgze+Qei7b2+Tp95rAW2OQjvndrLfQB7ZzknEfPl0vxQ+BULdgHhsQG3Gsj0UWfH3u
	 mPQ111tawSS7NAcgod/SKqAgl4gtNJ9uRIvHxC5HOWVgb7074Db3R/C5h+NvAa9blHENY
	 oxmOIU6ana5y8F8qa4jov0s08pqSYdoOM3vE3EADSFM49PbIBEVjKozBlSSSWlHgnLlYD
	 1VfW1MZnJF+ybmFGTrXN5kFkERfltjP+mHy0o9OTtDpdbcBqrL3RNg5lhCO5JEDzpdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZRpr6PNg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87451606A320;
	Wed, 18 Nov 2026 15:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZRpr6PNg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5B61F000C4;
	Wed, 18 Nov 2026 15:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017188;
	bh=xvxPJYEujCq+Wh29YZc/f88rNPu+Vnsr+pEphqvxmAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZRpr6PNgqO4Zeipl4cnf6OSMHuMeG3eB5eGSOnbg4C/q8y425vR9I0wMesBEDVO09
	 aOI2+r3sbtDthOtfZwLPVM8uIC0n5eQk5oZXuMa0BkQ/A9vTkd2tPxhV9YWFSFeos/
	 RH7o4xUS5D0GrOkH0dCHqB+0R/X8ZY4yKIRcnuxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0796/2651] ASoC: rt1016: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:33:56 +0100
Message-ID: <20261118150316.534975796@linuxfoundation.org>
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
index 11c8c45574a13..12b97c04d033c 100644
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



