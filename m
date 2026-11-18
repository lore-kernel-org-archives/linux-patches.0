Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032269;
	b=lY7Vjydk8dNH+6deOWUsOkZAj4anuLmdXp7LyCEaRfW+g26iPKuCN32ICtNCiWQd6iJ+
	 MpUsDG1KUdwgaoJhW4ISbZCEOMls352GKZxxMkFDwQOA/H8xBofzWQ5NDovlC9skuY5T5
	 j0pDqLByDMcr/RNZpXn4FiLlke+FG9k7L8Tgjdz5ufrN0/ucUSXQf4nExH4aWxaiJ8f3V
	 QAiUhubDh8VFsDFfQHrgx34J/gpKOZvjifd0vrElbrCk5udCzXqkWhr04/7e3IrTmfdxV
	 kiC1PpyJfmjnuXcBvigcnQX5BzcXeb4KSdkm6FS20gTQNn5oFxHtUE3hA1+PHymkJWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DvED6w+l3g2j+zXFdme6vNRfV6tXE1bBykYB9ej3QgE=;
	b=Huwu6BerobACUm2xPsa7GK+MrR8DX4YtZHml+gCOrFvMHfd/HTF+3bCt8FJmughQpMWp
	 nHOEFHnIOnDKnsS5uRnJaesGhdcg8PLDDJ1FIcjVxDX7DPP2wysXJnnZ9jgzhfsZpevtn
	 rxmIgvX7Ci62nq1iqv+3tHu0r2G9iSrkvFMDRYLGOCRArgTVFo/4nSH068qLHUtn3MjwW
	 vaof6vEYADLAt6SgQUZ7fzYHa5mKkCdJ0HeMfW8+Sa1Qov6iqER9uYKKhFqGvcM4rxxYL
	 HzlmpMiSzxzvVLcoqPOxslaYANdgVgriDI0BLdYF6ibg16UE2vfYEVAvY2lAKJ/J/Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eyp0COAo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BA6606A31C;
	Wed, 18 Nov 2026 20:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eyp0COAo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8761F000CA;
	Wed, 18 Nov 2026 20:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032269;
	bh=DvED6w+l3g2j+zXFdme6vNRfV6tXE1bBykYB9ej3QgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eyp0COAoKFvwLND3PKsiME1nElalOnozBjpnRwPk9aRG8PtOiLWkuO/GHFTDq69/L
	 Lx8GPLfsTh7MtGAxv07Zq+b2OYwzoDiWOvARZ8AQxg7TWX7B2uFa7+4HLDhbY9/XL3
	 eYSvJBweOxeRTQb8yGt5iK3krHHg2ds1ZjHkvymk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1352/1756] ASoC: codecs: sta350: Fix definition of Ch2 and Ch3 Volume Bypass controls
Date: Wed, 18 Nov 2026 15:57:59 +0100
Message-ID: <20261118150103.130125682@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 7308ce7c8459e994a36a22607e974e3e132a9275 ]

Each channel's master volume bypass (CxVBP) is in its own
configuration register, C2CFG and C3CFG, not in C1CFG, which holds the
channel 1 bit.

Fixes: 2439ea1f0f8f ("ASoC: sta350: Add codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/1107a42a563459b26038bdff4d8f6e2423816d0a.1792135144.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sta350.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/sta350.c b/sound/soc/codecs/sta350.c
index d1450de926524..ee67b13ab35aa 100644
--- a/sound/soc/codecs/sta350.c
+++ b/sound/soc/codecs/sta350.c
@@ -481,9 +481,9 @@ SOC_SINGLE("Ch2 EQ Bypass Switch",
 SOC_SINGLE("Ch1 Master Volume Bypass Switch",
 	   STA350_C1CFG, STA350_CxCFG_VBP_SHIFT, 1, 0),
 SOC_SINGLE("Ch2 Master Volume Bypass Switch",
-	   STA350_C1CFG, STA350_CxCFG_VBP_SHIFT, 1, 0),
+	   STA350_C2CFG, STA350_CxCFG_VBP_SHIFT, 1, 0),
 SOC_SINGLE("Ch3 Master Volume Bypass Switch",
-	   STA350_C1CFG, STA350_CxCFG_VBP_SHIFT, 1, 0),
+	   STA350_C3CFG, STA350_CxCFG_VBP_SHIFT, 1, 0),
 SOC_ENUM("Ch1 Binary Output Select", sta350_binary_output_ch1_enum),
 SOC_ENUM("Ch2 Binary Output Select", sta350_binary_output_ch2_enum),
 SOC_ENUM("Ch3 Binary Output Select", sta350_binary_output_ch3_enum),
-- 
2.53.0



