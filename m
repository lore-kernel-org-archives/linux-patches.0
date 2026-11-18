Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054463;
	b=UplW6zRlzxpUX9VcQ1i8AaFuIZPKkrnw4A0kjO2ozaxnvqranvBBkYLufI31auPkmmJT
	 VAFTDip3zlI7Z4hcQEGxMNtPVmUuChDTklVCS8VgnF3Inrg1kLg4RC4zPbaDpUXJHsVUN
	 UKtWZZ3GOFHn60WO/U2WEExDoJQOE8t7SILKeSCRtq5kmgO9KmKbphbe4HowG1kpW9Buh
	 FVFr7OUxBrCJtllu+LpnF8WYSxjWrcYv6GkTPdMEl++JFJWStKoh+oz82k+7tBoOeqmsJ
	 g3oCTZw+YngaOYJJJ/K1C7nLwgdXxCrG0TRqknXLU1UJirxmK/5ku/I7ZP4JDkijhag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YRWrXSLqIyEEYr9/qMSTtlsdwFGbU7NK9+PrSParNto=;
	b=Sp2fzzfQ7WetDk5xeusaLKcfKASlF38HSMkqehKW6+4f2Ewl8Ul4G608/zVZgIiaQYcS
	 G5VHWdnc7rPSnXEGO65G0XvZ2IMYIv12FVvQw+TsL5WkGPCxyF/ciGsi26UKILJOzBlMM
	 VRYUzww1klZ95T8BX+s/AHm+nsMDZv4ajHLMS7r0/wKJR0wRsXe9FUm1yZyz6Zce/lWyB
	 cykh0HkHxennlZLt/r/OpvB6G7/ohvGEDgjup4LuYQREqDd9KJ8gpPIoLTDjpGtjoFGx2
	 ucA9MKRj+QZee0GrqwZ+r3FFeRRu4aoPqdTkFFbW4iXGggeE0rdkyHGWkC+VwYZSQuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a8HP5iG3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982E9606A31C;
	Thu, 19 Nov 2026 02:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a8HP5iG3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B2A1F000C5;
	Thu, 19 Nov 2026 02:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054463;
	bh=YRWrXSLqIyEEYr9/qMSTtlsdwFGbU7NK9+PrSParNto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8HP5iG3s9dI6XHC9vKbJCai2JcGtuanfeRwTTNEJDq2YorSxvkVdgVi+sh2mPfhL
	 +xQJ0fXxEVUH+tqCfpGUqivB7I+nVS3Tx7apSQSGFsya61HUqBl88J7NlxOGCKQFGf
	 u/0XBBkiOFKMZvnXIDGfRtWdm8K+rjRc9iNlEsuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Jiale Yao <yaojiale02@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1282/2214] hwmon: (aquacomputer_d5next) reject short status reports
Date: Wed, 18 Nov 2026 15:49:18 +0100
Message-ID: <20261118150102.877548993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit cf8f81babd2e96087dedbb74985bc1781c98f73d ]

The HID raw_event callback runs before HID core validates the received
report length. aqc_raw_event() reads device-specific status fields at fixed
offsets, including multi-byte values, without first ensuring that the
received buffer contains every field. A truncated report can therefore
cause out-of-bounds reads and update hwmon state with unrelated data.

The required length differs between supported devices and cannot be
derived from the HID report descriptor. Define the minimum length needed
by each asynchronous status format, select it while configuring the
device, and reject reports that do not contain the last field accessed by
that format. Keep the published length zero until probe configuration is
complete, which also excludes legacy devices whose status is retrieved
through feature reports.

Suggested-by: Guenter Roeck <linux@roeck-us.net>
Fixes: 0e35f63f7f4e ("hwmon: add driver for Aquacomputer D5 Next")
Fixes: 19692f17cd13 ("hwmon: (aquacomputer_d5next) Add support for Aquacomputer Aquastream XT")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20261021120408.48495-1-yaojiale02@163.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ sashal: Replaced multi-device report-size selection with D5NEXT_PUMP_SPEED + sizeof(u16) for the D5 Next-only driver. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aquacomputer_d5next.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hwmon/aquacomputer_d5next.c b/drivers/hwmon/aquacomputer_d5next.c
index fb9341a530511..d3a3795c1cc4e 100644
--- a/drivers/hwmon/aquacomputer_d5next.c
+++ b/drivers/hwmon/aquacomputer_d5next.c
@@ -43,6 +43,7 @@
 
 #define D5NEXT_PUMP_CURRENT		112
 #define D5NEXT_FAN_CURRENT		99
+#define D5NEXT_MIN_STATUS_REPORT_SIZE	(D5NEXT_PUMP_SPEED + sizeof(u16))
 
 /* Labels for provided values */
 
@@ -86,6 +87,7 @@ struct d5next_data {
 	struct hid_device *hdev;
 	struct device *hwmon_dev;
 	struct dentry *debugfs;
+	u16 min_report_size;
 	s32 temp_input;
 	u16 speed_input[2];
 	u32 power_input[2];
@@ -189,6 +191,8 @@ static int d5next_raw_event(struct hid_device *hdev, struct hid_report *report,
 		return 0;
 
 	priv = hid_get_drvdata(hdev);
+	if (!priv->min_report_size || size < priv->min_report_size)
+		return 0;
 
 	/* Info provided with every report */
 
@@ -298,6 +302,8 @@ static int d5next_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (ret)
 		goto fail_and_stop;
 
+	priv->min_report_size = D5NEXT_MIN_STATUS_REPORT_SIZE;
+
 	priv->hwmon_dev = hwmon_device_register_with_info(&hdev->dev, "d5next", priv,
 							  &d5next_chip_info, NULL);
 
-- 
2.53.0



