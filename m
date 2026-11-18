Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033135;
	b=muIMdTnoQi0sstnyEISYsLLK6+8ZHozGSy1G9iR5MMST6uG6sR9dmGpQhbt1SAksVqyt
	 vl7DiXurHbro1Sj6eeAdH0x/sSpXumHZSb0GHvtXV+u1oMBTQq6FJMYARN4t5UGJpQ5NH
	 zIp5RHanJRQ0AVRBrXXASqFW5jMUTQu3Xt+0QqvEU3xnOQ8yuI/aq3rGnltokcIG2U6qn
	 cp+MtsyfRPaXSj0/aXpg585RO63g+btNa8gLR8GA5q8UGVDMc2njDl97iLdaP6xn3nuX1
	 Vf8jdr4KxYOsr1h4kz9KAMLIgNDjpuCgi3UxYqqVHi3QBhmhC9w6WyYPqjYD+xkVmPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tO0VrjpZEE7s7XABkwbI7N9LWu5B6qbN8MrdPnSME+Q=;
	b=bWR/Q8VTMqfkeoAH3Q0iJTkz4HSuS1j5PGoAI+KLvkXuSOAf8UOr6fTpBrs7YiXuND76
	 wDuWArPIF1WBzhhMQ0Bf6/aEpprRwulHKwFbF8PTx4AM0Bq3XSVmMrsZk+O0aZuP0uCek
	 vWLuFf/4sstfmuQhH8D2mE27HVsvswC+2EbhbWwZ503NGb4gNteo9VI/vJqAQR23T9/tB
	 AXYT9wQONKKVZy/nb/CQOux2JeGmO+Fnjn7kuZBxH0HedIXaNi8ks1IooHuMvoorS5+bG
	 0TT4JxAQQuNKkEfyR117IAl/a1l9igPoFZHYIWHGRbiKwlK/9aIzjEZkmYCCJn+mnEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c1WNmrzw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F5C606A31C;
	Wed, 18 Nov 2026 20:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c1WNmrzw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078721F000C4;
	Wed, 18 Nov 2026 20:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033135;
	bh=tO0VrjpZEE7s7XABkwbI7N9LWu5B6qbN8MrdPnSME+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c1WNmrzwZiKbZ5tglhp7sjl2pMkDkBAl6p28jIzheOUJB1WwObb5G1c2ZsHSHHf0c
	 lMYRJAJTuqcimQs4fJlnQbzp+Qno89rVgIOxXZc75wIsIvD7uiDVrTSU0RWeT7tfCd
	 pynkRYpMUB5+lofcKevnvUYZa9XoDFSbeUx411iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Probst <markus.probst@posteo.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1661/1756] rtc: s35390a: Add missing newline to dev_err
Date: Wed, 18 Nov 2026 16:03:08 +0100
Message-ID: <20261118150115.838266308@linuxfoundation.org>
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
index e3dc18882f414..a680d2c354261 100644
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



