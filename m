Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210561;
	b=P96quiBurRNdwBo67h+F7Tu/qL5qkwHUFuqmBnqPWPlYYY6WEplfrMonbGwHCY1p19kN
	 yx2GZVKlOk7hAPyqcblHudm/C04x3tSMfDTFcRjvQGZFNAsGodYlClZYX79OV7cndqx+L
	 G94s318R9cwFFb56YvFWY6q738+gT/jGZwK182zXzjt/5iCfqwPd3rvnQvET7tVZth8qz
	 ityLYn90YpROR0OM/9ju86r/BzNIf677Gy+NTm6UejajLGo8AnMIpZZ5psfsfmv/iMMnC
	 6U7eQ2PXjxwAZK/54KhkLO+S/1WHMKJM+XzP/hMhJTlNq8tITLGY2JKEuic71ry41Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=POrkT53oet6CbJuRcLsaztI+HAqWnp99MYjrRBH9G84=;
	b=y9dq92LoBB6VUSIfpUCmfFBgDTFP5iIQqIPAyiS/SK6EIqkvDzxT09/SKFybbZCvcU/5
	 1v7MIkXT3CMWpP6Y21cGZQ0GaBQYhM76X6n3tV+jTPRAWdYGbUOiGn/uVtTzoseWQELLT
	 hki6KdWKUhQYsvVtOUYSxNoiUdCI9tCCZ85gcOG0TIEQ8+6gLZhEjLjxYfEtNs/3OdgLK
	 f36f8Vgn9LuoMnzvxINk22Btgfprx1TkbL1QGRzb9Q3+iEnHsF4c0TD0bTwY3sjYa2Ulu
	 MVJciPj4RNFsxRGl6jlAST0pe8LQFxpJq44fuPMwSsc9pRWJqzfeT6JPnj9ZVytz8tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FvSUAe1a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEC5606A31C;
	Wed, 28 Oct 2026 18:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FvSUAe1a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391BD1F01825;
	Wed, 28 Oct 2026 18:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210560;
	bh=POrkT53oet6CbJuRcLsaztI+HAqWnp99MYjrRBH9G84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FvSUAe1a7MWkgLxzpAc2K61ZUTOgELuRsWO0LrIWVOxKKXerbQ8w3l6n3RNalGvdH
	 2cR6WDQbWcMj5pcyI42vO0nVAPAQ5dIMXWJeSOyCfho7GGiE8hmyPyOfGUB+EJWGAR
	 x5oM5fwyhyCcoLtu9sXr4slNs5gEnAkrhcQC97WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <noname.nuno@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Angel Iglesias <ang.iglesiasg@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/571] i2c: core: Introduce i2c_client_get_device_id helper function
Date: Wed, 28 Oct 2026 17:53:35 +0100
Message-ID: <20261028170009.639644051@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Angel Iglesias <ang.iglesiasg@gmail.com>

[ Upstream commit 662233731d66cf41e7494e532e702849c8ce18f3 ]

Introduces new helper function to aid in .probe_new() refactors. In order
to use existing i2c_get_device_id() on the probe callback, the device
match table needs to be accessible in that function, which would require
bigger refactors in some drivers using the deprecated .probe callback.

This issue was discussed in more detail in the IIO mailing list.

Link: https://lore.kernel.org/all/20221023132302.911644-11-u.kleine-koenig@pengutronix.de/
Suggested-by: Nuno Sá <noname.nuno@gmail.com>
Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Suggested-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Angel Iglesias <ang.iglesiasg@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 4e4b9f5ce9df ("power: supply: max17040: drop incorrect I2C functionality check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-base.c | 14 ++++++++++++++
 include/linux/i2c.h         |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 04bfd86688bc1..ee8d6e520ca05 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -2429,6 +2429,20 @@ int i2c_get_device_id(const struct i2c_client *client,
 }
 EXPORT_SYMBOL_GPL(i2c_get_device_id);
 
+/**
+ * i2c_client_get_device_id - get the driver match table entry of a device
+ * @client: the device to query. The device must be bound to a driver
+ *
+ * Returns a pointer to the matching entry if found, NULL otherwise.
+ */
+const struct i2c_device_id *i2c_client_get_device_id(const struct i2c_client *client)
+{
+	const struct i2c_driver *drv = to_i2c_driver(client->dev.driver);
+
+	return i2c_match_id(drv->id_table, client);
+}
+EXPORT_SYMBOL_GPL(i2c_client_get_device_id);
+
 /* ----------------------------------------------------
  * the i2c address scanning function
  * Will not work for 10-bit addresses!
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 996886f187a1e..b115fb9e2071e 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -188,6 +188,7 @@ s32 i2c_smbus_read_i2c_block_data_or_emulated(const struct i2c_client *client,
 					      u8 *values);
 int i2c_get_device_id(const struct i2c_client *client,
 		      struct i2c_device_identity *id);
+const struct i2c_device_id *i2c_client_get_device_id(const struct i2c_client *client);
 #endif /* I2C */
 
 /**
-- 
2.53.0



