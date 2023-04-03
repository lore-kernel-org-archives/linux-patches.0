Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE706FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64BFC433D2;
	Mon,  3 Apr 2023 14:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533028;
	bh=me7G3OT2TGrjVFbbnRhPeycgSljp4H5OILls7sQNoaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlBn3iMUWYk35BBSWMqGppeO/Ozds/c4X9Vn5nHLsx942l91sgEpR03ytxieWUjFF
	 ExycXeL2Us6GHHigtoZW7x8WR/qJJiG8LJ29FyXOn5J+5HF0j95S7l94DIA1grV2kl
	 z+shfLebocv9RG5NOLhjhI/YHsXq0SjKk7blx8Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 027/187] ACPI: x86: Add skip i2c clients quirk for Lenovo Yoga Book X90
Date: Mon,  3 Apr 2023 16:07:52 +0200
Message-Id: <20230403140416.904689471@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
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

[ Upstream commit 1a1e7540cf501dd5c8b57a577a155cdd13c7e202 ]

The Lenovo Yoga Book X90 is a x86 tablet which ships with Android x86
as factory OS. The Android x86 kernel fork ignores I2C devices described
in the DSDT, except for the PMIC and Audio codecs.

As usual the Lenovo Yoga Book X90's DSDT contains a bunch of extra I2C
devices which are not actually there, causing various resource conflicts.
Add an ACPI_QUIRK_SKIP_I2C_CLIENTS quirk for the Lenovo Yoga Book X90
to the acpi_quirk_skip_dmi_ids table to woraround this.

The DSDT also contains broken ACPI GPIO event handlers, disable those too.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rjw@rjwysocki.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index b2b0e2701333a..da5727069d851 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -300,6 +300,17 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY |
 					ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS),
 	},
+	{
+		/* Lenovo Yoga Book X90F/L */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "YETI-11"),
+		},
+		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
+					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY |
+					ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS),
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-- 
2.39.2



