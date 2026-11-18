Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062160;
	b=lHmvwYkA9zCWTIybDT4KgkPqpzKYVFZGzgzOfXU8uCDve64L80tfQO64hmTHcXbSGz9c
	 BZu8iH62sadF65mQJLBxk0BQhs3DDULP5Gmso52Z4fupdGQQqpzWKVyKa0r9/nW+XArFj
	 zOIkuM20SEXjgIWiAx81mvwBLpIWZJAq2zn7O0kPwpuf2nL4MokW6ExSI6ewGH0h1nQkF
	 APuEnvhbfG9EwWZpNuV41LeTdVqdRSDexc/ypZUoyQ8XAZi8J4z/RrcENFbkjsrMHqiN3
	 NnNfK/JWj0ktSGk4BfFOFTcp/aPYV2A45AYcArsff4UBVUby7GjyFmHpTuK8cnAMIew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jms3v02syigWqLK1ruT4bp+f0VjtlcE95xWt1W6gE1I=;
	b=lJST96cW1bHTadt9fv4WQ0ex7aHfD/XrP7xqrtYEMV0WPlHuPuKgz4HK89/jtV2QQS6i
	 qPzMhcgpzIfyd5IAts8NHekItetVi8s+1wsUaQyfSDMBOCILVD/km+iPa68BtINuaiK2S
	 IJyOqqI6XiamemgVb1kJNtBcbqUcBIusUcXvVhB3qi0qt71ylknsPKxJr/Uc2M6b1M9gv
	 ZS+/4jJNYNHLOoB/c7XiBtqhIF4j9MIuzI4qRDmSqaJxJxyVheLzElLLJvJH2bDPe83Ld
	 mzY7Jxc3sHFBmnvvOTV+YxJ0o8lgFyYJoo/blfra70HxMyu95DFp7LFDGh8F1jp1LOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W4SbXvDN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD59560A2600;
	Thu, 19 Nov 2026 04:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W4SbXvDN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36591F000C4;
	Thu, 19 Nov 2026 04:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062160;
	bh=jms3v02syigWqLK1ruT4bp+f0VjtlcE95xWt1W6gE1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4SbXvDN09xKM6Cm194xxa7g7h4ShyGbguqpygP801z++WGQMhOEDbV7wfa7vU2di
	 X9v9/Obdi+4gc7ZgcbjHbpyw34+EOqP67RYd5NWK/DSWysRgo0Rtm+gNdiN6GL+aA7
	 fePW6lBIXzULAmfAjXVTT4pfVWPbhdcJA1Qhw3M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Probst <markus.probst@posteo.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1810/1848] rtc: s35390a: Add missing newline to dev_err
Date: Wed, 18 Nov 2026 16:04:08 +0100
Message-ID: <20261118150035.145057821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 03672a2463569..5447f116cc910 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -474,7 +474,7 @@ static int s35390a_probe(struct i2c_client *client,
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



