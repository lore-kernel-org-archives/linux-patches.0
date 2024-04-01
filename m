Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F4C1E86C;
	Mon,  1 Apr 2024 16:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989631; cv=none; b=GnF2YTFe4PaaaaG5qrKYovKiXvvQ3yrr1lseAqbFERekOYAu+wQjDu8r+V3qeCUopM65lkV6xGSKuej8+OcdoZGXxPEGPwu2By8u0xG+TImLS4GqIw5XrxZVBrQeDojLEtEZVkS8cU2/QWf0Vr315+VjdtCpNNvcLZtCmSKtDks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989631; c=relaxed/simple;
	bh=iIABjpvWQPH6e3F+W9H+jOkyGnMwh8jY0kjTZstvIgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7zkhPsPHEHWR/BPQw9CBjvLXroKCbQaqPo5s8+7R08r6Jwt0fWeGCRq2gL9s6cMwH/3tdnOUikgbWdrkOz1Ojb0KUonHKtuCJLd0yDZAAcih6mg11v6drEWjBTfAY6L3CqKLVrhEdw1RnADYrT7sumwlVXd7+bStlLxVW9PUUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCf9LW/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCf9LW/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE25DC433C7;
	Mon,  1 Apr 2024 16:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989631;
	bh=iIABjpvWQPH6e3F+W9H+jOkyGnMwh8jY0kjTZstvIgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCf9LW/+61Mulg+wSmdK6iiBLNS2Ldvh3mC1xrWBwdRSHBssirwdFuuOYRw68hXue
	 N+xI8uqVKul0fnd0ew5/XD5MvAFwU1ed6DHvxTM1QSJwpa8OgdaTExTTbRWrNudZC9
	 syZpryoOkkWy08YkMnbPilZZJjbTt+7G8SFjlnw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/396] hwmon: (amc6821) add of_match table
Date: Mon,  1 Apr 2024 17:42:35 +0200
Message-ID: <20240401152551.080766980@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2a7a4b6b00942..9b02b304c2f5d 100644
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
 	.probe = amc6821_probe,
 	.id_table = amc6821_id,
-- 
2.43.0



