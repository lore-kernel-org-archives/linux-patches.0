Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A8718CC1F;
	Mon, 28 Oct 2024 06:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096914; cv=none; b=c29G05dseYwUd5n/T5VUlbLuO7sYlI4Y4cz9W3tYY6lZjFogXac0FK8SoY7Ws0+wbEp1HQDFGo+8PEZCDvAhMjytDDRG5OXMZYN9BQdrbRKoXa9L/Q5lLE/MbvlH4IwOTEabS7w8HjIaSj+brE+q73mal10Podwbn+0QSIZZX1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096914; c=relaxed/simple;
	bh=1u+ad+wOOJ2o2Wdqczvg7icGXZ2V2Viw1bSG1QP4hzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfAoZTjdIdm/BWWaNWk1Yay0m1nGAIAISqwrbY9CUEKZNdG1TrfdwO8HZP1r/aPSMyDEyS6Juz2wF1rPrcoN3rkEZekAh5M+NEgYPrAqxnr1c4gXs2Z9OcWpnFr0ZdmQZlqGmKMSi1UPPA+c5/Df6sU4DSgFR8VHbtV1UeTboEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+30jAii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+30jAii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB8EC4CEC3;
	Mon, 28 Oct 2024 06:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096913;
	bh=1u+ad+wOOJ2o2Wdqczvg7icGXZ2V2Viw1bSG1QP4hzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+30jAiiwWEnQ6cwtUqMNECG+bkW5AzsZeCWx0h9W+ZCgGhXim1svtm/TxLfcFeea
	 mnENimuBNp3f9eB+SOBhGBw+ojYr34Ffo1XaE5bdMyV0AAUemxwoJiSdLSjjcMDmgX
	 oBE9ioB0yM756y7VdCAwgt4I/JZLKDyrepV8xH0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 42/80] ASoC: codecs: lpass-rx-macro: add missing CDC_RX_BCL_VBAT_RF_PROC2 to default regs values
Date: Mon, 28 Oct 2024 07:25:22 +0100
Message-ID: <20241028062253.789340516@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Klimov <alexey.klimov@linaro.org>

[ Upstream commit e249786b2188107a7c50e7174d35f955a60988a1 ]

CDC_RX_BCL_VBAT_RF_PROC1 is listed twice and its default value
is 0x2a which is overwriten by its next occurence in rx_defaults[].
The second one should be missing CDC_RX_BCL_VBAT_RF_PROC2 instead
and its default value is expected 0x0.

Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://patch.msgid.link/20240925043823.520218-2-alexey.klimov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-rx-macro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index 72a0db09c7131..ac195e3b8c46a 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -907,7 +907,7 @@ static const struct reg_default rx_defaults[] = {
 	{ CDC_RX_BCL_VBAT_PK_EST2, 0x01 },
 	{ CDC_RX_BCL_VBAT_PK_EST3, 0x40 },
 	{ CDC_RX_BCL_VBAT_RF_PROC1, 0x2A },
-	{ CDC_RX_BCL_VBAT_RF_PROC1, 0x00 },
+	{ CDC_RX_BCL_VBAT_RF_PROC2, 0x00 },
 	{ CDC_RX_BCL_VBAT_TAC1, 0x00 },
 	{ CDC_RX_BCL_VBAT_TAC2, 0x18 },
 	{ CDC_RX_BCL_VBAT_TAC3, 0x18 },
-- 
2.43.0



