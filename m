Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEA946B8B;
	Mon,  1 Apr 2024 15:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986907; cv=none; b=FDFr2yxiE80zkodrusqWPRWv5SUL4n+gI9/HaIEPsAWTsopvfNco6QULtjJuW65aIwgvWvluE9M6ov2CrSE89eti1zKDC2UV80goqwMmD5a0OO/QhBN1mu+nVNWPRXNzBhk0jV3JRQuHjABH357OBcC7croVGLU+S1jM7uU3aYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986907; c=relaxed/simple;
	bh=8NcXt8Lv/5WPtWStYeirNQ2AWfVphdM92cn2avuUQ9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IT3SBE+ma9PbjQ2H2wMzG/pxQWyOlHLShOszxQrOH5Njd7gk3UAcr1RZR+NPK2yuHhmwhh9gwySwtpVhSRtDfxede3nP/BIUHCoU0CdbKrlWDtWFzAXLaEC6NGKQXk5xqoz5SrXhpPeioKPfecIs7nw/X5wXUNWr1QhM9emgvwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xl0CqZNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xl0CqZNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269D1C433F1;
	Mon,  1 Apr 2024 15:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986907;
	bh=8NcXt8Lv/5WPtWStYeirNQ2AWfVphdM92cn2avuUQ9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xl0CqZNwAs76TItrz9fTZNo5w7klt4OVouzUL5Bmv4r1f9g66YVKhzqZiJTniEKNO
	 zcBZpXCxOq0rZTpGLEEMjNyUOJ8hRxhJGqRkQj+JTxA9sPzfx04/JNjBkUZAaielSz
	 4xfpdDvUnjji0p2oBeQHrlAI4nrMy2ypsGKZyvNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 123/399] hwmon: (amc6821) add of_match table
Date: Mon,  1 Apr 2024 17:41:29 +0200
Message-ID: <20240401152552.859536884@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



