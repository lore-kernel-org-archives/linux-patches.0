Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774425;
	b=k95WpH5yMNKFpr0JGMmcHSUAunwIuyJ9daPcXboPRZRR+hmns2rIpTCo3EDXMHa/fsRU
	 Kr/PwC18xNMZcK6OTduIlFVa0WOslHbA3ZBeuK3sAtE99TndceUzPq53dO9LNUqW+NvcK
	 vf2iNLMj13NyJRR+S+J6m7jUpNlfGFHeuwI1J4ch/dl89hY3JyCV7tfjX1nnaJII+vlwo
	 rH6bq2h2bXP0YKyehTO44jjU/v+brXZu/fCjMw4Mrj3p2GqGJy1hagO6ckWAI+wlBSLT2
	 JXqm6K0qrL4cteVr3i1RVHUYTmZ7EKt37qyd9g5hcOOA/5PBj+iCmbFBD6h3l15PNZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bctp47XswutqmJaBN7Zay7BRnIythHIixkkKY6wb6tM=;
	b=H0gWd5JZW389nz9DH30WiK0jBSCHEdjIPtOEvEjMI9wo/7rWry+THFVCK2YIOVW/lq8h
	 bnadd9EUovKTXCkBNfWc0sbGdMHv/R32aaMks8iQkx6JTmMF2rZK43JYV2/HvKTew8wfK
	 VAw6lvM2wuAMBFkY+U/jQCvI1Md1dxwh2L3sSJ9mEjfjZsnNZEan8v9RbAY5OpMPmd1M3
	 vYoIGdbCKS2eLx++1AyHX3bmzT6mkBYgz6UYrzM4LR/5QtWzgLwpUrdTjHlfCbPxDFXVb
	 ctreQZ0yuew8Ed/B6IWbf5qoJwjpcnTfELhdxZ+YsgXBJAjcpVrUBqeHHtZPcnjiUCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hGmj+CE6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD4E606A31B;
	Fri, 23 Oct 2026 16:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hGmj+CE6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A6F1F01825;
	Fri, 23 Oct 2026 16:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774425;
	bh=Bctp47XswutqmJaBN7Zay7BRnIythHIixkkKY6wb6tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGmj+CE6ol/u9zA5b+pML9LeL3N0b/b3+WZzhZ7d8TWP1Y76szDoqF9xuJqlFTYKg
	 TbugnY9642Cc9j0p1SV/hoxjyN32D9TuLgp75jgqK2yky0/xh6D4My+YwE16oCH8hq
	 C8use5jZSUAcZlBJ7NljrVG8ew+HRzLw9llFtpwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 035/242] ASoC: pcm3168a: Fix the DAC zero flag polarity bit
Date: Fri, 23 Oct 2026 18:37:57 +0200
Message-ID: <20261023163714.611459291@linuxfoundation.org>
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

[ Upstream commit b26edc925c1cfa0184cd270ed81d4833db045ce0 ]

The DAC Zero Flag Polarity enum uses PCM3168A_DAC_ATSPDA_SHIFT, which
is bit 6 of register 70. That bit is ATSPDA, the attenuation speed,
which the DAC Volume Rate Multiplier enum already owns. The datasheet
puts ZREV, the zero flag polarity, at bit 0. The header defines
PCM3168A_DAC_ZREV_SHIFT for it, but nothing uses it.

So changing the zero flag polarity changes the attenuation speed, and
ZREV cannot be set.

Use PCM3168A_DAC_ZREV_SHIFT.

Fixes: a9b17a638af5 ("ASoC: pcm3168a: Add driver for pcm3168a codec")
Link: https://www.ti.com/lit/ds/symlink/pcm3168a.pdf
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261008130953.2446692-4-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/pcm3168a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/pcm3168a.c b/sound/soc/codecs/pcm3168a.c
index cb6a6f08f2f80..6f45ea4869a75 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -103,7 +103,7 @@ static SOC_ENUM_SINGLE_DECL(pcm3168a_dac_zf_func, PCM3168A_DAC_ATT_DEMP_ZF,
 static const char *const pcm3168a_pol[] = { "Active High", "Active Low" };
 
 static SOC_ENUM_SINGLE_DECL(pcm3168a_dac_zf_pol, PCM3168A_DAC_ATT_DEMP_ZF,
-		PCM3168A_DAC_ATSPDA_SHIFT, pcm3168a_pol);
+		PCM3168A_DAC_ZREV_SHIFT, pcm3168a_pol);
 
 static const char *const pcm3168a_con[] = { "Differential", "Single-Ended" };
 
-- 
2.53.0



