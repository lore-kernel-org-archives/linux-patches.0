Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211715;
	b=woFKtnt5rDR9vTFOo1Xauk+dWXUiQ8d4HQrsMr5T5kVvyczUfDvA5r0kfOeFdC37PHE9
	 LL0jrq5JRgZVSzTy1JMgFU67w1KWQqXzSCt2G5BXC3WyQCq+S+X1ouZP1CxZ9coSwp/kD
	 pClFK11BbtsD8hq6CfH6WkQfg30F7prDL2LYii4pjLoxqMFwsTwSyxPYMlB7K3q8x/uTA
	 dUMqBgRONnlq8irh0QtZWP6cS5RAZzEUdcImIAbsu87MfvJhN9mYDlmiU9NC4OiC4XI3Z
	 gkOKNweKHC1rp+B9F9UHezQKwEAAecZChTbspLC0hTWIp/bwGzfv4ldbjrCL3Wbn2Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J3wmg1Sw2FSDcyCp+qvNllg9oh+5I1qFem+8dn5k8DM=;
	b=cl56JcgdcCjwqqwBbowQfCdyhiJKsTOF0WZSMKLR7gnXt8vTL6I6zVZOT+1pc/UcMpt6
	 eSPunI9dHrvm6wJ3H6/3np7LZF/KFpZqj6MCmhqTuGdB8dnjbrRS54Q8cwnxqwABoWHXO
	 H1FB9eYC0EEraMxDjgqIFIHDUNOvtD4ImOXdWVueO+HJ5N3c9Oj6p/L2h6+gHjwTMV1gF
	 HqnY72zKbI3r2WEIvxLlgk8EPxd6FUpZMdfBLVoG5NtG9JI/JzOplzLErPUOQlr0CAcff
	 HdWPUvOWgP7f4KnUq93I3hXQ6EvQzk00Flo5XoQnH1957ID9ZHIjh3T0UIXNt6FG1lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ofLtxnSw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE6D60A260D;
	Wed, 28 Oct 2026 18:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ofLtxnSw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472091F01828;
	Wed, 28 Oct 2026 18:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211714;
	bh=J3wmg1Sw2FSDcyCp+qvNllg9oh+5I1qFem+8dn5k8DM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofLtxnSwCgNHsnTMr4MKeoO74xHU/0nVGWZwydinCHcNKmFdVB74xRFf26rfOELvA
	 kpKbmZO2oG9XQUv+cUhhBKPrYRzW7hzt5fEw2cG7GFkIFJrySO+LI80GSu6pNizzMC
	 D0UGnqKpQBJMiqzrvMXA2iw3Cilj0SeNRuA6jfuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 476/571] ASoC: pcm3168a: Fix the DAC zero flag polarity bit
Date: Wed, 28 Oct 2026 18:00:23 +0100
Message-ID: <20261028170019.316000719@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2aece113e7c0b..b5e5cdb376c5e 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -106,7 +106,7 @@ static SOC_ENUM_SINGLE_DECL(pcm3168a_dac_zf_func, PCM3168A_DAC_ATT_DEMP_ZF,
 static const char *const pcm3168a_pol[] = { "Active High", "Active Low" };
 
 static SOC_ENUM_SINGLE_DECL(pcm3168a_dac_zf_pol, PCM3168A_DAC_ATT_DEMP_ZF,
-		PCM3168A_DAC_ATSPDA_SHIFT, pcm3168a_pol);
+		PCM3168A_DAC_ZREV_SHIFT, pcm3168a_pol);
 
 static const char *const pcm3168a_con[] = { "Differential", "Single-Ended" };
 
-- 
2.53.0



