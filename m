Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207485;
	b=B4AZPDJK0DRlTb/tvWXVqr18VwauRRExaFoUhbMwgClaJYMCugOnN6tej12YTdWmAslH
	 aFIK/n3Hi8Zg4oICs11Po3Bp4ZRISNSIpjrEPlrghILR+y/C2KYfB2Lzie8a0G+dFEF3Z
	 lWrljxTq56QLX64izQAyQ/DU+WawDX3ulj7AiCo7FTC+Hlmm9A9ZBxHtkpMbxD0G3OW98
	 J3jXPPBu2zd0pIj+YJYSdacTEyU48FOZADbNeLJlKGSnku8g/h8DQdFffgpyaOSY3thLA
	 cDMfD3kzF+ul3HXFWSF6EURWLg7+GMPFi5Z7+0qH8TMQj7T8FP/hVhoIH4M0jYuHF0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RG95wp+x5DCblEocsl1pYXGDSi9GeztZ6+IYBa0tntg=;
	b=pGHEvPTCH5Qi8x17258QC6Odyc3d85kLnWJCuvpRYezLNVD82/luG+sxup7dklm5twRY
	 rdbOJO8e18ODQyJGzRV84F9J3mbUhcQiAsWILDjr9mVtfe9UH6BV+1fDLbN3WfbTSue3l
	 pjny5bsrFtI8DVTQ3VXmkOW9CMAuwkqNs68LqnXArPBvy4JVKak5Yqy91wcHSwY9CpsAm
	 QpAgT2uzIxiC4dlZULIE2RH/kClluOSFzuDrTpdY1K58nrSNoK8oROTVyvQUzJCaa1anG
	 e5vSeRtGzmFfnPGRx3ZltPhkVf+B5qyJnKByngaFtSq5iYDuTiobYJCiGLw2IjOEsjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b5rHKp6a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53256606A31A;
	Wed, 28 Oct 2026 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b5rHKp6a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21491F01825;
	Wed, 28 Oct 2026 17:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207485;
	bh=RG95wp+x5DCblEocsl1pYXGDSi9GeztZ6+IYBa0tntg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b5rHKp6axw/O+H/5BWTWSUyeo4aq8bUEY90a6/WTnplEn+5PwkR2ihFPhdkbElsa0
	 l4sOw62LIA/GZJBqSHtmvTMsxss0YRzqeka5Mv/7BcZ61iHoBHWKn+oCVKwrRRPAP7
	 ZcFiAvjGOWUAISfQoHB+aVIlhYGtiT3v4A1lYa3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/247] ASoC: cs42l52: Fix the NG Type Switch bit
Date: Wed, 28 Oct 2026 17:57:15 +0100
Message-ID: <20261028165948.127195429@linuxfoundation.org>
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

[ Upstream commit 8b08b98796d2da103f2432550c14a7c687e72080 ]

The NG Type Switch enum selects between "Apply Specific" and "Apply
All", which is the NGALL bit. The datasheet puts NGALL at bit 7 of the
Noise Gate Control register. The enum uses bit 6, which is NG, the
noise gate enable owned by the NG Enable Switch. cs42l52.h names it
CS42L52_NG_ENABLE_SHIFT. cs42l56 has the same Noise Gate register and
puts its NG All Switch at bit 7.

So changing the noise gate type turns the noise gate on or off, and
NGALL cannot be set.

Use bit 7.

Fixes: dfe0f98b8d2e ("ASoC: Add support for CS42L52 Codec")
Link: https://statics.cirrus.com/pubs/proDatasheet/CS42L52_F2.pdf
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-3-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l52.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index 7128d4c62f504..dda012be02b96 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -273,7 +273,7 @@ static const char * const cs42l52_ng_type_text[] = {
 };
 
 static SOC_ENUM_SINGLE_DECL(ng_type_enum,
-			    CS42L52_NOISE_GATE_CTL, 6,
+			    CS42L52_NOISE_GATE_CTL, 7,
 			    cs42l52_ng_type_text);
 
 static const char * const left_swap_text[] = {
-- 
2.53.0



