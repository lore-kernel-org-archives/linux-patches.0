Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEE547A5D;
	Mon,  1 Apr 2024 17:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990869; cv=none; b=IUtQRF+1NLgTYpFt8fGW2dSUjjN86zGmq6FJp0Pkwzfr8UJmoKuR6MfXRziw284KZcPDbqtIcXGBqdOqajw5Tii3w2ytoSrUTqSgnnHpME57LmMiBupOrbmbZEllhUwE73T3RPPZGdJRkqJJLorZ6AeBW2yP2081Mt0r2DJf3jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990869; c=relaxed/simple;
	bh=dzBZ9LThETi3hPUB2TjdU7HxDJsh4b8Pbg2KJTswCQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1YX011gmf9JZBD0TwhE2SaN6nW//lqRIdqUjGRzFSzGxOLmeuTUGgVL4MVwKuqZqyZ38Fe1WVmexOutF0+goHS9NNyxicI+Pzl5qv8dmdJOt85H7V5JDOLKZEshOJnNZw145qH9h0CdBFbcHHGIooazP3/VJA+At+Cj4fIHe3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2Ve/B4S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2Ve/B4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E54C433F1;
	Mon,  1 Apr 2024 17:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990869;
	bh=dzBZ9LThETi3hPUB2TjdU7HxDJsh4b8Pbg2KJTswCQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2Ve/B4S06gXTEN4uXywU3lD0ARq7AD/kix4E82LsmskDtAsuNmM+1ictIMgH6/Og
	 rt6zPc90ueJmM3xh13V2GKwx94yxQvwTIgxLmZ/wIK+iEvPlG9EaSV1vAh5hqo42pn
	 T5RZjkhveQEz9HCxon4Y4zMnwtfsogh9pksnlejc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/272] hwmon: (amc6821) add of_match table
Date: Mon,  1 Apr 2024 17:44:34 +0200
Message-ID: <20240401152533.242627165@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3bfd12ff4b3ca..6868db4ac84f3 100644
--- a/drivers/hwmon/amc6821.c
+++ b/drivers/hwmon/amc6821.c
@@ -934,10 +934,21 @@ static const struct i2c_device_id amc6821_id[] = {
 
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
 	.probe_new = amc6821_probe,
 	.id_table = amc6821_id,
-- 
2.43.0



