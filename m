Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026782;
	b=mfzvKwjU0MffvMHcsFZ89rzTPZ/NGJv3klJJg24gR/LZTb4z3R1gdeeI/BUeGoZAGBNP
	 wm0134Ptk8hhcg47ci4PKZlULheZeU+noMo1Gtv7MlQmowxHTy7CIf+1CbjDxnUVeRMV0
	 66YhwKNOeoM8THN+6hZgHHY2IMKhuzZNGrZ4afbNQOdSoQk/LKXDPrJFxthg8Iq9oTv63
	 mqQXVQ0HOJEf6WU9eINwd0ov8EWnBFFR0EPfPBaFn/UX6hKca8fWrTsuOQizVBr71LbG+
	 +0a/R7xxIUuLSYZ1mePTkv4gfrG3I4XzsrlDQLYFRy8i7WyjqGk2DuZeh62tmst3tiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dHzqaIIhOWseoetK1CHMdsI+cXY5OJbXMxhUGNMKjik=;
	b=Cvh1uDIBFiXspq62vnE4vqnn5ojVE49ZaEDqX8LBy/KagPTuakhTh8Gf1bzvYyAfFpX8
	 tk9D/jYiauhUrTUI+ivKLfzcrM86EeVPwhIjY3dVxOSVU9bINBfbSlq9fsYiGVYdH0I1T
	 eLvbvp4iDip9UJM3xv1xvYbCxKY/M5Du0BN42Uf+/ee8YPqsNGiymvFpUiOBE2Kfc0ujf
	 3Tcs7aBiI6Grui0/xdFmJc8kOU5TsG2LkOfDiSAVnb5Lh2Z9hahkw5WgHlS0zgg0bKpkA
	 Na9SxxfM1Uzi5DSOlP+jGGVD2ApnvsnUXfcVlYoutiY7Qh6kjTG0u3jbr+lTmFZUJhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oh8RfY7c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111F6606A32C;
	Wed, 18 Nov 2026 18:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oh8RfY7c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB531F000C4;
	Wed, 18 Nov 2026 18:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026781;
	bh=dHzqaIIhOWseoetK1CHMdsI+cXY5OJbXMxhUGNMKjik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oh8RfY7cVfXNZPL+q14n8eH6Vg5Xl8Qs+trXlgljsoucrLKDU5uHqNvqRp5A1F2ad
	 oO5HYeUEHALn7CjnXpe1CIQDFYbmpfU+NGCjnwbtSLJObDJfYkXdpgkYTdi+St/Se8
	 Kpbz+COS/6IzSPhxava2iqOn5QUOEKw45P+dX7lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1515/2151] ASoC: codecs: wm8510: Fix definition of ADC Inversion Switch control
Date: Wed, 18 Nov 2026 15:54:10 +0100
Message-ID: <20261118150217.041450642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

[ Upstream commit 22d50113078dfbeff0d005d64fd9cc680249831c ]

ADC polarity is bit 0 of WM8510_ADC, not bit 0 of WM8510_COMP, which
is the loopback enable. wm8974, which has the same register layout,
already uses WM8974_ADC for this control.

Fixes: 5d421516670e ("[ALSA] ASoC: Add WM8510 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/6ada61df8c8fc97ffb1623e74f6742ca498032fa.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8510.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8510.c b/sound/soc/codecs/wm8510.c
index 79adbcc90d4a7..330148dc2232a 100644
--- a/sound/soc/codecs/wm8510.c
+++ b/sound/soc/codecs/wm8510.c
@@ -135,7 +135,7 @@ SOC_SINGLE("Master Playback Volume", WM8510_DACVOL, 0, 127, 0),
 
 SOC_SINGLE("High Pass Filter Switch", WM8510_ADC, 8, 1, 0),
 SOC_SINGLE("High Pass Cut Off", WM8510_ADC, 4, 7, 0),
-SOC_SINGLE("ADC Inversion Switch", WM8510_COMP, 0, 1, 0),
+SOC_SINGLE("ADC Inversion Switch", WM8510_ADC, 0, 1, 0),
 
 SOC_SINGLE("Capture Volume", WM8510_ADCVOL,  0, 127, 0),
 
-- 
2.53.0



