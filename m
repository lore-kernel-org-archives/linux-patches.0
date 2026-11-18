Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021822;
	b=BBnjwIzUmePW2eV0/R8f8RipHenz5kmM7lUydKw0f2FYGI46V22QqpwPouQOyMNtcJgM
	 oomC+ebnQFOwbWN1/4OXBW05myWEeTwu5KTCJeXPiqzAxKht+SLL6W9KQs3JwraY/W773
	 WVyYeTRRyUh8w+jbyOmV+RbqhOnd1/DuahSI2+P8Wh0TACnjRukH0UIbAkGiYN/6Ga70D
	 GIeheLAmhcViZJnMMYCZs52VLTJCNZhlSvA+uqNbhamSWdUBBS8D6gTpAOjH5p/laDkY5
	 Yh/TEpJJucoUhuK+vpZ+txk2zL72oCfHTvY/5dshn/QMeb55Wea93RAUB/OxxlS6HXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7r9D8sRSSiPCfIBDXdD2770OOR0VZRgiu0ST7QtU6ls=;
	b=KMsuxKqY8ZHbQDviYpSXEDpSzsu0Qn8fkHnpKORAOpsSypudAwUaNPTK/CXP72fRnIBb
	 a/IyM8aklM9gJN/IKP5UA+rw8s0g+Zsk5cAUh8/Ur88W3Zd5H53uA+Wf6SKfiDwbIovnx
	 YczQVdttdeMyzMWnfcqq7fmekI04kS1Y0T2u2WdSXFXrfRYwagaS3jcrJSJIrkldM5RdV
	 SlOqiTIv2RdAAV/8sCT+bUrLZKvgqh+HG/lrb2gh/DokKQbc/gcVaKJCQQIMn8Tt0tWST
	 C5TGFKOJAmHF+bTkTfTw2YnUXENYu1BawsplbKIWm7LdVvhGbThJBBQXf9ZX9Jv1YCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A2bv8mVC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B78606A334;
	Wed, 18 Nov 2026 17:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A2bv8mVC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7901F000C5;
	Wed, 18 Nov 2026 17:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021822;
	bh=7r9D8sRSSiPCfIBDXdD2770OOR0VZRgiu0ST7QtU6ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A2bv8mVCK0VDragDRykBZQhhy0NZgqXg+QEBRPsHPzkRF/gnHRhqCOZOIIY2mDA3k
	 FT3eqeg1yWL9OwtpPAu+I9BcX7Mt7fl8CPVoxWRrMM8AmfMW+5G0H/jGKyYeRWMU7f
	 yxGlfy9H1IPTQN/yN/BsVVTg044fXyKkRoVjKsKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Zhang Yi <zhangyi@everest-semi.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2442/2651] ASoC: codecs: es*: Modify the maximum value of DMIC_GAIN
Date: Wed, 18 Nov 2026 16:01:22 +0100
Message-ID: <20261118150413.077131658@linuxfoundation.org>
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

From: Zhang Yi <zhangyi@everest-semi.com>

[ Upstream commit 29b867d8351de378704775d3733bfb589c48ab1f ]

The Kcontrol related to DMIC_GAIN affects bits[3:2].
However, the old code sets ES8375_DMIC_GAIN_MAX to 4, which causes the Kcontrol to
affect bits [4:2],this is incorrect. Therefore, change ES8375_DMIC_GAIN_MAX to 3.

Fixes: de2b3119f9f7 ("ASoC: codecs: add support for ES8375")
Reviewed-by: HyeongJun An <sammiee5311@gmail.com>
Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
Link: https://patch.msgid.link/20261026054837.13618-3-zhangyi@everest-semi.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8375.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/es8375.h b/sound/soc/codecs/es8375.h
index 11e3ceec9b682..70e56813fae7a 100644
--- a/sound/soc/codecs/es8375.h
+++ b/sound/soc/codecs/es8375.h
@@ -91,7 +91,7 @@
 
 // Function values
 #define ES8375_ADC_OSR_GAIN_MAX         0x3F
-#define ES8375_DMIC_GAIN_MAX            0x04
+#define ES8375_DMIC_GAIN_MAX            0x03
 #define ES8375_ADC_AUTOMUTE_ATTN_MAX    0x1F
 #define ES8375_AUTOMUTE_NG_MAX          0x07
 #define ES8375_ADC_VOLUME_MAX           0xFF
-- 
2.53.0



