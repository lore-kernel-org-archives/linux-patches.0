Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050692;
	b=Ey3kopiGq53gYWdRbhok36fkpSNx5xzbLW++le6fJLBT85+OqhugJp+3wwNfNZ+UUeNf
	 cImq+fpsVFPztBUfJEF2WIMt/GPPgzVZJNKiWXspyisZHEcQeaD1XrsFw+8jKpeVdnAp5
	 XPJXvhyHHVM8fEkH1pOfPPwPvGYd+PbohLVcTGpo1Idqpsq6rPfKurHp3NwP3IblLKY07
	 L3tEtITRs/jeymZGAxNyDugyEk1b1GMTUq0tRad0Fd8Q09guCE83WvH3U2M6xQH48/Hi2
	 JcbdZf6tpXD1lEoUunJE25vJB6hRL60hJIWifDxcebC1bCi2cCMipP1pwD6NQlfJy3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DYLaEfvPTX3woYQ72mqVFWqcxbVTaEUcUzJA9+7txc0=;
	b=lcrJb+h3vlRGajaTBKiZ6XqrmcdF5jIYlWcgoxjVspIlWIs+4OESF9BE3weuf+st717r
	 WIR2j1km9sBua5DPio/v8eTgLv/BiUGG0wTF77k6sGy0JJr7E4AoaEKyL4upMq5TbxxM1
	 mu7Wwk0rKj72IdHtnj/M0icVfvSfncXoFNPKAzbb1qCG/fUUx+44JmcXGfkTrL/VopfeQ
	 uZ9M3LZOdXfGrO/xXMFrnZ3NBUSAeupT/wvnDI41UToeQIX+sXMbew/2W2UJJVfJAVcad
	 MQO5ASuIRhneRHNYbqZg2AKK7pHd/dOArqw3iLx7pfxitipTb3orV5P34Jvp5H/28MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cn5JAM1n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5239606A320;
	Thu, 19 Nov 2026 01:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cn5JAM1n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26AF1F000C4;
	Thu, 19 Nov 2026 01:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050692;
	bh=DYLaEfvPTX3woYQ72mqVFWqcxbVTaEUcUzJA9+7txc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cn5JAM1nP9P55GG7WMDkzgftioJnWQECHwxAAFUZnYPO+uEaJDyj5KlW1gUPv/k+O
	 5ho3CXEvk6AjvCyeUJl/qw3wuY5nAkpwFIhxNwQG7xHZVyJhJFbPBHgv2uz3bMqO9B
	 lo5KGeZtz5JmahHlYze/RW0sJmhSeWoYlNDb7aSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2796/2857] rtc: s35390a: fix typo in comment
Date: Wed, 18 Nov 2026 16:03:50 +0100
Message-ID: <20261118150342.265243809@linuxfoundation.org>
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

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 50ccdc31010ed623e68e496aebd4b1d3d8430664 ]

Fix trivial typo

Link: https://patch.msgid.link/20260624204223.1479003-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 6199051016cd ("rtc: s35390a: Read 24-hour mode on access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-s35390a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index 79f9600197525..049d679ed2b55 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -315,7 +315,7 @@ static int s35390a_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	else
 		sts = S35390A_INT2_MODE_NOINTR;
 
-	/* set interupt mode*/
+	/* set interrupt mode*/
 	err = s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, &sts, sizeof(sts));
 	if (err < 0)
 		return err;
-- 
2.53.0



