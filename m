Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906E4FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03236C433EF;
	Mon, 15 May 2023 16:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169704;
	bh=ZGQwDrblZujQZQODfbu5LD+tJ6qDeTPQhNlyaCkmguQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0uPxCYNUED8OWoHxOPeWqJS2dx6u4aoiLu6irpxmDiMqQyRgPxOvw5LLiDGc7Rf0
	 2qplISYcxeyhJFzLKxgsgXeMav/JljjeLCUFxUqW/saLNQyebAZKqVtSQxucsmLNDm
	 PKkQ3XWUayXNwJfnQ5meXu6y9fSXEk0EssNz4+hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.3 143/246] platform/x86: touchscreen_dmi: Add upside-down quirk for GDIX1002 ts on the Juno Tablet
Date: Mon, 15 May 2023 18:25:55 +0200
Message-Id: <20230515161726.852035145@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

commit 6abfa99ce52f61a31bcfc2aaaae09006f5665495 upstream.

The Juno Computers Juno Tablet has an upside-down mounted Goodix
touchscreen. Add a quirk to invert both axis to correct for this.

Link: https://junocomputers.com/us/product/juno-tablet/
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230505210323.43177-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/touchscreen_dmi.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -378,6 +378,11 @@ static const struct ts_dmi_data gdix1001
 	.properties	= gdix1001_upside_down_props,
 };
 
+static const struct ts_dmi_data gdix1002_00_upside_down_data = {
+	.acpi_name	= "GDIX1002:00",
+	.properties	= gdix1001_upside_down_props,
+};
+
 static const struct property_entry gp_electronic_t701_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-size-x", 960),
 	PROPERTY_ENTRY_U32("touchscreen-size-y", 640),
@@ -1296,6 +1301,18 @@ const struct dmi_system_id touchscreen_d
 		},
 	},
 	{
+		/* Juno Tablet */
+		.driver_data = (void *)&gdix1002_00_upside_down_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Default string"),
+			/* Both product- and board-name being "Default string" is somewhat rare */
+			DMI_MATCH(DMI_PRODUCT_NAME, "Default string"),
+			DMI_MATCH(DMI_BOARD_NAME, "Default string"),
+			/* Above matches are too generic, add partial bios-version match */
+			DMI_MATCH(DMI_BIOS_VERSION, "JP2V1."),
+		},
+	},
+	{
 		/* Mediacom WinPad 7.0 W700 (same hw as Wintron surftab 7") */
 		.driver_data = (void *)&trekstor_surftab_wintron70_data,
 		.matches = {


