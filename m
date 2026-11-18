Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017205;
	b=ziJU44UeAwSN6ApbaEN4+pjK7kHeMy9tAfnWKdM6GtK6kloIvwOe5NkADEFdqwSbqWHK
	 QzsUAWiYUtuAACJ5FbGccI4w5DVZj3tby0Qb99cYKPuT+I9V2OsThR/w9dvKA+/gJJHd4
	 MDj7SmfiV/hEoYNuz3UNJODyaEenqxkV33vY+/R3C/hLC2rkdrjI1AuIjLet/djPW9IRj
	 Y+RNDYszsAxX8nOlRSu0jjL30qp1kqGeqOPclUwApFLxl7wdSEQtThfQKYlYnYxtdm6w3
	 5uS5JSTqO82BimqawKQCV4ZpOW8RYmGRF7I39vrn2LKsh/Ntf6YLykBJuO3OGEozwyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=COjx0N8Hh0vsRZD9L7D0m95YrwHyXGZ9LX1vzcKiwOM=;
	b=db0L6o4UP7kcFGoBASqPsWtIuHJlz61qqlrMDZz6V5pLySxEBMxtTs9AGtKbXshiRDOG
	 DLMFCSW6Y3FIP1n8rv9IHl4fJQBcyD7vjov362cP+zdp//ds4hYtMjo6BqfI4UDki7oW/
	 btPfLxKeMN7s2hHmdRhClvpUPPpoNOJ4+Sen+0xJ1hnOSIkM4TVr3GmuEj3+NDviEdvfT
	 TBWMiFqsAq27X+uUcziVBWF4IPs5pC0AEoDE/C70BDgq+DlgOhDE3nRTnoDakfjGlb56O
	 5dShPtS5IHcDof98uruwM9p3S4Lvn1Mh70iAgTyUMG+Kmzbg4xER+7tlfv+uUL0sLcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l17hZjuV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F12606A31C;
	Wed, 18 Nov 2026 15:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l17hZjuV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3731F000C4;
	Wed, 18 Nov 2026 15:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017205;
	bh=COjx0N8Hh0vsRZD9L7D0m95YrwHyXGZ9LX1vzcKiwOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l17hZjuV3scAQsiwn8WtubmKqkUGUgSslfP07YLR5ysx56JZ0XdFRlMUWEqBZmmRd
	 F6dcuVn6kU3d2RvS3KuocgrnGdObMsy4+LU0Dimk/qddpYQyW09NwLP4Z325Q3f6uF
	 HituXFtxKbMpl+KwjfVtTrGEGiGjxnRJ0ie8Lzx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0801/2651] ASoC: rt5659: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:34:01 +0100
Message-ID: <20261118150316.716314193@linuxfoundation.org>
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
index 3097ee6d4e89f..915b6b4b2630a 100644
--- a/sound/soc/codecs/rt5659.c
+++ b/sound/soc/codecs/rt5659.c
@@ -3703,9 +3703,7 @@ static int rt5659_resume(struct snd_soc_component *component)
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



