Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049774;
	b=UFdaMeQ+QX7CUBNUdcqHnrALf9zeTNukvh1hs9tr+K9ZTCs986EJxgrJgDYABtXnBtU3
	 PZCDwYXfoWFE2uORp/AxYZHKzd56nKS9mF0Whm5zAP5ryE/hBLCrmaG9JXOtUrSguhFsu
	 E/7g1A+KRX5UYhayiOvwBzFDYZ+cE5mUdAFKK7lrXXdL4wfUwLNaiauGa5pLX0t0JJw2I
	 Js3mk51nmfoX+OQuiH87g5WxTe9YCMcu9i1kSLF3kgKRRsd7I1DdxgH6JdNMde3BDbzTf
	 GiL4T9EqzORL+DrEl/tTeJYrtnYQHLIH1XavkzbkUZOGZOPJ54/s/jKE1DpG0fJjVlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4PHoU/UreMOHB7INtsWzkn7OhgBTqROwMlASlt1zCE8=;
	b=flUp5Av4QRRSeE5+pwFIeebSOeMY70oZfWHhd4vqjFJv51L0aBmWWQNr0FrJp+jC7rQe
	 BYM4Yub14ztD9QyjlE+d49QF2oq7GpnbunbQn4e26Ly20OCWY5tUqvknhUECfitRJ6fGq
	 /ciqAl7y42MpnlxAgoZVvDmMA21BLMT3P0RLBEODDxW/8TpykxjhAGTueREOQqJuFh4hi
	 mlwB0LpAjm6Vz7Kqlb6U2IgJr3bnUmfqUnp7j9xnBN/xjsmJlHMKKmIZOy9qM7qqOvTFj
	 ZAqR1SU6xfup4Ic6djtjmUvwWVBe6DHggnuEdIKIS4eHo98JL+23lcSuER0RgY1UEoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSUvj7R0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0C2606A32A;
	Thu, 19 Nov 2026 00:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSUvj7R0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1443F1F000C4;
	Thu, 19 Nov 2026 00:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049773;
	bh=4PHoU/UreMOHB7INtsWzkn7OhgBTqROwMlASlt1zCE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSUvj7R0zg79uejtNoMVdiRZN1WTiAznXASyvjLIKU5cZp+hJ5LWSd86hjsbp1SW2
	 dKx8ICR4wr3rC0p48aooxhLZWfhcgL5Egx72AHzmjtha2YEgRodCybNAQAEGTPQhAl
	 UsQRfM8G/tQHmoA9fXJWtietm5dSGBM5NsmieiqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2471/2857] ASoC: codecs: wm8983: Fix definition of ADC 128x Oversampling control
Date: Wed, 18 Nov 2026 15:58:25 +0100
Message-ID: <20261118150330.533630051@linuxfoundation.org>
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

[ Upstream commit c1af9e2272f025ff75be76e03413074d5e7801c9 ]

ADC 128x oversampling (ADCOSR128) is at bit 3 of ADC Control, not at
bit 8, which is the high pass filter enable (HPFEN).

Fixes: 6b3860b0a20a ("ASoC: WM8983: Initial driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/d6a5bbab35e1fd2bec5b13d30951546080d493a8.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8983.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8983.c b/sound/soc/codecs/wm8983.c
index 50e6ac6ccbe03..28665119e3051 100644
--- a/sound/soc/codecs/wm8983.c
+++ b/sound/soc/codecs/wm8983.c
@@ -234,7 +234,7 @@ static const struct snd_kcontrol_new wm8983_snd_controls[] = {
 			 8, 1, 0, pga_boost_tlv),
 
 	SOC_DOUBLE("ADC Inversion Switch", WM8983_ADC_CONTROL, 0, 1, 1, 0),
-	SOC_SINGLE("ADC 128x Oversampling Switch", WM8983_ADC_CONTROL, 8, 1, 0),
+	SOC_SINGLE("ADC 128x Oversampling Switch", WM8983_ADC_CONTROL, 3, 1, 0),
 
 	SOC_DOUBLE_R_TLV("Playback Volume", WM8983_LEFT_DAC_DIGITAL_VOL,
 			 WM8983_RIGHT_DAC_DIGITAL_VOL, 0, 255, 0, dac_tlv),
-- 
2.53.0



