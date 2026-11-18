Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055360;
	b=Rj8ZBXjyBph5UmWFzO9OiaP5oertJW2DMIySrVsG5CBZt5fE+Y4brHhzvLEQBH6Z3FoJ
	 P9Z2iMtmg0rI8WP89rcXxys20cEBZVqnGZ1c1bqXBI0EJ9YTjsKCZMDFqcrCVbFwpynB3
	 HI3hgv6eb0SKucKIF3QLCYewiuoWG0zAFU1PCuTgY0Ac24DBzI2kS0Ole3dw7XEgy/mwt
	 DtinjMBfXgy6UP0wEnVNbiSVZgqor5sAEigQ7l1YAC7g4v3wGVRifXh/QNkf+Jyp0PIH6
	 G2EEe0zG8cUEZtIK8A4ZBKWAn92EMyx+33mYapNJyZBSa4zibmQlNJO8WrnZ/GHg7sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Le2fVV6drbMBa4ab+Nm8Yaak+bIg0Tf3ntAQcmV6bso=;
	b=siyUnf5ceBGeN1cZWG/IoVjYAb4vyuKSElDEQiPF9WTh8YG6BoIJ4oFZVCpwsDbjCITQ
	 JKXHxahVP9332IqKo/qO9bJ5WiBERyI/QMsIQ7vhxKSwU2r81zdG6gTSpTZXmckJNmPeY
	 kcrojto9lfh6EUKMyH5fEmZHarTBOSH9VzBxsBMuCar0rnLgw8slk88i5kkDp1zOab8sL
	 H0OtvCLpqGpAh+9vfzmCaRhNIm1eJgm9AIc4ylSlvpAis8NzTVOcHKhIkP/dmub6YCXFu
	 Bda6QeYZzeyts2H/MVOIsQZ5FYETpb8Jg23qdxEcG2t2BIg4a1SQwSw5JxkEEwjpK6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ObS+DSOj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8701260A260A;
	Thu, 19 Nov 2026 02:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ObS+DSOj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62701F000C7;
	Thu, 19 Nov 2026 02:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055360;
	bh=Le2fVV6drbMBa4ab+Nm8Yaak+bIg0Tf3ntAQcmV6bso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ObS+DSOjfg8bwqUogWrawCHCWflmMGx4d5g33ejJzKxgKMS9k1mPUFpGQZ1F1lnLZ
	 8KxIgG10BgpPEM5Wg2/hcOL4WAWXcCmTzs1ib3tHNjJ6yJXAU33XoMRuB3VVhhp4kK
	 nPFPotpv2VstGZkT8f4jRluAeXziVfKa3pjGwhq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1604/2214] ASoC: rt5660: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:54:40 +0100
Message-ID: <20261118150116.125241427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 70fe8997b03078ff8253d985a161fef310f7c346 ]

rt5660_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The power-off resume delay remains ordered before the cache replay.

The issue was found by a tool we developed.

Fixes: 2b26dd4c1fc5 ("ASoC: rt5660: add rt5660 codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-14-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5660.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt5660.c b/sound/soc/codecs/rt5660.c
index 33ff9156358b4..596b3b8acc342 100644
--- a/sound/soc/codecs/rt5660.c
+++ b/sound/soc/codecs/rt5660.c
@@ -1152,9 +1152,7 @@ static int rt5660_resume(struct snd_soc_component *component)
 		msleep(350);
 
 	regcache_cache_only(rt5660->regmap, false);
-	regcache_sync(rt5660->regmap);
-
-	return 0;
+	return regcache_sync(rt5660->regmap);
 }
 #else
 #define rt5660_suspend NULL
-- 
2.53.0



