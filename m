Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028889;
	b=TrT3z8O0y/gRE85nq4AAirjOt5Jry0rVwGoHvp6CUBiTYnLAC5SJEgIUwG1id12W46wm
	 jm9GGKsHU0SlcBXa7ub+8ejAa3UTmfwbXNed4pRvcT2EXnJgiAu1hWBwlDubF71luBRwc
	 Jcf7XMrHlFnAaN3Po8hLCx/DKgpLDgf4LvB9hU58jxGQauQb3ne3FrODmOEJ1rWdajZ+d
	 j4VNQCzzu7b8tfU983pbTRFTT4xmy9NmjhNf9MIgAshB32qbnTJj6OK0fZbIu+wTVcp83
	 lnWiXqWLUznWZesp0pZTBghegvNJOMPn07u9oGXdV1hatYEkYUszvqi+cJ8qrggfFlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rI+hyovm3HK5YVTw259SiCX0oIOlaiw7XQvBfNHy8Nk=;
	b=xgBSbb2qg/DJuiFCetQ6QJVj/vUA766ODWlHA+bUqzilAZpl9Y8G71mW9lbhiopiT9Ej
	 FXdRTnV6ZyjNha4qSwQPEuT/m7vQSb4mqPgOlKq3KiSB792ydB9vW3pXi9E3tUB2nbyo4
	 jTMez+lZqUrEHsPlrjHWK4tgOEDkko75u0COsNLg+AajW7Se2FI13HLfGSdng2nOl9A4P
	 sJyBwThfAZhgKSn1azJ/xkSwIIWxTM8+erfRA1lS4Lo6HBk0gHC8het2JlDzb+XZvTfkx
	 mq4tCpIOoxQmx5ZZB2m6jNZZKtY90P1N1NCRLI43uf9H4UH9nYRNYeF5F10OndRVVLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pVScy8Ij;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40970606A334;
	Wed, 18 Nov 2026 19:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pVScy8Ij
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FE41F000C4;
	Wed, 18 Nov 2026 19:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028888;
	bh=rI+hyovm3HK5YVTw259SiCX0oIOlaiw7XQvBfNHy8Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pVScy8IjZ+qZLx6qHNTUCRbN/MFGnLE+kx8mFlZyDPwwyYbmxKibuJ23yycb+cYjF
	 /wssltwBGZ1Bs/Q6BUgbW6ARswfeV2mdyPKoLyryAmAqqHHAEQ3wZyIjF628YX/Mvq
	 RgzFwLTP8oxtPxolgfnBiV0XTZpoZAOr9XIgdY/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0153/1756] iio: pressure: rohm-bm1390: Fix AVE_NUM initialization
Date: Wed, 18 Nov 2026 15:38:00 +0100
Message-ID: <20261118150014.223854831@linuxfoundation.org>
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 64f4173ad1a7f1b247296c84e624f5095be170c7 ]

The BM1390 tries to initialize the AVE_NUM to 110b at the start-up. The
field location is not taken into account, and value is written unsifted.
This causes the AVE_NUM to be initialized to zero.

Use FIELD_PREP() to shift the intended AVE_NUM value to correct field.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Fixes: 81ca5979b6ed ("iio: pressure: Support ROHM BU1390")
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/rohm-bm1390.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/pressure/rohm-bm1390.c b/drivers/iio/pressure/rohm-bm1390.c
index ccaa07a569c9a..8008da21d021a 100644
--- a/drivers/iio/pressure/rohm-bm1390.c
+++ b/drivers/iio/pressure/rohm-bm1390.c
@@ -484,6 +484,7 @@ static const struct iio_info bm1390_info = {
 
 static int bm1390_chip_init(struct bm1390_data *data)
 {
+	u8 regval;
 	int ret;
 
 	ret = regmap_write_bits(data->regmap, BM1390_REG_POWER,
@@ -517,8 +518,9 @@ static int bm1390_chip_init(struct bm1390_data *data)
 	 * Default to use IIR filter in "middle" mode. Also the AVE_NUM must
 	 * be fixed when IIR is in use.
 	 */
+	regval = FIELD_PREP(BM1390_MASK_AVE_NUM, BM1390_IIR_AVE_NUM);
 	ret = regmap_update_bits(data->regmap, BM1390_REG_MODE_CTRL,
-				 BM1390_MASK_AVE_NUM, BM1390_IIR_AVE_NUM);
+				 BM1390_MASK_AVE_NUM, regval);
 	if (ret)
 		return ret;
 
-- 
2.53.0



