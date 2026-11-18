Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026793;
	b=2d3/uA4/i4i2fMuk6IB/1aAf6rbnjFB1jYZMbLlkhXNj+YsPB/GuX20T4WXvGQKuxScV
	 kqSxkBeqxbhjtJ3XjzTpnZq2KddfZIeWA/Pi/JcBZzBwf9ZFZimbD5Ere7wMsO9XL2aZh
	 +HVXhQnH5f8xoVA3BsI0mko1t6xUdPd8+5n/RaQCQkSYpowiz/wwwet6bhZkMaiFufZ+T
	 ATzrCzISBt7B3ohbjELlUwXyEZwSgqCLZMp7HKxoP1oWWOS/f72gNKKsz0wwypjJEFTdX
	 FXqndkaF9hwa+kvDSxmV9yxAuPJT3uUs29CR1HgZjVaWuRJLDSzRVOlNOyd/16z3K6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KDRNLjUdztS2Lp7p5oL4Y6u8ivgYC9yB7u2idvKS9ow=;
	b=RmUft8FTHlNwvREGzIX3C6Tt6BXHHg35uf8uHWemBltOg8uCbcVqkyanHHQnx1Z3L/q1
	 vRKDyySf+LW0+wbfaeqpDXEqoBe86x1S6QsU2VT+gCpP+k0hFUgq++qnZrSOzvAfvjlVy
	 JyNXjT5pMCyUg6Dv2++gnvjfNEQQkYMhIk+NdJ6HA+nHRyIyh1YlYSJjfl/IIwfR6gzxC
	 uX84jaTt8XsiUtu2G9ZFbygMLu7nDYd2C1zgReGnBT3kchynPFyiwIz+Qe/P0UD9Hf/O3
	 QWFWVcM6XBI9f2/xXqP7foEu2+KAxZp3d2f2c6jRYjwYb+Uxx4IVxxu3/Fq7uOWyhOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s+fNSeiZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602E1606A325;
	Wed, 18 Nov 2026 18:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s+fNSeiZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CF01F000C4;
	Wed, 18 Nov 2026 18:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026793;
	bh=KDRNLjUdztS2Lp7p5oL4Y6u8ivgYC9yB7u2idvKS9ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s+fNSeiZfBjsGGJhgqGKVaEEykQLeExjF/CxKJbnxhKMN98l9Gu4CxrXe3CRaUSlu
	 6N1d+SucEZ3EUCfAcYv7zfwDxmgdpDSZ3ukK/heyADT/Ozr77H9z6dY3Fev64WhNeI
	 Izw1ckY1e9z/HH5xVn3mJJs4tAsIPTfFM/ppfR9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1509/2151] ASoC: codecs: wm8994: Fix definition of WM8958 noise gate hold time controls
Date: Wed, 18 Nov 2026 15:54:04 +0100
Message-ID: <20261118150216.828240172@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 291d81d628f3453026b029507a26b856056e4fdc ]

The noise gate hold time (NG_HLD) is at bits 6:5 of each WM8958 DAC
noise gate register, not at bits 3:1, which hold the threshold
(NG_THR).

Fixes: 1ddc07d0f13a ("ASoC: Add WM8958 noise gate support")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/8acff0f7314eef9eb3d290ca7855a87052d7e706.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 80b1bb7e17749..13ef3d0c5053d 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -700,17 +700,17 @@ static const char *wm8958_ng_text[] = {
 
 static SOC_ENUM_SINGLE_DECL(wm8958_aif1dac1_ng_hold,
 			    WM8958_AIF1_DAC1_NOISE_GATE,
-			    WM8958_AIF1DAC1_NG_THR_SHIFT,
+			    WM8958_AIF1DAC1_NG_HLD_SHIFT,
 			    wm8958_ng_text);
 
 static SOC_ENUM_SINGLE_DECL(wm8958_aif1dac2_ng_hold,
 			    WM8958_AIF1_DAC2_NOISE_GATE,
-			    WM8958_AIF1DAC2_NG_THR_SHIFT,
+			    WM8958_AIF1DAC2_NG_HLD_SHIFT,
 			    wm8958_ng_text);
 
 static SOC_ENUM_SINGLE_DECL(wm8958_aif2dac_ng_hold,
 			    WM8958_AIF2_DAC_NOISE_GATE,
-			    WM8958_AIF2DAC_NG_THR_SHIFT,
+			    WM8958_AIF2DAC_NG_HLD_SHIFT,
 			    wm8958_ng_text);
 
 static const struct snd_kcontrol_new wm8958_snd_controls[] = {
-- 
2.53.0



