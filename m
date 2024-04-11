Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029E9145B05;
	Thu, 11 Apr 2024 10:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829617; cv=none; b=gnDudATZlTHZn3dn9sPqcWZ3svMRs+HDt3WB08/+o2P0YeEYa5TwFio4G2nyJzMOXUxOToxpFtR7U0qj2exPzZreSemuK9zxR3pBDgJqOajlcM8WDUkNbPw3Agit8SbV9zKQNRKk/u6V/5peqiIkNpF1jhDwW2HSl62ghcmyzXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829617; c=relaxed/simple;
	bh=rkQ4zTQX9Tje0OfVNVEITcRH31gaUFPwzZ4rI1M2U7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgghlI/ukb3kseS0uusZT1fLLEWxH1v6T/fCg+mMliMZoQOErYKxbISCnYUi876zdMqDjgreiClsn2WNAlMRR3I3kB1lXrrBNINz4/X/E6Kw18WJihf1JaNEvuVnrtYe9NZBKT4HjEWwua+6mZakJi4QHDr4KMBnZ0BvSU8fB0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCN+WuMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCN+WuMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAF5C43390;
	Thu, 11 Apr 2024 10:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829616;
	bh=rkQ4zTQX9Tje0OfVNVEITcRH31gaUFPwzZ4rI1M2U7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCN+WuMKo41kGaswvdjggoIrpllZUdGW7sln3yVCMh1wKlgocdNc7bAFPW59xxI53
	 rft4MUktsugTr1QEIzxnVN/YNZb9KtnCSEXtLAWakK0Im/514O0H9ZopG13sPY6rUy
	 DnN6y19Vuz6XnOnPnai58bwBnC8xQiksOHO6ymfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 048/175] hwmon: (amc6821) add of_match table
Date: Thu, 11 Apr 2024 11:54:31 +0200
Message-ID: <20240411095421.013559736@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 46b4e35fd5555..b562337df7b3c 100644
--- a/drivers/hwmon/amc6821.c
+++ b/drivers/hwmon/amc6821.c
@@ -1003,10 +1003,21 @@ static const struct i2c_device_id amc6821_id[] = {
 
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



