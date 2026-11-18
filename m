Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015218;
	b=4PWffP29yKqzzpJAqD1MTD2X8bYLZaIj7Y8pmLd8A7G/849R7JuQoxIt4olGCHZIVhaS
	 d39mZJKtQAM8Ypl4AdRfVP1Z3Qm1J/brmcyt1R3Cs5fGYsDqV0pc7HrO4Ar7sxcmPdoMw
	 8H0lF9d9CSF+vWrqJF08clQ8PtbjxfsO1/V7wtA3zuTUx3K/9Q8sAGQqOZ8KCUfYmMZpP
	 yxnmuCPw85q6z59mXfRIKEMrWLSmkDGIRSg5W91QkvES9tJ0OIzQg+9A9gW2A61ZnQGeQ
	 Y7BTB9Z6DgTgzmHgYLTBXq6+kl4HymACL13qkQhQVlC4+VKtN2HZUi8qECIv+h5LrnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4UW5DrvjCh+oNsRSAMjBeSlKDUY7s4A9f/u4RJ2iI84=;
	b=jOO8L//g6/mvAIGZrCRKaiBbhxPCPwu3Qw1dnLg7epyJv3MougX0Ztpe3Y1HAVTHLRmb
	 7/8TkvoaDjAQ2Z+HNMoBydvE4jyOfi/fQ1MajQFdqugMv1RV/RubrGKVQotgH0Cgrk4Sz
	 0Xsuml3wi1zyxKkz40eljO2+o/GxOwJ+n8RxSYQ5D7NwMZe6197CQmUrJ1YAUWjf4JYeA
	 9kSRTlrVx9Rlv1kaalbHl6UtQrE8GBsrDuKIzqaB48PBiFM/Vggl1P/m8NUJdmr3gKmSb
	 +RPjgZ8yWIstPYiog6ZTAo1RhyhVnNyj1q+uGJcNqJyG6Po6uaMGD4zE0VOoLn5k2tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1qYMni6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F656606A339;
	Wed, 18 Nov 2026 15:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1qYMni6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BCF1F000C5;
	Wed, 18 Nov 2026 15:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015218;
	bh=4UW5DrvjCh+oNsRSAMjBeSlKDUY7s4A9f/u4RJ2iI84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1qYMni6haE/d/pqV5c4r4ulbPgdxuZ1QOE1HUqxhsfQJluYHcAdVhAfYKzMplUD9
	 503TYu2UyR28ZrfdIYVdM4rhEKZXdy+f9wGwy0cdA1sw5h4M/1QsuxGI0tcA//tyA9
	 I8rOO1CPmfuXes6ANHsif25e6BPOpq+IjSsWvzD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0095/2651] iio: pressure: rohm-bm1390: Fix AVE_NUM initialization
Date: Wed, 18 Nov 2026 15:22:15 +0100
Message-ID: <20261118150251.323023637@linuxfoundation.org>
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
index f9deb48e6a41c..d1268c289831d 100644
--- a/drivers/iio/pressure/rohm-bm1390.c
+++ b/drivers/iio/pressure/rohm-bm1390.c
@@ -479,6 +479,7 @@ static const struct iio_info bm1390_info = {
 
 static int bm1390_chip_init(struct bm1390_data *data)
 {
+	u8 regval;
 	int ret;
 
 	ret = regmap_write_bits(data->regmap, BM1390_REG_POWER,
@@ -512,8 +513,9 @@ static int bm1390_chip_init(struct bm1390_data *data)
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



