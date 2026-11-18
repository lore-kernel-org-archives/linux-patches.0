Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031858;
	b=CnKKfDK8mNUOdGrlpQCY0Pz2HRfqkMi9di9H5yKVfK6HOJ392fJCuU6d6ObUSMo9kD3N
	 tftxjYDmuuUo0Jdn/sPc4opMH3dhlGMfk1uwDtVZWBuvnZ75CQck86oqlunEpMDIteabp
	 nMEur/xEF2JHyPeCybfEBzMEmbynC39qJcb8tjeLBhXNOVe9kLx5ivcUSLPZrgnd2wmO/
	 pBBLz3Q7oqGHiJQIlw96JAyylaXenrYDmrjUid8xU+zQpd6CQN47DxPgsHpArKcdelQlD
	 T7UECNqpLWZXysnyBXKR863NFEs29uLeB2UQPDtg6RSLDss7aHZgaXCVG2qgIWW4sjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9rfXf7A6Hnz5qj6oj7n93953godBptOaF9rvWlGbAyY=;
	b=UldQukb5hN5d4d/MGLP1aYMZpQNuzc3r6c9kKJ/tBC+nkRxoBsxXfrcidPBpB2anz3NP
	 q3FBDxKn1/2J7rgQ/Vy6CH5MJ4yQ7FoxdlKCBT/3IlQN+981PMQXIU381kLj51F1U6oZL
	 l1PVodPptKKSSa1y3NtTgr+3Ymi5ixApWBbHk8n0xS9pmxv0J0X+DLO3ruV+2LFbNVkAZ
	 iNWT7fj2xwcwiJFkZtV5YgnFGNup3I7hJDwbZXtQ9ZQfho/X9eh1bfVlUfzB/rXdfsAlV
	 qmXYTir5Z5Hv31iqQrEgeKI7mKFsLk2vqR+ErurG2v99MW2n9jcIGQ0ok39lTOTQnuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gFTu0PC5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2E2606A320;
	Wed, 18 Nov 2026 19:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gFTu0PC5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEC41F000C4;
	Wed, 18 Nov 2026 19:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031857;
	bh=9rfXf7A6Hnz5qj6oj7n93953godBptOaF9rvWlGbAyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFTu0PC5JTFnknhz3xXDp8LGzx+i49+PTnWuzlF74mINxJnIkrbdY+FgFiFGE4n3+
	 UhN+0CEsKw2zwZltnbz78ZF8XZ0rcvxFM822BLsPLBR7r+OFBIWBIu4TSww/JmIx2/
	 pIyl7TD5SQXbSpVPebMJCh8juijdUvr2/2TsLMVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1207/1756] ASoC: codecs: wm8510: Fix definition of ADC Inversion Switch control
Date: Wed, 18 Nov 2026 15:55:34 +0100
Message-ID: <20261118150057.869657350@linuxfoundation.org>
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

[ Upstream commit 22d50113078dfbeff0d005d64fd9cc680249831c ]

ADC polarity is bit 0 of WM8510_ADC, not bit 0 of WM8510_COMP, which
is the loopback enable. wm8974, which has the same register layout,
already uses WM8974_ADC for this control.

Fixes: 5d421516670e ("[ALSA] ASoC: Add WM8510 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/6ada61df8c8fc97ffb1623e74f6742ca498032fa.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8510.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8510.c b/sound/soc/codecs/wm8510.c
index 4a31d6f895020..4978c8b0aad9a 100644
--- a/sound/soc/codecs/wm8510.c
+++ b/sound/soc/codecs/wm8510.c
@@ -135,7 +135,7 @@ SOC_SINGLE("Master Playback Volume", WM8510_DACVOL, 0, 127, 0),
 
 SOC_SINGLE("High Pass Filter Switch", WM8510_ADC, 8, 1, 0),
 SOC_SINGLE("High Pass Cut Off", WM8510_ADC, 4, 7, 0),
-SOC_SINGLE("ADC Inversion Switch", WM8510_COMP, 0, 1, 0),
+SOC_SINGLE("ADC Inversion Switch", WM8510_ADC, 0, 1, 0),
 
 SOC_SINGLE("Capture Volume", WM8510_ADCVOL,  0, 127, 0),
 
-- 
2.53.0



