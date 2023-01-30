Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA57528EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C43C433EF;
	Mon, 30 Jan 2023 14:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087598;
	bh=MII1gthDuE70IDCSNFXk7nI7lYhYLxdTG/ukJwCJFjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uw9vyKAS0Gzp+fIhoC6OASe3NihxEgRaf+WHm/zjeLhr6nesgubHPRb2cepf0VvZt
	 xQWoMT94MwjyjceMoWLChiFkxiaxiTISHy3WFzjRbVkTtpevIwBLP+btpJkGLFJ3/U
	 xUbO3zLO5IPuQwRYRS1XvBru8QF/FrHXPPl5mglo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 261/313] ACPI: video: Add backlight=native DMI quirk for HP Pavilion g6-1d80nr
Date: Mon, 30 Jan 2023 14:51:36 +0100
Message-Id: <20230130134348.894068042@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

[ Upstream commit d77596d432cc4142520af32b5388d512e52e0edb ]

The HP Pavilion g6-1d80nr predates Windows 8, so it defaults to using
acpi_video# for backlight control, but this is non functional on
this model.

Add a DMI quirk to use the native backlight interface which does
work properly.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 9dcb34234b82 ("ACPI: video: Add backlight=native DMI quirk for HP EliteBook 8460p")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 1db8e68cd8bc..c20fc7ddca2f 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -608,6 +608,15 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "UX303UB"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* HP Pavilion g6-1d80nr / B4U19UA */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion g6 Notebook PC"),
+		DMI_MATCH(DMI_PRODUCT_SKU, "B4U19UA"),
+		},
+	},
 	{
 	 .callback = video_detect_force_native,
 	 /* Samsung N150P */
-- 
2.39.0



