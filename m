Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033149;
	b=qn7HLZ+85RL/IfuXv+YpqBE0+X90q+GUy0t4A8hf+5al6dgVVkpsgktkamWkMEVL+sBy
	 pwaWryJ00B3YW8qFrTDpXUM8o6HWOlw1dXVQrpgv6P5g6tCiHBoP5tp4v5Fbp31pYFcAf
	 DGx15rLSqN+FWW4Tvbx2QecOeF2Ecb6wvwuVAUMbNpNKx8DG07vM1N9MJcUP6D6bgwy6B
	 BXsmLNu3a1Vkmf567gj7RVniA/lWTOULCXS5LT9FBLN0y5rbTUqy2salHaviniFARFJzV
	 WtR4Xsjevf6TFDgs9IuqFHmcr+hMkzqW72xZ4Bwt24V3cR4jQPvtFgokTP2BwBdCsGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iqlOd9lscAvk/de+3ivzzQmwiERr6RoRGCSIBL96NCg=;
	b=QIImCDWYT3wt+oOtV1b2mu0ZOP9v8NG0ruqVmSFP/TQpnwBBNfbG7bfQeYqXVG5Innz0
	 KPjl3noCPiL3d9HlRPS2uuOlc/zMPINdf5bbhpVK/8LuIE7oLmWVwwkBCtKyCPHwZ0YgZ
	 dmiFXyjU16RFlsaJjPidlt9BXDBG9HF/6iMs3IqgPreMb7SL5O9LvTksHVeu2HvA7B1L/
	 ISJbIsk+pZH5+HdLPHo6LcMeYcV62mdTYshmIl77Vuc3k6Mau2+Pn25krHKfsCTYuUbN+
	 3GlsR9ritWkM2hSRLnByQdvaDzCJsLk5EYeb+qslD0Dw5QN+bQzfMvxNLkq54rq8J5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dtwCULoT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A10B606A330;
	Wed, 18 Nov 2026 20:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dtwCULoT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB83E1F000C4;
	Wed, 18 Nov 2026 20:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033149;
	bh=iqlOd9lscAvk/de+3ivzzQmwiERr6RoRGCSIBL96NCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dtwCULoTBrBlkQjAeoTLeuwEtAE5PWIV9Y77L9Q7EMnrPNmg0w45iqlJ2bxtEuC1B
	 tb45g1XcnCElYzKaAr1F+k0OQ5xTBzFIdbonojndM/jieCpf5caOCRDE85yRFfOjPm
	 lYU2uBx8qb7vsdiwe8yqWEKH37rkss+WmA2AJwFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1665/1756] rtc: s35390a: fix typo in comment
Date: Wed, 18 Nov 2026 16:03:12 +0100
Message-ID: <20261118150116.001804235@linuxfoundation.org>
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
index 0713a5afadfa6..94c75cdf0c8a7 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -314,7 +314,7 @@ static int s35390a_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	else
 		sts = S35390A_INT2_MODE_NOINTR;
 
-	/* set interupt mode*/
+	/* set interrupt mode*/
 	err = s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, &sts, sizeof(sts));
 	if (err < 0)
 		return err;
-- 
2.53.0



