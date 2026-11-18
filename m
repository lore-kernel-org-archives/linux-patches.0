Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028193;
	b=w0yIL0c/MNn3aVgNVjEq7xSG5I2WWzAL98Wv7GdHk3fhj+1GVB7eMj9Fy4EjUOe2y4gW
	 K71ZF3+wRZzRmHAb+hkMwS8OIEYlKxdsMS17gFkExElRNhYtSKwywbFmZH//KSM7BaVu+
	 vF38VDuulwuIDkHVz2HBdq9HsEgl6n+ZfXNtSAgOO4pcfgFVQDU5zZ7oKjRRi/yJNEIIo
	 kRXYPUxFhNvlG8JrxobY3x9Iapa9IsWsdDV8H8Itx4GskPHhjdCg6kkRdzcRyciNGrTnD
	 EVm+HMusrc0ovClmf/JBGwON7ImsfJqaG1hxpMeBGcqDdw2sn5g5/qJMom/MxttFvcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/VFbwHgmrw94cql9wgQ4JVKIg/wU05qNTLnJjrIZt0M=;
	b=vlGSeYw1TTVjLGSb2TqNIL7FDzRLYzpcX0/u0G3PvRKn3RdTCNdP7qMHYyKE5PZmbcNx
	 oSvjzZilEwPQeKTdtrOFGguLwKihxyQ/7ReDPYnoI6LYe5Q1g4HFHbkIcz3ti7FQc10py
	 Iwxbr1Tg/31H+mn/Zu4E3ayMNE6gIyfJ24S1Fn7Si1MfVKOG5KaAQAN6/ZeSCT501sfVR
	 HBgPykombBqDw1MB6v7Dy7iYoEVhXEm2FYg5kPCE4WNYMRzS9wvwPf8OQwPoSGCSUw0zt
	 RwjixiSh9UlR4Va1EAJb29pypLpaojgkotI3PKf+nqDn1oJSe+KYdwuy+vielFmbv5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h5ayoBt6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07AF606A31C;
	Wed, 18 Nov 2026 18:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h5ayoBt6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57AF1F000C4;
	Wed, 18 Nov 2026 18:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028193;
	bh=/VFbwHgmrw94cql9wgQ4JVKIg/wU05qNTLnJjrIZt0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5ayoBt6T+6wEFugdHd0btjBoHlDU2znH5m2eeW0uL5/Qxdfc+WWGbHTp4QsImmf6
	 oRUYQUULYrKiyxXTSj2JRRDpRyHLt+IRnfhcAaOtr5+ZFyIX7Dp7/G/6EfuFQXyerN
	 BdbXrkrF6uNjysi8uqer6qWm6v9JIY+Q1/tPC2JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Probst <markus.probst@posteo.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2059/2151] rtc: s35390a: Add missing newline to dev_err
Date: Wed, 18 Nov 2026 16:03:14 +0100
Message-ID: <20261118150236.725121287@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 3408d2ab27419..671e6e7ad7f43 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -467,7 +467,7 @@ static int s35390a_probe(struct i2c_client *client)
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



