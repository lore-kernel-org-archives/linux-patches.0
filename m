Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773849;
	b=Aozgxtf1Dok8mxGTt7UWHW5ecpKLpkamR/xDvZKBaMtgxjPLjD9wGOaWM7RemknPmJv+
	 Kh6mNSMCIHImlw4+Dmv/P9XAykx/967mKVHgVfsPaA0y+4J8sIt0E0y/6y6xi2wzZHdmZ
	 dadm6emo0IEC1xm99Bb829GsbweSHSsjfO7HBukCxNxryipbRLEb3Rojs28DAUOc/6nA4
	 0QBypFobDuo+KHfWouOuUtzoJTvAtbhxux7VQsVii/E3b502wJ7uKUY7KgDxKXcHIexA4
	 NfvSqHRZ353MW9rogiSxjT+wrkIRK1v0PeFaAOcr5P7dmmcfHv5rMPXQZjZQGF01QDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KrhrDer4ttiwgkClmf5P5Wqsa8hJNaMznRn6VF2Qujk=;
	b=x6RlpTzkyCJ+VC/MpfHKCwziGqd8X89kERGfgrmKxWxURHF7ueDHGr0bE2iZa/CZmMtg
	 rloCx2QkAreDrmTT00BjHuikpuii4p6PcHEOeJ+XXTBbXeT4hwlbvPZ6KCFhfpHOX4NVI
	 DmAjIvyatz/TKysqEepQY211lLlrD/9A4zkezfruA5JEr04kQ7TzW1WmAfTNCNJ1aI8IE
	 NLekNC/eAR7FDKD7IFIDduoqQLhyzQVV99jE1fxBfz5f8+z2F48459jamMWe2dg4rOj4o
	 KHlNkPksE9b+SOrdh4mROap2C+tLXZCo4W7GoD6YmI43E0VDg02b/YLNWxDx6OaJ9Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="L/JDIcl9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9DA606A337;
	Fri, 23 Oct 2026 16:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L/JDIcl9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BE41F031E3;
	Fri, 23 Oct 2026 16:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773848;
	bh=KrhrDer4ttiwgkClmf5P5Wqsa8hJNaMznRn6VF2Qujk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/JDIcl9SEMOEvxGKAqvhI1kJGa+dmvAxfZ4T/V/uxddxSyWW9h4RR04bmfoIV8L1
	 e1/0MDQHO7+1nu7xxN4O1c85YYFNsExAAhz+Ew25aXeQLg3LavZkU82BD8G0WVOgGR
	 e+/4YceEb4ShduQwwlJYtNrTXOBFhqm+2cz3Moew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 036/193] ASoC: wm8978: Fix the 128x oversampling switch bits
Date: Fri, 23 Oct 2026 18:35:13 +0200
Message-ID: <20261023163715.057640020@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
index 8c45ba6fc4c3a..e9ef9bf4be095 100644
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



