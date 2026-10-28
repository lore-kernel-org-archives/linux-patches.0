Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207488;
	b=P94h4aUHu52vW/IMdho3EppSy/L8Iv08XGFtUX7p/C2d2baqZcbmKwlOt/2zsmRO1gb3
	 Z8JKzEB3xop6xSmon5V7nvXqKvHiGwpr4RSxtVJ5DqEaxtZTBvwz1y7Q8lCohDGzsy4l+
	 cmvqfQEoVWtz6RTkdOxHOdiCJ7xiL1+SB6Fr1JzUOEqyWTKwErGFMaSt0sCGIg16bhMzs
	 vzTDytgz91NnhUH3jE29IlifSeBfhICQCrD/5IF1TcWg0F19AiSmPV9pQb9fjqYLcgGm8
	 Y2V2b06EXTaAJ4IElZiRa2ofpMdiyHZqNuOQbtQTOQYyAyO+KWlSqTmSssTV6KPIQAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jZblX0CbneEdqdBruIMtZ/Zo+SElIvXhQtWD0iTwa0A=;
	b=H2Dl4ZjNt/+FF/b/lBcWggpwJEzm9L9BiU00x5JwCiOR9SU6WjoSFkQT8XVTA4b9leCL
	 wLFAJkWf+2NMaLDahXQcFJi4DlOi62WzEt6HssHF0T20+NIKy8o93gf75bhUdk4e07W0e
	 f91CPDmiCJ0AgQhBwbqwEywF++5OXsCj7bXuLqxJ+/cvjsXOLWWocOKNpzkpYMWTUI4yT
	 wG/XPsXo0b02cuybsNkG+t90+Di19QcjoY8HBuYmm5ENXXcQw1/OucrJmIXU1zIuRUKz8
	 k6rJmI+HSCpmrklej4l9986VcFgEzGTf4aVk8NI3fTXpyZih8gYmKbwYWjG7oeAbunA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uqg720v4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42612606A337;
	Wed, 28 Oct 2026 17:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uqg720v4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EC11F031E4;
	Wed, 28 Oct 2026 17:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207488;
	bh=jZblX0CbneEdqdBruIMtZ/Zo+SElIvXhQtWD0iTwa0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uqg720v4YFhxIInvC2mS8S0GPJnTVekal40CL5VJwKMXBqoiGN6WDiEQmPZbvunzU
	 NeRq7HaasW3hUFIRoxxErMcVdDJWqXLrobt5vHHEtz2x8fJU0ZNCBStuklq+elPnj/
	 P4g+6f8Wf2ixXPxlqJnxl9fVsilySAz9t5RrDlU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/247] ASoC: pcm3168a: Fix the DAC zero flag polarity bit
Date: Wed, 28 Oct 2026 17:57:16 +0100
Message-ID: <20261028165948.149809170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit b26edc925c1cfa0184cd270ed81d4833db045ce0 ]

The DAC Zero Flag Polarity enum uses PCM3168A_DAC_ATSPDA_SHIFT, which
is bit 6 of register 70. That bit is ATSPDA, the attenuation speed,
which the DAC Volume Rate Multiplier enum already owns. The datasheet
puts ZREV, the zero flag polarity, at bit 0. The header defines
PCM3168A_DAC_ZREV_SHIFT for it, but nothing uses it.

So changing the zero flag polarity changes the attenuation speed, and
ZREV cannot be set.

Use PCM3168A_DAC_ZREV_SHIFT.

Fixes: a9b17a638af5 ("ASoC: pcm3168a: Add driver for pcm3168a codec")
Link: https://www.ti.com/lit/ds/symlink/pcm3168a.pdf
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261008130953.2446692-4-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/pcm3168a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/pcm3168a.c b/sound/soc/codecs/pcm3168a.c
index ad1564e7d8faa..ce68b239b9ef9 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -103,7 +103,7 @@ static SOC_ENUM_SINGLE_DECL(pcm3168a_dac_zf_func, PCM3168A_DAC_ATT_DEMP_ZF,
 static const char *const pcm3168a_pol[] = { "Active High", "Active Low" };
 
 static SOC_ENUM_SINGLE_DECL(pcm3168a_dac_zf_pol, PCM3168A_DAC_ATT_DEMP_ZF,
-		PCM3168A_DAC_ATSPDA_SHIFT, pcm3168a_pol);
+		PCM3168A_DAC_ZREV_SHIFT, pcm3168a_pol);
 
 static const char *const pcm3168a_con[] = { "Differential", "Single-Ended" };
 
-- 
2.53.0



