Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216882;
	b=4SM9y7W9GxqzpglsY7bhDoxhREw/Y1uAht/4JxxYnUWc+mZYfMlvovoz4I0xL0sJfkxE
	 28NECiOBPLR71YiiFbkmqGXtEys4rTQ0PGqn/55wshZk/iG8uDGElRlUdxuvd84fEJ91H
	 wETjzvpP55f+W1El7w1o+gSNxVDg3nNH3AD/gmTSzc9nHQavMnldObvI/jI+4PL3WzgRS
	 oA49TB++z8teT1vZg2U8eRqrECCzifwfeEpQVslbG5tMXDgW/M1+rSNPLjCX3Z7iESyCk
	 xu6BZ7MtKMAOymstrmN7xmWCU+7mNG4oNUwe+uZANch6CPUbVR+qMYFg0y7IZa97/+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GoXXvDkoiSvrWJ62ZZM30O5PbnR8PqIf2+CuxAqsA4o=;
	b=npLb40GW0RVBfChV2thzXAMKlsLDmY2XH8FTjgpLG4Hkz6OdCHEIQVZ0bQmgmgXU85qc
	 0tq1Z/ekJ1FGgLspFecSDS8Tljgp+9mWWGQerpHeJMTYgMDAT+pTPW0tIPg8nvMlKZUdm
	 KnI9AFSzwKWBG6i7bJ4g+X1EwHt1sj26P/JDu4Z1iZKrUiRO6Faw7PbHLArmN5F0KYtUu
	 BR3VD6OxwJc44ZLHwUYNBh0c1HUVmSXCqifCljaxuw0jQnPR4sHEVK//Hz+nKXlZNjWi0
	 LHBKmaN51LTdbunRn0uzQBG5XISD6r5VE+5AtpLOXxP9QCfpUOBrPW7fzmHBKTer93A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HvLHAmBt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F9B606A31A;
	Wed, 28 Oct 2026 19:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HvLHAmBt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1CD1F01825;
	Wed, 28 Oct 2026 19:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216882;
	bh=GoXXvDkoiSvrWJ62ZZM30O5PbnR8PqIf2+CuxAqsA4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HvLHAmBtmi5XZIis2K9SSd1Uli29o9E7xa8YzvOsbL1GzDzD2YKsOZblpuHt7Kz0R
	 VDBWhwlS1ThVsrbNZbEJLgU9FZo1S/VmZZXXd6XcB+TvG25b5vjlrlFLpuEgPXUFa+
	 /Xdd/bciSZkYhqPyVSNZzKeUDou4mp8pLHt6pEs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1712/1887] ASoC: pcm3168a: Fix the DAC zero flag polarity bit
Date: Wed, 28 Oct 2026 18:03:28 +0100
Message-ID: <20261028170538.415374504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
index e5ac1146588cc..983ca03e7a757 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -104,7 +104,7 @@ static SOC_ENUM_SINGLE_DECL(pcm3168a_dac_zf_func, PCM3168A_DAC_ATT_DEMP_ZF,
 static const char *const pcm3168a_pol[] = { "Active High", "Active Low" };
 
 static SOC_ENUM_SINGLE_DECL(pcm3168a_dac_zf_pol, PCM3168A_DAC_ATT_DEMP_ZF,
-		PCM3168A_DAC_ATSPDA_SHIFT, pcm3168a_pol);
+		PCM3168A_DAC_ZREV_SHIFT, pcm3168a_pol);
 
 static const char *const pcm3168a_con[] = { "Differential", "Single-Ended" };
 
-- 
2.53.0



