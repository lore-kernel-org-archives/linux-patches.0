Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041583;
	b=ZPyhL9jySy8cZZrzFuX8w0FDeVLDEG0xTOoKdUpTxP9Ix4Kul2DKBVGswgvahi98wItX
	 6YIcb/VMbBAmgguGfrZoCgjTBXTh88oBkkLF/0oPoKgcOJg6J+nL2VWOnZCdKCin1vY5M
	 HjPUWDbX9fudRtos2hP3bxIByexcU1HLb8sfDBtCVdAm8V2bC/FZJweR8Ez2UPjoFcine
	 4S7tq8hqizhagRQgaSCOz6UWl4VsbbarsSEWzzeFnJaOca/+dWFJ+YdSxqGXZoYmSZiwm
	 yaXDb9pdOSXAUENU5ti2ojaJjVd4RvxrvjBlBVfGSLCb03v/r1C6I1HH9IAJJg6CyFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cb5X+laEFXmleqcsmkAJFMzAglkZi5WnX41EXhvhVJU=;
	b=hy/8R0vdSKq05MVeBgFM6i2kFywdxNkXWHgqBWBFGnz+h/1AlKLPSgJ7e+tekKR0yzR2
	 GvTXK/PUromZdi3epx/OXNzTmtojoKCZML9jBYBFqt5aQ1Q3UIXxDAsIZhVxutCM7V+cS
	 hm5mbO+oWp+pZi+rZBZiCI6szezx9hckxB23sf0LVX7gq1/PSPs5RE67SdA06fKAIGTSC
	 t9WGdQxqWZiACZpBj9kOdltkQQ7FH+/JEpYbxtDHbu7K9ciB6mwYmF1RRPwcmraXiwcwx
	 WR0BfXSb6HaGZdcfj4Z9V8gz7FtXcLufGKsZGqew0GIPHDBaBH3qq/jHne/FuJpB62Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqRfLPRi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0C2606A332;
	Wed, 18 Nov 2026 22:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqRfLPRi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476741F000C4;
	Wed, 18 Nov 2026 22:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041582;
	bh=cb5X+laEFXmleqcsmkAJFMzAglkZi5WnX41EXhvhVJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqRfLPRivG+ofwPDkACXyeZxDCIGzzq7Ltx/6rSH9BEhHxucdq5TAnareerxJf4xG
	 QuqgdUDdLgA/rxmbXNQ5IQMHYds3wrnwOUsLWTOalVdYIZjH7MuXkDsMATfAi1gJQb
	 I55RAIUaldEt9v9yQtiB0qU6toUlSaQ2BOQ6SdCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2865/3318] ASoC: codecs: wm5100: Fix definition of EQ3 Band 1 Volume control
Date: Wed, 18 Nov 2026 15:58:07 +0100
Message-ID: <20261118150446.524421527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
index ff63723928a16..b1e9484334a85 100644
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



