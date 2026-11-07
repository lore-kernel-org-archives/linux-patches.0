Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063548;
	b=nlhgyYFPSpbmBXs2LvfL5yGgEno7orehAn0D6o3gu4XP4XB9kC2tWLmJNzDPzIzmMpng
	 XIRQXzKVwtiTKK9RF/i9c8RNe3XRPOkRYAHoY290/Jb3yiDk2YTno028MUYUkOTzoXkbj
	 g2aA5fADDwJ3YiLgYZUwTGpQ671YpFoQs7sw6N+DtxBH/9Ip1W1iqRMjmUBdSG/badML+
	 W1ovhQ9Vwyn8m1FWV1SMY9cqBMs1crb1le5ldbBqKw+wtWkTPzisF6FfYdEl0LATYRGcR
	 +7914OiJ/Vg0UpeD0cAKl99LIo5lXEiuEEuXaKWNkbJ/pdjrTE6HKNN0t/4l6H/Le4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/ocyamQba2lZDbXFPojCqTcqB+o+G8bKVJrDNzU3dSI=;
	b=HOI5136d+Ukd4Ku8G9Z9Ng87SzywsoKVTW0kDOSqf525X0STJ8oSBfviuTiEXQQ2DSzG
	 ubue64yImk/eQQ7gOMlMJWX4Ncoe1dz71n2ax6ORCbHf+6u3CRdCU8uRfgvuNHBcy9pr0
	 IEQzPBkbxus/G0hc7ZHc6oEb3axQejpNOB7cRBE4nxsNYTeX/j/2IcVD2HtUERa4Y/6DX
	 VaHQCK6VdJOg5iNAVnhzkplUEu0evuwRDDpGkk9/M51F2x79T1kgBdaeQLNQtF9fKvN0g
	 deJNaiRsOcs2M85GntsajlQXfIgUF2Rk3aFCaTChgFhFfMvfPdWqjr1uNMw0+1eYdxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=upPfmq7s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88F36082BCB;
	Sat,  7 Nov 2026 14:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=upPfmq7s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A191F0089F;
	Sat,  7 Nov 2026 14:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063547;
	bh=/ocyamQba2lZDbXFPojCqTcqB+o+G8bKVJrDNzU3dSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=upPfmq7shNxgiGNyrpd13+5ZOzUq/nto/Vqq+ccsUSPO2l1YOcUoOXJhysZc+8GEp
	 gPdLSYxsMAWsb5iaRaHr+w2JdB1DsFonqu1Eul1KCt2l1d8iCkyIEj1CNEUp1PagbP
	 FOwfbXaFf2WUsw8IzvqaviiaIHwBjzLD/vFtb3O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 645/869] hwmon: (gigabyte_waterforce) reject short input reports
Date: Sat,  7 Nov 2026 08:55:27 -0500
Message-ID: <20261107134914.824136747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



