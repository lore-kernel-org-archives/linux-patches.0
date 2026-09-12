Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17FD3A8758;
	Sat, 12 Sep 2026 19:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240261; cv=none; b=s+5SfV9jOGgFhJ6fznrFlLhPJ4ANnm43RrghPvlBVDAtPMlrgSJGDhKoJw1iytWtYF2TtKWanuz26EAcDM1g45mdL0HjbOvVlvdptZQf1QUWyiVzb8lheTFFjfyVjU5Az5rg/IY0SBpEYfGOZPnn9hulRGJiFv0nxhcxyVN77yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240261; c=relaxed/simple;
	bh=U8ke0lAuVqKJsj9w+Xmum1iIpGvr9GRjN0c7u5zRl88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hX+HXalvZsIM++n75ohFtcF2KelWFfrZxkGAye4kePMD20wv9Dq22QBq4FzIu+E1415nZ3r4vieD0qoUmbpy1eKCQzuZjC5nlOmav3zn84g5mROBGzj1kW2HHYhGcXTYnHKMkRzLBQSvGU/cT+kWKGDcWuOsqEH6fH8WI7Wu2mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oh/J3Phe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oh/J3Phe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA3F1F000FF;
	Sat, 12 Sep 2026 19:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240259;
	bh=zMBNjgIs3g/ct6z62DfIE5szlzP1RHhgKB/1Rhpvwlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oh/J3Phe+85V0ALvZKxZ9jbhTlon2+5+IMH5oCDAq+WTlnJYk0V9m0a7aH8S4ZwgV
	 J9lXFgwW1COGNwZ27P7jzx8mi/6jQsc86Ph/uv7ac9o2z8pnNdC9eWuNkG6GSCB4/9
	 vqxbzWp9wS5qLXR6o4GIAhthr4O9bfl9a6SZ95l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>,
	Patrick Williams <patrick@stwcx.xyz>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 832/935] hwmon: (emc1403) Add support for EMC1442
Date: Sat, 12 Sep 2026 09:04:22 +0200
Message-ID: <20260912065545.906527839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3148382720499..568702e08cafd 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -346,6 +346,9 @@ static int emc1403_detect(struct i2c_client *client,
 	case 0x27:
 		strlcpy(info->type, "emc1424", I2C_NAME_SIZE);
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



