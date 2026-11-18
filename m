Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020146;
	b=TE7cAUeHjHVVRBTKJ8ayE83lGdlDXijHh9N2vXBHxtd/JHINmXJ05v5QdOP9eP0e/zMg
	 5DZNomaLjq+y0IhcqcqxL19t2vlJ3dlbXdl0QUXvMBP2lwAaGNPqLNTAfAOkl70bfczyc
	 I2TLrGYCjyA302FCI7Z495MSnRWPgCOvJU+oCC1sxQozdj8m4ukRVdHTNQx1oE2E6lzh6
	 xfN8BbZm7b695SEXPchJ0KdVDN92ujU5xsi91cjHjMAFx+2IB+mKk2Zgs0hT9pxccnBgM
	 AGiCXYFqozE1kNgSp1i37t7zFWAm8fw8brUfreDC5zKkBXFDYmJnvWH1xkCyi6z15kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fdsLZOoFNlOPf7gIbjbCl6SaIyovz/F+lltS3/nZQ7E=;
	b=sRDliVGQtP0gAGu8tTk4G35tblavxt2KUL8gyaXYJdsadYPtQzXCSw1DUWAMCZzg8jB6
	 DPOYrOaW9ymm0nV36TPWH336fdotLYv5f6Rk25oBIq3sIInUzuXVtxH3VWlmId0BswrA6
	 t3ox/Ll01DFnRCmQ2j4D9yZm0rXcWFHqfN1TwutFeMYW78fhckKbUEdFAmc4IJWxZheyp
	 McDbrDmlN0vZ7a14GHXMYez/hhJljfHjDQ7PeTyzqd1ao0bO3ipN2n8PRdNvv4MoCtKhm
	 +kgbYJA/oK3N77z3hfFkIuWn++oHLvEOr2SiFSvuwRKQf9vz5vf5vLBmhwldhne3AJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LHL6V605;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1780606A32F;
	Wed, 18 Nov 2026 16:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LHL6V605
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2871F000C5;
	Wed, 18 Nov 2026 16:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020146;
	bh=fdsLZOoFNlOPf7gIbjbCl6SaIyovz/F+lltS3/nZQ7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LHL6V605OG3nGAHjyi39DKk+f9c/KhEzrUuiABICz1+C4sj6uHMcYvQ5YWSDUanQh
	 7BKsdFflwgb0I8EqBcpxHhZlA1aMmhhkqEHV5Ye/H3OY979+g6GskX9OkBcoWjGljk
	 eBROHt3rrcwUd+FXeU+SdW9wmGS6ym4XG+bJTu3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1849/2651] ASoC: codecs: wm8990: Fix definition of LOMIX AINLMUX Bypass Volume control
Date: Wed, 18 Nov 2026 15:51:29 +0100
Message-ID: <20261118150353.617583088@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index a3843094866b2..5674d97fcd840 100644
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



