Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7CA2E62C;
	Mon,  8 Apr 2024 13:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581785; cv=none; b=pnRQtM+mP7CnK+kTf5r5ZZRRIgpHv1dumFEbVqvRn7atak+Z6V33t2zBtHBXX0pA0mMlzXXtzIj9VVszjsL7db7L1GB60XW9HfVM73mmSL+cQHQfPUIyL63ExRQKpgKmnn/dYnH5yPtZ2vug7I7wY9gd1C/jT+uzyUdDFNcLOEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581785; c=relaxed/simple;
	bh=D0CJ4JPgAbyzYs6LaoWbKMjaREM5ThE9g5AMswOO3Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlh1BmRcEBlR5L79NYpwd55T7S6QPJfP6cnxbqsgitSGYiCuTia89ri7qRlDj4/Wov1DX+d6Rqj7hz6TuR049Bzcl4V1S6spLvOJ7vTgZclBmUzVlMAE54Fe5MpewXr0jSk3wkvybX9FTlqWN68+v2VmxCEsTOwgkIXf8BZt0jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzFenN6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzFenN6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29023C433F1;
	Mon,  8 Apr 2024 13:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581785;
	bh=D0CJ4JPgAbyzYs6LaoWbKMjaREM5ThE9g5AMswOO3Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzFenN6mZK/eq6jO/uXHYYHDViKLvPWHmfNEXEJGE+dL9DRVG5hbUxSQulW/bqlc7
	 hjFdDVqIlNPHckBvTS2zyoFuTuXqxXbUqXFxGCAPAWBR/ra0ZfGYlX6tzBJk2P6Cp/
	 FKHrGtSq+NF5kIWm5PvRyo9apT8uhkVCya9/R+UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/690] hwmon: (amc6821) add of_match table
Date: Mon,  8 Apr 2024 14:48:59 +0200
Message-ID: <20240408125402.165561269@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6b1ce2242c618..60dfdb0f55231 100644
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



