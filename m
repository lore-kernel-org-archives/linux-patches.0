Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042385;
	b=r0m8h3+h4B4LS7BfqW3huEQlAEkgy5F1TNMds0bZ+Mxtz1S/ypyEeEhGXFqrKDCwEc16
	 LF14HXITUtP3bK3zYtPOzyc32SkqfKY/1KTKQ0FV/DMxodYK6NuQrs00gvMUMomndRWq7
	 dqSkR4FlHCVDZqR7YFGd3dd29SItkRHgQbCO9uspa9V9DGYU5UurAiFzFRkw7Hmg2HiBQ
	 9LzCKXCGGktVYI9EgRVc04mTbrm0jETgksFuCF84MaD3Ygzv9Bm9aFk3ihYEPngj7l81Y
	 XygBxng4E2Ls/RkJB/YkxARfim3/e4EpeWkdSzYM+k9BMC1f2VK2+c+XElW/PuPN4Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=crh7UO3HYchVa6SY5q5AYT0iSYOA+Z61tfRSXi/sbNw=;
	b=FkpFbLaToQAJdW9xeN5Cx6Y5/O9rjsiGPSfpdGlc+IgIhGT85nYl8dqtauRkRmjzTNSY
	 itkK5E/p5XfuiAXKRrJxJEYu7xvid2qQZdb8N5bDEN1l7clze6HzWP2wzQFnc3ZFgLRvX
	 Z1DRDNKiclIRLwXPmjgSlh4+7q4i0he5rJfLa+FulkRRMgI8Qjbv90XCjTtCocBLsM+vJ
	 FFAS6MY4eesjsk/6XowO1uo5a+gDqiNf8+yvCRsvB3zAYDv3/8CQjeszsfrs3lcmVfUfO
	 qGH4ZNPxeqXs9z/So9wTqNVLUzd6Y+26+fbhsPalu/Dj5AgRWmPfcR1chru3yQIoirQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OyPtMwHy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA5F606A31C;
	Wed, 18 Nov 2026 22:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OyPtMwHy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06D71F000C4;
	Wed, 18 Nov 2026 22:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042385;
	bh=crh7UO3HYchVa6SY5q5AYT0iSYOA+Z61tfRSXi/sbNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OyPtMwHyi2klkKNP1IpIp60EVuTqyeRyQ8dHYmzoBOZBTC+nqiYgiraGYa++SDdLq
	 esDnOx1NnNNXXDEqOsDbxXE19mcJDU23XGY4Bv4szmnbPOOTLvf+Ck542sIPl+dNoh
	 qU8K6Ek4j2O0F2YFw19DJm5ZFycUhHn6VPgc2g38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3115/3318] ASoC: samsung: Use snd_soc_substream_to_rtd() for accessing private_data
Date: Wed, 18 Nov 2026 16:02:17 +0100
Message-ID: <20261118150453.402916825@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 3e726593107d134221f666b4f2be612b278c3ddb ]

Do not open-code snd_soc_substream_to_rtd().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240430-asoc-snd-substream-clean-v1-12-6f8a8902b479@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: d9c23ac1217a ("ASoC: samsung: midas_wm1811: run FLL1 at the AIF1 configured rate when idle")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/midas_wm1811.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/samsung/midas_wm1811.c b/sound/soc/samsung/midas_wm1811.c
index 2ec7e16ddfa21..9ac5452b537e8 100644
--- a/sound/soc/samsung/midas_wm1811.c
+++ b/sound/soc/samsung/midas_wm1811.c
@@ -129,7 +129,7 @@ static int midas_stop_fll1(struct snd_soc_pcm_runtime *rtd)
 static int midas_aif1_hw_params(struct snd_pcm_substream *substream,
 				struct snd_pcm_hw_params *params)
 {
-	struct snd_soc_pcm_runtime *rtd	= substream->private_data;
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	unsigned int pll_out;
 
 	/* AIF1CLK should be at least 3MHz for "optimal performance" */
-- 
2.53.0



