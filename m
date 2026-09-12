Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F9539A067;
	Sat, 12 Sep 2026 20:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243329; cv=none; b=ZNsCQKBXirTJ3W3WVlQad6DD/DbWe1lhYt9OVkmWoPwGgo6Bij9G37fFvsZeNmq6Pgq73uE456ax2XBauek35uQBCjA/RaQ9zewkLInjHWh/akjRy1eU1WGRLZc4AELaERPI9YRl54uXOvuRlO5y0qXrwjoUn549mY2ll7rhMQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243329; c=relaxed/simple;
	bh=xP2Nf6l8A2AJUOBEvWYF6Ylk0EHfEf/5DS6Bh5PlTVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q89E8CRYPOqQjP6Vz2Le2mc5w4Y6Z8Z5zuyabaNtjXMqxy+HVp1xkmYlvJ+SUbphenMN+YjPdUiSidkm0lO4L7vz0i6AL+Fm11GZNP1Q12533Au3GALG2bH4JzQgR60aHxkuDgUtJZfxBLrdOpcXQXHXD0qUiUfjYqmIVfB65nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Jsqro7I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Jsqro7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4691F000FF;
	Sat, 12 Sep 2026 20:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243327;
	bh=YTFFnnC/sYdnqu9CMRbUtvr1PogsOwIcYEXvQbVlWb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Jsqro7IdqVjGfFWRMrjqztsAm9u5F9dAO7iMny4hzgScw25n1Bj4Hl+/j5y3SI3E
	 67H2rLSSqKDpEu/6i6PVAuY40StE3cLVi6f5LDNhlzuqqpuLXsDyflXrkWeetGXe+2
	 Y6ZNlbHGr49F1gNWCyWK9SWe/Fy4RGTplivwMMcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>,
	Patrick Williams <patrick@stwcx.xyz>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 717/798] hwmon: (emc1403) Add support for EMC1442
Date: Sat, 12 Sep 2026 09:05:45 +0200
Message-ID: <20260912065533.515750941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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



