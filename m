Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062511;
	b=p+1i8dm9uF+PqysMDB1Uxhjw52Zd/0PHnQTU4pDQsUktlcHZvdqt0MkzZBHzx1AiILm9
	 FGcyskLlxADq3jBM/xbvZcqhRjyMv8zkL3iUW95IoJ3t0HBtWKsWRaZTirjg80cTVnnKV
	 yCrRbI3inoyK4JAAXx2R9ccDyAVTgpc/p9jlVO0LWT68Cy5dTQm2q55MCIFpMvV5J/jgd
	 nMIybRfcuu5OmgQ3xzvLDlkFLINFRzrp8j/icHRJ49mATvXcvMhP9d8xk4oaP9No5g9eI
	 1x8yFQf6dBONgqUzNKflUL/QCS7bGlbAEBYH4UUm31fRlbYDcWRkujvUGfz3ppLBGmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L3rK9DNKdFLYP82chq2rCKFTm2Va9tkcps14XVhk+IY=;
	b=fYo4PQC26UtUYHK3O8vlYlRswoonmRT7u7ese5qfQxypQndeFIqrNnxJxC8GqSM8xW3b
	 7R78uutrW3bnuaIpf7M29C6HeAs+HbcsZQ7WxgHZNnciddrzmtxLyOFFBbMuPeMOWgZWg
	 LOfI5WiYA3WRvsi3elsvxnwleEa8+C65Zy+fzmvRHAWO6o2PKusRSJku+gAt4wwG830uq
	 +BTN/3DfOgPi9pPov5qeleoEBflvE28n0O5K/ZlCYMMSiLmXAzb7DocArfQ0MRTyRsqEV
	 XLUquoJA/GYoetv2ZZZFL+Jve8qV7cKN9E2lCUIrPo6LgfNk19WC4htG0P7iNN9nwDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qV1HS9ZV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AE7606D838;
	Sat,  7 Nov 2026 14:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qV1HS9ZV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52461F0089F;
	Sat,  7 Nov 2026 14:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062511;
	bh=L3rK9DNKdFLYP82chq2rCKFTm2Va9tkcps14XVhk+IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qV1HS9ZVh/ChisCTt0MG0N9BSA/hqej2YZpdJrbmtTPYA7A70bNcpvnQ19Z3AP9jw
	 oHY6jQ88qNTUjff9+vS+Wmw7D2C6Tp0AAOJddS23h7WdEn4Zdn3pNmqoXc/E5JKX2y
	 2+Fhd/GOKnxgDIFqCH8sQiP5qPgdBktRP9gKzfZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1359/1536] hwmon: (gigabyte_waterforce) reject short input reports
Date: Sat,  7 Nov 2026 08:56:15 -0500
Message-ID: <20261107135036.003231022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



