Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056232;
	b=4ChQyM5LLNwwyvTNa/NWQu798ws5KZmqb6tUQHy4yVIh9UiJkuYWcgQEza6FNn2jYHPW
	 7jCRyLULBvyE+xLWC5/754782vzbNiGteW0ErBVadz2qhcSz1Ydd2f5iLXNV9rvLnLs0P
	 1Bm3Cc3pMcM8ig84Kq4oYJAEfpATb3a6Q0js+jsFhv04srP+m6h4rkwuasJWf/8wdz47a
	 Am0xK6OG7a3Oaey63hss3NJgWpBeCjFMmE5GDMkv5bJHdpVdXPDdhhMJUyTLf4Q4xzgQY
	 qWDd6wGXDAdAfreNTAiUQWgF7IsM2b8dFIbevYOTDtsb6hA5rQqOBVTQLxKjD9NU9Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IpNx3EBBlVzQFOGgiyxs2xgHZNxKlZdvCOivQbnTJI0=;
	b=XtTd6ndPrP8KUT6169GwPS5wNBlpxxVMlLhltG79BzPXYhaIcqJCa9B9aJveGPf+pUSM
	 rbJ/I6KL4wpacyyAtRSO7W0OdDBKXomfeZmbtEQl90BDPvhM3HDDbJLeOKEIgw7Ue223K
	 V1BLiSOHCwhND6gCMZ07d0TxqHQ6TGDRCrhDW5Bpc4nRGg/jBcwB0+2Tb0KLRF3em6Zzk
	 pkpfRwtVaM1IoB12STcAXg/TaRmXi8WJnm2r3cc+hHVFFd1aoC3Z7+oSqJnlmYkzCDfSf
	 9RJBZEt4FYvXX5uvvOEpQ2DJ/bgJ3Lhjd6OV4W69OAqc1wNaqY6YGyxld1kJNJO8vHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VEh6cdhh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E18606A320;
	Thu, 19 Nov 2026 02:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VEh6cdhh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1303B1F000C4;
	Thu, 19 Nov 2026 02:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056232;
	bh=IpNx3EBBlVzQFOGgiyxs2xgHZNxKlZdvCOivQbnTJI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VEh6cdhhsm2B5pCp0kqNh1qOQDR7D7XNjYcAoip5YbqRrJKDdLGN7utiAFoLSHMQx
	 iG3u64SSIOJ9ZQj6MZsrRPF6/1G338TvX1cYTKoUiNSpJi+4ZY2ruTmQiLOMpL6bOV
	 svL+AJK9a6mkWx/2Tf0dHyoOGfzAR4P+4cYhULJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1915/2214] ASoC: codecs: wm8990: Fix definition of LOMIX AINLMUX Bypass Volume control
Date: Wed, 18 Nov 2026 15:59:51 +0100
Message-ID: <20261118150127.680953833@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 75e0b607e3456c9eb15dfb783984f814a89cbcaf ]

The LOMIX AINLMUX bypass volume (LLBLOVOL) is at bits 2:0 of Output
Mixer5, not at bits 5:3, which hold the AINRMUX bypass volume
(LRBLOVOL).

Fixes: f10485e79882 ("[ALSA] ASoC: Add WM8990 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/87b3bfa7711b61d89c21044d02fb3242dd934385.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8990.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index 5a1570598771c..3c78a9c8a78f9 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -112,7 +112,7 @@ SOC_SINGLE_TLV("LOMIX RIN3 Bypass Volume", WM8990_OUTPUT_MIXER5,
 SOC_SINGLE_TLV("LOMIX AINRMUX Bypass Volume", WM8990_OUTPUT_MIXER5,
 	WM8990_LRBLOVOL_SHIFT, WM8990_LRBLOVOL_MASK, 1, out_mix_tlv),
 SOC_SINGLE_TLV("LOMIX AINLMUX Bypass Volume", WM8990_OUTPUT_MIXER5,
-	WM8990_LRBLOVOL_SHIFT, WM8990_LRBLOVOL_MASK, 1, out_mix_tlv),
+	WM8990_LLBLOVOL_SHIFT, WM8990_LLBLOVOL_MASK, 1, out_mix_tlv),
 
 /* ROMIX */
 SOC_SINGLE_TLV("ROMIX RIN3 Bypass Volume", WM8990_OUTPUT_MIXER4,
-- 
2.53.0



