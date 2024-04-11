Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF87145350;
	Thu, 11 Apr 2024 10:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830602; cv=none; b=WW6yNLlqVzR+JWeL6esQuakM8n4Hnqb+6M7fMpKejwkPTftNU+P7NoJ2jQFusBOrce45O3cI+fEIIwG8v4ZJ0ieKj4gYBVZQhUa47NWgKkBOE9Iz69zKcdEX91880fP3PvWPUj/vYGomBOoMr8Dp/A7h0A2g2mt+J1HUsB65jfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830602; c=relaxed/simple;
	bh=/o5qAbWvAScIh4JRwRkMZxLUnHQ4Ken9aOYozNq44Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFNdAkM6WYMOtgK6CDHxViy3l8VXiIdLRNyyW0Ews5OnRdHgM6TodB3/p36uPocTN/xwGE7WrzyE5yqInBnMYvDu9otlOjZrEAljmzgI4+10FXCVwxX24Z9y1cNzYXeRa0kKpUrT6VdMyOa8haFyK73m0nPmUqZvbHK9kxMQnuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksVvKoSp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksVvKoSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC52C433F1;
	Thu, 11 Apr 2024 10:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830602;
	bh=/o5qAbWvAScIh4JRwRkMZxLUnHQ4Ken9aOYozNq44Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksVvKoSpmiOZjCM5SGHZVZktFjkSJrJqsrJs4xIwqooNP6oC5Gwvz2qxGUCV9NxP2
	 GSYy3JS0zZ8ZHJEGic5X6Y8ByAhM9DRWdmbBaUW+bZjpgA7oiHywdZyJLhJWxJo/eI
	 s64T/XGTd38KAW364CUdaRfS5SvNvfB5x81pz1Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/215] hwmon: (amc6821) add of_match table
Date: Thu, 11 Apr 2024 11:54:23 +0200
Message-ID: <20240411095426.518105328@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit 3f003fda98a7a8d5f399057d92e6ed56b468657c ]

Add of_match table for "ti,amc6821" compatible string.
This fixes automatic driver loading by userspace when using device-tree,
and if built as a module like major linux distributions do.

While devices probe just fine with i2c_device_id table, userspace can't
match the "ti,amc6821" compatible string from dt with the plain
"amc6821" device id. As a result, the kernel module can not be loaded.

Cc: stable@vger.kernel.org
Signed-off-by: Josua Mayer <josua@solid-run.com>
Link: https://lore.kernel.org/r/20240307-amc6821-of-match-v1-1-5f40464a3110@solid-run.com
[groeck: Cleaned up patch description]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/amc6821.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/hwmon/amc6821.c b/drivers/hwmon/amc6821.c
index 013fb056b1d02..a8e94d73eaa04 100644
--- a/drivers/hwmon/amc6821.c
+++ b/drivers/hwmon/amc6821.c
@@ -935,10 +935,21 @@ static const struct i2c_device_id amc6821_id[] = {
 
 MODULE_DEVICE_TABLE(i2c, amc6821_id);
 
+static const struct of_device_id __maybe_unused amc6821_of_match[] = {
+	{
+		.compatible = "ti,amc6821",
+		.data = (void *)amc6821,
+	},
+	{ }
+};
+
+MODULE_DEVICE_TABLE(of, amc6821_of_match);
+
 static struct i2c_driver amc6821_driver = {
 	.class = I2C_CLASS_HWMON,
 	.driver = {
 		.name	= "amc6821",
+		.of_match_table = of_match_ptr(amc6821_of_match),
 	},
 	.probe = amc6821_probe,
 	.id_table = amc6821_id,
-- 
2.43.0



