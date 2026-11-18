Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042691;
	b=18xC2Q6rvVSKk8D7Fz5cGCeG8/aJggxrM+lMWLLeTDiR9U1nu9FSoou7HxwRlmEePCZ5
	 E7unolUmAoUtS8O44NyevP+o5Z4oc+J/3u7ONSzL5YzIvtS+mpfbSCdCVh4dNBsTR1Ypz
	 mvUpAkb5df90moAiqoyR9ix+gbxZVmcFDlnc9YPjiEyAcN5ZcV/AOFbnwaC/2UmRsJQ+3
	 8Brgk5s/AfBrKCerxyJVpk1inorUkfbqs7+8rFV5pxfGMb/I4UxFesLCEc/SgI6nLxCIP
	 /vt/LhZIzV5JASsGXmtsT216f9xZm79NZAYcjm/zPjBelEcZZn0uPGTRJxFoz93nvJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N8dXvAwfg4gDfRyFmD/fl6UBe8wl3EQkbVuPGMgXtI0=;
	b=ckvVAYapnTRRVknAWdbJSQf1AOYmgBww/PcERvQFUPHTXm8f9eEo8aHyOaUPw3K+jJqP
	 rvKeEjg8LH/yb3r0pwF1hUj/4PWf8zvrsno3s2MMendCJGkivn3CPrOG8KR3NWYMIJ8a3
	 v7Kmu3qfxbWREYIlvIibGs5WUfBIgaSGZBWnBB4etM/dlyZ9cCCNcex49Q8KJLJfpbW1S
	 HmNdY95qj8rbcO3i+prBweDRLQJujR7aUhO56/9LxLxM672Ayjn/h1IRwPEVI7Ld/mBRt
	 DGffk0g8q19QJu/QxV2iR4DC/E3m3u3X7+JvtIUOHv/0JluVVVIqLOkUDB5M1XSWeQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oRdQv6pg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD6C606A31C;
	Wed, 18 Nov 2026 22:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oRdQv6pg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5691F000C4;
	Wed, 18 Nov 2026 22:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042691;
	bh=N8dXvAwfg4gDfRyFmD/fl6UBe8wl3EQkbVuPGMgXtI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oRdQv6pghLqmuxFNWXkWwfliUr6loNjc5YtkJFkd+sVIyjRfmPLMLd32Id/1OTOeY
	 0mdPPs0aureHd9NK/+EfltAGd/cK8KLbO2UFk/buPRHLcxOKP8vRsHL6v6U6cy8LLS
	 MO0dGAEzlQlzF83RkML76dgTsMKdaIjUj/a7GCds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Probst <markus.probst@posteo.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3244/3318] rtc: s35390a: Add missing newline to dev_err
Date: Wed, 18 Nov 2026 16:04:26 +0100
Message-ID: <20261118150456.986991923@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 90a3028ac5743..ea4eaa675e236 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -468,7 +468,7 @@ static int s35390a_probe(struct i2c_client *client)
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



