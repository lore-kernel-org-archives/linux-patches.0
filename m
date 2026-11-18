Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022819;
	b=sO6bmTWqoC2AAyU/nIMnIT4HkAb6g6Y/VI96Hr8CAzmyz42ZnO/PwgJ88v5ETGbvcgAV
	 qQ0TDyt0Qz5nRT+73NZQyFAfgdpVgQCQdUrij+ZFH0HpwahYtClVKvtQbtMuuKP6tBB+z
	 KcKCKoSlRsZ3oGCV+m1v+2DXPq/n/ymjy+9lQdpQrnoJilFyNWtEZpJ2Di1kovroyjkJm
	 V39SoXtfNavrBd4M/K1tb12z4na9mIahKM1atLoqTA/lIfr3PhRdk1xdIGHOrDgu/iMj0
	 I8okMT28x+yVvQKy5KtaFWWFye5z5fkmswQHD23NdtXg3fyPb0to46c9bv/ucof5KLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1LKZWvHJuWL1CEj5cZkqKFq0Z9XtzyoZDsLNSU6fFUs=;
	b=HNvuXr91+ZZS1vEMw7lycFRprWjn3AozHAPheo/xDMMoMI0lTgW92FQNxvhVc3U8j2o6
	 gQfII9qdDv72Tx2RyF9m8BhBnOPDPXM+x+eNF7anI6qpg6B7U9Z+kqHB9l2rhw5iK+70d
	 uQR9QBe77FX7xpOL7nXfltFHymZArgTCO+8jHqTFG4xUoT2a6C+Nwq7arvEWmMCLrLnAl
	 5403Y2uUIxwsjHq6YfR278MS/I1Xl9/yqzFAFGTgWsCLunp83s3WlMtzlq/OKvnTSYkIW
	 S/Ig2p58uA+OENQwBxeaGxQpuhdt2wGDNJgzCqzdTxTRnIuVUf1di+vdFPhLUujLGjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=okOxY2t3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD35606A756;
	Wed, 18 Nov 2026 17:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=okOxY2t3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8751C1F000C4;
	Wed, 18 Nov 2026 17:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022819;
	bh=1LKZWvHJuWL1CEj5cZkqKFq0Z9XtzyoZDsLNSU6fFUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=okOxY2t34i8GPMewgzBCMzGb/1UV+OXy2yXTMDhDwSmk2uZBM5auPKZhqWufJzOFk
	 SA5O12gcMigjVT37UrWw6d8ZkW5cjGI7c1rSaEyb/SgaJ+sB7XL7d1ZWF5BzJ6Hy2A
	 RF9wBcDM7HSVqhBnCtF/iusIMpW9HhU1WwtXrNEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0150/2151] iio: pressure: rohm-bm1390: Fix AVE_NUM initialization
Date: Wed, 18 Nov 2026 15:31:25 +0100
Message-ID: <20261118150127.232370538@linuxfoundation.org>
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
index 3b48c1c86fd2e..f6732781dd567 100644
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



