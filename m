Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049785;
	b=pIwZtW8pLd8gj9hLHj6C/+DATGB/eu/dE+zrIv1Hn8XsR4lZF4/LL0bTRIdMp5o3+R0z
	 BZRPShqautsprPIPpbb79Uz79CGfC3cNQ9OAiyuV78PD03i2tyQUjgqgdAEryidO56kPy
	 nUNQJCVyCmzX8Y+yjYAErZqRV9igisIThR0JBV9MrScaIeGGg5kE7KUaKtF1OalYkxdnl
	 nSFORT4iEJypY827PjZ66cQojRdsMiF9ER4ZqqBXDqCwHs1W27wftlPPQkqDvRNw0/UxA
	 NBbrsB/AaOIroWyKgLL67iTcgXbYEbM+d1f+NAlQPkcqKssE85ZrgcrXOhSlG3YR0ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NF6Wfpn3Ph1rGhJBJNGVRf2pd2NtEdFgWGDVt4rd9ZI=;
	b=xtkOhluZgXKTZOTSKAqjPXuw7PpUhnOdpOOA3F6GXCxQvBfj3iCyblfvoSjMidXGdvKQ
	 IN0kQZZKzDWB1dUjKdjH4jyDsvgThSJvCE9fQJDZY110sRWz9TyW/kNBNuhLb7AeHiUOw
	 oHdhV/8HLAky/WAV4gcHLYZZiKZzF5G6TgHom2ZA6yCx/yI3MwZsOxYQp1dYsWxThjo5d
	 swSCUPBSN0W49Q1nIeGAPp4l8Xd2768D3qJMcaxCx9czLAxfcnzbM0gsSwliao0Y6ZBnR
	 Q0/11WiF9hDWE9/B6N8Qt/gxzqH48bjMd7lcTO2S2ovwWuAfQUUVRI2Mjwkd7rK60BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A89giVLi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F8D606A31C;
	Thu, 19 Nov 2026 00:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A89giVLi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D0E1F000C4;
	Thu, 19 Nov 2026 00:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049784;
	bh=NF6Wfpn3Ph1rGhJBJNGVRf2pd2NtEdFgWGDVt4rd9ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A89giVLiCUjLBO+e+jxgcI4WtCcFhRiMsxCHpxV8OnHe7Bzgw+A9R07feFx3oeUYS
	 cs/wBV1MrkEQwRvvZX+IKAtrxxbvXFm5AReHgaV/75jZNg8U097UMvmCT0lXjV7YwV
	 SvMjP11fX9H05f0QB0kiu8xh/1eHSaQ5vZ6+ykuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2475/2857] ASoC: codecs: wm_hubs: Fix definition of MIXINR to MIXOUTR volume control
Date: Wed, 18 Nov 2026 15:58:29 +0100
Message-ID: <20261118150330.677218915@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 22bfcedd3febd6acc63ecf8bfd9638210e4b9a5e ]

The Right Output Mixer Right Input Volume (MIXINR_MIXOUTR_VOL) is at
bits 2:0 of Output Mixer6, not at bits 8:6, which hold the IN2LN volume
(IN2LN_MIXOUTR_VOL).

Fixes: 942c435ba79f ("ASoC: Add WM8993 CODEC driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/1ea1d115cea5b183dd51bba5cd9e38157b3482ee.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_hubs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index 0c881846f485f..3b0cc340bfec9 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -426,7 +426,7 @@ SOC_SINGLE_TLV("Right Output Mixer IN2RP Volume",
 SOC_SINGLE_TLV("Right Output Mixer Left Input Volume",
 	       WM8993_OUTPUT_MIXER6, 3, 7, 1, outmix_tlv),
 SOC_SINGLE_TLV("Right Output Mixer Right Input Volume",
-	       WM8993_OUTPUT_MIXER6, 6, 7, 1, outmix_tlv),
+	       WM8993_OUTPUT_MIXER6, 0, 7, 1, outmix_tlv),
 SOC_SINGLE_TLV("Right Output Mixer DAC Volume",
 	       WM8993_OUTPUT_MIXER6, 9, 7, 1, outmix_tlv),
 
-- 
2.53.0



