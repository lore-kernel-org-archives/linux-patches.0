Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026762;
	b=xkdMfhqPlDq1kpI8Ef4DSvQdmkJ/1gTIEY8QrENzVTE7ZfPaEFzVPg41x+Nq9qQuMvjH
	 ppiN54yzKxHnZaFX7WMs8AIFdkyCH7aGmCfBprGeGaObW3m9bfn2z91pi1ar7L+EeBz20
	 rpQ8/VATTg5YYLPfgj1jep3pjDIEGgAujhRSuL6SpfB9HsH5IPge+vi16FRkYbeUlswuB
	 V7EnxxcfFMyBr8adMXItx8dQNCz6GbYC2uTtZ52c4hGj9PW185EHtXlusYgLRf6fGi2NB
	 H02QIxQt1zJ2klpq5yWz0XK5DwJR/DFR30qfBkXgWuP+Fs1M8SbEfqg4huDwlV4kd8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NpgKKc1x2HSJDuPV2IcXtKUqYx9IRzkYGIrH3gjQpNk=;
	b=q3PZvX4Bl8nQfVdGD+dC29zQJtjhl+8u8xXpziEiNbqMa9eZ1pQ+Y6rrWm2OsxMdASp8
	 Ecud2AwFkhC6PbL3RD3c//PlRQKHGNwiqzer3GrTy/QKYitVP9jByzOfgqk1W1SQvt4td
	 6VgwFAqbv9CrnoF3nfqfKA8OeySuRggATZv3u/yJNw4gpOQs7s+2MgnrWhKCER1+SBsrL
	 IuCoEURYyHVmpZqjsNE6POv0901Qh97U5N3Tw4pEH5O8aiRaLJB9sMQs10QWoKfayaX8N
	 NXuTEuR5P6XD6W8oN2HkQp6ZS5K3IDkBjpby6QFyd6mY7PQkiDMvMLg5m5TC7tXDgxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ooOP54/l";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445D4606A320;
	Wed, 18 Nov 2026 18:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ooOP54/l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7641F000C4;
	Wed, 18 Nov 2026 18:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026762;
	bh=NpgKKc1x2HSJDuPV2IcXtKUqYx9IRzkYGIrH3gjQpNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooOP54/li9aSLkzLfSepWm5FhuEqhT9pUqtKuu4uIbbSWpQMCMZmm7/8M4wa4FL9Z
	 cRMH5fGDCfdnvaQsfo+gH+Bo0eXy/JLfVRRrZhY+2eYK+su4yNYNJNr1Vm3oxOLeuk
	 HQifJsgJJKH5B4N9n2ZoyraeP8D8v9cHYZMW3GLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1513/2151] ASoC: codecs: wm5100: Fix definition of EQ3 Band 1 Volume control
Date: Wed, 18 Nov 2026 15:54:08 +0100
Message-ID: <20261118150216.969243747@linuxfoundation.org>
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

[ Upstream commit 96d30816a9a4fa6b3cc470f82d0f53e8a6425ab9 ]

The EQ3 band 1 gain is in WM5100_EQ3_1, not in WM5100_EQ1_1, which
holds the EQ1 band 1 gain.

Fixes: 6d4baf084f4d ("ASoC: Add WM5100 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/d7f690e391feda7a6d8f38d0b238b165bc1f4fe2.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm5100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index 2d0a20f2fd8c2..05d5ecb797e46 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -658,7 +658,7 @@ SOC_SINGLE_TLV("EQ2 Band 4 Volume", WM5100_EQ2_2, WM5100_EQ2_B4_GAIN_SHIFT,
 SOC_SINGLE_TLV("EQ2 Band 5 Volume", WM5100_EQ2_2, WM5100_EQ2_B5_GAIN_SHIFT,
 	       24, 0, eq_tlv),
 
-SOC_SINGLE_TLV("EQ3 Band 1 Volume", WM5100_EQ1_1, WM5100_EQ3_B1_GAIN_SHIFT,
+SOC_SINGLE_TLV("EQ3 Band 1 Volume", WM5100_EQ3_1, WM5100_EQ3_B1_GAIN_SHIFT,
 	       24, 0, eq_tlv),
 SOC_SINGLE_TLV("EQ3 Band 2 Volume", WM5100_EQ3_1, WM5100_EQ3_B2_GAIN_SHIFT,
 	       24, 0, eq_tlv),
-- 
2.53.0



