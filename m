Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F771C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1FEC433D2;
	Wed, 28 Dec 2022 16:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245956;
	bh=gXqKP8qLSfDtzf3svRbeUhGdvQn00qDVDCgVG3upEKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nIddGgzhuK23GVRRkpFa54yRTMUj2Rd3uXUKtOsFQFu0th9wfvlFdk3ESXE9zmv1A
	 /VIr+UnpD5sbLtXWFVjL95ynYdLGUXUBq5f8o6Fz1C1sPct5m8V7lTJW1aZo+tpeOQ
	 eFyKZOw9xJXZn02yvGOONEUe6aVOLBAnFDND+6zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0953/1146] ACPI: video: Change GIGABYTE GB-BXBT-2807 quirk to force_none
Date: Wed, 28 Dec 2022 15:41:32 +0100
Message-Id: <20221228144356.206041383@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 9f7dd272ff9338f1f43c7a837d5a7ee67811d552 ]

The GIGABYTE GB-BXBT-2807 DMI quirk was added by
commit 25417185e9b5 ("ACPI: video: Add DMI quirk for GIGABYTE
GB-BXBT-2807") which says the following in its commit message:

"The GIGABYTE GB-BXBT-2807 is a mini-PC which uses off the shelf
components, like an Intel GPU which is meant for mobile systems.
As such, it, by default, has a backlight controller exposed.

Unfortunately, the backlight controller only confuses userspace, which
sees the existence of a backlight device node and has the unrealistic
belief that there is actually a backlight there!

Add a DMI quirk to force the backlight off on this system."

So in essence this quirk was using a video_detect_force_vendor quirk
to disable backlight control. Now a days we have a specific "none"
backlight type for this. Change the quirk to video_detect_force_none
and group it together with the other force_none quirks.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index b2a616287638..375d1ef8fbea 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -197,14 +197,6 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "1015CX"),
 		},
 	},
-	{
-	 .callback = video_detect_force_vendor,
-	 /* GIGABYTE GB-BXBT-2807 */
-	 .matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "GB-BXBT-2807"),
-		},
-	},
 	{
 	 .callback = video_detect_force_vendor,
 	 /* Samsung N150/N210/N220 */
@@ -671,6 +663,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 9020M"),
 		},
 	},
+	{
+	 .callback = video_detect_force_none,
+	 /* GIGABYTE GB-BXBT-2807 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "GB-BXBT-2807"),
+		},
+	},
 	{
 	 .callback = video_detect_force_none,
 	 /* MSI MS-7721 */
-- 
2.35.1



