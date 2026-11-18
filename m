Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049793;
	b=s2oCL+m2YSEWD2vCan3czG7INtLQsBA1Z9mFYW2sGwWWb26bzVkjvMITMlmUHfdzfijp
	 LmcwxG3h6kbeZMsomAzHgJDuxKqpGb9kwKrL1EX+F0fJXLnfkVPulXOOw2DeEGHtnhNiF
	 4RmqtraLjZyux0DnILj129BW2gxEJwz6VoAH+6H/dJ0kmK3sDwjms8IkpkGemCu6/ACa3
	 eHk8VneQwTr9QtjJCVVgct/2UivndIDU1Ux241Idn14oCXu7JHwO0qZM0bCLuiyqkcyOD
	 zIh6aHQKQPmDixlMvFcgHrwMZsKf/Vvl6Uef5QHZh7W0apFDqc8+Tg8OolUFyqpQGFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+7OnVaDtnwtoIDSYbAEpXCZjzW9PQsW7LgTMu10IhJ4=;
	b=e7+XpTSFZhf9pYeA76G0Tt0T42MOkh2HF/425w4HLea6dWJgYKZqgb8AWiSi40PoAno4
	 nHHe/7+K8U+jkmiy0H1eqOzI43+5AYmSwEOj3BMv52DOu6SBJZD8KRxgN3j9S6WtdS5SD
	 XdjkAgzmrOwxhihNrWSG37upkRK/vQyJMOauBgtE3CZ+QjN+jqD9GhH1PnN2ejuhff/30
	 cDAlMRl7ZYxC3h5hrj+0b8GORwaK87H7iRbJGPES7qJsReAUW0vcGFy8b6OMkkdmUnJ6v
	 Jgb1Js0jAWHCORNGS/CvPug9UFUWg/m6zDAqnAUAu2RznAtXp6AGM/Dln3R7qlZkMYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f9N2qvOo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601B2606A32C;
	Thu, 19 Nov 2026 00:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f9N2qvOo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5C61F000C5;
	Thu, 19 Nov 2026 00:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049793;
	bh=+7OnVaDtnwtoIDSYbAEpXCZjzW9PQsW7LgTMu10IhJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f9N2qvOo7+hn49x7Lxf+YQu+Z2Vhp1VcWks5hqqkcbnj3CNLlGmCa+Gupbra+zyhA
	 Jbu9jDyhyJrxDiKIREPgLy2RUhSVLVRDVgJf8wgqcPRZWW5sdtzZM3duBA6CI4k7lL
	 1rb1COW27uJQEQuNGHmAdi+pkUlWmBCMI7c6ph1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2477/2857] ASoC: codecs: wm5100: Fix definition of EQ3 Band 1 Volume control
Date: Wed, 18 Nov 2026 15:58:31 +0100
Message-ID: <20261118150330.748168183@linuxfoundation.org>
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
index 3b09d4a1684f3..7b2ba70687919 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -655,7 +655,7 @@ SOC_SINGLE_TLV("EQ2 Band 4 Volume", WM5100_EQ2_2, WM5100_EQ2_B4_GAIN_SHIFT,
 SOC_SINGLE_TLV("EQ2 Band 5 Volume", WM5100_EQ2_2, WM5100_EQ2_B5_GAIN_SHIFT,
 	       24, 0, eq_tlv),
 
-SOC_SINGLE_TLV("EQ3 Band 1 Volume", WM5100_EQ1_1, WM5100_EQ3_B1_GAIN_SHIFT,
+SOC_SINGLE_TLV("EQ3 Band 1 Volume", WM5100_EQ3_1, WM5100_EQ3_B1_GAIN_SHIFT,
 	       24, 0, eq_tlv),
 SOC_SINGLE_TLV("EQ3 Band 2 Volume", WM5100_EQ3_1, WM5100_EQ3_B2_GAIN_SHIFT,
 	       24, 0, eq_tlv),
-- 
2.53.0



