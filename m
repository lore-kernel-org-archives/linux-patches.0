Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048572;
	b=Yw4uX9t3Rd7tJFPkfBFL234qVxB1LxjIx2eiXHE0JKWFTc7kihF84M+2T+/u1oRYHHmG
	 IeMwwnRo0W4xkUYyrh6y1ic/dOQHCBekN2diBDYfBIZba6vLCgSqnLF+t2g4VXKzOoyCA
	 s66OUCYBjzgxZMIBH1VbdprpflGS2iQiFrXlYnE/haLOOp1uh22wPQUNbsAKL1Jbazb8j
	 ZZhVDuOCWvQuNsuvwsigFX8WqI68wZG2TzjXBFp5uvmpYNOsuGh3H8JuHYGciDU9S+1Mu
	 dEuA8SLO7lGAaJjZdM07sLv8oO9CQ7VcNk5Pb68rJyqCJ0i8zU/AhfSVYCu5LHZyAdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kuivaCs8XTysFiBQJjPPgmtzH3HSyMPdrC92ytnF/+o=;
	b=10OEZh67iRVKfUQxa2aRZP9ElXzOabsgnCDlHMhQ/WH6y9tK/+88XxOaujzDe5fUqPmA
	 W96fXZg/myZQ3mqAJFXKmkSHOXiJ1MBBe2yDdfvUsNMJCayMfZX2/kwwoI5V3eBI9SU5Z
	 ndvnMKumtcxZFAPn1L6O0A+whNZesyt+8rxrJ7/2AKUM8z2sJaYHZ8mylSaNkFvviqGwS
	 YJOOiuEN6JVuVrWhencI9lQK36nvu7lfF01vFk74IhL/o5iM75Lfbc+UeCYyHAagTeCbU
	 Nop1s4OjCyaxmin43LFKUBPrF2VyVjJF/u0y3dMaIuQJOJQrvrasqk9ASbBh8JNpgyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d9AHY8i9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E33606A32C;
	Thu, 19 Nov 2026 00:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d9AHY8i9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9461F000C4;
	Thu, 19 Nov 2026 00:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048572;
	bh=kuivaCs8XTysFiBQJjPPgmtzH3HSyMPdrC92ytnF/+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d9AHY8i9oW9MB4g5++YL0+xbcgT1yx/Jh1w2RjrtF0vtSngwqth9FP1uXVW/2uUer
	 wXpy9QeShshMXb4xkVPc1/gIrDIqjVtQWUIEvT0uKt+2e//KNPQ0zfKDXjiXMMChei
	 Jp4n6BnMe6TFX5zxD96d3HLvY8z/tvr2IWllqDoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2043/2857] ASoC: adau17x1: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:51:17 +0100
Message-ID: <20261118150314.973979376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 8ca84987c11d11e0ba60f202e3199b3b80c87721 ]

adau17x1_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The optional switch-mode callback remains ordered before the cache
replay.

The issue was found by a tool we developed.

Fixes: 4101866c743a ("ASoC: Add ADAU1X61 and ADAU1X81 CODECs common code")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-2-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/adau17x1.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/adau17x1.c b/sound/soc/codecs/adau17x1.c
index c0f44ecef6067..aae4ebf624793 100644
--- a/sound/soc/codecs/adau17x1.c
+++ b/sound/soc/codecs/adau17x1.c
@@ -990,9 +990,7 @@ int adau17x1_resume(struct snd_soc_component *component)
 	if (adau->switch_mode)
 		adau->switch_mode(component->dev);
 
-	regcache_sync(adau->regmap);
-
-	return 0;
+	return regcache_sync(adau->regmap);
 }
 EXPORT_SYMBOL_GPL(adau17x1_resume);
 
-- 
2.53.0



