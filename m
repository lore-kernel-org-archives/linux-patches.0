Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161871868
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4DFC433F0;
	Wed, 28 Dec 2022 14:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672238689;
	bh=SSVVqv/Ev4MY05waRO2gzPh9AGYY/5A8YZJ8h1gRwk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4MoME/I2kc8yeuyTy/B/TB/FhmPmpEDCx2Atzp9QwSPyuhgn0qLONPbUgrXSgDIA
	 9UX86dMhglHlBPMFyI/MLavc9w2WhvNa7kifpM3v5TmmOpUUAQvYWRfzVepYGUW42+
	 szzu4fyrw0G5mRxvY97FGNwyoWq3Dv2Ph3adaEc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Sasha Levin <sashal@kernel.org>,
	Philipp Hortmann <philipp.g.hortmann@gmail.com>
Subject: [PATCH 6.0 0001/1073] staging: r8188eu: remove duplicate bSurpriseRemoved check
Date: Wed, 28 Dec 2022 15:26:29 +0100
Message-Id: <20221228144328.208508491@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit 8f60cb9534e459d66f6888038951ffd74351ef25 ]

We don't have to check bSurpriseRemoved in the SwLedOn function.

SwLedOn calls rtw_read8 which in turn calls usb_read. This function checks
bSurpriseRemoved for us.

Tested-by: Philipp Hortmann <philipp.g.hortmann@gmail.com> # Edimax N150
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Link: https://lore.kernel.org/r/20220918175700.215170-6-martin@kaiser.cx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 12c6223fc180 ("staging: r8188eu: fix led register settings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/r8188eu/core/rtw_led.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/r8188eu/core/rtw_led.c b/drivers/staging/r8188eu/core/rtw_led.c
index d5c6c5e29621..e889e7861706 100644
--- a/drivers/staging/r8188eu/core/rtw_led.c
+++ b/drivers/staging/r8188eu/core/rtw_led.c
@@ -37,7 +37,7 @@ static void SwLedOn(struct adapter *padapter, struct led_priv *pLed)
 	u8	LedCfg;
 	int res;
 
-	if (padapter->bSurpriseRemoved || padapter->bDriverStopped)
+	if (padapter->bDriverStopped)
 		return;
 
 	res = rtw_read8(padapter, REG_LEDCFG2, &LedCfg);
-- 
2.35.1



