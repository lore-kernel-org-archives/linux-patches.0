Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213186;
	b=1LgcB6VhpXOTLwqwiseMt95Z40D52MMOwTAuCd8niMl/4KJoCunYnA54/ZCvWTBr12ac
	 +oSgEFmvsfYFUDcc0WymbmbRgARP6K2yXuCqFiZQuNoeGNPTgIDnLSTWu+HFeGNcjClVu
	 3Hn4/+sURizXpsBRUHKfBBjSdl2kO7PHSLbKt0W8xx2opJy6OGIySHwI4i6nomZwfXGW3
	 7eYzV8IqYVWpaCONJcpaybSM59VbIZqixNcy4EinDBS05s0HOAPOfnj3TzlTfMhOLyktv
	 iov8ho/RB0eCNtVq2/GGKO38eWxNxwilLOpQ29bApydyd9+oG9X/sfYPNW4O5Wq1U+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ZNHG0nPTY+wWhp/ElCLh6RSjl0PaYEUf2Gd8viHxWSk=;
	b=2D4OF1fzvfSd13R9fAsdQbPAMUSdW40owFt5RjpEqwQMxBC+pkh+u5SeQhGXCYt6uR4w
	 puVy/Y94iLB0oiDMBNX1EKqpBv7S9smxpKOtfKernu9xscmhsy9vhsH4nXjKQGQAUTqa9
	 VsXHlqC/SD/Nv7RH0L4NzrbWyjCqnOHHjNk5T+kP5arEjn7Osvmy3lTN6GRSCt++TLiEe
	 H0ZH9zhXlqqERKCF22P4unejhpEzcQmRkXIWTWdbTh6hvGdIhNfGdynVWEYZ5hBaclGsp
	 WEl8bWTyo05MCyJZ4ChCQbcmBJKCAbe54MZP1a4HZlAHUG6wIpT5/ldTcO4mvOUOS5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yeVUYAQS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66012606A321;
	Wed, 28 Oct 2026 18:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yeVUYAQS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B731A1F01828;
	Wed, 28 Oct 2026 18:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213186;
	bh=ZNHG0nPTY+wWhp/ElCLh6RSjl0PaYEUf2Gd8viHxWSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeVUYAQSZt95j4vzE2eWMH8dBxdaa6rVuQLQenesruBpSigJ5lOF+ybf61sOYGNS3
	 f9KH8FnnDVQoWbpbvL0fDZgYFpIWwDCCB6y0O79vcgQxabzc3qIEL7upd69rkE7xi9
	 EL9C3WRv4yXTVRmyRx2C8PdFbLD5xVtxU1QAfO60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0417/1887] iio: cdc: ad7150: fix OF matching and publish module aliases
Date: Wed, 28 Oct 2026 17:41:53 +0100
Message-ID: <20261028170508.724716046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 52da294027f53e7084c18dd4b4f73354a40382f3 ]

The OF match entries use positional initializers, which initialize the
name field rather than compatible. Consequently the advertised AD7150,
AD7151 and AD7156 compatible strings do not describe OF compatible
matches. The table is also not exported for module alias generation.

Use designated compatible initializers and publish the OF table. Keep
the existing I2C ID table and its device-variant selection unchanged.

The issue was found by our static-analysis tool.

Fixes: 89f2d5b080bc ("staging:iio:cdc:ad7150: Add of_match_table")
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ sashal: Adjusted context for the OF match-table terminator’s existing {} formatting. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/cdc/ad7150.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/cdc/ad7150.c b/drivers/iio/cdc/ad7150.c
index ebe112b4618b0..023b4fd09b254 100644
--- a/drivers/iio/cdc/ad7150.c
+++ b/drivers/iio/cdc/ad7150.c
@@ -653,11 +653,13 @@ static const struct i2c_device_id ad7150_id[] = {
 MODULE_DEVICE_TABLE(i2c, ad7150_id);
 
 static const struct of_device_id ad7150_of_match[] = {
-	{ "adi,ad7150" },
-	{ "adi,ad7151" },
-	{ "adi,ad7156" },
+	{ .compatible = "adi,ad7150" },
+	{ .compatible = "adi,ad7151" },
+	{ .compatible = "adi,ad7156" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, ad7150_of_match);
+
 static struct i2c_driver ad7150_driver = {
 	.driver = {
 		.name = "ad7150",
-- 
2.53.0



