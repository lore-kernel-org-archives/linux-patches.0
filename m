Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209931;
	b=GwA9+I58wPkKCr6fs22zaQu4j7ijbnrD48jFuLv40JqjoPeN/SbXkakkyvKyyVn6b2pK
	 NUw3EAPFqh7k3kA1WXtoMKS57n40gGB18OGGOBWuDgcuWAPPtR5+kbp0SwsYjLP/85Rou
	 5NlYaBUW+bEAO2YVhdyK4gt2C7IEA3XFxYqqW40VxbqYEPmZ2+586KKgO2+k0gc7n1Csb
	 08I3tb1445qf+8NgI0bqMEcoDkfeyxfH+OET9UnbMI3eGRORIj22hTBiLeDvmTHeWjEaO
	 E1l1j1tjQtkKhmlLvSIEUCpfRiaCXvKPoYwXuijbtaLLzgBTNLOnPoelrTb3lcP29JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z+00ZDheTvOuRbtFRl7Z3zcuCeosNOAq4ILihU5y450=;
	b=43y0w2vhs/5NgMlVLC1bjK3z4ELfNFbWYgzHDZw0Zqq/42COpnJN8UUMus+P2u5rTyHQ
	 dgHmjy58RNFzGNccjyrNdttXLJlUEse/GW3lQktp1RV8d6l8PcZX7XlOpHhCDTnw75pt3
	 DiLXcYwcm7wmq+IAsMeQMC3/sopZcFEEAsZVrE7HfMiYtcnKkrFb5I6zIdW+ekTyma+iG
	 /PuzI71nqMBoIsvY+N/uw/HQJO76ePATzs7lIrqj/q49WlueP2zR2NXM9Rwzm0TXJXXR+
	 2/VtUfz4Aus/f5Zzqkt20sdu3cRlfYYgUhZGs6NOdiaOgk4QHm7dTpXhu6pMAOLScvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VRYPpZGO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F32606A31E;
	Wed, 28 Oct 2026 17:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VRYPpZGO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7418A1F01828;
	Wed, 28 Oct 2026 17:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209931;
	bh=Z+00ZDheTvOuRbtFRl7Z3zcuCeosNOAq4ILihU5y450=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VRYPpZGONUE1s7cMwriZ+UFzzb6W0HFjB1ebVVimUpBxyh84QJuPRX4xk4bi9OK1P
	 HWkzneVS9a7KBd64wf8r76rcDo88r5RyB8vXmbXAnUwBoUcrZSIn/sPuVim0dgnG3X
	 +YTPLyiU/++uYxNJ/R8Hq6zURqZKywOct04aL6ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/168] ASoC: pcm3168a: Fix the DAC zero flag polarity bit
Date: Wed, 28 Oct 2026 17:59:14 +0100
Message-ID: <20261028165943.528881855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



