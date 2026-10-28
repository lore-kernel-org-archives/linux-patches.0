Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216888;
	b=ujWRe/nypeST7R23zKqTEbKNHdCKkTx/frdihP3yGvxGUSjN2TXPk3bfo3C9CWUdidH7
	 Z8yVK63gJBqX6XfITr0Yr6xn+aOZkWb9ox4Uv4+h9cALP76YbLv449MgrMpl0boiTkWWu
	 gEQ9deftcJx587DuLccwaGPu58U4dDmu3OpL3Eu6Gc9ILDFMxTS74UFpxgPfNbH1Jauv+
	 zbg52OdM6fJOD9X+8xJnIuPusqHGRk1/FMScIE5rRiDKJ27YFgzR/YPpdd71LX0PKdaxF
	 muwjBqvslSiIWqHtD+b6NEHtf1qCVvi0Uxj6tMb48WTONtaci5pXL+DTotxSTLjqP3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a1ib8CXIlVpWZgQtvWsCVdHpkhA+WqJa/IOVk7vQHhY=;
	b=cH186cv+8UuZxp4mjq3I+m2iJln6y0qmXmPLq3ztaLoysaFFvPSLyyH9ldu3IdH4TMZw
	 QHYM6HxofRAP86i84gZHNCoL95H12SIrek/HkGLwfI3eDSkBTUqqAhyS8dX2ganjM8VKc
	 2JaTW01w2vGHfjS8GfLObqFlnu3F/IGhMg/jUlaoBvmXrV9uqw7iii0DnbxYBpEacTjmX
	 wFL7+XSPDxyu6KpBZyAQCsbLFQj41JgCsIHYAxW4icSIn01KQmHb2Q8L50WkBDtalmMB8
	 xaRCI2TsJwGtIEWQfVUWvzmHCzg7dEmz1bSv7hCQUPGfmI/RVg4mKwcT3kJEgjuJojA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OmKo+yYx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E890606A31A;
	Wed, 28 Oct 2026 19:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OmKo+yYx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9191F01825;
	Wed, 28 Oct 2026 19:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216888;
	bh=a1ib8CXIlVpWZgQtvWsCVdHpkhA+WqJa/IOVk7vQHhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OmKo+yYx2M7/DOBX275pNYfLO2UWW+CI2HbLFMZSuxtiAxR3BzBJhcDkr3eXrz8fl
	 ySfiB73mI79K8C6s6UevkEJdUEbmt3LoGdNMD8+S07o7JTSV3HuhmArd+Ct/WUnhzM
	 iGDXussP/g8lov+jDMebldE5e/YANWj8cmgB7E18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1714/1887] ASoC: wm8978: Fix the 128x oversampling switch bits
Date: Wed, 28 Oct 2026 18:03:30 +0100
Message-ID: <20261028170538.460568257@linuxfoundation.org>
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

[ Upstream commit d0567ca9a2faa33efbe5ae84ef7b86423a93bffd ]

The DAC and ADC 128x Oversampling Switches use bit 5 of R10 and R14.
Table 66 of the WM8978 datasheet puts DACOSR128 and ADCOSR128 at bit 3
of those registers.

In R14, bit 5 is inside HPFCUT[6:4], which the High Pass Cut Off
control owns. So turning on ADC oversampling changes the high pass
cut-off, and the oversampling bit cannot be set. In R10, bit 5 is
reserved, so the DAC switch has no effect.

Use bit 3 for both.

Fixes: 823dba519122 ("ASoC: Fix broken bitfield definitions in WM8978")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-6-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8978.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
index a682f8020eb6d..73b17376ce1c3 100644
--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -255,9 +255,9 @@ static const struct snd_kcontrol_new wm8978_snd_controls[] = {
 
 	/* DAC / ADC oversampling */
 	SOC_SINGLE("DAC 128x Oversampling Switch", WM8978_DAC_CONTROL,
-		   5, 1, 0),
+		   3, 1, 0),
 	SOC_SINGLE("ADC 128x Oversampling Switch", WM8978_ADC_CONTROL,
-		   5, 1, 0),
+		   3, 1, 0),
 };
 
 /* Mixer #1: Output (OUT1, OUT2) Mixer: mix AUX, Input mixer output and DAC */
-- 
2.53.0



