Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C9D4432FE;
	Mon, 17 Aug 2026 14:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976003; cv=none; b=AKby0rBQ67Mt/v7q6vgFgH6O8RdQb24kWJjnwjHZ3a5GOwzczBNcCogGUGW03kBuON1qAV8kWslAcgD88Ive4uWmPTz+TSaqd2SdpN1Yt1j2HBuQXVnw41AGYlwbvaRWqy0Uv4yKF1jcsXfjzIBuECk9Qdx7jI5uSZlBGhyKu50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976003; c=relaxed/simple;
	bh=ssXqCQr+v6l6TmjR/9k617hozaFi7hyMcDiRV8wO2gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVZLFgOHVCVG9CxNkM1gr62n80kowTMycBviZoPtaBWqtXSvJ4R2K1Xtb7cW9Nn/ZsLy44zgAmo041cBsQ5xaz+GA165x7KcxnC+tQ/WQt2BxGc30e1DH6fHCaTgs3OLWEgglEujoVrcFDrdf1PN5hoflp0tPDOzCYhYoLupE+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2UpZyc/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2UpZyc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C011F000E9;
	Mon, 17 Aug 2026 14:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976002;
	bh=LdUzi5lWi9xkx++g+ANYce3S57/iGTD/6jNjTRoH9LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l2UpZyc/uUR63DEMGIfuyMYxdnFD9oQHoKFjQQ9xmhY0EhxGs/OBpfTUYh8AKQ30O
	 hQy7HsOIbmUmXeetRRgxR/IEUCFM9kxV269Z08DQ7I/uTnA+SU5MQJ1w2Z0nMfLcDF
	 Eh53lRYUb9fBG96EESRZqs8qttNywI6OvVOwmlHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 222/389] hwmon: (adt7470) Fix some style issues
Date: Mon, 17 Aug 2026 15:31:01 +0200
Message-ID: <20260817132547.869592084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 23bd022aa6182367e1add7b4d05777cdba283756 ]

In preparation for the changes that follow fix up some existing style
issues.
Specifically:
- add blank line between variable declaration and code
- use strscpy instead of strlcpy
- remove unnecessary braces

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20210826024121.15665-2-chris.packham@alliedtelesis.co.nz
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 92413f439d1e ("hwmon: (adt7470) Fix PWM auto temp state array and bounds check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7470.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index b8697975d8b6c..95c5e219adeff 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -175,6 +175,7 @@ struct adt7470_data {
 static inline int adt7470_read_word_data(struct i2c_client *client, u8 reg)
 {
 	u16 foo;
+
 	foo = i2c_smbus_read_byte_data(client, reg);
 	foo |= ((u16)i2c_smbus_read_byte_data(client, reg + 1) << 8);
 	return foo;
@@ -1282,7 +1283,7 @@ static int adt7470_detect(struct i2c_client *client,
 	if (revision != ADT7470_REVISION)
 		return -ENODEV;
 
-	strlcpy(info->type, "adt7470", I2C_NAME_SIZE);
+	strscpy(info->type, "adt7470", I2C_NAME_SIZE);
 
 	return 0;
 }
@@ -1331,9 +1332,8 @@ static int adt7470_probe(struct i2c_client *client)
 
 	data->auto_update = kthread_run(adt7470_update_thread, client, "%s",
 					dev_name(hwmon_dev));
-	if (IS_ERR(data->auto_update)) {
+	if (IS_ERR(data->auto_update))
 		return PTR_ERR(data->auto_update);
-	}
 
 	return 0;
 }
-- 
2.53.0



