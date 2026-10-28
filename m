Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212240;
	b=yGado/ZQCnhzb6XkMUkehDTzwu4l3bbFyIPyn8NPaIDyOokHywk42jP0vjeeVnvSbQrJ
	 ZlUSIDV+Ir9XqxFcJwA3fTJMVJL3/WD7xXdiDJRwmTx8YISomU2UpdJYKBMXvNGhbPfV3
	 DYSmvCt7oBudTWymoxNoXFvQZYMxgpjn01Vvxf2HLEk677xrUOFqFGvnzNnyWyWGoSqoL
	 9k+T371HREI6a1G8WUWYS4zC0zOtw/58qGUmpTf3g4lE0iEvx8GZqX62DnYFSXk+H+mSX
	 j7hNG0//xyvl7ef1PicI5pwj8CAnPLLKwKJa1ZIT1IcsiHSsEL17ZEo74bisMdW5aQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fXtOMe52oyDa2bmq9DLxb9xVd7vEFS0qM6rUAHufA6Q=;
	b=T7KoxAoyT6boJer75c7m4M1GaTOfH26c52v8e6OR5G7BOnVmkhAvtMglXk/59F4Cb3ou
	 kasQM+SN3c+gE30Oe9tdJGwnwfo+Np8VxOJkhcxZKQX117pz0iRoUW7LAMerYBwWMfJVe
	 X0UMc6k1kLWqgzMEsCYLoMjRKxpDXfsYPfT1XfxiqM+XqaRep7sgYDW9jaDjG13QvfT/u
	 t5MNyVk6sI8fWfMbQk68ys/gE8CVCNt/qbb6FgEH0oxjG/fxqUqdwpEF+bA7V7Mn1SUHM
	 9fMffm+cMtUPxb65uxr9APU/oNYpycI1aM9dLTge8IPybLa0vjnL2JqruPUsEs1b1gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zikSvFpz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A83606A31A;
	Wed, 28 Oct 2026 18:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zikSvFpz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A1F1F01825;
	Wed, 28 Oct 2026 18:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212240;
	bh=fXtOMe52oyDa2bmq9DLxb9xVd7vEFS0qM6rUAHufA6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zikSvFpzl7OC2TRB37+On9hego/yr7MvfLQY42fLVIwmavgSaXB9AhiTWbZGQQMwt
	 zLnVlrsJ/VVIkXliYs9hBclhrv0JrTW529IA2DXSfDzA8iZd8Dk8GPvbnh2DaJ6ovO
	 XUVDSZRdGD0xSn1FbNDNrTy3beHmMNXRNvyiARIA=
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
Subject: [PATCH 6.1 0087/1887] i2c: core: Introduce i2c_client_get_device_id helper function
Date: Wed, 28 Oct 2026 17:36:23 +0100
Message-ID: <20261028170501.215403605@linuxfoundation.org>
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
index e8fb84c7cfd85..cfb1454c48b9f 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -2432,6 +2432,20 @@ int i2c_get_device_id(const struct i2c_client *client,
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
index 87b403a6d7e41..60c5bc674dcce 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -189,6 +189,7 @@ s32 i2c_smbus_read_i2c_block_data_or_emulated(const struct i2c_client *client,
 					      u8 *values);
 int i2c_get_device_id(const struct i2c_client *client,
 		      struct i2c_device_identity *id);
+const struct i2c_device_id *i2c_client_get_device_id(const struct i2c_client *client);
 #endif /* I2C */
 
 /**
-- 
2.53.0



