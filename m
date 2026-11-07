Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065085;
	b=bwANcSj6OF7I4YABV2LmK2R1KGHHKN129Tsr2+bUE/yd7FeQKJzDVPCrUlWpG45PAlcc
	 +5+b6xonsp7EwjtiIDCoIDmbjnSILV1QD4Oil8Hi6AuuTNXYtOdaO1Q69wHuLEitY7xHI
	 gSws3TBQhN+4Din3bsqLiX4dGgOFXFnLvDRlywJQ490oIhcP6VhxBv/P73GROItU/g7fC
	 I3tZG6YQJ4Z5qMBl4fXSBU3V4/LsncALbOqSiX9p17jBBIWdKyNrpncAXKRICjs4OKSnB
	 Rr2BXddDlzI6uxji863kUw96afJpk65gueMwsQq2VUzTgxP6UbmUa5rc+UqBqEf5XxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dxa1DfSN3Sa9B3ljNQhrIfXS9B3z985Exi0xG7I7cbw=;
	b=pJIvw31T8mHqjlnoq/+Kamekvw+MsAjJAhbFuGmywevPp6GWnQepBcPNS7fRM5nk7INP
	 E8x4C8qSMJtQG74Evor0aaEp/hzgJcWQGYSW5khm8LXLDPH5TR8WlMfAa6q3262iNVusd
	 tTChW56s6K3Wwf+uaxxzDN+KdS34FdYvZ7rR909gGB83pC2K2LThXsfN6mXas2wMKPoBy
	 Esxy1HZJ+SnuAb4BIZF7MBAiEAIAES8fDpTOBf/60dZVTQ7Jvwaz6ypSzDzCMhxbJGPCW
	 z1hYXfs22ocjO4iAYduLWZOlU0MliuPBj2v4nGQUXO/H0o1hqBrVgCmzR9GBUO1uLxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SizvSkyX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D6C606A326;
	Sat,  7 Nov 2026 15:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SizvSkyX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4A91F0089F;
	Sat,  7 Nov 2026 15:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065085;
	bh=Dxa1DfSN3Sa9B3ljNQhrIfXS9B3z985Exi0xG7I7cbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SizvSkyXOAqO1/FZE8aGjt/WYp2XlJHQNHdnBwXdx/4EOmmCrBJ2MfS4oH05dI8CP
	 pkTDcb1SIpInQg/DprjqTqwUwTA9CRMLAxhdGJmWTY0+oHiBcctyUUNQbyl3+Ija7L
	 0pp5xcKzUf2UimpY5V3rTTkXmmsD7DgSSfoWlQaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0881/1257] hwmon: (gigabyte_waterforce) reject short input reports
Date: Sat,  7 Nov 2026 08:52:57 -0500
Message-ID: <20261107135003.656208307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 400be69515c327ced60082b27ede902a8d93cbdb ]

The HID raw_event callback runs before HID core validates the received
report length. waterforce_raw_event() reads command bytes and then accesses
fixed offsets for firmware or status data without any length checks. A
truncated report can therefore cause out-of-bounds reads and update hwmon
state with unrelated data.

Require every report to contain the firmware response fields, which also
covers both command bytes. After identifying a status response, require
the byte at the highest status offset before accessing its payload.

Fixes: 42ac68e3d4ba ("hwmon: Add driver for Gigabyte AORUS Waterforce AIO coolers")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260927084959.893708-1-yaojiale02@163.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/gigabyte_waterforce.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwmon/gigabyte_waterforce.c b/drivers/hwmon/gigabyte_waterforce.c
index 4eea05f8b569c..f4d0376dd68e0 100644
--- a/drivers/hwmon/gigabyte_waterforce.c
+++ b/drivers/hwmon/gigabyte_waterforce.c
@@ -257,6 +257,9 @@ static int waterforce_raw_event(struct hid_device *hdev, struct hid_report *repo
 {
 	struct waterforce_data *priv = hid_get_drvdata(hdev);
 
+	if (size <= FIRMWARE_VER_START_OFFSET_2)
+		return 0;
+
 	if (data[0] == get_firmware_ver_cmd[0] && data[1] == get_firmware_ver_cmd[1]) {
 		/* Received a firmware version report */
 		priv->firmware_version =
@@ -269,6 +272,8 @@ static int waterforce_raw_event(struct hid_device *hdev, struct hid_report *repo
 
 	if (data[0] != get_status_cmd[0] || data[1] != get_status_cmd[1])
 		return 0;
+	if (size <= WATERFORCE_TEMP_SENSOR)
+		return 0;
 
 	priv->temp_input[0] = data[WATERFORCE_TEMP_SENSOR] * 1000;
 	priv->speed_input[0] = get_unaligned_le16(data + WATERFORCE_FAN_SPEED);
-- 
2.53.0



