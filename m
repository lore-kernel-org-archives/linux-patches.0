Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050674;
	b=xHhIFxWpDxBVPXlbHBxGu94VtvlhKB1rQiQtUK6uTvN4YsQO+HA+Dyt/uszP6OMlkCDk
	 SevCDdb0yECkMABrNs966Ei548iXur/NwAgpsWmRoRDuS2ZmrYpFeLr5+Nc/GmSzPJLTY
	 3h6iasw9Ot3xLKR+Fqlmrc+pb+irFx9dA/6IZz0xnbuluKaOy117aSPxx/KWuRdfMslmj
	 pNvJlQ2Z7Cg6FijH6VkgojIKCl3HOE7zVJuKKhOHivicI+bpKvwAXAJ89fY1VcDE3a9a0
	 M++4GnbeI2b8IU7TcTLLeLk2ijkJzyPowwf7RBiV/lOtLSCyhf86asSscnmwwy6bjIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xucHxdUTbUaUiA/U5bL9PGh2pHvB21gwjVqDlfXnSnQ=;
	b=sswrIUF9KWyxzX0K057sSUrVQRBWanmiOqVePo2TYpF3MLk4DS3CnzZgXgN1tRwn0hCO
	 /btw2LXivlBVcAyxUmkl8ckoQI8rMrM34RnDTKigofeSNj1Vv347JzGC27yrXjXsEXgcE
	 qE6A/IVcjZliwynM9nPRpyyTHOhlNYR3BxPv0htFfO3rcbAtX0viAc/FfSNODBOGRY1C/
	 wq0TE3DP+OMCmWezpMa0rw2Km3F1R5FEXQwHEUQMMCtucbMZPpWblZRSGGSPoGdsOj7rn
	 ZoSxk4DYfFZpwKOmmLEo3d/UkDG+bVU7lBrvdKE5BwZGsAS9Hogwxo9KpPJqAg+2iwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rZDnZXJc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150B9606A31C;
	Thu, 19 Nov 2026 01:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rZDnZXJc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7431F000C4;
	Thu, 19 Nov 2026 01:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050673;
	bh=xucHxdUTbUaUiA/U5bL9PGh2pHvB21gwjVqDlfXnSnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rZDnZXJcbUEITDdBwWwrHv+ON2OFluWbDeWrSABj0pANpKHcAkrFUxEAvp/Kt/6r7
	 NT6jENukki//9A5V9+TCjM3coVu5aHy8fJckOawFQVoq5Dl4ApvA3ou7hiMTTDBg9c
	 6YZbMqZHJ6ZZISjLrpBVjdE1xlpjz3hHxCHdxQH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Probst <markus.probst@posteo.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2791/2857] rtc: s35390a: Add missing newline to dev_err
Date: Wed, 18 Nov 2026 16:03:45 +0100
Message-ID: <20261118150342.089804015@linuxfoundation.org>
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

From: Markus Probst <markus.probst@posteo.de>

[ Upstream commit a27b25bb9b422c8468cb6965b2d72b7b64187fd2 ]

Fixes: 3bd32722c827d ("rtc: s35390a: improve irq handling")
Signed-off-by: Markus Probst <markus.probst@posteo.de>
Link: https://patch.msgid.link/20260930-rtc_s35390a_int1-v10-2-e7b1cbc50a7b@posteo.de
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-s35390a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index 81d97b1d31591..2509beac5009d 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -470,7 +470,7 @@ static int s35390a_probe(struct i2c_client *client)
 		buf = 0;
 		err = s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, &buf, 1);
 		if (err < 0) {
-			dev_err(dev, "error disabling alarm");
+			dev_err(dev, "error disabling alarm\n");
 			return err;
 		}
 	} else {
-- 
2.53.0



