Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060846;
	b=joCpynT8rNgoO+LFM0CsychtaYBAv4Onu2/7VxqlT2AoI5LiabuESDLkFKI5nmjV7WSr
	 vckbYVmRS8S7TC91hgAv7Va9HIza3GI2c7C69isWhOoa6u2wN3k8MPVONh/u9vpOL/Eyj
	 HhtAZRSAyMtK2nQ0bv1MvxglVCNKLKBv8UdgSkeLejORjAMv+3hUoPiQmT7ZVW0ARMIhA
	 o3KhqGIamVJwDgVYe3Tytvj8iJryJlWnT9WZEH1J+s8bLHopjUKZnhIbEaD3eRTQX4xfZ
	 jOB+i6ZPdZ9lmHwBKnCjxGJXTNbNt6d53amK4iuObiNNwk2ygbyFXvKbvHvVtZCIDPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zs97iMVwYcjBlgpuYfPgxVOP+6ZL33ya19rClPbcwts=;
	b=pZQqmMaVzjyD/2UVxZ/eGq/M0ZiClTsddHkptpMSiNCD8FxkGsHtLLfU/s4vSpD4vHCU
	 hO68hzfLLQF9QEt5ACCGLq09n83G3rFGnJKhp1NSYI46E8oBJ670P2tSjWmpU+VHP1Liy
	 yDJ2by4tdgBq+4CvCqLPTb0Vy8qaGN7FG5u7fDx8gDOCtK0s5D+HFlbM+YIzPuJfoAPJi
	 +me4jxMyK8yMJIiA/OpYJhtmNdk09KTNKPcM6SmOefLch497ZOgJMmiUMg+I7U0SHuiGU
	 G4St6BhHVvr3PbVnxPaYPUX5P08jXEMt81jDKoCtqkianIpm4P6xQg9NXQ05vkqoDKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pNqTwKUk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C103B606A32A;
	Thu, 19 Nov 2026 04:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pNqTwKUk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26ACF1F000C4;
	Thu, 19 Nov 2026 04:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060846;
	bh=zs97iMVwYcjBlgpuYfPgxVOP+6ZL33ya19rClPbcwts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pNqTwKUkVHVU0ki2xHHfnCiySv0IE8dJMWenF4QISIr1/oXnYE0Xr+NZHPuBPcl57
	 v9t/263L259bFVw3/CLLq5JKC+2KWVu71BNvreXxOKuGitPT6E1B9KS/lmLrWre1dE
	 t4ttdiiAT6pTqZ7fEDoL+702PMcmG4Gcr39gikao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1346/1848] ASoC: rt1016: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:56:24 +0100
Message-ID: <20261118150016.016314784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a23d368ab4da4..5c3820c5104da 100644
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



