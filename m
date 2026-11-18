Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042033;
	b=lSwSkSxuwCUw+/5y2+cBpCzese15x0xPtbIpIR6zpX9MDP43ny+rW5iF/RQY7H7qj2zp
	 PAL9KRaFHhzSqc90T4gqPIDfUeoh3y7NorYIPZismaetNerIRzp/9bzv8c2evAqVL5DBF
	 2xvteAqzZCwvh1u9WgOo2EMgl5GASocNBFOoFnDQ532CxSFzAAi59OF+EiPreWnQmsG8i
	 BIAEY9fZz78XiSPnrLWvROi0rdUP/M/xIbEMgrbENlm7vg9xoRvW25nx4d+ERN4CO0o6P
	 v9QIJKe1ybZTx0msFCEXgtbEx6hnxZ2KG8qugJuL1FsGVf/fm2WmxueNIINPo9DGk7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HM8dHMAAd59h69e7U9WOpbdPyLR+w5M/RVXn2Ue219E=;
	b=fEBZGZrkLxx8mFoQzMlHhy0ngNPSb4b7fDR7goGi5HWv9YfDiHUPrL/BTLUzFXa062Ld
	 eFd4p5oscuM4s2Pv5wAR7z3r2ETUo0ygZ8S4ZjdI+2xVZiVx9PajuHtCVhxMAftqUgo0G
	 XoC2qAuUCpLDRLi4nlsaqikzEB93Mh6yjCS5ukfYQlnGKBQ5YzVxiMZA54oEwOBiFiVEt
	 TuiaEc93JMjbed75PAHAHIRca4gaqPqtJ0gheNSNsd1zEAcueRVuqiaVknO2432BBU9ya
	 43kQObHoYC+rOly0ysPq3i0tQZKGC2UPNLlkBzONQ0DQIaSjjgIPk10lSOewWQ+IQRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=toGFqjn5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DA4606A31C;
	Wed, 18 Nov 2026 22:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=toGFqjn5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDB21F000C4;
	Wed, 18 Nov 2026 22:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042033;
	bh=HM8dHMAAd59h69e7U9WOpbdPyLR+w5M/RVXn2Ue219E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=toGFqjn5++Yty+9K5RXEYgWpAGJ3x0VdWLczIJ6ZpHnwglxBrOoIXQUQtlpud+J9T
	 KuK7tqx7NUIn0+1lSq6/7Y/0XetDbMxqE4jTHHChExKRQ+Li8Us0ZVKJK27+UjB7jz
	 yOogL3DW80Yr2tXLRUGDuDF0taTF/favsuhedxlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2985/3318] ASoC: codecs: da732x: Fix definition of ADC2 EQ Overall Volume control
Date: Wed, 18 Nov 2026 16:00:07 +0100
Message-ID: <20261118150449.823714236@linuxfoundation.org>
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

[ Upstream commit ebef9212cb469706e28002a20f9d48307d1fd867 ]

The ADC2 EQ overall volume is in DA732X_REG_ADC2_EQ5 (0x9F), not in
DA732X_REG_ADC1_EQ5 (0x97), which holds the ADC1 one.

Fixes: 48e278746070 ("ASoC: codecs: Add DA732x codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/35bae3f84cdc3ceb6ca412153f44dee3647fdbd6.1792135144.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/da732x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/da732x.c b/sound/soc/codecs/da732x.c
index f8ca1afa8af5f..db79ec7a0a418 100644
--- a/sound/soc/codecs/da732x.c
+++ b/sound/soc/codecs/da732x.c
@@ -511,7 +511,7 @@ static const struct snd_kcontrol_new da732x_snd_controls[] = {
 	SOC_SINGLE_TLV("ACD2 EQ Band 5 Volume", DA732X_REG_ADC2_EQ5,
 		       DA732X_EQ_BAND5_SHIFT, DA732X_EQ_VOL_VAL_MAX,
 		       DA732X_INVERT, eq_band_pga_tlv),
-	SOC_SINGLE_TLV("ADC2 EQ Overall Volume", DA732X_REG_ADC1_EQ5,
+	SOC_SINGLE_TLV("ADC2 EQ Overall Volume", DA732X_REG_ADC2_EQ5,
 		       DA732X_EQ_OVERALL_SHIFT, DA732X_EQ_OVERALL_VOL_VAL_MAX,
 		       DA732X_INVERT, eq_overall_tlv),
 
-- 
2.53.0



