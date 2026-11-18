Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048597;
	b=Vu1XED2zPgeP+sME2S3A43C1QaTEd+KZPtDfcrrzzKMxyC1mFp/dBfHdPIKg66AS8/V/
	 G+QfBbxghVpu3r3Ky8/RtmQzMfooRZTPNikwR7emYG0gEjhrfzTZZFdG/twm1/2Eix5Ad
	 VENIDYdRxQL42fahkflnwC5YbjjBWEeWDNJoSldD721MU+L7XbegCg1p9S+Tt1ErW3rPA
	 XahLLR84ZD5PwDzjnfr1f+oRPDjol4kdXsmSfmxdk2pXHyuw4BFwR4GGBjWU3pvV3KSwV
	 V5QX0Q4wQK5XOZ0/KYGzYYEPluM3mIkWdUTY0DRBS28Ao3MiKXTVudAHbEZp74AZF4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NyhpYWkdCGcNgZCrV2qeK2L2bSAFZIyAjIThbMA3SpM=;
	b=siH3Kr+g3xFWuIRRq9z1gKAuv5I7RwOTPJR31PRfE1Cpt4MZT+grh2LMkQBfMUUtnWcV
	 rWVbcxwhxdqr3jWCPDW6Ki8QguZDJnlezaNd5O6+nRMbjc5WJP6ad9rfT9Fo4sThcQ4Tr
	 kIm9Dntb1Bo/DpE2X5XW4a3TJy4PGREEGkdvAmzINkhAZpV8R8rj1Da+wucrcie/bV7r9
	 BRaC2xW1wCbycsM9Lgxd1zN7qCn3c7+yIyaoRcegfzD/7Gb33xPW4NNytDIPwMLV0ArR+
	 CMLNM4QYGKA8NF++qrJ4luuGX7xbXkRO4mJyeb3ixNHUASl7B8mk61khb/veInu6xZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OU+1pF9g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554F0606A325;
	Thu, 19 Nov 2026 00:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OU+1pF9g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E881F000C4;
	Thu, 19 Nov 2026 00:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048597;
	bh=NyhpYWkdCGcNgZCrV2qeK2L2bSAFZIyAjIThbMA3SpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OU+1pF9gkqumkFDAIGsG56ZTDbOUqfucgZW6HEI5ovs9u301zRg3eRpO9D6vBFN3z
	 c7HvQwV+kRaQlj8scT4e0ZmrdUgRmHLq6R3tzv6FdqkYpVSyD0jJ2xa6fp7RCTnOx7
	 guCD2a/0UUxAVCFHAoqfEguqpvUtu6kRORLA0r0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2051/2857] ASoC: rt5616: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:51:25 +0100
Message-ID: <20261118150315.270652313@linuxfoundation.org>
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
index 948abde10463e..933d8bfbe0ab8 100644
--- a/sound/soc/codecs/rt5616.c
+++ b/sound/soc/codecs/rt5616.c
@@ -1250,8 +1250,7 @@ static int rt5616_resume(struct snd_soc_component *component)
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



