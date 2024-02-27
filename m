Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60291146009;
	Tue, 27 Feb 2024 14:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043210; cv=none; b=L9kyrpA5lwVb9DDARQwui0/6LeCXhP9Q2dlgDfTinrjla1NYmrIO6+MOF+b4j/6ReJFh18fzgK21JXIaZjZSj0RWfSl6enIniIkKd/3uZFs6nF3ChL5vrQGbp7VQDOf/SeIPELQiGv5ZDe3HnJ1kkm7iWXwJSV6KgGEMQpZsGbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043210; c=relaxed/simple;
	bh=Vw72gz3kUrhRlwcv/EYUvg6VpdtQfvhCOIZF588z4oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q20VHVu5lzAxk+IcL740OdUk5vAEj0qM1JLMWbTUo+Ty8745wnG/eY225GauawRDLvqTXGSMMWeI8osJHgftMbFzMNMAUSecK1UvCPCTueF+yIaWwG0seygtQyqAhui4KXXNDeQ9WDszaLSe780Vprk3+Qn6/H+3ZwWn9JHeTTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ejz81Ws9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ejz81Ws9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EBFC433F1;
	Tue, 27 Feb 2024 14:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043210;
	bh=Vw72gz3kUrhRlwcv/EYUvg6VpdtQfvhCOIZF588z4oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ejz81Ws9V76ND+i9F50pQFVS4XTRCk2YzEeHIJ6FlHm0JGBPrbYykTdP78OFvBeXe
	 6ILcyZ55f2WA7TCKUFq9RXVUCbi3hCjMYvjFcJk5uzFPRcDmM7nSriJ34ujoiFCxvC
	 9gokYNRDGFxMIKZYRowSMf7kyaTj6xN83uYAfnms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phoenix Chen <asbeltogf@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/195] platform/x86: touchscreen_dmi: Add info for the TECLAST X16 Plus tablet
Date: Tue, 27 Feb 2024 14:24:46 +0100
Message-ID: <20240227131611.227407074@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phoenix Chen <asbeltogf@gmail.com>

[ Upstream commit 1abdf288b0ef5606f76b6e191fa6df05330e3d7e ]

Add touch screen info for TECLAST X16 Plus tablet.

Signed-off-by: Phoenix Chen <asbeltogf@gmail.com>
Link: https://lore.kernel.org/r/20240126095308.5042-1-asbeltogf@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 35 ++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 9a92d515abb9b..50ec19188a20d 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -913,6 +913,32 @@ static const struct ts_dmi_data teclast_tbook11_data = {
 	.properties	= teclast_tbook11_props,
 };
 
+static const struct property_entry teclast_x16_plus_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-min-x", 8),
+	PROPERTY_ENTRY_U32("touchscreen-min-y", 14),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1916),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 1264),
+	PROPERTY_ENTRY_BOOL("touchscreen-inverted-y"),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl3692-teclast-x16-plus.fw"),
+	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	PROPERTY_ENTRY_BOOL("silead,home-button"),
+	{ }
+};
+
+static const struct ts_dmi_data teclast_x16_plus_data = {
+	.embedded_fw = {
+		.name	= "silead/gsl3692-teclast-x16-plus.fw",
+		.prefix = { 0xf0, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00 },
+		.length	= 43560,
+		.sha256	= { 0x9d, 0xb0, 0x3d, 0xf1, 0x00, 0x3c, 0xb5, 0x25,
+			    0x62, 0x8a, 0xa0, 0x93, 0x4b, 0xe0, 0x4e, 0x75,
+			    0xd1, 0x27, 0xb1, 0x65, 0x3c, 0xba, 0xa5, 0x0f,
+			    0xcd, 0xb4, 0xbe, 0x00, 0xbb, 0xf6, 0x43, 0x29 },
+	},
+	.acpi_name	= "MSSL1680:00",
+	.properties	= teclast_x16_plus_props,
+};
+
 static const struct property_entry teclast_x3_plus_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-size-x", 1980),
 	PROPERTY_ENTRY_U32("touchscreen-size-y", 1500),
@@ -1567,6 +1593,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_SKU, "E5A6_A1"),
 		},
 	},
+	{
+		/* Teclast X16 Plus */
+		.driver_data = (void *)&teclast_x16_plus_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TECLAST"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Default string"),
+			DMI_MATCH(DMI_PRODUCT_SKU, "D3A5_A1"),
+		},
+	},
 	{
 		/* Teclast X3 Plus */
 		.driver_data = (void *)&teclast_x3_plus_data,
-- 
2.43.0



