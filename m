Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774432;
	b=OQpiODtE2vIIzw4AVaaLn3M1gZI/iDxgjuD8ksP7pgp+0TZYVxDXK4ylYnYc9vLzg5eF
	 p8OtIsDwIEuRGm7W0BJZiR+cD08NNiuBQpKudL1UesPCnx2C/d1ULc+PEbL7C4mpOMDHv
	 Jz56n1g6rcmeXGQ9yCtXakKmRgtlhkVnt3Y56N5dQUJQDHa0DjVtR/7luycBXSZ9OkEYL
	 EpXqtwzyWeL6Xhxse3Iy2Z8soQuR90vpe/GxWc00EROpZImqESzsbuKxHBSq4G18HEQRq
	 d3tkkTdtRwVHoHc7qly+ZGa2RNUgV0Dt9al4g8XUj4Y4kfJ5hMa31vnrXtm5yhfHNRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bwBoK8LYKa6OTJdKxlv6TlWBM7IrWdPuWfeSYoJWxHI=;
	b=uyWRzqmPoPETg5d78f21nmXvhJBVQgQzLhWTsR3nAEuBDRwP7OUSp13DA5FigPB33bpm
	 nm5+SMhr9752csBtjqHIJ/zcjlMCviBWH36lLA9K5SOUsypeEgJzyzj0/iVtYfODswbkI
	 twLbsEPD3z8+SReUif72p3ysXzfA6tJpJOvxRZOGU+nFRN4Tbn1WPJ5bJoeP7ZabyFr57
	 HjVQUAZotEQcUpPhqoXXZAj5oLR+YJfPSCfl3/5o1mfY/QIagnG51LA0oxaEvIC7YebrC
	 ukFWU1Luqdt95zYhvLJ5a29eSmPY0MS4tThvqbLDr3nSoyz9bpzIAeIHWJfhWnmz97Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJfDFOQm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1AC606A31A;
	Fri, 23 Oct 2026 16:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJfDFOQm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA251F01825;
	Fri, 23 Oct 2026 16:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774431;
	bh=bwBoK8LYKa6OTJdKxlv6TlWBM7IrWdPuWfeSYoJWxHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJfDFOQmZJui1VRfbCh0g8Pcd6YzTqrpmDH/BuF67UyeyZAx7jGJuxWyRF4Ep61Nr
	 JWBte6Guszku/glAeoYisF/uwjMVJtnNSXDORqsrvVGXxX/orKwpdVTsX2omjSLOEm
	 RzLnkGJXKtRtTiESWslVyh/FB2PNx5NpO0AQQoBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 037/242] ASoC: wm8978: Fix the 128x oversampling switch bits
Date: Fri, 23 Oct 2026 18:37:59 +0200
Message-ID: <20261023163714.656746527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit d0567ca9a2faa33efbe5ae84ef7b86423a93bffd ]

The DAC and ADC 128x Oversampling Switches use bit 5 of R10 and R14.
Table 66 of the WM8978 datasheet puts DACOSR128 and ADCOSR128 at bit 3
of those registers.

In R14, bit 5 is inside HPFCUT[6:4], which the High Pass Cut Off
control owns. So turning on ADC oversampling changes the high pass
cut-off, and the oversampling bit cannot be set. In R10, bit 5 is
reserved, so the DAC switch has no effect.

Use bit 3 for both.

Fixes: 823dba519122 ("ASoC: Fix broken bitfield definitions in WM8978")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-6-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8978.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
index ad8064bbaaac8..e40ba4d43ada0 100644
--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -255,9 +255,9 @@ static const struct snd_kcontrol_new wm8978_snd_controls[] = {
 
 	/* DAC / ADC oversampling */
 	SOC_SINGLE("DAC 128x Oversampling Switch", WM8978_DAC_CONTROL,
-		   5, 1, 0),
+		   3, 1, 0),
 	SOC_SINGLE("ADC 128x Oversampling Switch", WM8978_ADC_CONTROL,
-		   5, 1, 0),
+		   3, 1, 0),
 };
 
 /* Mixer #1: Output (OUT1, OUT2) Mixer: mix AUX, Input mixer output and DAC */
-- 
2.53.0



