Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049333;
	b=DjAt+dnzdwkQNw8Ti0mJzJs1DVH5okpQvGEmQHNA1qDFP026IFcha1prCgSE/K76aVlt
	 LExw28BAdcClB122FpU1IeWC/taQjcu9KvJoJPSCJNzie5Zpes6c2f9ZTvxd6Dpq88Jo0
	 hoSZYBnmZaS3waCODK92HIo8jWJpb/7I8FTZLIZJXb508RccNTeMzHnN1R215YTlVpFPV
	 l21/bhD7lMEwp4gUKXyZSySUKd3TGwdU8NfAI8Ws8kQyacICLKfth4+sx86XWNZuQ2UCu
	 myGFTj4yV6HzsBnkoweXK2T37VmSU9Wa3LKxjLRQGbvaaEB1dzCx9p9eWLLF42Cb8gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9jLlkPou94QLBYtVMMpSiT3fvkj4Fp+nFCjn67u58v8=;
	b=hmJPMp9aYHRlxMMP9M5syxrUieBwNOsm7NkbSViwGXg2ivEQdOvvLmXqN99626fpBvmu
	 jlT4Pw0Wua5oOtgAx31oyKH/wVqcC9WvZOR68MKU21UflqwHtatUrjgSzSclrVdTT2jp0
	 tUIfX/nx5FUL8+DaTbDNq70jgvAPGT4u4zC75JSHlUsYusAuJ6diO0sFC1S+ljRLpoo1a
	 cN1KLjArNrvBwARV2N523Q9PNZbN4r47O5tedNltoIHk/wI8fe1A5IM12/6ASdqX5GZap
	 35J4emd6biespvoh9NexKYLty0YU/vc3z0xdOmKOJfIsM8JRZj+or73pOjPud+iH7yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPmbIVQU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F82860A2606;
	Thu, 19 Nov 2026 00:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPmbIVQU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18CF1F000C5;
	Thu, 19 Nov 2026 00:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049333;
	bh=9jLlkPou94QLBYtVMMpSiT3fvkj4Fp+nFCjn67u58v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPmbIVQUuxJHsnM+Er5vp1a3YOVkATC53Xx5YEhJ6j2LyBQLaK8klL8SHeJruujtm
	 N9Jy8qWMSaNDsF+3EKV8liH1VWQ6YU3ZREy9uKXTST/Eq7GHYVQVoKSNL1n3M+0oCo
	 +fRGUAshc236l2N4Yy4TjalgTcO3vVPlOkpki6o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2312/2857] ASoC: rockchip: rockchip_i2s: Handle runtime PM resume failures in set_fmt
Date: Wed, 18 Nov 2026 15:55:46 +0100
Message-ID: <20261118150324.752068923@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit e9eb1854d16136006c6fe94c927b54b2b264b429 ]

rockchip_i2s_set_fmt() calls pm_runtime_get_sync() before accessing
hardware registers, but ignores its return value.
If the runtime resume fails, the function continues to perform register
accesses while the device state is undefined.
Replace pm_runtime_get_sync() with pm_runtime_resume_and_get() and
return early on failure to avoid unpowered register accesses.

Fixes: 53ca9b9777b9 ("ASoC: rockchip: i2s: Fix regmap_ops hang")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260903112739.373621-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_i2s.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index a8758ad68442d..8c3bd7940691e 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -245,7 +245,9 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 	unsigned int mask = 0, val = 0;
 	int ret = 0;
 
-	pm_runtime_get_sync(cpu_dai->dev);
+	ret = pm_runtime_resume_and_get(cpu_dai->dev);
+	if (ret)
+		return ret;
 	mask = I2S_CKR_MSS_MASK;
 	switch (fmt & SND_SOC_DAIFMT_CLOCK_PROVIDER_MASK) {
 	case SND_SOC_DAIFMT_BP_FP:
-- 
2.53.0



