Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022179;
	b=QULT64yVffAvYYnUB0e6en4s3rBx6wi9XMRkJPN1C4pgIKF8Li9vtKLhmULg5xIyMp8m
	 k4Bl2rBmRBq1sxAvQRd3dt0+rgs1jm8uZbnOjpXPiFrFCii7gabIVvfJW+MrteiBtpmyv
	 itWEO1LzLAv9821xBKLBFILQuoYZ9LyvyE2RaUWBwKn2+XBiNx5BxDkdD4N2mlmHV3pEq
	 JUDantApQ+u/bOQ9uUW7pFhPVpy2DncBsVEO5s5OC0ix98ZvYkUybaqIwNyAd8N4liz7J
	 JNvcb0Kn7QckNJQf41oXOq3aHY8OhmbFZTWWzmFJu585ubDz7MN6fqmBXpcHLC/2Iaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Uv1Xy3TNIfcb2TDdMT4bZIX3wnFRhdG3gSzSUGOZDxo=;
	b=YoXdHGh7ghVSEEkg9xrbIb3HJMYCMg5krjcBbERWZLdl8ybFMzwMw6sbGqTbt9Dnvm00
	 MMZgq+0GiN6W4tAGyd1i9x29TgPQfVsyDATaUGH9S2kvZvYTvu2afLDu6TYgLASNlGU1P
	 UW+rVHoYJ5foZhsiGi3j6WtYOfoIVGXQNeDB4yAzIirQY74r+4oIZzQC7a5nElCtJMJou
	 Pj7j3fcflwfunL9g7p7i38txt5OGW22x3m/V6rCTjm2CF0V3kWoClfdSb87bxDb1qgle6
	 PtjWkHE8XUPKDdAPQLrQpMEFuNaxSgptZ5f8mqO2S0bVS8EZh949txR5dS+kNznvbIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WqDockLo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCB7606A325;
	Wed, 18 Nov 2026 17:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WqDockLo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15321F000C4;
	Wed, 18 Nov 2026 17:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022179;
	bh=Uv1Xy3TNIfcb2TDdMT4bZIX3wnFRhdG3gSzSUGOZDxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WqDockLo/qyp2wHDwZrY+iufmCQLlCzWt8CorA9fF7B4xkxkK5lviavZ/Bn4gqmRm
	 2XJftyMf/1G4xKY2MyRmOzVlYkjO+Ulsgm69+yiJ15DHrOlhl6s3jEsBTdzgdZCn/k
	 D8UMHAg+wJHPb2JpSZMkl72oEmT03K/DOPR8K1+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Probst <markus.probst@posteo.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2569/2651] rtc: s35390a: Add missing newline to dev_err
Date: Wed, 18 Nov 2026 16:03:29 +0100
Message-ID: <20261118150416.880815098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b72eef4fb0997..4cfe7034c5165 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -494,7 +494,7 @@ static int s35390a_probe(struct i2c_client *client)
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



