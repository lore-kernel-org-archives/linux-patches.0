Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056241;
	b=Yi0eb+gZCcB4IwrRAScCLZhS9PtmYz7z6P+ijRAHCPewFadNgeL0ZbcQ7ls9F3RZB6fl
	 cvLtdLCepfrnladNAbcmhkDLIx8dYOHGlWTnsF2NuHLnMxw/juYHpGeA9iakqPvrr1JMX
	 8b2wo7hGuXOMhW0XFXy5wylWbpPGHt9LpN1zGyFQfvKYZ2bYaR9R4pHOGulHGlHYZY6Yz
	 CbNmedTqOG/nB41NZJNz37dR8NX4SUPvhS/Aa3JmOP//1dJWrVM9P2a3FC8prZ4rWIhjk
	 76fkAHIAmXacc+CvPRSCEKQ2APyIaU7VN2bF5GwaoPVzvEN0R6iAaFz4DSpVMHxrRcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=thjJ+uETcpBnG1eS+SVBGke3das4Le8FQfv5H3MP/ZQ=;
	b=dDxTesNpMDARPEEbB9IvR2H5nTlIeYvpUCWeV4FNkBZ4wAjB+HLM5rLlwvkjOodwup8k
	 PSSKJBvNr59S9PiI8ZyygQh3VuDm49curtk2U/9XXMnd+DpXu1DDpwm/LafPt5hNBL6Bi
	 2jtWQtdG2QWSokfVLN2ZTqdQPPo+bsqRi6/BDoPIcdLAg49v06l7C/JFdVnGC23bIuf1W
	 IV+Uq66iMKU6ICRIWuQn1b5zcl/4mG55ZkufW4Ttd6Zlq0sBjWYNVZyRHvnnGHz/od9ot
	 Lj3IxfjY+EsDPohNdjaQM7DvCb8zeWGQosOJEss6SEa219qkbG9ahWtGf2C8h6Sl8tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RVWA057X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7C5606A325;
	Thu, 19 Nov 2026 02:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RVWA057X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDED1F000C4;
	Thu, 19 Nov 2026 02:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056241;
	bh=thjJ+uETcpBnG1eS+SVBGke3das4Le8FQfv5H3MP/ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RVWA057XdQhJHVl/8GGEknF9tFJbt2MrnnB2+XVF0jxabO34s+dF3KW7/wxkvFMuy
	 0S4uY/LFRp9V2a/CUK+leHt5U8bpSxr/6uINQ/dBTPt1AcB9BwHxQqM3VawIvSEzYS
	 qk4zBXGZFdUe3YN5FsV1ON5H1fxlfRfp8h2pmAtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1918/2214] ASoC: codecs: wm8983: Fix definition of ADC 128x Oversampling control
Date: Wed, 18 Nov 2026 15:59:54 +0100
Message-ID: <20261118150127.789174677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index d8ed22a9caac1..a08ce894bcffe 100644
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



