Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057078;
	b=LB5dgYKiW97Q0VFpx0hbdiFiBePOOrRloV0BkK3/SeGZdHDlv6WNFSpCPDfomLJZHsi0
	 305i0vV4u0vGycLOFzwoldXvEISutMEPW4h3/EOL28FTV3LZ4HqPKiA3SNJZigh46SBQO
	 I+YiFUlhUYs+Ot+B5++SGkKKNtTXGqCm8xDeORS85sKMLmDxKgVNzPb3DUP16j4l3/gjB
	 Q5WmshJA/v7WxY8qYQzHdamOiaucnfyS6XBNQ7a1MtMLilon9u2jUe1PU1q8MksW+aQea
	 H0NAY58Gct2XJ59MYqtJNw3nV6fdXCDmnR/BnFL7h8mpFs8trULoUwUZ5qBd0HH4QEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CykDHtTWHmHFlUOhNwmZiE2P/EKuBOodaX1hEMRbOqA=;
	b=pzCNTxfmW0HJO3YGUMEAha/dslgVlY+CmHNwbJvCGRWnL5Bx9jNpVtOenc22+SLxAOCC
	 v8sxlxnI0WMhpKvIqlWATr9EKu2VNPqCpw4EIUWlqind3s0cPQrMJpEdf3gXiO0mJ12F3
	 1zYQLt3f9u/Rt+A0JXF5nHsRbiPDlcnGkKJQIevbfmVHXDceudDKrOVeI8J9nh6PfO/YY
	 b2CRIJbET9nlIj42R3CCYx+ZLuUhKwjYxzT8e2FUoRV8Kf9yViGmeVt8j3D4Qnke2mvTN
	 H3Epnt3QGNRDmW+/YYdJcRqzyhmXyZ/ATBL70MeKJ3ZJHGfUS4CIdSerk0Il4xrsHNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nqknx2Yz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D74606A325;
	Thu, 19 Nov 2026 02:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nqknx2Yz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25C81F000CF;
	Thu, 19 Nov 2026 02:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057078;
	bh=CykDHtTWHmHFlUOhNwmZiE2P/EKuBOodaX1hEMRbOqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nqknx2Yzk6h3Oeasv5RIfMESTuS+6zu2ePlV1S7jEiabyGeXdPgH2JZPYKFfkNiHY
	 EslMdRaKCIJga7Y40XQb9tX14mAo+uxhr0cRt2eqMKHD9Bxlehv1cf4XDfaenyQJtA
	 4vMr44FCdwDFWPgpBZuu9b9lnr3jeruKZhHz+zzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Probst <markus.probst@posteo.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2165/2214] rtc: s35390a: Add missing newline to dev_err
Date: Wed, 18 Nov 2026 16:04:01 +0100
Message-ID: <20261118150137.037140590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b5bdeda7d7678..5e669b75b408a 100644
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



