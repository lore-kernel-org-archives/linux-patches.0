Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212235;
	b=BkBfEZYyQDkOn+pqo+JDzKMdCufcTAijMa7DLvCa+TAK4wAqckV3PwK0k1Oe6n2bvghS
	 7P0lMIBO2v1cHhS6CjzbAITQFU1NGnLaSGKm9QoG2klC2sMxbi1dutTUw2ED5Xc4L2PJY
	 AMM7fJOZkb0x2j7+Bz37iq1gSOWHetY/UI+4YX32HbKwBTAv/WCjYUao3nKOnIYnJy0o6
	 +F84+6zySAPhKPR/TO1a8q9MVcIZYjxLrNMUyVOFrovF59CV/meAl4XXb+EUd2Adl45vk
	 4zOsDwpxTM96H581+lRQzjhA+UOB415NYTQtAen725qMOmuP+nPe/2bwnU0RUDGzZHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JnVmwDCzzUj/AAEb4JkoKk8rTcgoRgND+8w8kAaMiRc=;
	b=A/KD3yATM3v8z5fMTtwFd2A4Ua7nOVwvGKbvv75viWbVzi8xDxbCsr7g19696oj7C0E6
	 96yTRz1G+aIQHOHPGkqpYJ1BigPtsVCI23u/spNP5gJcJaMlnZyMMGVAFtE06TwGxCey5
	 //j79AGIRhm9h7SCeEL79nHQAxZBU6CqS6EeFcwPSw1JIQjcFewfMc38+e9Lgs45gyHu6
	 xYViL1ffEPzw5OuARUKUFZy10Q2bI/Kb2cr3j/HdqImvVMKBroVQxnuN8IWiMOwRZ6jn6
	 rtM6hrDvXLzYk/6Nrwhq7j9k+b/RtJ1ve2PNRTndKEig1z4bYASwLzz/HEYn2vD/VCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=px7kalfl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3BC606A31A;
	Wed, 28 Oct 2026 18:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=px7kalfl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C621F01825;
	Wed, 28 Oct 2026 18:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212234;
	bh=JnVmwDCzzUj/AAEb4JkoKk8rTcgoRgND+8w8kAaMiRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=px7kalflk+ZbTnz/FZgcb7xUg9brtRyYa3+GVvPizW/vNna9FXsEGaJODs+ghml1S
	 gA073tChvY2bSFtMBN/95sCDi3nS/CJEt+0MdMUyEIymV6NIc3KtqeP+uqYgRwzgFU
	 vTP8fXahKJtEJWNGBYXRIijqx8dTEGJLLdnquUtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0085/1887] power: supply: rt9455: Convert to i2cs .probe_new()
Date: Wed, 28 Oct 2026 17:36:21 +0100
Message-ID: <20261028170501.169320289@linuxfoundation.org>
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 2adfc4370ebb745380a44c3e5418486a32a9ba67 ]

The probe function doesn't make use of the i2c_device_id * parameter so it
can be trivially converted.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 3e7a1ebc32fa ("power: supply: rt9455: quiesce delayed work before teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9455_charger.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/rt9455_charger.c b/drivers/power/supply/rt9455_charger.c
index 566243a423c8f..dd4ff038814f4 100644
--- a/drivers/power/supply/rt9455_charger.c
+++ b/drivers/power/supply/rt9455_charger.c
@@ -1583,8 +1583,7 @@ static const struct regmap_config rt9455_regmap_config = {
 	.cache_type	= REGCACHE_RBTREE,
 };
 
-static int rt9455_probe(struct i2c_client *client,
-			const struct i2c_device_id *id)
+static int rt9455_probe(struct i2c_client *client)
 {
 	struct i2c_adapter *adapter = client->adapter;
 	struct device *dev = &client->dev;
@@ -1741,7 +1740,7 @@ MODULE_DEVICE_TABLE(acpi, rt9455_i2c_acpi_match);
 #endif
 
 static struct i2c_driver rt9455_driver = {
-	.probe		= rt9455_probe,
+	.probe_new	= rt9455_probe,
 	.remove		= rt9455_remove,
 	.id_table	= rt9455_i2c_id_table,
 	.driver = {
-- 
2.53.0



