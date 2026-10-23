Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774417;
	b=U2ydPXc26+Ncp5+hVhJFH/1FV3isOW28lCrxhgOzxdaZky9bSL5USfDFnMnUS7uHsEde
	 Ut6dEp9tGY2yv9mFdj4e5WkZpBFhAw+T+RNg13gwmHlHo7i7DM8pc2QhKYaSv2fC54+G4
	 srcqg6RPV7m2Z2mmG939oopPHMEKhC9HmT+j+8QqVipHJ2TnPafVe7ZwRDr2cb9hDikoW
	 48lcm6MKx0ex0uocvarM9Nf0h4tt2kNqTqzZmOsTcSoDeZXHOticPCbLZRYD6zRtRpmFy
	 VZAnneoivK1ORJn19RDQgR6GW1B4eCdarqgZox99nYU3C+0UlqXoSDCxsEmdGmYzI+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sn9gp/SrFRXOMRNdiPCAN4E/FyIYtknK6bhYCW2ZG38=;
	b=qav4fbyKBHdRUo8w4NF5D+VCUzIU5VV5KxgjPWdYSYQmKeZpyqFaHfwhOoGFWXRE+Rl0
	 mEKnskjoFxLUmxHrYDtWRXKSinvYoqjiPI5cE25LSKKzNrb4dSe9TqIHV8R2HuJdaz0Ib
	 LNH3DAG4YZ5+hLHDzQmCqEpx32XKA/C9DSwnnmpQoRHY3MiZTzKfC/fBMfffWxP6wGGQM
	 M4uFuUKhsuu/edaFZ4yak5jZqgM1B5OuVLbPXcw3ASTpugoaDSrWLdan4/gu59O/Wpwhh
	 VdwHlVbYihz8w5wIU+a/EILKFVSiwtfyn+/PNffkTH35NM0C2oiMUXaB2uCZTlnn7Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bc3X3zgD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C776B606A31B;
	Fri, 23 Oct 2026 16:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bc3X3zgD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24101F01825;
	Fri, 23 Oct 2026 16:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774416;
	bh=sn9gp/SrFRXOMRNdiPCAN4E/FyIYtknK6bhYCW2ZG38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bc3X3zgDCOFKCirN7Jj+TcBgG7JbDoSP23YiCil0Fd3gvLd4ugljV3WGnrqtvrlA9
	 1M2DG/P0J5q+DyTv0qGcfJhd1jLBEq12kVvWECn3eQyWTx7AOouUQhebG7UeHQx+Fr
	 SbDSeJmx3y3hcXc+VJ/zvOxUzPokqwM6LdfhBW8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 033/242] ASoC: cs42l56: Put the Limiter Cushion control on the limiter register
Date: Fri, 23 Oct 2026 18:37:55 +0200
Message-ID: <20261023163714.564326988@linuxfoundation.org>
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
index 4d9a22a1029c6..f0ea5309a6d49 100644
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



