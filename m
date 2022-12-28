Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239151C15
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935F0C433EF;
	Wed, 28 Dec 2022 16:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245968;
	bh=joUiXrawmAJHiaVDfPQdm0pzrZtel83AWOUVXLSsXaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZ+8VAyjk3VozFvwJRuh+k9sfXuKc2A4/gz9qHE3YV7k3TJ1p2VEtwmmcxjnTY9Hn
	 r5JrYYLpxvDvscx3QFYVTZPhtAM+1CRzokazmhvNIKaK1ZBbzngnXYWk+KfO2Aij5E
	 7HJCVYJJg3mNw2S1Odmv6ssEgIIrzAsHYiQTl2bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0955/1146] ACPI: video: Add force_vendor quirk for Sony Vaio PCG-FRV35
Date: Wed, 28 Dec 2022 15:41:34 +0100
Message-Id: <20221228144356.259328375@linuxfoundation.org>
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

[ Upstream commit 23735543eb228c604e59f99f2f5d13aa507e5db2 ]

The Sony Vaio PCG-FRV35 advertises both native and vendor backlight
control interfaces. With the upcoming changes to prefer native over
vendor acpi_video_get_backlight_type() will start returning native on
these laptops.

But the native radeon_bl0 interface does not work, where as the sony
vendor interface does work. Add a quirk to force use of the vendor
interface.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 0ab98f2e484c..8e8b435b4c8c 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -237,6 +237,19 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		},
 	},
 
+	/*
+	 * Models which should use the vendor backlight interface,
+	 * because of broken native backlight control.
+	 */
+	{
+	 .callback = video_detect_force_vendor,
+	 /* Sony Vaio PCG-FRV35 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "PCG-FRV35"),
+		},
+	},
+
 	/*
 	 * Toshiba models with Transflective display, these need to use
 	 * the toshiba_acpi vendor driver for proper Transflective handling.
-- 
2.35.1



