Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A715020ED;
	Sat, 12 Sep 2026 15:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225640; cv=none; b=nCTpoSn5FQ2fvCz0+qLXcYg8BvtEKJumJvGvb+8yjwbHuZa+R+frNTrm6/8Z/2PwVn5VgRrP0GWo67oUBG8/I5HZhapyCz5ds2Qj+o+wong/FbkEdXN1Bk/JxnoY8MAUbdHK5SVhnDxE/Jy0Uixpq+I6IJkbiXkA7lMTCZmb1Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225640; c=relaxed/simple;
	bh=qO4hKf8FX0hBTHBwmqCn/WIPujtCJkum5j3tT/44RpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoGWDzZYu+3j5LgOaFPjzWThZO6z886UsjBH/t07FC/4DMS5TAjlXFI5Ro/k6zg7yIXGnWKyjxwPZp032xEi6LHhtP6/CXH5y8Y04YcUB/X1HfH+rVaSI5IAwR6vK1EipmyBD6GiuobD52vowuIt5NaDX7vHDyfIcVX0sIUa744=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVy2Pi/7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVy2Pi/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3F31F000FF;
	Sat, 12 Sep 2026 15:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225639;
	bh=umsSjMPClrwIW8wOp2CYEJ1p/idOtn0pOrdfrGv77Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uVy2Pi/7rRFH5TrrBrVgkmlDinK5Hqw+oonN5vQrLsEe0zwyol3E7VyYiK9P9eak/
	 +a+U1II11VoRQ89EfwrTkgKqR8qm6+xUv4bvC5GCrPRc0nJQs8cv84LP/++7YJAW4J
	 JHVTl+kyC9iQm0F/UZjUV9EMB/JRtmnK38058S5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>,
	Patrick Williams <patrick@stwcx.xyz>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1240/1424] hwmon: (emc1403) Add support for EMC1442
Date: Sat, 12 Sep 2026 09:01:12 +0200
Message-ID: <20260912065635.052398408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>

[ Upstream commit 9350163aff24530f2aa3357ee1c7bd8771a443e4 ]

Add support for EMC1442 which is compatible with EMC1402.

Signed-off-by: Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>
Reviewed-by: Patrick Williams <patrick@stwcx.xyz>
Link: https://lore.kernel.org/r/20231102090808.427351-1-Delphine_CC_Chiu@wiwynn.com
[groeck: compatible with EMC1402, not EMC1403]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 75f2c0b36907 ("hwmon: (emc1403) Drop hysteresis for low limit temperature")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/emc1403.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index bb7c859e799dc..1332e4ac078c1 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -346,6 +346,9 @@ static int emc1403_detect(struct i2c_client *client,
 	case 0x27:
 		strscpy(info->type, "emc1424", I2C_NAME_SIZE);
 		break;
+	case 0x60:
+		strscpy(info->type, "emc1442", I2C_NAME_SIZE);
+		break;
 	default:
 		return -ENODEV;
 	}
@@ -430,7 +433,7 @@ static int emc1403_probe(struct i2c_client *client)
 }
 
 static const unsigned short emc1403_address_list[] = {
-	0x18, 0x1c, 0x29, 0x4c, 0x4d, 0x5c, I2C_CLIENT_END
+	0x18, 0x1c, 0x29, 0x3c, 0x4c, 0x4d, 0x5c, I2C_CLIENT_END
 };
 
 /* Last digit of chip name indicates number of channels */
@@ -444,6 +447,7 @@ static const struct i2c_device_id emc1403_idtable[] = {
 	{ "emc1422", emc1402 },
 	{ "emc1423", emc1403 },
 	{ "emc1424", emc1404 },
+	{ "emc1442", emc1402 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, emc1403_idtable);
-- 
2.53.0



