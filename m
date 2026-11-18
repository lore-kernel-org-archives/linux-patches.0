Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061665;
	b=uZILPayPPlIr3MKVn3gIIKdWHTucPF+5lgrWYD7/VIAbQvBmEok4eEsTsKm5nG6UlAO8
	 DuKN9ZMTcMRk/N4SlE8kVbgGGokCSRoF89fM6AtqEbP6JA2RVuk7vmH+6Po0JUsymAQf0
	 KR0H4S/X6nNXe+GN7EctmbZKUraFqp5hixWvD2+LCnxADy4NYygBR40Z5UmCnipPSxdQf
	 mD7P+oebhfKDB/WY/3jOqT9XDBjdXzymCEKK/JVg3i0V++h6zfxt2PSZhGf+FFDb7rwhP
	 0pH/M5rCd2rDR7rLl7mJLtEHWUTAW+xXRxgbJIsyExmd/LG18WFhnz3PWswmoEWrB4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vqmnW/IBYbMZXb4yzAvHcupFo6jfwqcZ3NuKofbnUss=;
	b=NnG71zaXdAiyy+cSBiKVKK97j/+EsqtiIIxahjpuL1d3yCkoPzSWL7XuRT/96FUQgGB/
	 mfSztDhchjNPDoU+USKjegRvykFOR/IkddC/I+nt40EadVTOBPC0x1w1h1XWHXSX7UEGp
	 kztygYIKAwFOoh5OIXutEk0lWnYNS58J9G/SRLW6DVwhoWRV4kJmWnBzdJpOcprb5vD/F
	 YTUm+Ds4jdJ0BmNGR82hzWNt0VjBAOp14JvgejdbwU1NT9UjZbEiCb0oPSUhBcZ1xI6LY
	 om3YvDh2gKm79tKRZnVgeSz/D7Du61T8jiri+uCEKUebS69XWHxO0UQEC58VaEQwjSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lrP1nhNs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06C060A2603;
	Thu, 19 Nov 2026 04:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lrP1nhNs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96621F000C8;
	Thu, 19 Nov 2026 04:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061665;
	bh=vqmnW/IBYbMZXb4yzAvHcupFo6jfwqcZ3NuKofbnUss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lrP1nhNshksoFSRGY4pR6Ux9VF1rP5xw5yW+/TItD+CoOfT3YJn0qM8J5svDdGxkq
	 bYRF8ujg4+xjFrWLHzzdHYkCYsXQl7kKB3QkR9RKqfCfbnBHn6H2t9+Xkmxubgo7ch
	 ZNnTd0fuFRg6MnUFhwbZVoC2alR0Zvu1mYkk7mhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1633/1848] ASoC: codecs: wm8990: Fix definition of LOMIX AINLMUX Bypass Volume control
Date: Wed, 18 Nov 2026 16:01:11 +0100
Message-ID: <20261118150027.938895403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



