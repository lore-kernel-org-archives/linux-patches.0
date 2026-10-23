Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773838;
	b=1qIXtYQnKl8DoXNn/AYm2c+aHH/4LgeCW3Z4HXI2wqx35lkrQ5DOjGjhb1+zv0fZorxv
	 HMRQXvDavvAIby0FxNQFeOEV62Y7hSuMDIoly6OoIfR6rYhS/y05kpE99RlHukMx+e0yH
	 Lbqx1kZGgmFzsEctEP4YmTS7o1DJVb4JJ1hyodT+YVdS3llkGk2qLrOunBm7uQ+IOcDnx
	 o6tdJZOGZKH2CLvrGqcCoIbGca6FhS/OT0cq4nk7qQ82PYOCcooENbsayMiVcCMyKwe82
	 KQAwUYL1Q5oXTJ4N6lhLJha8iIQPhhDJsTdX/kw6rmrkdTRFTycNUNeRqv+J32aF0/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wQdCOl8S2DcCJgYZs5naSlQBCwXJvMSRLWOENrr89zE=;
	b=HdGvu7a5r8Y3jJA3ijX3gOQIJ35jDzojnFXDBno/dle83zTH2qXH8Gxz+8J2YMp0m63E
	 WEzOhQPdw5f0ruT/kltR66qLE0lMoht2ZZX9hpWcZfWSmDZnaTZeZu08z//Gicl+/egW5
	 iCtJOX00/U7bElTzjHcVpX/621EtyEQ0MUJomQcCUq8HxTT8kdia0Xd6Z75jKXO1DOTuU
	 /pTh5osPDXElx48GJ03rgRBPnuuPUV2gRkS08s4Wp/zam+iP32ni2H3EYVdxFrgvo3W03
	 +UYvLnXEto9CqCbeFcSCLe23oOvSziTgmq/ifOyoMIW43AAx7RXt7X4fzshP9BQA9Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ezkpBmEJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBEE606A31F;
	Fri, 23 Oct 2026 16:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ezkpBmEJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4711F01825;
	Fri, 23 Oct 2026 16:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773837;
	bh=wQdCOl8S2DcCJgYZs5naSlQBCwXJvMSRLWOENrr89zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ezkpBmEJo9XpClLhpjWGNlGrrlqx5WEMyixYdlkycRdW4rdVXW7BNaBu2Y2345aI3
	 bqe7P2d7ipEuZqW/w0j8CNYcRz6Ql7wl4Pqf9dxeES/NFawa8D5WuY0gwuLkFMIF8e
	 TuKay+DgI8o+0lCSmhuMOufm69mnIwNDYX4WsTPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 032/193] ASoC: cs42l56: Put the Limiter Cushion control on the limiter register
Date: Fri, 23 Oct 2026 18:35:09 +0200
Message-ID: <20261023163714.960297930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 203436d2aeb7093290459e344e1912a418a6ebfd ]

The Limiter Cushion control writes bits 4:2 of the ALC Thresholds
register. Those bits are ALCMIN, which the ALC MIN control owns. The
datasheet puts CUSH at bits 4:2 of the Limit Thresholds Control
register, next to LMAX, which the Limiter MAX control already uses.

So setting the limiter cushion changes the ALC minimum threshold, and
the cushion itself cannot be set.

Use CS42L56_LIM_THRESHOLD_CTL.

Fixes: 272b5edd3b8f ("ASoC: Add support for CS42L56 CODEC")
Link: https://statics.cirrus.com/pubs/proDatasheet/CS42L56_F2.pdf
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-2-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l56.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index 98fa812bc07b8..4e46b8ba92485 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -481,7 +481,7 @@ static const struct snd_kcontrol_new cs42l56_snd_controls[] = {
 			0, 0x3f, 0, 0),
 	SOC_SINGLE_TLV("Limiter MAX", CS42L56_LIM_THRESHOLD_CTL,
 			5, 0x07, 1, alc_tlv),
-	SOC_SINGLE_TLV("Limiter Cushion", CS42L56_ALC_THRESHOLD,
+	SOC_SINGLE_TLV("Limiter Cushion", CS42L56_LIM_THRESHOLD_CTL,
 			2, 0x07, 1, alc_tlv),
 
 	SOC_SINGLE("NG Switch", CS42L56_NOISE_GATE_CTL, 6, 1, 1),
-- 
2.53.0



