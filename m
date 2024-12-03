Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2271F75A6;
	Tue,  3 Dec 2024 15:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239900; cv=none; b=mbTPxAXowHhnBJt4B5f0Fm3B5M/6Tpm1U3YBItL3rlElbfa1u8bhlNb3xzUkqK9UWrHVg78bG9dUvG9GyEYrdB2z4NnosXWf1s2ZP6mi0s3tlbpsATu0EqRlv3RJXddGG+Z5UNbG/78BjOh7ap2HxjtgChRtGb2Wh4mc2Nd9hMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239900; c=relaxed/simple;
	bh=nxn1lOWKCVGGmI0cdS5jOS1s7Klj9XKf5e+eig5snyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sx/g2u/Ilj4b1fr/M2i7wkZ82pT3MLz2gySIEa7tz63KuqFfRRYpmY0k/aKAG8xaKYpNBC1Fg0KYOpePMRuWf6jEK1cmY8HG3uMJNFKcxA30oqytCDl/G3tU0LLUuFL9Q4eMUeXlJ9pit7XJmR2Y/uv3Mc87lUoj2kUjP4xGx3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t87bEZFW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t87bEZFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CE7C4CECF;
	Tue,  3 Dec 2024 15:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239899;
	bh=nxn1lOWKCVGGmI0cdS5jOS1s7Klj9XKf5e+eig5snyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t87bEZFWgto+cco4hHPZ/x1QJ+CWwJR56eljGPxsNhtsf81tWqlMwppyKZ7X20aL3
	 sIdvE0RzxzKdyosAd+Pe1KfrD9Hx6JTy9MI2CAZHyvNg3TPar1Y+aeKqCA7xWpc9uC
	 RqY2b4+4ct8d3v6iq/VFJC0cXEdcx5NsMOiZROAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Gebben <jgebben@sweptlaser.com>,
	Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 772/817] rtc: abx80x: Fix WDT bit position of the status register
Date: Tue,  3 Dec 2024 15:45:44 +0100
Message-ID: <20241203144026.148215926@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>

[ Upstream commit 10e078b273ee7a2b8b4f05a64ac458f5e652d18d ]

The WDT bit in the status register is 5, not 6. This fixes from 6 to 5.

Link: https://abracon.com/Support/AppsManuals/Precisiontiming/AB08XX-Application-Manual.pdf
Link: https://www.microcrystal.com/fileadmin/Media/Products/RTC/App.Manual/RV-1805-C3_App-Manual.pdf
Fixes: 749e36d0a0d7 ("rtc: abx80x: add basic watchdog support")
Cc: Jeremy Gebben <jgebben@sweptlaser.com>
Signed-off-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Link: https://lore.kernel.org/r/20241008041737.1640633-1-iwamatsu@nigauri.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-abx80x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-abx80x.c b/drivers/rtc/rtc-abx80x.c
index 1298962402ff4..3fee27914ba80 100644
--- a/drivers/rtc/rtc-abx80x.c
+++ b/drivers/rtc/rtc-abx80x.c
@@ -39,7 +39,7 @@
 #define ABX8XX_REG_STATUS	0x0f
 #define ABX8XX_STATUS_AF	BIT(2)
 #define ABX8XX_STATUS_BLF	BIT(4)
-#define ABX8XX_STATUS_WDT	BIT(6)
+#define ABX8XX_STATUS_WDT	BIT(5)
 
 #define ABX8XX_REG_CTRL1	0x10
 #define ABX8XX_CTRL_WRITE	BIT(0)
-- 
2.43.0



