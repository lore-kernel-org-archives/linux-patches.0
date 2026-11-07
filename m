Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060572;
	b=YWAshHfcOQ4yWpOoBR5lCAxFGuyxE2YygKHPgtDU8BKqNlGbs2IQ5l/SYgGNQplqnYCX
	 SCv1FzcRtS/yZMG+KvtjtF/yVxFPwpQ4ik2DvoVJXD0fUvsUK1nyG5HqwMZMtxLQTH1q5
	 r2PgCGs1HMSl652D2IuqOd8y4K1cS3+8LdvIZGotDz4pBYqOTEIlxi6SRZ02DR1Rg7OOA
	 kpAl/8sEKYw3QMO6m4nUKUgJJHY2gv45NI8FwneoJrlYJ+RgPQ0KOSRVJQg5WGK6vBFQZ
	 qYsxuoqBLcFxCK9/rclCI7MjoyN9UeW9r6ID9TYhjtRjvJJSdMpiQL6Z7HZ2Y3nYp3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TRZl/IWjuRZtiBExvAhxr/IdgvIMkdp3N6WZxtp15Tg=;
	b=ZtBT0ddW2QazFVx7JQC/efRweGHQG4WWupnPXl7UuCGvKHGYOkbtQZrb4V/31ldJOli4
	 MuxHLd2wMGK23Qy7ww0eRwGz8xPOERFYG55cjvLMSyqko6oZHjTSx5QeJljeOaohCucgy
	 Ps1+zedO05hLWCcJJvb1gNjyXDYArl/mD+maVYCjV5FTrcV5rIPK03f0+Kfljz0NgozsY
	 zYw7nPsxooNYfl5phezYyl/G6jnWMfZZUuEXVWXD13gMKDWQZbnEjJPyXKVnTPvxt6mZW
	 YTxTo/FLemLafWOIHqk5xtNzsTk6XwMwgcMjRCF5EU6BRm7odVkagCtwVgg8oA3vw1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mkxrUVnu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAFA606A326;
	Sat,  7 Nov 2026 14:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mkxrUVnu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDF41F0089F;
	Sat,  7 Nov 2026 14:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060571;
	bh=TRZl/IWjuRZtiBExvAhxr/IdgvIMkdp3N6WZxtp15Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mkxrUVnuPPL665JOzxtetz8wI2RK/8G7nsJ+VqdUYJYV9VmmGmcCG3B5gqAo0oi1T
	 I/V2GDX7M9DSQI19TE6O8KvpUdIx6MK3fAWDizIC7kxTcS6HzspnpWyilTANN8Zdku
	 Z7UzKT9u5jnOhJDAKhBgi2aNVxG3F6+WnWQnRQtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kry=C5=A1tof=20=C4=8Cern=C3=BD?= <cleverline1mc@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0032/1536] w1: ds2482: add OF device match table
Date: Sat,  7 Nov 2026 08:34:08 -0500
Message-ID: <20261107134958.571942839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kryštof Černý <cleverline1mc@gmail.com>

[ Upstream commit 53f33fd74d3993af0fbb5494b5be709f6ca6b712 ]

Add an of_device_id table and hook it into the i2c driver so the
ds2482/ds2484 can be matched and auto-probed from Device Tree.

This allows automatic module loading when instantiated via DT.

Signed-off-by: Kryštof Černý <cleverline1mc@gmail.com>
Link: https://patch.msgid.link/20260612-w1-of-autoload-v1-1-74e8a17626e6@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/masters/ds2482.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/w1/masters/ds2482.c b/drivers/w1/masters/ds2482.c
index a7fc6ec31938e..226c480b48182 100644
--- a/drivers/w1/masters/ds2482.c
+++ b/drivers/w1/masters/ds2482.c
@@ -551,9 +551,17 @@ static const struct i2c_device_id ds2482_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ds2482_id);
 
+static const struct of_device_id ds2482_of_match[] = {
+	{ .compatible = "maxim,ds2482", },
+	{ .compatible = "maxim,ds2484", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ds2482_of_match);
+
 static struct i2c_driver ds2482_driver = {
 	.driver = {
 		.name	= "ds2482",
+		.of_match_table  = ds2482_of_match,
 	},
 	.probe		= ds2482_probe,
 	.remove		= ds2482_remove,
-- 
2.53.0



